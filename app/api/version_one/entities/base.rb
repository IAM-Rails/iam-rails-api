# frozen_string_literal: true

module VersionOne
  module Entities
    # The Base class is responsive for inheritance
    class Base < Grape::Entity
      expose :id, documentation: { type: 'Integer' }
      expose :created_at, documentation: { type: 'DateTime' }
      expose :updated_at, documentation: { type: 'DateTime' }

      format_with(:to_string) { |foo| foo.to_s }
      format_with(:safe_iso_timestamp) { |dt| dt&.to_time&.iso8601 }
      format_with(:to_float, &:to_f)
    end
  end
end
