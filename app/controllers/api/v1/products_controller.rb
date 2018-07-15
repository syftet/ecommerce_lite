class Api::V1::ProductsController < Api::ApiBase
  include ActionController::Helpers
  helper ProductHelper
  def index
    p params[:taxon_id]
    taxon = Admin::Category.find_by_permalink(params[:id])
    p taxon
    products = Search.new(params, taxon).result

    response = {
        total_item: products.total_count,
        products: []
    }

    products.each do |product|
      response[:products] << {
          id: product.id,
          master_id: product.id,
          name: product.name,
          avg_rating: product.average_rating,
          preview_image: helpers.product_preview_image(product, true),
          price: product.price,
          point: product.reward_point,
          # promotion: product.promotionable,
          discount_price: product.discount_price,
          is_favourited: product.is_favourite?(params[:user_id]),
          total_on_hand: product.total_on_hand,
          categories: product.categories.as_json(only: [:id, :name])
      }
    end

    render json: response
  end

  def get_names
    products = Product.where("lower(name) like '%#{params[:name]}%'")
    render json: products.as_json(only: :name)
  end

  def show
    product = Product.includes(:reviews, :categories, :wishlists).find_by_id(params[:id])
    reviews = product.reviews

    response = {
        id: product.id,
        master_id: product.id,
        name: product.name,
        description: product.description,
        avg_rating: product.average_rating,
        price: product.price,
        point: product.reward_point,
        discount_price: product.discount_price,
        is_favourited: product.is_favourite?(params[:user_id]),
        total_on_hand: product.total_on_hand,
        total_review: reviews.count,
        user_reviews: reviews,
        images: [],
        rating_detail: rating_per(reviews),
        categories: product.categories.as_json(only: [:id, :name]),
        varients: []
    }

    product.images.each do |image|
      response[:images] << {
          id: image.id,
          photo: image.file.url(:product)
      }
    end

    product.variants.each do |varient|
      response[:varients] << {
          info: varient.as_json(only: [:id, :sku, :product_id, :color, :color_image, :size]),
          images: []
      }
      varient.images.order(:id).each do |image|
        response[:varients].last[:images] << {
            id: image.id,
            photo: image.file.url(:product)
        }
      end
    end

    render json: response
  end

  def rating_per(reviews)
    total = reviews.count || 1
    details = reviews.group(:rating).count
    (1..5).each do |i|
      if details[i].present?
        per = (details[i] / total.to_f) * 100
        details[i] = per
      else
        details[i] = 0
      end
    end
    details
  end

  def filters
    #variants = Variant.all
    render json: {
        categories: Admin::Category.where('parent_id IS NULL').as_json(only: [:id, :name]),
        colors: [],#variants.where.not(color_image: nil).pluck(:color_image).uniq.as_json,
        sizes: []#variants.where.not(size: '').pluck(:size).uniq.as_json
    }
  end

  def create
    # categories = []
    brand = nil

    # if params[:categories].present?
    #   params[:categories].each do |category|
    #     categories << Admin::Category.find_or_create_by!(category.permit(:name, :description))
    #   end
    # end

    if params[:brand].present?
      brand = Admin::Brand.find_or_create_by!(params[:brand].permit(:name, :description))
    end

    product = Product.find_by_pos_id(params[:product][:pos_id])
    if product.present?
      product.update!(params[:product].merge(brand_id: brand.present? ? brand.id : '').permit!)
    else
      product = Product.create!(params[:product].merge(brand_id: brand.present? ? brand.id : '').permit!)
    end

    if params[:images].present?
      params[:images].each do |image|
        p 'http://accounts.tangailenterprise.com' + image
        product_image = product.images.build(remote_file_url: 'http://accounts.tangailenterprise.com' + image)
        product_image.save! if product_image.file.present?
      end
    end

    # if categories.present?
    #   categories.each do |category|
    #     ProductCategory.find_or_create_by!(product: product, category: category)
    #   end
    # end
  end

  # private
  #
  # def taxonomy_view
  #   @html_view = "<ul class='product-categories'>"
  #
  #   Taxonomy.all.each do |taxm|
  #     @html_view += "<li class='menu-item'><a href='#nof'>#{taxm.name}</a><span data-ref='top-cat-taxm-#{taxm.id}' class='pull-right collapse-ref'><i class='fa fa-plus'></i> </span><ul class='top-sub-menu' id='top-cat-taxm-#{taxm.id}'>"
  #     taxm.taxons.where('parent_id IS NULL').each do |taxon|
  #       draw_category_tree(taxon, (@taxon.present? ? @taxon.id : ''))
  #     end
  #     @html_view += "</ul>"
  #     @html_view += "</li>"
  #   end
  #   @html_view += "</ul>"
  # end
  #
  # def draw_category_tree(node, selected = '')
  #   @html_view += "<li> <a href='#{categories_path(node.permalink)}' class='#{selected == node.id ? 'active' : ''}'>#{node.name}</a>"
  #   @html_view += "<span data-ref='top-cat-#{node.id}' class='pull-right collapse-ref'> <i class='fa fa-plus'></i> </span>" if node.children.any?
  #   if node.children.any?
  #     @html_view += "<ul id='top-cat-#{node.id}'>"
  #     node.children.each do |child|
  #       if child.children.any?
  #         @html_view += "#{draw_category_tree(child, selected)}"
  #       else
  #         @html_view += "<li><a href='#{categories_path(child.permalink)}' class='#{selected == child.id ? 'active' : ''}'>#{child.name}</a>"
  #         @html_view += "<span data-ref='top-cat-#{child.id}' class='pull-right collapse-ref'> <i class='fa fa-plus'></i> </span>" if child.children.any?
  #         @html_view += "</li>"
  #       end
  #     end
  #     @html_view += "</ul>"
  #   end
  #   @html_view += "</li>"
  # end
end
