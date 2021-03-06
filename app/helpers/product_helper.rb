module ProductHelper
  def product_preview_image(product, url = false)
    if product.images.present?
      image_url = product.images.first.file.url(:product)
    else
      image_url = no_image
    end
    url ? image_url : image_tag(image_url, class: 'image-hover product-image')
  end

  def mini_image(variant, size = 50)
    image_url = no_image
    if variant.present?
      image_url = variant.images.present? ? variant.images.order(:id).first.file.url(:small) : no_image
    end
    image_tag(image_url, style: "width: #{50}px")
  end

  def wishlist_link(product)
    wishlist = current_user.present? ? current_user.wishlists.find_by_product_id(product) : nil
    if wishlist.present?
      raw "<i class='fa fa-heart' style='color: #fcc030;' title='added to wishlist'></i>"
    else
      link_to product_wishlists_path(product), remote: true, method: :post do
        raw '<i class="fa fa-heart-o"></i>'
      end
    end
  end

  def average_rating(product)
    total_review = product.reviews.count
    ratings = product.reviews.sum(:rating)
    if total_review > 0
      (ratings / total_review)
    else
      0
    end
  end

  def get_additional_images(product)
    product.images
  end

  def variant_color_image_option(image_link)
    if image_link.present?
      if image_link.length > 7
        "background: url(#{image_link}) center center;"
      else
        "background: ##{image_link};"
      end
    else
      'Default'
    end
  end

  def amount_with_currency(amount, currency = '৳')
    "#{currency}#{amount.round(2)}"
  end

  def discount_price(product)
    return unless product.discountable
    discount_amount = product.sale_price
    raw("<del>
      <span class='price-amount discount-amount'>
        #{amount_with_currency(discount_amount)}
       </span>
      </del>")
  end

  def categories(product)
    tags = []
    product.categories.each do |cat|
      tags.push("<span> #{link_to cat.name, categories_path(cat.permalink)} </span>")
    end
    tags.join(' | ')
  end

  # Order

  def line_item_count
    current_order.present? ? current_order.line_items.count : 0
  end

  def no_image
    asset_path('empty_product.svg')
  end

end