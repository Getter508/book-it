module ApplicationHelper
  def sortable(attribute, display = nil)
    display ||= attribute.titleize
    direction = params[:direction] == 'asc' ? 'desc' : 'asc'
    css_class = attribute == params[:sort] ? "current #{params[:direction]}" : nil
    link_to display, { controller: params[:controller], sort: attribute, direction: direction }, { class: css_class }
  end

  def selected_month(have_read_book)
    if have_read_book&.date_completed.nil?
      Time.zone.now.strftime('%b')
    else
      have_read_book.date_completed.strftime('%b')
    end
  end

  def selected_day(have_read_book)
    if have_read_book&.date_completed.nil?
      Time.zone.now.day
    else
      have_read_book.date_completed.day
    end
  end

  def selected_year(have_read_book)
    if have_read_book&.date_completed.nil?
      Time.zone.now.year
    else
      have_read_book.date_completed.year
    end
  end

  def have_read(book)
    book.have_read_books.detect { |b| b.user_id == current_user&.id }
  end

  def to_read(book)
    book.to_read_books.detect { |b| b.user_id == current_user&.id }
  end

  def is_active?(book_list)
    'is-active' if book_list.present?
  end
end
