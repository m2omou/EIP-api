class Publication < ActiveRecord::Base
  
  
  self.inheritance_column = nil
  attr_accessible :id, :user_id, :place_id, :content, :file, :longitude, :latitude, :type, :url, :thumb_url, :pub_url
  
  attr_accessor :pub_url, :file
  
  mount_uploader :file, FileUploader
  
  belongs_to :user

  has_many :reports
  has_many :votes
  has_many :comments #, :limit => 10
  
   def as_json(options={})
        hash = super(except)
        hash[:comments] = self.comments.count
        hash[:like] = self.votes.where(:value =>  true).count
        hash[:dislike] = self.votes.where(:value =>  false).count
        hash[:vote] = {:id => self.id, :value => (Vote.exists?(:publication_id => self.id)) ? true : false }
        hash
    end
  
  def except
        { :except => [ :file ] }
  end
  
end
