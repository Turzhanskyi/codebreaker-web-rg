# frozen_string_literal: true

module Validator
  def validate(user, request)
    error_name(request) unless user.valid?
  end

  def error_name(request)
    raise StandardError, I18n.t(:name_not_valid, user_name: request.params['user_name'])
  end
end
