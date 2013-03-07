require 'spec_helper'
module TrafficSpy

# {"url":"http://curlexample.com/party","requestedAt":"2013-02-16 01:38:28 -0700","respondedIn":99,"referredBy":"http://curlexample.com","requestType":"GET","parameters":[],"eventName": "heromode","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"4253","resolutionHeight":"2341","ip":"63.29.38.211"}

  describe Request do
    let(:request){ Request.new(1, {"url"              => "www.google.com/porn/alien/weirdshit",
                                   "requestedAt"      => "2013-02-16 01:38:28 -0700",
                                   "respondedIn"      => 69,
                                   "referredBy"       => "www.google.com",
                                   "requestType"      => "GET",
                                   "parameters"       => [],
                                   "eventName"        => "whackinIt",
                                   "userAgent"        => "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                                   "resolutionWidth"  => "6969",
                                   "resolutionHeight" => "0690",
                                   "ip"               => "63.29.38.211"})}
    let(:request2){ Request.new(1, {"url"              => "www.google.com/porn/alien/weirdshit",
                                   "requestedAt"      => "2013-02-16 01:38:28 -0700",
                                   "respondedIn"      => 89,
                                   "referredBy"       => "www.google.com",
                                   "requestType"      => "GET",
                                   "parameters"       => [],
                                   "eventName"        => "whackinIt",
                                   "userAgent"        => "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                                   "resolutionWidth"  => "6969",
                                   "resolutionHeight" => "0690",
                                   "ip"               => "63.29.38.211"})}

    before(:each) do
      Request.destroy_all
    end

    context "self-creation" do
      describe "initialize" do
        it "should create a request object" do
          request.class.should == Request
        end
      end

      describe "save" do
        it "should save an instance of itself" do
          expect{ request.save }.to change{ Request.count }.by(1)
        end
      end
    end

    context "searching" do
      describe ".urls_by_times_requested" do
        it "should return an array of hashes with urls associated with the given customer as keys and the number of times they were received as values" do
          request.save
          test_array = Request.urls_by_times_requested(1)
          expect( test_array ).to eq [["www.google.com/porn/alien/weirdshit", 1]]
        end
      end

      describe ".urls_by_response_time" do
        it "returns an array of urls associated with given customer id listed by response times" do
          request.save
          test_array = Request.urls_by_response_time(1)
          expect( test_array ).to eq [["www.google.com/porn/alien/weirdshit", 69.0]]
        end
      end

      describe ".url_extensions" do
        it "returns an array of the parts of the url's associated with the customer that differ from their root url" do
          request.save
          test_array = Request.url_extensions(1)
          expect( test_array ).to eq ["/porn/alien/weirdshit"]
        end
      end

      describe ".url_specific_response_times" do
        it "returns an array of response times associated with given url" do
          request.save
          test_array = Request.url_specific_response_times("www.google.com/porn/alien/weirdshit")
          expect( test_array).to eq [{:url=>"www.google.com/porn/alien/weirdshit", :respondedIn=>69}]
        end
      end

      describe ".events_by_times_received" do
        it "returns an array of events associated customer id by times received" do
          request.save
          test_array = Request.events_by_times_received(1)
          expect( test_array ).to eq [["whackinIt", 1]]
        end
      end

      describe ".event_hourly_breakdown" do
        it "returns an array hashes with the hours of the day as keys and the number of times a specific event was received at that hour as the value" do
          request.save
          test_array = Request.event_hourly_breakdown("whackinIt", 1)
          expect( test_array ).to eq({"01"=>1})
        end
      end

      describe ".browser_breakdown" do
        it "returns an array of hashes with browser names as keys and times they appeared in requests as values" do
          request.save
          test_array = Request.browser_breakdown(1)
          expect( test_array ).to eq({"Chrome"=>1})
        end
      end

      describe ".operating_system_breakdown" do
        it "returns an array of hashes with operating systems as keys and times they appeared in requests as values" do
          request.save
          # request2.save
          test_array = Request.operating_system_breakdown(1)
          expect( test_array ).to eq({nil=>1})
        end
      end

      describe ".event_exisis?" do
        it "returns true if given event exists in database, and false otherwise" do
          request.save
          test_array = Request.event_exists?("whackinIt")
          expect( test_array ).to eq true
        end
      end

      describe ".screen_resolutions_by_times_requested" do
        it "returns an array, with hashes containing screen resolution dimensions as keys and their respective values as values, and the number of times that combination appeared in requests" do
          request.save
          test_array = Request.screen_resolutions_by_times_requested(1)
          expect( test_array ).to eq [[{:resolutionWidth=>6969, :resolutionHeight=>690}, 1]]
        end
      end

      describe ".url_exisis?" do
        it "returns true if given url exists in database, and false otherwise" do
          request.save
          test_array = Request.url_exists?("www.google.com/porn/alien/weirdshit")
          expect( test_array ).to eq true
        end
      end

      # describe ".payload_data_exisis?" do
      #   it "returns true if given payload data exists in database, and false otherwise" do
      #     request.save
      #     clean_payload_data = JSON.parse({"url":"http://curlexample.com/party","requestedAt":"2013-02-16 01:38:28 -0700","respondedIn":99,"referredBy":"http://curlexample.com","requestType":"GET","parameters":[],"eventName": "heromode","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"4253","resolutionHeight":"2341","ip":"63.29.38.211"})
      #     test_array = Request.payload_data_exists?(clean_payload_data)
      #     expect( test_array ).to eq false
      #   end
      # end
    end
  end
end
