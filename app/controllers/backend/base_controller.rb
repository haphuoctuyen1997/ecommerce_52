class Backend::BaseController < ApplicationController
  before_action :authenticate_user!, :admin_user?
  layout "admin"
end
