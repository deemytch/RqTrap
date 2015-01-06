class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :is_trap?

  def is_trap?
    controller_name == 'hello' && action_name == 'trap'
  end

end
