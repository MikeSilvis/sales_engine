require 'sales_engine/model'
module SalesEngine
  class Transaction
    include SalesEngine::Model

    belongs_to :invoice
    field :credit_card_number,           :string
    field :credit_card_experiation_date, :datetime
    field :result,                       :string

    def successfully_procesed?
      result.downcase == "success"
    end
  end
end
