module Api
  module V1
    module Admin
      class GroupsController < ApplicationController
        # Agrega aquí las acciones necesarias: index, show, create, update, destroy
        def index
          groups = Group.all
          render json: groups
        end

        def show
          group = Group.find(params[:id])
          render json: group
        end

        def create
          group = Group.new(group_params)
          if group.save
            render json: group, status: :created
          else
            render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          group = Group.find(params[:id])
          if group.update(group_params)
            render json: group
          else
            render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def group_params
          params.require(:group).permit(:name, :description)
        end
      end
    end
  end
end
