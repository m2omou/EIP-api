class Conversation < ActiveRecord::Base
  attr_accessible :id, :creator_id, :recipient_id
  has_many :messages
  belongs_to :user, :foreign_key => :creator_id


  # overwrite the as_json method to add user info, user vote status, number of comments
  def as_json(options={})
    @url = options[:params] ? options[:params] : ""
    hash = super(except)
    # user informations
    hash[:creator] = (self.user) ? { :id => self.user.id, :username => self.user.username,
                                    :avatar => @url + self.user.avatar.url,
                                    :avatar_thumb => @url + self.user.avatar.thumb.url} : nil
    return hash
  end

  def except
    { :except => [ :created_at, :creator_id, :updated_at, :recipient_id ] }
  end
end
