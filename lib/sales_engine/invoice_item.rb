require 'sales_engine/model'

module SalesEngine
  class InvoiceItem
    include SalesEngine::Model

    belongs_to :item
    belongs_to :invoice
    field :quantity,    :integer
    field :unit_price,  :decimal

    def total_cost
      unit_price * quantity
    end

    def self.paid
      all.select {|item| item.invoice.paid?}
    end
  end
end
