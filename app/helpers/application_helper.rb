module ApplicationHelper
  def page_title(title = nil, size: nil)
    page_width(:title, size)
    @title = title unless title.nil?
    @title || "Tasking"
  end

  def page_description(content = nil, size: nil, &block)
    page_width(:description, size)
    content_for(:page_description, content, &block)
  end

  def page_width(kind, value = nil)
    @page_width ||= {title: {class: "span3"}, description: {class: "span9"}}
    @page_width[kind][:class] = value unless value.nil?
    @page_width[kind]
  end

  def page_container(klass = nil)
    @page_container ||= {class: "container"}
    @page_container[:class] = klass unless klass.nil?
    @page_container
  end

  def flash_messages
    flash.each.with_object([]) do |(type, message), notices|
      next unless message
      classes = %W[alert fade in alert-#{type == :notice ? :success : type}]
      classes << "auto-close" if type == :notice
      notices << content_tag(:div, class: classes.join(" ")) do
        link_to("x", "javascript:void(0)", class: "close", "data-dismiss" => "alert") + message
      end
    end.join("\n").html_safe
  end
end
