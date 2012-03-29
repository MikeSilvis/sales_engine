require 'sales_engine/model'

module SalesEngine
  class InvoiceItem
    include Model

    belongs_to :item
    belongs_to :invoice
    field :quantity,    :integer
    field :unit_price,  :decimal

    def total_cost
      @total_cost ||= unit_price * quantity
    end

    def self.paid
      @paid ||= all.select {|item| item.invoice.paid?}
    end
  end
end
