class Comment < ActiveRecord::Base
  attr_accessible :id, :publication_id, :user_id, :content

  # associations
  belongs_to :publication
  belongs_to :user

  # validations
  validates :publication_id, :presence => {:message => "Please specify the publication_id"}, :allow_blank => false

  # overwrite the as_json method to add user info
  def as_json(options={})
    @url = options[:params] ? options[:params] : ""
    hash = super(except)
    hash[:user] = (self.user) ? { :id => self.user.id, :username => self.user.username,
                                  :avatar => @url + self.user.avatar.url,
                                  :avatar_thumb => @url + self.user.avatar.thumb.url} : nil
    return hash
  end

  def except
    { :except => [ :file, :user_id ] }
  end
end
