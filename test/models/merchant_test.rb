require "test_helper"

describe Merchant do
  before do
    @valid_test_m = Merchant.new(username: "tricycle", email: "tricycle@tricycle.com" )
  end

  it "must be valid" do
    @valid_test_m.must_be :valid?
  end
end
