module Admin
  class BrandsController < BaseController
    before_action :set_admin_brand, only: [:show, :edit, :update, :destroy]

    # GET /admin/brands
    def index
      @admin_brands = Admin::Brand.all
    end

    # GET /admin/brands/1
    def show
    end

    # GET /admin/brands/new
    def new
      @admin_brand = Admin::Brand.new
    end

    # GET /admin/brands/1/edit
    def edit
    end

    # POST /admin/brands
    def create
      @admin_brand = Admin::Brand.new(admin_brand_params)

      respond_to do |format|
        if @admin_brand.save
          format.html { redirect_to @admin_brand, notice: 'Brand was successfully created.' }
          format.json { render :show, status: :created, location: @admin_brand }
        else
          format.html { render :new }
          format.json { render json: @admin_brand.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/brands/1
    def update
      respond_to do |format|
        if @admin_brand.update(admin_brand_params)
          format.html { redirect_to @admin_brand, notice: 'Brand was successfully updated.' }
          format.json { render :show, status: :ok, location: @admin_brand }
        else
          format.html { render :edit }
          format.json { render json: @admin_brand.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/brands/1
    def destroy
      respond_to do |format|
        if @admin_brand.destroy
          format.html { redirect_to admin_brands_url, notice: 'Brand was successfully destroyed.' }
        else
          format.html { redirect_to admin_brands_url, notice: 'Unable to destroy brand.' }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_admin_brand
      @admin_brand = Admin::Brand.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def admin_brand_params
      params.require(:admin_brand).permit(:name, :slug, :description, :is_active,
                                          :permalink, :meta_title, :meta_desc,
                                          :keywords)
    end
  end
end
