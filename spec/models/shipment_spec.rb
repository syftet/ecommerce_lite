require 'rails_helper'

RSpec.describe Shipment, type: :model do

  describe ".with_state" do
    it "should return false" do
      shipment = Shipment.create()
      expect(shipment.with_state("state")).to eq(false)
    end
    it "should return true" do
      shipment = Shipment.create(state:"state")
      expect(shipment.with_state("state")).to eq(true)
    end
  end

  describe ".ready?" do
    it "should return false" do
      order =Order.create(
          state: 'John')
      shipment = Shipment.create(order:order)
      expect(shipment.ready?).to eq(false)
    end
  end

  describe ".shipped?" do
    it "should return true" do
      shipment = Shipment.create(state:'shipped')
      expect(shipment.shipped?).to eq(true)
    end
    it "should return false" do
      shipment = Shipment.create(state:'')
      expect(shipment.shipped?).to eq(false)
    end
  end

  describe ".currency" do
    it "should return currency" do
      order =Order.create(
          state: 'John',currency:'taka')
      shipment = Shipment.create(order:order)
      expect(shipment.currency).to eq("taka")
    end
  end
  describe ".set_cost_zero_when_nil" do
   it "should set cost to 0" do
     shipment = Shipment.create
     shipment.send(:set_cost_zero_when_nil)
     expect(shipment.cost).to eq(0)
   end
  end

end
