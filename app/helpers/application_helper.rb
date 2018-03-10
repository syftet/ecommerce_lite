module ApplicationHelper
  # Devise Things

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Menu things

  def get_active_class(action, menu_action)
    action == menu_action ? 'active' : ''
  end

  def generate_breadscrumb(text, taxon = nil, product = nil, customs = {})
    html_code = ''
    if taxon.present?
      p taxon_breadscrumb(taxon)
      html_code += taxon_breadscrumb(taxon.parent) # + "<li> #{link_to taxon.name, ''} </li>"
    end
    if product.present?
      html_code += "<li> #{link_to taxon.name, ''} </li>"
    end
    customs.each do |link_text, link|
      html_code += "<li> #{link_to link_text, link} </li>"
    end
    html_code + "<li> #{t(text.downcase.to_sym)} </li>"
  end

  def currency_symbol
    '$'
  end

end
