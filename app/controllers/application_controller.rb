class ApplicationController < ActionController::Base
  include ApplicationHelper
  add_flash_types :warning, :danger
end
