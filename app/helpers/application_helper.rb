module ApplicationHelper
  def page_title(title = nil)
    @title = title unless title.nil?
    @title || "Tasking"
  end

  def page_description(content = nil, &block)
    content_for(:page_description, content, &block)
  end
end
