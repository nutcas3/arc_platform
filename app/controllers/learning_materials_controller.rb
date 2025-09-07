# frozen_string_literal: true

class LearningMaterialsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @materials = filter_and_paginate_materials
    @featured_materials = LearningMaterial.featured.limit(6)
  end

  private

  def filter_and_paginate_materials
    @q = params[:q].to_s.strip
    @level = params[:level].to_s.presence
    LearningMaterial.search(@q).by_level(@level).recent_first.page(params[:page]).per(12)
  end
end
