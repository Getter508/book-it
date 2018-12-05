module ApplicationHelper
  def sortable(attribute, display = nil)
    display ||= attribute.titleize
    css_class = attribute == params[:sort] ? "current #{params[:direction]}" : nil
    direction = attribute == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to display, {sort: attribute, direction: direction}, {class: css_class}
  end

  def selected_month(have_read_book)
    if have_read_book.date_completed.nil?
      Time.zone.now.strftime("%b")
    else
      have_read_book.date_completed.strftime("%b")
    end
  end

  def selected_day(have_read_book)
    if have_read_book.date_completed.nil?
      Time.zone.now.day
    else
      have_read_book.date_completed.day
    end
  end

  def selected_year(have_read_book)
    if have_read_book.date_completed.nil?
      Time.zone.now.year
    else
      have_read_book.date_completed.year
    end
  end
end
