# frozen_string_literal: true

module VersionOne
  # The Authenticated module is responsive for granting authentication
  module Authenticated
    extend ActiveSupport::Concern

    included do
      before do
        authenticate!
      end
    end
  end
end
