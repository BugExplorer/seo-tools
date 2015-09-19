require File.dirname(__FILE__) + '/spec_helper'

RSpec.describe App do
  describe "GET Index" do
    it "says 'SEO Link Reporter'" do
      get '/'
      expect(last_response.body).to include "SEO Link Reporter"
      expect(last_response.status).to eq 200
    end
  end

  describe "Get undefined path" do
    it "shows error message" do
      get '/test'
      expect(last_response.body).to include "Page not found"
      expect(last_response.status).to eq 404
    end
  end

  describe "POST Report" do
    context "with valid request" do
      it "redirects to the index" do
        post "/report", :url => "http://example.org"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
        expect(last_response.body).to include("example.org")
      end
    end

    context "with invalid request" do
      it do
        expect {
          post "/report", :url => "http://example.wrong"
        }.to raise_error Curl::Err::HostResolutionError
      end
    end
  end
end
