require "rails_helper"

RSpec.describe "Constraints de autenticação" do
  def insert_user(overrides = {})
    attributes = {
      name: "Usuário via SQL",
      email: "sql-#{SecureRandom.hex(4)}@example.test",
      password_digest: BCrypt::Password.create("temporary-password-123"),
      active: true,
      system_role: "user"
    }.merge(overrides)

    User.insert_all!([ attributes ]).first.fetch("id")
  end

  it "rejeita nome nulo" do
    expect { insert_user(name: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita nome vazio" do
    expect { insert_user(name: "   ") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita e-mail nulo" do
    expect { insert_user(email: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita e-mail vazio" do
    expect { insert_user(email: "   ") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita e-mail duplicado por caixa" do
    insert_user(email: "case@example.test")
    expect { insert_user(email: "CASE@EXAMPLE.TEST") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita password_digest nulo" do
    expect { insert_user(password_digest: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita password_digest vazio" do
    expect { insert_user(password_digest: "   ") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita active nulo" do
    expect { insert_user(active: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita system_role nulo" do
    expect { insert_user(system_role: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita system_role inválido" do
    expect { insert_user(system_role: "owner") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "impede Session sem User" do
    expect do
      Session.insert_all!([ { user_id: nil } ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "impede Session com User inexistente" do
    expect do
      Session.insert_all!([ { user_id: SecureRandom.uuid } ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "aplica ON DELETE CASCADE diretamente no banco" do
    user_id = insert_user
    session_id = Session.insert_all!([ { user_id: user_id } ]).first.fetch("id")

    User.where(id: user_id).delete_all

    expect(Session.exists?(session_id)).to be(false)
  end

  it "mantém índice funcional único e constraints nomeadas" do
    index = User.connection.indexes(:users).find { |candidate| candidate.name == "index_users_on_lower_email" }
    constraints = User.connection.check_constraints(:users).map(&:name)

    expect(index.unique).to be(true)
    expect(index.columns).to include("lower")
    expect(constraints).to include(
      "users_name_not_blank",
      "users_email_not_blank",
      "users_password_digest_not_blank",
      "users_system_role_supported"
    )
  end
end
