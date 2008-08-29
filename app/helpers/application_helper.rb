# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def aws_search_link(text, search_query)
    link_to(text, "http://developer.amazonwebservices.com/connect/isearch.jspa?searchQuery=#{search_query}&x=0&y=0&searchKB=true&searchForums=true", :target => "_blank")
  end

  def google_search_link(text, search_query)
    link_to(text, "http://www.google.com/search?q=#{search_query}", :target => "_blank")
  end
end
