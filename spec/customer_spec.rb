require 'sales_engine/customer'
require 'sales_engine/model'

describe Customer do 
  let(:customers) do
    Customer.all
  end
  let(:customer) do 
    Customer.find_by_first_name("Casper")
  end
  context "Call random method" do
    it "should hit method missing" do
      lambda {Customer.garbage}.should raise_error(NoMethodError)
    end
  end
  context "#find a random customer" do
    it "Should find a random customer" do
      Customer.random.should be_a Customer
    end
  end

  context "#find_by" do
    context "#find_by" do
      it "#find_by_fautly_values" do
        Customer.find_by_garbage("Mike").should be_nil
      end
      it "#find_by_first_name" do
        Customer.find_by_first_name("Casper").should_not be_nil
      end
      it "#find_by_faulty_name" do 
        Customer.find_by_first_name("Garbage").should be_nil
      end
    end

    context "#find_all_by" do
      it "#find_all_by_fautly_values" do
        Customer.find_all_by_garbage("Mike").should be_nil
      end
      it "#find_all_by_first_name" do
        Customer.find_all_by_first_name("Casper").should_not be_nil
      end
      it "#find_all_by_faulty_name" do 
        Customer.find_by_first_name("Garbage").should be_nil
      end      
    end
  end

  context "has_many associations" do
    context "#invoice" do
      it "returns an array of invoices" do 
        Customer.all.any? {|c| !c.invoices.empty?}.should be_true
      end
    end
    context '#transactions' do
      it "returns an array of transactions" do 
        Customer.all.any? {|c| !c.transactions.empty?}.should be_true
      end
    end
    context '#favorite_merchant' do 
      it "returns a single favorite merchant" do 
        customer.favorite_merchant.name.should == "Botsford Inc"
      end
    end
  end


end