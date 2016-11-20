module Api
  module V1
    class SkillsController < Api::BaseController
      before_action :authenticate, only: [:create, :update, :destroy]
      before_action :set_skill, only: [:show, :update, :destroy]
      load_and_authorize_resource :skill, parent: false
      respond_to :json

      def show
        respond_with build_data_object(@skill)
      end

      def index
        respond_with build_data_object(Skill.all)
      end

      def create
        skill = Skill.new(skill_params)
        if skill.save
          render json: build_data_object(skill), status: 200
        else
          render json: build_error_object(skill), status: 422
        end
      end

      def update
        if @skill.update(skill_params)
          render json: build_data_object(@skill), status: 200
        else
          render json: build_error_object(@skill), status: 422
        end
      end

      def destroy
        if @skill.destroy
          render json: { success: true }, status: 200
        else
          render json: build_error_object(@skill), status: 422
        end
      end

      private

      def set_skill
        @skill = Skill.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('Skill not found', 404)
      end

      def skill_params
        params.permit(:name)
      end
    end
  end
end
