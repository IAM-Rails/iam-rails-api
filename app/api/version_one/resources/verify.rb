# frozen_string_literal: true

module VersionOne
  module Resources
    # The Verify Grape Controller is responsive for verify status endpoint
    class Verify < Base
      resource :verify do
        resource :status do
          get do
            status 200
          end
        end
      end
    end
  end
end
