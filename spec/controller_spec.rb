require File.dirname(__FILE__) + '/spec_helper'

RSpec.describe App do
  describe "GET Index" do
    it "says 'SEO Link Reporter'" do
      get '/'
      expect(last_response.body).to include "SEO Link Reporter"
      expect(last_response.status).to eq 200
    end
  end

  describe "POST Report" do
    it "says redirects to the index" do
      post "/report", :url => "http://example.org"
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/')
      expect(last_response.body).to include("example.org")
    end
  end
end
