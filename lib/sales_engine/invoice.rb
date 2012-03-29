require 'sales_engine/model'

module SalesEngine

  class Invoice
    include Model

    has_many :transactions
    has_many :invoice_items
    has_many :items, :through => :invoice_items
    belongs_to :customer
    belongs_to :merchant
    field :status, :string

    def pending?
      !paid?
    end

    def paid?
      transactions.any?(&:successfull?)
    end

    def total_cost
      invoice_items.sum(&:total_cost)
    end

    def item_count
      invoice_items.sum(&:quantity)
    end

    def self.create(attributes=nil)
      items = attributes.delete(:items)
      invoice = super(attributes)

      if items
        items.each do |item|
          InvoiceItem.create(:invoice => invoice,
                             :unit_price => item.unit_price,
                             :item => item, :quantity => 1
                            )
        end
      end

      invoice
    end

    def self.paid_invoices
      all.select(&:paid?)
    end

    def self.average_revenue(date=nil)
      if date
        date = date.to_date
        select = paid_invoices.select { |i| i.created_at.to_date == date }
      else
        select = paid_invoices
      end
      (select.sum(&:total_cost) / select.count).round(2)
    end

    def charge(attributes)
      attributes[:invoice_id] = self
      Transaction.create(attributes)
    end

     def self.pending
      all.select(&:pending?)
    end

    def self.average_items(date=nil)
      if date
        date = date.to_date
        select = paid_invoices.select { |i| i.created_at.to_date == date }
      else
        select = paid_invoices
      end
      (select.sum(&:item_count) / select.count.to_d).round(2)
    end

  end
end
