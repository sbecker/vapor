# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Search Links
  def aws_search_link(text, search_query)
    link_to(text, "http://developer.amazonwebservices.com/connect/isearch.jspa?searchQuery=#{search_query}&x=0&y=0&searchKB=true&searchForums=true", :target => "_blank")
  end

  def google_search_link(text, search_query)
    link_to(text, "http://www.google.com/search?q=#{search_query}", :target => "_blank")
  end

  # Form Helpers
  def format_array_for_select(array, value_attribute, text_attribute=nil)
    array.map do |element|
      if text_attribute
        [element.send(value_attribute), element.send(text_attribute)]
      else
        element.send(value_attribute)
      end
    end
  end

end
