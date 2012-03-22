require 'sales_engine/model'

module SalesEngine
  class Item
    include SalesEngine::Model    
    attr_accessor :id, :name, :description, :unit_price, :merchant_id, 
                  :created_at, :updated_at

    def self.most_revenue(limit)
      
    end

    def self.most_items(limit)
      
    end

    def best_day
      
    end

  end

end