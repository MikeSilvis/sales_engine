require 'sales_engine/invoice'
require 'sales_engine/model'

describe Merchant do 
  let(:invoices) do 
    Invoice.all
  end
  let(:invoice) do 
    Invoice.find_by_id("1")
  end
  context "has_many assocations" do
    it "returns a collection of transactions" do
      invoice.transactions.should_not be_nil
    end
    it "returns a collection of invoice items" do
      invoice.invoice_items.should_not be_nil
    end
  end
end