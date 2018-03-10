module Admin
  class VariantsController < BaseController
    before_action :set_product
    before_action :set_variant, only: [:edit, :update, :destroy]

    def index
      @variants = @product.variants
    end

    def new
      @variant = @product.variants.build(code: Product.generate_code)
    end

    def create
      @variant = @product.variants.build(variant_params)
      respond_to do |format|
        if @variant.save
          format.html { redirect_to admin_product_variants_path(@product), notice: 'Variant added to product successfully.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @variant.update(variant_params)
          format.html { redirect_to admin_product_variants_path(@product), notice: 'Variant updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @variant.destroy
        flash[:notice] = 'Variant deleted successfully.'
      else
        flash[:error] = 'Unable to deleted variant.'
      end
      redirect_to admin_product_variants_path(@product)
    end

    private

    def set_product
      @product = Product.friendly.find(params[:product_id])
    end

    def set_variant
      @variant = @product.variants.friendly.find(params[:id])
    end

    def variant_params
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
