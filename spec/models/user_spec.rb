require 'spec_helper'
require 'dm-validations'

RSpec.describe 'User' do
  context "with valid data" do
    user = SEOTool::User.create(username: "test",
                                email:    "email@email.com",
                                password: "a"*9)
    it "validates" do
     expect(user.valid?).to be true
   end
  end

  context "with short password" do
    user = SEOTool::User.create(username: "test",
                                email:    "email@email.com",
                                password: "a"*3)
    it "doesn't validate" do
      expect(user.valid?).to be false
    end
  end

  context "with empty username" do
    user = SEOTool::User.create(username: "",
                                email:    "email@email.com",
                                password: "a"*12)
    it "doesn't validate" do
      expect(user.valid?).to be false
    end
  end
end
