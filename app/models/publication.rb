class Publication < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :id, :user_id, :place_id, :content, :file, :user_longitude, :user_latitude, :type, :url, :thumb_url, :pub_url
  
  attr_accessor :pub_url, :file

  # for the upload of fime (gem carriewave)
  mount_uploader :file, FileUploader

  # associations
  belongs_to :user
  has_many :report_publications
  has_many :votes
  has_many :comments #, :limit => 10


  # validations
  validates :user_longitude, :presence => {:message => "Please specify the user_longitude"}, :allow_blank => false
  validates :user_latitude, :presence => {:message => "Please specify the user_latitude"}, :allow_blank => false
  validates :place_id, :presence => {:message => "Please specify the place_id"}, :allow_blank => false
  validates :content, :presence => {:message => "Please specify the content"}, :allow_blank => false

  # overwrite the as_json method to add user info, user vote status, number of comments
  def as_json(options={})
        @auth_user_id = options[:auth_user_id] ? options[:auth_user_id] : -1
        @url = options[:params] ? options[:params] : ""
        hash = super(except)
        # publications urls
        hash[:url] = self.url.nil? ? nil : self.type == 2 ? @url + self.url : self.url
        hash[:thumb_url] = self.thumb_url.nil? ? nil : @url + self.thumb_url
        # comments number
        hash[:comments] = self.comments.count
        # like & dislike
        hash[:upvotes] = self.votes.where(:value =>  true).count
        hash[:downvotes] = self.votes.where(:value =>  false).count
        # user informations
        hash[:user] = (self.user) ? { :id => self.user.id, :username => self.user.username,
                                      :avatar => @url + self.user.avatar.url,
                                      :avatar_thumb => @url + self.user.avatar.thumb.url} : nil
        # see if the current user voted this publication
        @vote = self.votes.where(:publication_id => self.id, :user_id => @auth_user_id).first()
        hash[:vote] = (@vote) ? {:id => @vote.id, :value => @vote.value } : nil
        # get place's information sush as name
        if (!(@foursquare = options[:fq]).nil?)
          @place = @foursquare.venues.find(self.place_id)
          hash[:place] = @place.nil? ? nil : { :id => @place.id, :name => @place.name }
        end
        return hash
  end

  def except
        { :except => [ :file, :user_id, :place_id ] }
  end
end
