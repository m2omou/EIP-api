module PublicationsHelper

  def self.checkPublicationType(pub, publication_params)
    @types = { :link => 0, :unknown => 0, :text => 1,
               :image => 2, :youtube => 3, :file => 4 }

    puts pub.file_url

    if (pub.file_url != nil)
      pub[:type] = @types[:image]
      pub[:url] =  pub.file.url
      pub[:thumb_url] = pub.file.thumb.url
    elsif (publication_params[:link] != nil)
      pub[:type] = @types[:link]
      pub[:url] = publication_params[:link]
    elsif (publication_params[:content] != nil)
      pub[:type] = @types[:text]
      pub[:url] = nil
    else
      pub[:type] = @types[:unknown]
      pub[:url] = nil
    end
    return pub
  end

end
