class Current < ActiveSupport::CurrentAttributes
  attribute :user, :company, :membership
  attribute :request_id, :ip_address, :user_agent
end
