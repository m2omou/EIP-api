class Conversation < ActiveRecord::Base
  attr_accessible :id, :creator_id, :recipient_id

  # associations
  has_many :messages
  belongs_to :user, :foreign_key => :recipient_id

  # overwrite the as_json method to add user info, user vote status, number of comments
  def as_json(options={})
    @url = options[:params] ? options[:params] : ""
    hash = super(except)
    # user informations
    hash[:recipient] = (self.user) ? { :id => self.user.id, :username => self.user.username,
                                    :avatar => @url + self.user.avatar.url,
                                    :avatar_thumb => @url + self.user.avatar.thumb.url} : nil
    if (options[:opt] == "index")
      hash[:messages] = self.messages
    end
    return hash
  end

  def except
    { :except => [ :created_at, :creator_id, :updated_at, :recipient_id ] }
  end
end
