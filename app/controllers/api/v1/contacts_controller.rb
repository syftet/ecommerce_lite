class Api::V1::ContactsController <  Api::ApiBase
  def create
    contact = Contact.new(contact_params)
    if contact.save
      message = 'Thank you for contact with us, We will get back to you shortly'
      success = true
    else
      message = contact.errors.first
      success = false
    end
    render json: {response: message, success: success}
  end

  private

  def contact_params
    params.require(:contact).permit!
  end
end