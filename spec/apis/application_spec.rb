require "spec_helper"

RSpec.describe 'Application' do
  describe "GET Index" do
    it "includes 'SEO Link Reporter'" do
      get '/'
      expect(last_response.body).to include 'SEO Link Reporter'
      expect(last_response.status).to eq 200
    end
  end

  describe "GET undefined path" do
    it "shows error message" do
      get '/undefined_path'
      expect(last_response.status).to eq 404
    end
  end

  describe "POST Report" do
    context "with valid request" do
      it "redirects to the Index" do
        post "/report", url: "http://example.spec"
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
        expect(last_response.body).to include('example.spec')
      end
    end
  end
end
