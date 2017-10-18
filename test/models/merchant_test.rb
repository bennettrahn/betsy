require "test_helper"

describe Merchant do
  before do
    @valid_test_m = Merchant.new(username: "tricycle", email: "tricycle@tricycle.com" )
  end

  describe "validations" do
    it "is valid when given valid merchant data" do
      @valid_test_m.must_be :valid?
    end

    it "requires a username" do
      merchant = Merchant.new(username: "", email: "email@email.com")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :username
    end

    it "requires an email" do
      merchant = Merchant.new(username: "username", email: "")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email
    end

    it "requires an email in a certain format" do
      merchant = Merchant.new(username: "username", email: "tricycle")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchant1 = Merchant.new(username: "username", email: "tricycle@")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchant2 = Merchant.new(username: "username", email: "tricycle@tricycle")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchant2 = Merchant.new(username: "username", email: "tricycle@tricycle.")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email
      
    end
  end
end
