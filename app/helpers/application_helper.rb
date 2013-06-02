module ApplicationHelper
  def page_title(title = nil)
    @title = title unless title.nil?
    @title || "Tasking"
  end

  def page_description(content = nil, &block)
    content_for(:page_description, content, &block)
  end

  def layout_type(type = nil)
    @layout_type = type unless type.nil?
    "container#{"-" if @layout_type}#{@layout_type}"
  end
end
