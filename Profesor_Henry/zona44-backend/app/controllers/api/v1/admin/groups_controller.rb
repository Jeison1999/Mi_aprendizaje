module Api
  module V1
    module Admin
      class GroupsController < ApplicationController
        before_action :authorize_request
        before_action :set_group, only: [:update, :destroy]

        # GET /api/v1/admin/groups
        def index
          groups = Group.all
          render json: groups
        end

        # GET /api/v1/admin/groups/:id
        def show
          group = Group.find(params[:id])
          render json: group
        end

        # POST /api/v1/admin/groups
        def create
          group = Group.new(name: params[:name])
          group.image.attach(params[:image]) if params[:image].present?
          
          if group.save
            render json: group, status: :created
          else
            render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/groups/:id
        def update
          if @group.update(group_params)
            render json: { message: 'Grupo actualizado exitosamente', group: @group }
          else
            render json: { errors: @group.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/groups/:id
        def destroy
          @group.destroy
          render json: { message: 'Grupo eliminado exitosamente' }
        end

        private

        def set_group
          @group = Group.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Grupo no encontrado' }, status: :not_found
        end

        def group_params
          params.require(:group).permit(:name, :description)
        end
      end
    end
  end
end
