require 'sales_engine/model'
module SalesEngine
  class Transaction
    include Model

    belongs_to :invoice
    field :credit_card_number,           :string
    field :credit_card_experiation_date, :datetime
    field :result,                       :string

    def successfull?
      result.downcase == "success"
    end

    def unsuccessfull?
      result.downcase != "success"
    end
  end
end
