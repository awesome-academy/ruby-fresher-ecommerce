class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include CartsHelper
  include OrdersHelper
  include ProductsHelper

  around_action :switch_locale

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale locale, &action
  end
end
