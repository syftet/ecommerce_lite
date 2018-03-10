module Admin
  class ImagesController < BaseController
    before_action :set_product
    before_action :set_image, only: [:edit, :update, :destroy]

    def index
      @images = @product.images
    end

    def new
      @image = @product.images.build
    end

    def create
      @image = @product.images.build(image_params)
      respond_to do |format|
        if @image.save
          format.html { redirect_to admin_product_images_path(@product), notice: 'Image added to product successfully.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @image.update(image_params)
          format.html { redirect_to admin_product_images_path(@product), notice: 'Image updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @image.destroy
        flash[:notice] = 'Image deleted successfully.'
      else
        flash[:error] = 'Unable to deleted image.'
      end
      redirect_to admin_product_images_path(@product)
    end

    private

    def set_product
      @product = Product.friendly.find(params[:product_id])
    end

    def set_image
      @image = @product.images.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:viewable_type, :viewable_id, :width,
                                    :height, :file_size, :position, :alt,
                                    :content_type, :file)
    end
  end
end
