require 'sales_engine/model'
require 'sales_engine/transaction'

describe Transaction do
  let(:items) do
    Transaction.all
  end
  let(:item) do
    Transaction.find_by_id("1")
  end

  #context "belongs_to assocation" do
    #it "returns an instance of an invoice item" do
      #item.invoice_item.should_not be_nil
    #end
    #it "returns an instance of merchant" do
      #item.merchant.should_not be_nil
    #end
  #end
end
