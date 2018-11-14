module ApplicationHelper
  def sortable(attribute, display = nil)
    display ||= attribute.titleize
    css_class = attribute == params[:sort] ? "current #{params[:direction]}" : nil
    direction = attribute == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to display, {sort: attribute, direction: direction}, {class: css_class}
  end
end
