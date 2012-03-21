require 'sales_engine/model'
module SalesEngine
  class Transaction
    include SalesEngine::Model   
     #belongs_to :invoice
     attr_accessor :id, :invoice_id, :credit_card_number,
                   :credit_card_experiation_date, :result, :created_at,
                   :updated_at
      def invoice

      end
  end

end