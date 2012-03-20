module SalesEngine
  class InvoiceItem
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at

    #belongs_to :invoice, :item

    def invoice

    end

    def item

    end

  end


end