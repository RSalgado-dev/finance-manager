class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, limit: 160, null: false
      t.string :email, limit: 254, null: false
      t.string :password_digest, null: false
      t.boolean :active, null: false, default: true
      t.string :system_role, null: false, default: "user"
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"

    add_check_constraint :users, "btrim(name) <> ''", name: "users_name_not_blank"
    add_check_constraint :users, "btrim(email) <> ''", name: "users_email_not_blank"
    add_check_constraint :users,
      "btrim(password_digest) <> ''",
      name: "users_password_digest_not_blank"
    add_check_constraint :users,
      "system_role IN ('user', 'platform_admin')",
      name: "users_system_role_supported"
  end
end
