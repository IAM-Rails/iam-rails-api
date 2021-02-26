# frozen_string_literal: true

# Main entry point to the route mounted for the API in Grape
module Api
  class Api < Grape::API::Instance
    helpers Helpers::Base

    rescue_from ActiveRecord::RecordInvalid do |e|
      camelized_errors = Hash[e.record.errors.messages.map { |k, v| [k.to_s.camelize(:lower), v] }]
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

    mount V1::Base
  end
end
