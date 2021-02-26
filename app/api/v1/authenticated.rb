# frozen_string_literal: true

module V1
  module Authenticated
    extend ActiveSupport::Concern

    included do
      before do
        authenticate!
      end
    end
  end
end
