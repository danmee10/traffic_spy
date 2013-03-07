require 'spec_helper'

describe "/sources" do
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  before(:each) do
    TrafficSpy::Customer.destroy_all
    TrafficSpy::Request.destroy_all
  end

  describe "application registration at /sources" do
    context "given valid and unique parameters" do
      it "registers the application" do
        post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
        expect(last_response).to be_ok
        expect(last_response.body.downcase).to include("jumpstartlab")
      end
    end

    context "given no parameters" do
      it "throws error 400" do
          post "/sources", {:identifier => '', :rootUrl => ''}
          # expect(last_response).to be_ok
          expect(last_response.body.downcase).to include("error")
        end
      end

    context "given parameters for an already existing applicaion" do
      it "returns an error" do
        2.times { post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}}
        expect(last_response.status).to eq 403
      end
    end
  end

  describe "data submission at /sources/IDENTIFIER/data" do
    context "when the application is known" do
      before(:each) do
        post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
      end

      it "accepts data" do

        payload_hash =  { "hghghghg" => "hajhdshjfjh" }
        headers = { "payload" => payload_hash.to_json }
        post "/sources/jumpstartlab/data", headers
        expect(last_response.status).to eq 200
      end

      it "throws error when no data exists" do
        2.times { post "/sources/jumpstartlab/data", {"payload" => ''} }
        expect(last_response.status).to eq 400
        expect(last_response.body.downcase).to include("payload")
      end

      it "throws error when no data exists" do
        2.times { post "/sources/jumpstartlab/data", {"payload" => nil} }
        expect(last_response.status).to eq 400
        expect(last_response.body.downcase).to include("payload")
      end

      it "rejects duplicated data" do
        payload_hash =  { "hghghghg" => "hajhdshjfjh" }
        headers = { "payload" => payload_hash.to_json }

        2.times { post "/sources/jumpstartlab/data", headers }
        expect(last_response.status).to eq 403
        expect(last_response.body.downcase).to include("payload")
      end
    end
  end

  describe "data display at /sources/IDENTIFIER" do
    it "assigns variables properly" do
      post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
      get "/sources/jumpstartlab", {:identifier => 'jumpstartlab'}
      expect(last_response.status).to eq 200
    end
  end

  describe "data display at /sources/IDENTIFIER/urls" do
    it "assigns variables properly" do
      post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
      get "/sources/jumpstartlab/urls/*", {:identifier => 'jumpstartlab'}
      expect(last_response.status).to eq 200
    end
  end

  describe "data display at /sources/IDENTIFIER/events" do
    it "assigns variables properly" do
      post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
      get "/sources/jumpstartlab/events", {:identifier => 'jumpstartlab'}
      expect(last_response.status).to eq 200
    end
  end

  describe "data display at /sources/IDENTIFIER/events/goodness" do
    it "assigns variables properly" do
      post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
      get "/sources/jumpstartlab/events/*", {:identifier => 'jumpstartlab'}
      expect(last_response.status).to eq 200
    end
  end

  describe "data display at /sources/IDENTIFIER/events/goodness" do
    it "assigns variables properly" do
      post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
      get "/sources/jumpstartlab/events/*", {:identifier => 'jumpstartlab'}
      expect(last_response.status).to eq 200
    end
  end

  # describe "data display at /sources/IDENTIFIER/data" do
  #   it "assigns variables properly" do
  #     post "/sources", {:identifier => 'jumpstartlab', :rootUrl => 'http://jumpstartlab.com'}
  #     get "/sources/jumpstartlab/events/*", {:identifier => 'jumpstartlab'}
  #     expect(last_response.status).to eq 200
  #   end
  # end
end



