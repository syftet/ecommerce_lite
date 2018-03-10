module ProductHelper
  def product_preview_image(product)
    if product.images.present?
      image = product.images.first
      image_tag(image.file.url(:product), class: 'image-hover product-image')
    else
      image_tag(no_image, class: 'image-hover product-image')
    end
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
    # variant = product.master # Variant.where(product_id: product.id, is_master: true).first
    # variant.images.order(:id) # Asset.where(viewable_id: variant.id).order(:id)
    product.images
  end

  def variant_color_image_option(image_link)
    if image_link.present?
      if image_link.length == 6
        "background: ##{image_link};"
      else
        "background: url(#{image_link}) center center;"
      end
    else
      'Default'
    end
  end

  def amount_with_currency(amount, currency = '$')
    "#{currency}#{amount}"
  end

  # Order

  def line_item_count
    current_order.present? ? current_order.line_items.count : 0
  end

  def no_image
    asset_url('empty_product.svg')
  end

end