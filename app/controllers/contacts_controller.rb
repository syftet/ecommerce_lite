class ContactsController < ApplicationController

  def new
    @contact_us = Contact.new
  end

  def create
    @contact_us = Contact.new(contact_params)
    respond_to do |format|
      if @contact_us.save
        format.html { redirect_to root_path, notice: 'Thank you for contacting with us. We will get back to you soon!' }
      else
        format.html { render :new, notice: "Sorry. You should try again." }
      end
    end
  end


  private

  def contact_params
    if params[:contact]
      params[:contact].permit!
    else
      {}
    end
  end


end
