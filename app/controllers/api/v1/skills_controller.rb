# frozen_string_literal: true

module Api
  module V1
    class SkillsController < Api::BaseController
      before_action :authenticate, only: %i[create update destroy]
      load_and_authorize_resource :skill, parent: false
      before_action :load_skill, only: %i[show update destroy]

      def show
        respond_with build_data_object(@skill)
      end

      def index
        respond_with build_data_object(Skill.all)
      end

      def create
        skill = Skill.new(skill_params)
        if skill.save
          render json: build_data_object(skill), status: :ok
        else
          render json: build_error_object(skill), status: :unprocessable_entity
        end
      end

      def update
        if @skill.update(skill_params)
          render json: build_data_object(@skill), status: :ok
        else
          render json: build_error_object(@skill), status: :unprocessable_entity
        end
      end

      def destroy
        if @skill.destroy
          render json: { success: true }, status: :ok
        else
          render json: build_error_object(@skill), status: :unprocessable_entity
        end
      end

      private

      def load_skill
        @skill = Skill.find(params[:id])
      end

      def skill_params
        params.permit(:name)
      end
    end
  end
end
