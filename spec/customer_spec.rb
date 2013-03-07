require 'spec_helper'
module TrafficSpy

  describe Customer do
    let(:customer){ Customer.new(:identifier   => "DanMee",
                                 :rootUrl => "www.effinsweetness.com")}

    before(:each) do
      Customer.destroy_all
    end

    context "self-creation" do
      describe "initialize" do
        it "should create a customer object" do
          customer.class.should == Customer
        end
      end

      describe "#save" do
        it "should be able to save an instance of itself" do
          expect{ customer.save }.to change{ Customer.count }.by(1)
        end
      end
    end

    context "searching" do
      describe ".find_root_url" do
        it "should return the root url associated with the given identifier" do
          customer.save
          test = Customer.find_root_url("DanMee")
          expect( test ).to eq "www.effinsweetness.com"
        end
      end

      describe ".find_id" do
        it "should return the id associated with the given identifier" do
          customer.save
          Customer.data.where(:identifier => "DanMee").set(:id => 1)
          test = Customer.find_id("DanMee")
          expect( test ).to eq 1
        end
      end

      describe ".identifier_exists?" do
        it "should return true if identifier exists in DB, and false otherwise" do
          customer.save
          expect( Customer.identifier_exists?("DanMee")).to eq true
        end
      end
    end
  end
end
