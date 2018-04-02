require 'rails_helper'

RSpec.describe Setting, type: :model do

  describe ".initialize" do
    it "should set currency and currency symble" do
      setting = Setting.new
      expect(setting.currency).to eq('Taka')
      expect(setting.currency_symbol).to eq('$')
    end

  end
end
