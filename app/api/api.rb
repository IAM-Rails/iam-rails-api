# frozen_string_literal: true

# Main entry point to the route mounted for the API in Grape
module Api
  # The Api class is responsive for handle errors
  class Api < Grape::API::Instance
    helpers Helpers::Base

    rescue_from ActiveRecord::RecordInvalid do |error|
      camelized_errors = Hash[e.record.errors.messages.map {
        |key, value| [key.to_s.camelize(:lower), value] }]
      logger.error(e)
      error!(camelized_errors, 422)
    end

    rescue_from ActiveRecord::RecordNotFound do |_e|
      logger.error(_e)
      error!({ message: 'RECORD_NOT_FOUND' }, 404)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |exception|
      errors = {}
      exception.errors.each do |param, error|
        logger.error(error)
        errors[param.first] = error.map(&:message)
      end

      error!(errors, 400)
    end

    rescue_from Grape::Exceptions::MethodNotAllowed do |_e|
      logger.error(_e)
      error!({ message: 'METHOD_NOT_ALLOWED' }, 405)
    end

    rescue_from StandardError do |_e|
      logger.error(_e)
      error!({ message: 'INTERNAL_SERVER_ERROR' }, 500)
    end

    mount VersionOne::Base
  end
end
