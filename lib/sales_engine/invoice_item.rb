require 'sales_engine/model'

module SalesEngine
  class InvoiceItem
    include SalesEngine::Model  
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, 
                  :created_at, :updated_at
    #belongs_to :invoice, :item
    
    def invoice
      Invoice.find("id", invoice_id).first
    end

    def item
      Item.find("id", item_id).first
    end

  end


end