module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.all
    end

    def show
    end

    def new
    end

    def edit
    end

    def update
    end

    def destroy
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
                                      :discount, :reward_point)
    end
  end
end
