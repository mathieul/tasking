class TeammateDecorator < Draper::Decorator
  delegate_all

  def role_labels
    object.roles.sort.each.with_object([]) do |role, labels|
      labels << helpers.content_tag(:span, role, class: "label")
    end.join(" ").html_safe
  end

  def account_email
    account.present? ? account.email : "-"
  end

  def show_color_class
    {class: "show-color-#{object.color}"}
  end
end
