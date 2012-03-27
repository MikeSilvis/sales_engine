require 'sales_engine/model'

module SalesEngine
  class Item
    include Model

    has_many :invoice_items
    has_many :invoices, :through => :invoice_items
    belongs_to :merchant
    field :name,         :string
    field :description,  :string
    field :unit_price,   :decimal

    def best_day
      InvoiceItem.paid.
        select { |invoice_item| invoice_item.item == self }.
        group_by { |invoice_item| invoice_item.invoice.created_at }.
        sort_by { |date, invoice_items| -invoice_items.sum(&:quantity) }.
        first
    end

    def self.most_revenue(limit)
      InvoiceItem.paid.
        group_by(&:item).
        sort_by { |item, invoice_items| -invoice_items.sum(&:total_cost) }.
        map { |item, invoice_items| item }.
        first(limit)
    end

    def self.most_items(limit)
      InvoiceItem.paid.
        group_by(&:item).
        sort_by { |item, invoice_items| -invoice_items.sum(&:quantity) }.
        map { |item, invoice_items| item }.
        first(limit)
    end

  end

end
