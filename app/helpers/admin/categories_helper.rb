module Admin::CategoriesHelper
  def get_page_url(link)
    "#{root_url}c/#{link}"
  end
end
