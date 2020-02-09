module ApplicationHelper
  include SessionsHelper

  def error_messages_for(resource)
    render 'shared/error_messages', resource: resource if resource&.errors.present?
  end
end
