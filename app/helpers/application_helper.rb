module ApplicationHelper
  def sortable(attribute, display = nil)
    display ||= attribute.titleize
    css_class = attribute == sort_attribute ? "current #{sort_direction}" : nil
    direction = attribute == sort_attribute && sort_direction == "asc" ? "desc" : "asc"
    link_to display, {sort: attribute, direction: direction}, {class: css_class}
  end
end
