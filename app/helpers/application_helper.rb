module ApplicationHelper
  # Devise Things

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Menu things

  def get_active_class(action, menu_action)
    action == menu_action ? 'active' : ''
  end

end
