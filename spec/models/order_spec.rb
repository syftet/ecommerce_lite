require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'check order should cancle or not' do
      it 'should return true ' do
        order = Order.new(
            state: 'approved')
        expect(order.can_cancel?).to eq(true)
      end
      it 'should return false' do
          order = Order.new(
              state: 'John')
          expect(order.can_cancel?).to eq(false)
    end
  end

  describe 'check order should resume or not' do
    it 'should return true ' do
      order = Order.new(
          state: 'canceled')
      expect(order.can_resume?).to eq(true)
    end
    it 'should return false' do
      order = Order.new(
          state: 'John')
      expect(order.can_resume?).to eq(false)
    end
  end

  describe 'should approved or not' do
    it 'return true ' do
      order = Order.new(
          state: 'canceled',
          completed_at: Time.now
      )
      expect(order.can_approve?).to eq(true)
    end
    it 'return false' do
      order = Order.new(
          state: 'approved',
          completed_at:nil )
      expect(order.can_approve?).to eq(false)
    end
    it 'return false' do
      order = Order.new(
          state: 'approved',
          completed_at:nil )
      expect(order.can_approve?).to eq(false)
    end
  end

  describe '.net_total' do
    before(:each) do
      @order = Order.new(
          total: 100
      )
    end
    context 'should calculate net total' do
      it 'calculate net total when shipment present ' do
        shipment = @order.create_shipment(cost:10)
        expect(@order.net_total).to eq(110)
      end
      it 'calculate net total when shipment is not present ' do
        expect(@order.net_total).to eq(100)
      end
    end
  end

  describe 'should return 0' do
    it "should " do
     order = Order.new()
      expect(order.adjustment_total).to eq(0)
    end
  end

  describe '.next' do
   before(:each) do
      @order = Order.new()
   end
    context 'assing value to state attribute depending on state' do
       it "should assing delivery to state" do
         @order.state='address'
          @order.next
          expect(@order.state).to eq('delivery')
       end
      it "should assing payment to state" do
        @order.state='delivery'
        @order.next
        expect(@order.state).to eq('payment')
      end
    end
  end

  describe '.contents' do
  before(:each) do
    @order = Order.new()
  end
    it "should create new ordercontent" do
      orderContent =OrderContents.new(@order)
     expect(orderContent.class).to eq(OrderContents)
    end
  end

  describe '.update_with_params' do
    before(:each) do
      @order = Order.new()
      @order.create_ship_address()
      @shipingMethod = ShippingMethod.create(rate: 30,code:'101')

    end
    context 'update param state' do
     it "should update attribute" do
       params = {:state => "address", :email => "ahadhossain@gmail.com"}
       permitedParams = {:state => "address", :email => "monon@gmail.com"}

       @order.update_with_params(params,permitedParams)
       expect(@order.email).to eq("monon@gmail.com")
     end
    end

    context 'when state = dalevery' do
       it "should update attribute" do
         params = {:state => "delivery", :email => "ahadhossain@gmail.com"}
         permitedParams = {:state => "delivery", :email => "pias@gmail.com",:shipping_method =>@shipingMethod.id}
         @order.update_with_params(params,permitedParams)
         expect(@order.email).to eq("pias@gmail.com")
       end
    end
  end


  describe ".completed?" do
    before() do
      @order = Order.new(completed_at: DateTime.now)
    end
    it 'should return true if order id completed' do
      expect(@order.completed?).to eq(true)
    end
  end

  describe "#get_incomplete_order" do
    before(:each) do
      @user = User.create(
          email: "ahadhossain73@gmail.com",
          password: "password"
      )

      @order1 = Order.create(completed_at:nil)
      @order2 = Order.create(completed_at:nil)
      @order3 = Order.create(completed_at:DateTime.now)
      @order4 = Order.create(completed_at:DateTime.now)
      @order4 = Order.create(guest_token:"guest",completed_at:DateTime.now)

    end
    context "return incompleted order" do
      it 'should return nill order' do
       order = Order.get_incomplete_order("guest",@user)
        expect(order).to eq(nil)
      end

      it 'should not return nill order' do
        @user.orders.create(completed_at:nil,payment_total: 30)
        order = Order.get_incomplete_order("gusest",@user)
        expect(order.payment_total).to eq(30)
      end
    end

  end

end
