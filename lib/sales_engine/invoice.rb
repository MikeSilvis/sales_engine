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
    
    def self.average_revenue
      all.sum(&:total_cost) / all.count
    end

    def charge(attributes)
      attributes[:invoice_id] = self
      Transaction.create(attributes)
    end

     def self.pending
      all.select(&:pending?)
    end
       
  end
end
