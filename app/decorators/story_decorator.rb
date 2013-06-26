class StoryDecorator < ApplicationDecorator
  delegate_all

  def badged_points
    classes = ["badge", badge_class(object.points)].compact.join(" ")
    helpers.content_tag(:span, object.points, class: classes)
  end

  def link_to_spec
    return "" unless object.spec_link
    helpers.content_tag(:a, object.spec_link, href: object.spec_link, target: "_new")
  end

  private

  def badge_class(number)
    case number
    when 0    then "badge-inverse"
    when 3, 5 then "badge-success"
    when 8    then "badge-info"
    when 13   then "badge-warning"
    when 21   then "badge-important"
    else nil
    end
  end
end
