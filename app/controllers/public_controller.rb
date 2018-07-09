require 'mail'

class PublicController < ApplicationController
  def contact_us
    @contact_us = Contact.new
  end

  def about_us
    # @title = "About Us - Brandcruz.com"
    # @keywords = "brandcruz, Brand Cruz, Brandcruz.com"
    # @description = "Brandcruz.com customers always get FAST, FREE Shipping and returns with NO order minimums and FREE 60-Day Returns!"
  end

  def return_policy
    @title = "BrandCruz: Designer Apparel, Shoes, Handbags, & Beauty FREE SHIPPING"
    @keywords = "free shipping, coupon code, brand, cloth, shoes, women shoes"
    @description = "Free Shipping & Free Returns at Brandcruz.com. Shop the latest styles from top designers including Michael Kors, Tory Burch, Burberry, Christian Louboutin."
  end

  def international
    @title = "Brandcruz: Search and find the latest in fashion | Shipping Worldwide"
    @keywords = "Shoes, Dress, New to Sale, Designers,"
    @description = "FREE RETURNS & FREE 3-DAY SHIPPING WORLDWIDE -Women’s, Men’s Dresses, Handbags, Shoes, Jeans, Tops and more."
  end

  def promise

  end

  def subscribe
    email = params[:newsletter_subscription][:email]
    begin
      Mail::Address.new(email)
      newsletter = NewsletterSubscription.find_or_initialize_by(email: email)
      p newsletter
      if newsletter.save!
        p 'iopiopipoiop'
        cookies[:hidemodal] = 1
      else
        p newsletter.errors
        @message = newsletter.errors.first
      end
    rescue => ex
      p 'sdfsdfsdfsdf'
      p ex.message
      @message = "Email address not valid: #{ex.message}"
    end
    respond_to do |format|
      format.js
    end
  end

  def privacy_policy

  end

  def term_condition

  end

  def unauthorized
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.js {}
    end
  end

  def safe_shopping_guarantee
    @title = "Brandcruz.com – Shop securely for Shoes, clothing, accessories and more on sale!"
    @keywords = "Women's Clothing, Sandals, Jackets & Coats, Women's Shoes"
    @description = "Discounted shoes, clothing, accessories and more at Brandcruz.com! Shop for brands you love on sale. Score on the Style, Score on the Price."
  end

  def secure_shopping
    @title = "Brandcruz.com - Up to 50% off luxury fashion‎ |Shop Secure"
    @keywords = "Sale, Shoes, Designers, Dresses, Clothing, Tops , Bags, porter"
    @description = "Shop designer fashion online at Brandcruz.com. Designer clothes, designer shoes, designer bags and designer accessories from top designer brands: ..."
  end

  def coupon
    @title = "Brandcruz.com coupon code – Brandcruz.com | FREE SHIPPING & RETURNS"
    @description = "Brandcruz.com coupon code available online, Promotion code for unbeatable discount"
    @keywords = "brandcruz.com coupon code, brandcruz, brandcruz.com"
  end

  def faq
    # @title = "Shop Brandcruz.com  for the latest trends and the best deals | BrandCruz"
    # @keywords = "Plus size, Men, Women’s sale, sale sale, sale, hello"
    # @description = "Brandcruz.com is the authority on fashion & the go-to retailer for the latest trends, must-have styles & the hottest deals. Shop dresses, tops, tees, leggings & more."
  end

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.xml { render xml: {error: 'Not found'}, status: 404 }
      format.json { render json: {error: 'Not found'}, status: 404 }
    end
  end

  def internal_error

  end

  def unacceptable

  end

  def wishlist
    render layout: 'product'
  end

  def cart
    render layout: 'product'
  end

  def checkout
    render layout: 'product'
  end

  private

  def contact_us_params
    params.require(:contacts).permit!
  end
end
