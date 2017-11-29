module ApplicationHelper

  ##
  # Title of the website
  ##
  def full_title(page_title)
    base_title = 'Team Maker'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end