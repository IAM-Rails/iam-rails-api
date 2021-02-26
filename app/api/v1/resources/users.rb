# frozen_string_literal: true

module V1
  module Resources
    class Users < Base
      include V1::Authenticated

      resource :users do
        get do
          users = User.where(visible: true, parent_id: current_user.id)

          present users, with: Entities::User
        end

        params do
          requires :name, type: String
          requires :email, type: String
          requires :password, type: String
          requires :password_confirmation, type: String
        end
        post do
          params[:parent_id] = current_user.id
          user = User.create!(permitted_params)

          ::ApiKeys::FromUser.call(user_id: user.id)

          present user, with: Entities::User, with_api_key: true
        end

        route_param :user_id, type: Integer do
          get do
            user = User.where(id: permitted_params[:user_id]).first

            error!('Forbidden', 403) unless user

            present user, with: Entities::User
          end

          params do
            optional :name, type: String
            optional :email, type: String
            optional :password, type: String
          end
          patch do
            user = User.find(permitted_params[:user_id])

            attrs = permitted_params.except(:user_id)
            user.update!(attrs)

            present user, with: Entities::User
          end
        end
      end
    end
  end
end
