# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_project, only: %i[show]

  # GET /projects or /projects.json
  def index
    featured_scope = Project.featured
    if featured_scope.exists?
      @total_featured = featured_scope.count
      @current_offset = params[:featured_offset].to_i
      @featured_project = featured_scope.offset(@current_offset % @total_featured).first
    end
    
    projects_scope = Project.includes(:chapter).not_featured
    projects_scope = projects_scope.search(params[:query]) if params[:query].present?
    
    @pagy, @projects = pagy(projects_scope.order(created_at: :desc), items: 9)
    
    if turbo_frame_request?
      if request.headers["Turbo-Frame"] == "featured_project"
        render partial: 'featured_project', locals: { featured_project: @featured_project }
      else
        render partial: 'projects', locals: { projects: @projects, pagy: @pagy }
      end
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    @related_projects = Project.where(chapter_id: @project.chapter_id)
                               .where.not(id: @project.id)
                               .limit(3)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find_by!(slug: params[:id])
  end
end
