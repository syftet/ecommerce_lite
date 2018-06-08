# require 'search'
class ProductsController < ApplicationController
  before_action :load_taxon, only: :index

  layout 'product'

  respond_to :html

  def index
    # @searcher = build_searcher(params.merge(include_images: true))
    # @products = @searcher.retrieve_products
    @products = Search.new(params).result
    @categories = Admin::Category.where("parent_id IS NULL")
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @product = Product.friendly.find(params[:id])
    @rating_analysis = @product.reviews.group(:rating).count
    @review = @product.reviews.build
  end

  def quickview
    @product = Product.friendly.find(params[:product_id])
    respond_to do |format|
      format.js {}
    end
  end

  def brand_show
    @brand = Admin::Brand.find_by_permalink(params[:id])
    @categories = Admin::Category.where("parent_id IS NULL")
    redirect_to products_path unless @brand
    @products = @brand.products.page(params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def compare
    product = Product.friendly.find(params[:product_id])
    if cookies[:compare_products]
      ids = cookies[:compare_products].to_s.split(',').push(product.id)
      cookies[:compare_products] = ids.uniq.join(',')
    else
      cookies[:compare_products] = product.id
    end
    @products = Product.where(id: cookies[:compare_products].to_s.split(','))
  end

  def remove_compare
    @product = Product.friendly.find(params[:product_id])
    if cookies[:compare_products]
      ids = cookies[:compare_products].split(',')
      ids.delete_at(ids.find_index(@product.id.to_s))
      cookies[:compare_products] = ids.join(',')
    end
  end

  def keyword_search
    term = params[:keyword]
    search = Product.solr_search do |s|
      s.keywords params[:keyword]
      s.paginate :page => params[:page] || 1, :per_page => 30
    end

    if is_number?(term)
      product = Product.find_by_id(term.to_i)
      if product.present?
        redirect_to "/p/#{product.slug}"
      end
    end
    @products = search.results
    @top_categories = get_filter_category(@products)
    @title = "Search result for ‘#{term}''"
  end

  def review
    product = Product.find_by_id(params[:product_id])
    review = product.reviews.build(review_params)
    review.user_id = current_user.id if current_user.present?
    if review.save
      flash[:success] = 'Review successfull.'
    else
      flash[:error] = review.errors.first
    end
    redirect_to product_path(product)
  end

  private

  def accurate_title
    if @product
      @product.meta_title.blank? ? @product.name : @product.meta_title
    else
      super
    end
  end

  def load_product
    if try_spree_current_user.try(:has_spree_role?, "admin")
      @products = Product.with_deleted
    else
      @products = Product.active(current_currency)
    end
    @product = @products.includes(:taxons, :brand, :variants, :product_sizes, :recommended_products, master: [:prices, :images]).friendly.find(params[:id])
  end

  def load_taxon
    @taxon = Taxon.find(params[:taxon]) if params[:taxon].present?
  end

  def redirect_if_legacy_path
    # If an old id or a numeric id was used to find the record,
    # we should do a 301 redirect that uses the current friendly id.
    if params[:id] != @product.friendly_id
      params.merge!(id: @product.friendly_id)
      return redirect_to url_for(params), status: :moved_permanently
    end
  end

  def is_number? str
    true if Float(str) rescue false
  end

  def get_filter_category(products)
    category = {}
    products.each do |product|
      product.taxons.each do |tax|
        tax_id = tax.id
        if category[tax_id].present?
          category[tax_id] = category[tax_id] + 1
        else
          category[tax_id] = 1
        end
      end
    end
    if category.present?
      top_taxon = category.sort.reverse.first
      @taxon = Taxon.find_by_id(top_taxon[0])
      @taxon.taxonomy.top_categories.order(created_at: :asc).includes(:sub_taxons)
    end
  end

  private

  def review_params
    params.require(:review).permit!
  end

end