module ApplicationHelper
  def nav_link(label, path, options = {})
    content_tag(:li, class: current_page?(path) ? "active" : "") do
      link_to(label, path, options)
    end
  end

  def badge_for_number(number)
    class_name = case number
                 when 1 then "badge-success"
                 when 2 then "badge-warning"
                 when 3 then "badge-important"
                 when 5 then "badge-info"
                 when 8, 13, 21 then "badge-inverse"
                 else ""
                 end
    content_tag :span, number, class: "badge #{class_name}"
  end
end
