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
      @best_day ||= InvoiceItem.paid.
        select { |invoice_item| invoice_item.item == self }.
        group_by { |invoice_item| invoice_item.invoice.created_at }.
        sort_by { |date, invoice_items| -invoice_items.sum(&:quantity) }.
        first[0]
    end

    def self.most_revenue(limit)
      @most_revenue ||= InvoiceItem.paid.
        group_by(&:item).
        sort_by { |item, invoice_items| -invoice_items.sum(&:total_cost) }.
        map { |item, invoice_items| item }.
        first(limit)
    end

    def self.most_items(limit)
      @most_items ||= InvoiceItem.paid.
        group_by(&:item).
        sort_by { |item, invoice_items| -invoice_items.sum(&:quantity) }.
        map { |item, invoice_items| item }.
        first(limit)
    end

  end

end
