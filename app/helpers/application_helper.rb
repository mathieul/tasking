module ApplicationHelper
  def nav_link(label, path, options = {})
    content_tag(:li, class: current_page?(path) ? "active" : "") do
      link_to(label, path, options)
    end
  end
end
