require 'rails_helper'

RSpec.describe ContactsController, type: :controller do

  describe "POST create" do
    context "if contact save" do
      it "should request to create" do
        contact_us = create(:contact)
          post :create
          expect(response).to redirect_to(root_path)
      end

      it 'should incremet by 1' do
        count = Contact.count
        post :create
        expect(Contact.count).to eq(count+1)
      end
    end
  end
end
