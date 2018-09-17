class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include SessionsHelper

  protect_from_forgery with: :exception

  before_action :set_locale, :category_all

  rescue_from ActiveRecord::RecordNotFound, NoMethodError, with: :not_found?

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def not_found?
    render file: "#{Rails.root}/public/404.html", status: 403, layout: false
  end

  private

  def after_sign_in_path_for resource
    resource.admin? ? backend_path : root_path
  end

  def category_all
    @categories = Category.all
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::USER_PARAMS)
    devise_parameter_sanitizer.permit(:account_update, keys: User::USER_PARAMS)
  end
end
