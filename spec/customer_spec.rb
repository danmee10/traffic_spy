require 'spec_helper'
# require 'simplecov'
# SimpleCov.add_filter '/test'
# SimpleCov.start

describe TrafficSpy::Customer do

  context "Ability to self-create" do
    describe "initialize" do
      it "should create a customer object" do
        test_customer = TrafficSpy::Customer.new({:identifier => "DanMee", :rootUrl => "www.effinsweetness.com"})
        test_customer.class.should == TrafficSpy::Customer
      end
    end
  end
end
