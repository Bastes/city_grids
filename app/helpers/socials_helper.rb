module SocialsHelper
  def metatags_share( metatags_share_data = nil )
    return metatags_share! if metatags_share_data.blank?
    @metatags_share_data = metatags_share_data
  end

  def metatags_share!
    return if @metatags_share_data.blank?
    @metatags_share_data[:url] ||= request.url
    @metatags_share_data.
      map { |key, value| tag :meta, property: "og:#{key}", content: strip_tags(value.gsub(/&nbsp;/, ' ')) unless value.blank? }.
      join.html_safe
  end
end
