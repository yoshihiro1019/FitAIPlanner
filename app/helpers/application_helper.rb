module ApplicationHelper
  def title(page_title = '')
    content_for :title, "#{page_title} | RUNTEQ BOARD APP" if page_title.present?
  end
end
