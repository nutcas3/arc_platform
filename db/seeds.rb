# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Sample learning materials for Rails & Ruby
if defined?(LearningMaterial)
  LearningMaterial.find_or_create_by!(title: 'Rails Guides') do |lm|
    lm.level = :beginner
    lm.thumbnail_url = 'https://rubyonrails.org/images/rails-logo.svg'
    lm.link_url = 'https://guides.rubyonrails.org/'
    lm.featured = true
    lm.description = 'Official Rails Guides for beginners to experts.'
  end

  LearningMaterial.find_or_create_by!(title: 'Ruby Official') do |lm|
    lm.level = :intermediate
    lm.thumbnail_url = 'https://www.ruby-lang.org/images/header-ruby-logo.png'
    lm.link_url = 'https://www.ruby-lang.org/en/documentation/'
    lm.featured = false
    lm.description = 'Official Ruby documentation and resources.'
  end
end
