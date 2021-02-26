# frozen_string_literal: true

Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine => '/docs', as: 'docs'
  mount Api::Api => '/', anchor: false
end
