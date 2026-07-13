require "rails_helper"

RSpec.describe User do
  describe "estrutura e defaults" do
    subject(:user) { create(:user) }

    it "gera UUID e não possui company_id" do
      expect(user.id).to match(/\A[0-9a-f-]{36}\z/i)
      expect(user).not_to respond_to(:company_id)
    end

    it "aplica defaults e mantém last_sign_in_at opcional" do
      expect(user).to have_attributes(active: true, system_role: "user", last_sign_in_at: nil)
    end

    it "não cria Session automaticamente" do
      expect { user }.not_to change(Session, :count)
    end
  end

  describe "nome" do
    it "exige valor não vazio" do
      expect(build(:user, name: nil)).not_to be_valid
      expect(build(:user, name: "   ")).not_to be_valid
    end

    it "remove espaços externos e preserva capitalização" do
      expect(create(:user, name: "  Maria da Silva  ").name).to eq("Maria da Silva")
    end

    it "não exige unicidade e limita o tamanho" do
      create(:user, name: "Nome repetido")

      expect(build(:user, name: "Nome repetido")).to be_valid
      expect(build(:user, name: "a" * 161)).not_to be_valid
    end
  end

  describe "e-mail" do
    it "exige e-mail e rejeita formato básico inválido" do
      expect(build(:user, email: nil)).not_to be_valid
      expect(build(:user, email: "   ")).not_to be_valid
      expect(build(:user, email: "invalido")).not_to be_valid
      expect(build(:user, email: "invalido@ ")).not_to be_valid
    end

    it "remove espaços externos e normaliza para lowercase" do
      user = create(:user, email: "  USER.Name@Example.TEST  ")

      expect(user.email).to eq("user.name@example.test")
    end

    it "impede duplicidade case-insensitive e limita o tamanho" do
      create(:user, email: "unique@example.test")

      expect(build(:user, email: "UNIQUE@EXAMPLE.TEST")).not_to be_valid
      expect(build(:user, email: "a" * 250 + "@x.test")).not_to be_valid
    end
  end

  describe "senha" do
    it "exige senha na criação" do
      expect(build(:user, password: nil, password_confirmation: nil)).not_to be_valid
    end

    it "persiste somente digest e autentica a senha correta" do
      plaintext = "temporary-password-123"
      user = create(:user, password: plaintext, password_confirmation: plaintext)

      expect(user.password_digest).not_to include(plaintext)
      expect(user.authenticate(plaintext)).to be(user)
      expect(user.authenticate("wrong-password-123")).to be(false)
    end

    it "exige no mínimo 12 caracteres e respeita o limite BCrypt" do
      expect(build(:user, password: "short-pass", password_confirmation: "short-pass")).not_to be_valid
      expect(build(:user, password: "a" * 73, password_confirmation: "a" * 73)).not_to be_valid
    end

    it "valida confirmação quando fornecida" do
      user = build(
        :user,
        password: "temporary-password-123",
        password_confirmation: "different-password-123"
      )

      expect(user).not_to be_valid
    end

    it "mantém reset token desabilitado" do
      expect(described_class.new).not_to respond_to(:password_reset_token)
      expect(described_class).not_to respond_to(:find_by_password_reset_token!)
    end
  end

  describe "papel global e estado" do
    it "aceita os dois papéis e fornece predicates do enum" do
      expect(build(:user, system_role: "user")).to be_user
      expect(build(:user, :platform_admin)).to be_platform_admin
    end

    it "rejeita papel não suportado" do
      expect(build(:user, system_role: "owner")).not_to be_valid
    end

    it "representa usuário inativo sem efeito colateral" do
      user = create(:user, :inactive)

      expect(user).not_to be_active
      expect(user.sessions).to be_empty
    end
  end
end
