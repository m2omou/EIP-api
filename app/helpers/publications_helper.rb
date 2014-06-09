module PublicationsHelper

  PUB_TYPES = { :link => 0,
                :unknown => 0,
                :text => 1,
                :image => 2,
                :youtube => 3,
                :file => 4 }

  def self.checkPublicationType(pub, publication_params)
    if (pub.file_url != nil)
      pub[:type] = PUB_TYPES[:image]
      pub[:url] =  pub.file.url
      pub[:thumb_url] = pub.file.thumb.url
    elsif (publication_params[:link] != nil)
      pub[:type] = checkMediaSources(publication_params[:link])
      pub[:url] = publication_params[:link]
    elsif (publication_params[:content] != nil)
      pub[:type] = PUB_TYPES[:text]
      pub[:url] = nil
    else
      pub[:type] = PUB_TYPES[:unknown]
      pub[:url] = nil
    end
    return pub
  end

  # check media type such as youtube, dailymotion, ...
  def self.checkMediaSources(link)
    if !isAYoutubeVideo?(link).nil?
      return PUB_TYPES[:youtube]
    end
    return PUB_TYPES[:link]
  end

  # regex youtube videos
  def self.isAYoutubeVideo?(url)
    youtube_regex = %r{^(http|https):\/\/(?:www\.)?youtube.com\/watch\?(?=[^?]*v=\w+)(?:[^\s?]+)?$}xi
    (url =~ youtube_regex)
 end

end
