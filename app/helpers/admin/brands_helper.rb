module Admin::BrandsHelper
  def get_brand_url(link)
    "#{root_url}b/#{link}"
  end
end
