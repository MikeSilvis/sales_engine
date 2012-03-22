require 'sales_engine/model'
module SalesEngine
  class Transaction
    include SalesEngine::Model

    field :id,                           :integer
    field :invoice_id,                   :integer
    field :credit_card_number,           :string
    field :credit_card_experiation_date, :datetime
    field :result,                       :string
    field :created_at,                   :datetime
    field :updated_at,                   :datetime

    def invoice
      Invoice.find(:id, invoice_id).first
    end

    def successfully_procesed?
      result.downcase == "success"
    end
  end
end
