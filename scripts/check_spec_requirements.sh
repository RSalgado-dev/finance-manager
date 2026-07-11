#!/usr/bin/env bash

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root_dir"

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

mapfile -t spec_files < <(find specs -mindepth 2 -type f -name '*.md' ! -name 'source-brief.md' | sort)

id_pattern='[A-Z][A-Z0-9]*(-[A-Z0-9]+)*-[0-9]{3}'
definition_pattern="\`${id_pattern} (MUST NOT|MUST|SHOULD|MAY)\`"

rg -o --no-filename "$definition_pattern" "${spec_files[@]}" \
  | sed -E 's/^`([^ ]+) .*/\1/' \
  | sort > "$tmp_dir/definitions"

uniq -d "$tmp_dir/definitions" > "$tmp_dir/duplicate_ids"

rg -o --no-filename "$id_pattern" specs planning \
  | sort -u > "$tmp_dir/references"

sed -E 's/-[0-9]{3}$//' "$tmp_dir/definitions" \
  | sort -u > "$tmp_dir/namespaces"

: > "$tmp_dir/missing_ids"
while IFS= read -r requirement_id; do
  namespace=${requirement_id%-*}
  if rg -Fxq "$namespace" "$tmp_dir/namespaces" && ! rg -Fxq "$requirement_id" "$tmp_dir/definitions"; then
    printf '%s\n' "$requirement_id" >> "$tmp_dir/missing_ids"
  fi
done < "$tmp_dir/references"

: > "$tmp_dir/unidentified_normative_lines"
for spec_file in "${spec_files[@]}"; do
  awk -v file="$spec_file" '
    /^```/ { in_code = !in_code; next }
    in_code { next }
    /`[A-Z][A-Z0-9]*(-[A-Z0-9]+)*-[0-9][0-9][0-9] (MUST NOT|MUST|SHOULD|MAY)`/ { next }
    {
      lower = tolower($0)
      explicit_modal = lower ~ /(^|[^a-z])(must|should|may)([^a-z]|$)/
      list_or_table = $0 ~ /^[-*][[:space:]]/ || $0 ~ /^[0-9]+\.[[:space:]]/ || $0 ~ /^\|/
      implied_normative = lower ~ /(deve|devem|deverá|não permitir|permitir|usar|exigir|garantir|impedir|registrar|executar|criar|oferecer|suportar|aplicar|validar|armazenar|configurar|documentar|preservar|bloquear|proteger|prevenir|expor|formatar|considerar|tratar|evitar|respeitar|incluir|excluir)/
      if (explicit_modal || (list_or_table && implied_normative)) {
        print file ":" FNR ":" $0
      }
    }
  ' "$spec_file" >> "$tmp_dir/unidentified_normative_lines"
done

: > "$tmp_dir/broken_paths"
rg -o --no-filename '`[^`]+\.md`' specs planning AGENTS.md README-SPEC-SCAFFOLD.md \
  | sed -E 's/^`|`$//g' \
  | sort -u \
  | while IFS= read -r document_path; do
      if [[ -f "$document_path" || -f "specs/$document_path" ]]; then
        continue
      elif [[ "$document_path" == */* ]]; then
        printf '%s\n' "$document_path"
      else
        matches=$(find . -type f -name "$document_path" | wc -l)
        [[ "$matches" -eq 1 ]] || printf '%s (matches=%s)\n' "$document_path" "$matches"
      fi
    done > "$tmp_dir/broken_paths"

status=0

if [[ -s "$tmp_dir/duplicate_ids" ]]; then
  printf 'Duplicate requirement IDs:\n'
  sed 's/^/  - /' "$tmp_dir/duplicate_ids"
  status=1
fi

if [[ -s "$tmp_dir/missing_ids" ]]; then
  printf 'References to undefined requirement IDs:\n'
  sed 's/^/  - /' "$tmp_dir/missing_ids"
  status=1
fi

if [[ -s "$tmp_dir/unidentified_normative_lines" ]]; then
  printf 'Normative statements without an ID:\n'
  sed 's/^/  - /' "$tmp_dir/unidentified_normative_lines"
  status=1
fi

if [[ -s "$tmp_dir/broken_paths" ]]; then
  printf 'Broken or ambiguous Markdown document references:\n'
  sed 's/^/  - /' "$tmp_dir/broken_paths"
  status=1
fi

if [[ "$status" -eq 0 ]]; then
  printf 'spec_files=%s\n' "${#spec_files[@]}"
  printf 'requirement_ids=%s\n' "$(wc -l < "$tmp_dir/definitions")"
  printf 'duplicate_ids=0\n'
  printf 'undefined_id_references=0\n'
  printf 'normative_lines_without_id=0\n'
  printf 'broken_document_references=0\n'
fi

exit "$status"
