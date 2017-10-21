require "test_helper"

describe Merchant do
  before do
    @m = Merchant.new
    @valid_test_m = Merchant.new(username: "tricycle", email: "tricycle@tricycle.com" )
  end

  describe "relations" do
    it "responds to products" do
      @m.must_respond_to :products
    end

    it "has one or many products" do
      @m.must_respond_to :products
      @m.products.must_be :empty?

      product = products(:tricycle)

      @m.products << product

      @m.products.must_include product
    end
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

    it "requires a unique username" do
      merchant = merchants(:anders)
      same_username = Merchant.new(username: merchant.username, email: merchant.username)
      same_username.valid?.must_equal false
      same_username.errors.messages.must_include :username
    end

    it "requires an email" do
      merchant = Merchant.new(username: "username", email: "")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email
    end

    it "requires a unique email" do
      merchant = merchants(:anders)
      same_email = Merchant.new(username: merchant.username, email: merchant.username)
      same_email.valid?.must_equal false
      same_email.errors.messages.must_include :email
    end

    it "requires an email in a certain format" do
      merchant = Merchant.new(username: "username", email: "tricycle")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchant1 = Merchant.new(username: "username", email: "tricycle@")
      merchant1.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchant2 = Merchant.new(username: "username", email: "tricycle@tricycle")
      merchant2.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchant3 = Merchant.new(username: "username", email: "tricycle@tricycle.")
      merchant3.valid?.must_equal false
      merchant.errors.messages.must_include :email
    end
  end

  describe "custom methods" do

    #below test not passing - in merchant.rb, if I comment out all the auth_hash['info'] lines, then it passes. In test_helper.rb, #mock_auth_hash does not set an ['info']['name']... but that can't be all the problem (if it is even a problem), because ['info']['email'] and ['info']['nickname'] also aren't being recognized
    describe "#self.from_auth_hash" do
      it "returns an instance of Merchant" do
        merchant = merchants(:lauren)

        merchant_instance = Merchant.from_auth_hash('github', mock_auth_hash(merchant))

        merchant_instance.must_be_instance_of Merchant
      end
    end

    describe "relevant_orders" do
      it "returns an Array of Hashes Order objects" do
        merchant = merchants(:lauren)
        should_return = merchant.relevant_orders
        should_return.must_be_instance_of Array
        should_return[0].must_be_instance_of Hash
      end

      it "returns an empty Array if no orders" do
        Order.destroy_all
        merchant = merchants(:lauren)
        should_return = merchant.relevant_orders
        should_return.length.must_equal 0
      end
    end

  end

end
