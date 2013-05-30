module ApplicationHelper
  def nav_link(label, path, options = {})
    content_tag(:li, class: current_page?(path) ? "active" : "") do
      link_to(label, path, options)
    end
  end

  def badge_for_number(number)
    class_name = case number
                 when 0 then "badge-inverse"
                 when 3, 5 then "badge-success"
                 when 8 then "badge-info"
                 when 13 then "badge-warning"
                 when 21 then "badge-important"
                 else ""
                 end
    content_tag :span, number, class: "badge #{class_name}"
  end
end
