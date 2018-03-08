module Admin
  class HomeSlidersController < Admin::BaseController

    before_action :set_slider, only: [:show, :edit, :update, :destroy]

    def index
      @sliders = HomeSlider.all
      respond_to do |format|
        format.html
      end
    end

    def new
      @slider = HomeSlider.new
      respond_to do |format|
        format.html
      end
    end

    def create
      @slider = HomeSlider.new(slider_params)
      respond_to do |format|

        if @slider.save
          format.html { redirect_to admin_home_sliders_path, notice: 'Slider image was successfully created.' }
        else
          redirect_back(fallback_location: admin_home_sliders_path)
          flash.now[:error] = t('notice_messages.slider_image_not_created')
        end
      end
    end

    def edit
      respond_to do |format|
        format.html
      end
    end

    def update
      respond_to do |format|
        if @slider.update(slider_params)
          format.html { redirect_to admin_home_sliders_path, notice: 'Slider was successfully updated.' }
        else
          format.html { redirect_to admin_home_sliders_path, alert: 'Some problem occurred before updating the slider. Try again' }
        end
      end
    end

    def destroy

      @slider.destroy
      respond_to do |format|
        format.js
      end
    end

    private

    def slider_params
      params.require(:home_slider).permit(:image, :title, :sub_title, :link)
    end

    def set_slider
      @slider = HomeSlider.find(params[:id])
    end

  end
end
