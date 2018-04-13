module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:edit, :update, :destroy, :stock]

    def index
      respond_to do |format|
        format.html { @products = Product.master_active }
        format.json { @products = Product.master_active.search_by_name_or_code(params[:q][:term]) }
      end
    end

    def new
      @product = Product.new(code: Product.generate_code)
    end

    def create
      @product = Product.new(product_params)
      respond_to do |format|
        if @product.save
          format.html { redirect_to edit_admin_product_path(@product), notice: 'Product created successfully.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to edit_admin_product_path(@product), notice: 'Product updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @product.destroy
        flash[:notice] = 'Product deleted successfully.'
      else
        flash[:error] = 'Unable to deleted product.'
      end
      redirect_to admin_products_path
    end

    def stock
      @products = @product.variants_with_master
      @stock_locations = StockLocation.active
      if @stock_locations.empty?
        flash[:error] = t(:stock_management_requires_a_stock_location)
        redirect_to admin_stock_locations_path
      end
    end

    private

    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:code, :name, :description, :origin,
                                      :slug, :meta_title, :meta_desc, :keywords,
                                      :brand_id, :is_featured, :is_active,
                                      :deleted_at, :product_id, :sale_price,
                                      :cost_price, :whole_sale, :color_name,
                                      :color, :size, :weight, :width, :height,
                                      :depth, :discountable, :is_amount,
                                      :discount, :reward_point,
                                      :track_inventory, category_ids: [])
    end
  end
end
