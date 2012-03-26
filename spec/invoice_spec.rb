require 'sales_engine/invoice'
require 'sales_engine/model'

describe Invoice do
  let(:invoices) do
    Invoice.all
  end
  let(:invoice) do
    Invoice.find_by_id(1)
  end
  let(:customer) do
    Fabricate(:Customer)
  end
  let(:merchant) do
    Fabricate(:merchant)
  end
  let(:item1) do
    Fabricate(:item)
  end
  let(:item2) do
    Fabricate(:item)
  end
  let(:item3) do
    Fabricate(:item)
  end  
  let(:transaction) do
    Fabricate(:transaction)
  end
  context "has_many assocations" do
    it "returns a collection of transactions" do
      invoice.transactions.should_not be_nil
    end
    it "returns a collection of invoice items" do
      invoice.invoice_items.should_not be_nil
    end
    it "returns a collection of items" do
      invoice.invoice_items.collect(&:item).should_not be_empty
    end
  end
  context "belongs_to assocation" do
    it "returns a single customer" do
      invoice.customer.last_name.should == "Lemke"
    end
  end
  context "generation" do
    it "creates an invoice" do
      invoice = Invoice.create(:customer_id => customer, 
                               :merchant_id => merchant, 
                               :status => "shipped", 
                               :items => [item1, item2, item3], 
                               :transaction => transaction
                              )
      raise invoice.inspect
    end
  end
end
