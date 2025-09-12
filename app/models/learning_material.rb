# frozen_string_literal: true

# == Schema Information
#
# Table name: learning_materials
#
#  id         :bigint           not null, primary key
#  featured   :boolean
#  level      :integer
#  link       :string
#  thumbnail  :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_learning_materials_on_featured  (featured)
#  index_learning_materials_on_level     (level)
#  index_learning_materials_on_title     (title)
#
class LearningMaterial < ApplicationRecord
  enum :level, { beginner: 0, intermediate: 1, expert: 2 }

  validates :title, presence: true
  validates :level, presence: true
  validates :link, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :thumbnail, allow_blank: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  scope :featured, -> { where(featured: true) }
  scope :by_level, ->(lvl) { lvl.present? ? where(level: levels[lvl]) : all }
  scope :search, lambda { |query|
    if query.present?
      where('title ILIKE ?', "%#{sanitize_sql_like(query)}%")
    else
      all
    end
  }
  scope :recent_first, -> { order(created_at: :desc) }
end
