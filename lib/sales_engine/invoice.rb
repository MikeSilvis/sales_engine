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

    def self.paid_invoices
      all.select(&:paid?)
    end

    def self.average_revenue(date=nil)
      if date
        date.to_date
        select = all.select { |i| i.created_at == date }
      else
        select = all
      end
      select.sum(&:total_cost) / all.count
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
        date.to_date
        select = all.select { |i| i.created_at == date }
      else
        select = all
      end
      select.sum(&:item_count) / all.count
    end

  end
end
