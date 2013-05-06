module ApplicationHelper
  def nav_link(label, path)
    content_tag(:li, class: current_page?(path) ? "active" : "") do
      link_to(label, path)
    end
  end
end
