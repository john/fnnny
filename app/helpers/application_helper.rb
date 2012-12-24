module ApplicationHelper
  
  # def localized_time_ago_in_words(the_time)
  #   loc = I18n.locale
  #   if loc.present? && loc.to_s.split('-').first == 'es'
  #     "hace #{time_ago_in_words(the_time)}"
  #   else
  #     "hace #{time_ago_in_words(the_time)} ago"
  #   end
  # end
  
  def slugged_item(item)
    slugged_item_url(item, item.name.parameterize)
  end
  
end
