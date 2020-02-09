module NotesHelper
  def format_date(date)
    date.strftime('%B %d at %I:%M %p')
  end
end
