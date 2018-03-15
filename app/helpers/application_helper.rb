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
      html_code += taxon_breadscrumb(taxon.category) # + "<li> #{link_to taxon.name, ''} </li>"
    end
    if product.present?
      html_code += "<li> #{link_to taxon.name, ''} </li>"
    end
    customs.each do |link_text, link|
      html_code += "<li> #{link_to link_text, link} </li>"
    end
    html_code + "<li> #{t(text.downcase.to_sym)} </li>"
  end

  def sort_link object, field, text
    text
  end

  def taxon_breadscrumb(node)
    html = []
    return '' unless node.present?
    if node.category.present?
      html.push("<li> #{link_to node.name, categories_path(node.permalink)} </li>")
      html.push(taxon_breadscrumb(node.category))
    else
      html.push("<li> #{link_to node.name, categories_path(node.permalink)} </li>")
    end
    html.reverse.join('')
  end

  def currency_symbol
    '$'
  end

  def color_filters(taxon = nil)
    variants = filter_variant(taxon)
    variants.map(&:color).compact
  end

  def size_filters(taxon = nil)
    variants = filter_variant(taxon)
    variants.map(&:size).compact
  end

  def filter_variant(taxon)
    if taxon
      product_ids = taxon.products.map(&:id)
      Product.where(product_id: product_ids)
    else
      Product.all.limit(10)
    end
  end

end
