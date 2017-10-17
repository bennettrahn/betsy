require "test_helper"

describe MerchantsController do
  describe "index" do
    it "succeeds when there are merchants" do
    Merchant.count.must_be :>, 0, "No merchants in the test fixtures"
    get merchants_path
    must_respond_with :success
  end

  it "succeeds when there are no merchants" do
    Merchant.destroy_all
    get merchants_path
    must_respond_with :success
  end
  end
end
