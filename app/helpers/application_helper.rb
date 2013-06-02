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
end
