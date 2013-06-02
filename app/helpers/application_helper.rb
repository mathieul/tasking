module ApplicationHelper
  def page_title(title = nil)
    @title = title unless title.nil?
    @title || "Tasking"
  end

  def page_description(content = nil, &block)
    content_for(:page_description, content, &block)
  end

  def page_container(klass = nil)
    @page_container ||= {class: "container"}
    @page_container[:class] = klass unless klass.nil?
    @page_container
  end

  def flash_messages
    flash.each.with_object([]) do |(type, message), notices|
      next unless message
      type = :success if type == :notice
      notices << content_tag(:div, class: "alert fade in alert-#{type}") do
        link_to("x", "javascript:void(0)", class: "close", "data-dismiss" => "alert") + message
      end
    end.join("\n").html_safe
  end
end
