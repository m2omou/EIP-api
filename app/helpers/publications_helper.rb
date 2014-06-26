module PublicationsHelper

  PUB_TYPES = { :link => 0,
                :unknown => 0,
                :text => 1,
                :image => 2,
                :youtube => 3,
                :file => 4 }

  # Method that check the publication type, link, image, video...
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

  def self.power(num, pow)
    num ** pow
  end

  # If the user is too far from the place, the user won't be able to create a publication
  # Check the distance between the place and the user
  def self.allowedToPublish?(user, place, distanceMax)
    @dtor = Math::PI/180
    @r = 6378.14*1000

    @rlat1 = user[:lat].to_f * @dtor
    @rlong1 = user[:lon].to_f * @dtor
    @rlat2 = place[:lat].to_f * @dtor
    @rlong2 = place[:lon].to_f * @dtor

    @dlon = @rlong1 - @rlong2
    @dlat = @rlat1 - @rlat2

    @a = power(Math::sin(@dlat/2), 2) + Math::cos(@rlat1) * Math::cos(@rlat2) * power(Math::sin(@dlon/2), 2)
    @c = 2 * Math::atan2(Math::sqrt(@a), Math::sqrt(1-@a))
    @d = @r * @c
    return {:can_publish => @d > distanceMax ? false : true, :distance => @d, :distance_boundary => (distanceMax - @d).abs}
  end

end
