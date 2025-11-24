# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text
#  end_date    :datetime
#  name        :string
#  start_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chapter_id  :bigint           not null
#
# Indexes
#
#  index_projects_on_chapter_id  (chapter_id)
#
# Foreign Keys
#
#  fk_rails_...  (chapter_id => chapters.id)
#
class Project < ApplicationRecord
  # Attachments
  has_one_attached :image

  # Associations
  belongs_to :chapter

  # Validations
  validates :name, presence: true
  validates :intro, length: { maximum: 200 }, allow_blank: true
  validates :preview_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  validates :git_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }

  # Scopes
  scope :featured, -> { where(featured: true).order(:featured_order, :created_at) }
  scope :not_featured, -> { where(featured: false) }
  scope :search, ->(query) {
    where("name ILIKE ? OR description ILIKE ? OR intro ILIKE ?", 
          "%#{sanitize_sql_like(query)}%", 
          "%#{sanitize_sql_like(query)}%", 
          "%#{sanitize_sql_like(query)}%")
  }

  # Methods
  def has_image?
    image.attached?
  end
end

