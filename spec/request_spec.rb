require 'spec_helper'
module TrafficSpy

{"url":"http://curlexample.com/party","requestedAt":"2013-02-16 01:38:28 -0700","respondedIn":99,"referredBy":"http://curlexample.com","requestType":"GET","parameters":[],"eventName": "heromode","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"4253","resolutionHeight":"2341","ip":"63.29.38.211"}

  describe Request do
    let(:request){ Request.new(:url => "www.google.com/porn/alien/weirdshit",
                               :requestedAt => "2013-02-16 01:38:28 -0700",
                               :respondedIn => 69,
                               :referredBy => "www.google.com",
                               :requestType => "GET",
                               :parameters => [],
                               :eventName => "whackinIt",
                               :userAgent => "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                               :resolutionWidth => "6969",
                               :resolutionHeight => "0690",
                               :ip => "63.29.38.211")
