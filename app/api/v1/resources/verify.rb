# frozen_string_literal: true

module V1
  module Resources
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
