require "test_helper"

describe PaymentInfo do
  let (:payment_info) { payment_infos(:payment1) }
  describe "relationships" do
    it "has one order" do
      payment_info.must_respond_to :order
    end
  end

  describe "validations" do
    before do
      @invaild_payment = PaymentInfo.new(buyer_name: "", email: "")
    end

    it "is valid when given valid merchant data" do
      payment_info.must_be :valid?
    end

    it "requires a buyer_name" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :buyer_name
    end

    it "requires an email" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :email
    end

    it "requires an email in a certain format" do
      @invaild_payment.email = "tricycle"
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :email

      @invaild_payment.email = "tricycle@"
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :email

      @invaild_payment.email = "tricycle@tricycle"
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :email

      @invaild_payment.email = "tricycle@tricycle."
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :email
    end

    it "requires a card_number" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :card_number
    end

    it "requires an expiration" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :expiration
    end

    it "requires an mailing_address" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :mailing_address
    end

    it "requires an cvv" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :cvv
    end

    it "requires an zipcode" do
      @invaild_payment.valid?.must_equal false
      @invaild_payment.errors.messages.must_include :zipcode
    end
  end

end
