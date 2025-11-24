module ProjectsHelper
  def project_image(project, css_class: "")
    if project.image.attached?
      image_tag project.image, class: css_class
    else
      # Placeholder image if no image is attached
      image_tag "https://placehold.co/600x400?text=#{project.name}", class: css_class
    end
  end

  def format_url(url)
    return "" if url.blank?
    url.start_with?('http://', 'https://') ? url : "https://#{url}"
  end
end
