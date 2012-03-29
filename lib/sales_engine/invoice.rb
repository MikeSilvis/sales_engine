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
      @paid ||= transactions.any?(&:successfull?)
    end

    def total_cost
      @total_cost ||= invoice_items.sum(&:total_cost)
    end

    def item_count
      @item_count ||= invoice_items.sum(&:quantity)
    end

    def self.create(attributes=nil)
      invoice = super(attributes)

      items = attributes[:items]
      if items
        items.each do |item|
          InvoiceItem.create(:invoice => invoice,
                             :unit_price => item.unit_price,
                             :item => item, :quantity => 0
                            )
        end
      end

      invoice
    end

    def self.paid_invoices
      @paid_invoices ||= all.select(&:paid?)
    end

    def self.average_revenue(date=nil)
      if date
        date.to_date
        select = all.select { |i| i.created_at == date }
      else
        select = all
      end
      @average_revenue ||= select.sum(&:total_cost) / all.count
    end

    def charge(attributes)
      attributes[:invoice_id] = self
      @charge ||= Transaction.create(attributes)
    end

     def self.pending
      @pending ||= all.select(&:pending?)
    end

    def self.average_items(date=nil)
      if date
        date.to_date
        select = all.select { |i| i.created_at == date }
      else
        select = all
      end
      @average_items ||= select.sum(&:item_count) / all.count
    end

  end
end
