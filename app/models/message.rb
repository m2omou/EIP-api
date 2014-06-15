class Message < ActiveRecord::Base
  attr_accessible :sender_id, :conversation_id, :content, :recipient_id
  attr_accessor :recipient_id

  belongs_to :conversation
  belongs_to :user, :foreign_key => :sender_id

  # validations
  validates :content, :presence => {:message => "Please specify the content"}, :allow_blank => false
  validates :recipient_id, :presence => {:message => "Please specify the recipient_id"}, :allow_blank => false

  # overwrite the as_json method to add user info, user vote status, number of comments
  def as_json(options={})
    @url = options[:params] ? options[:params] : ""
    hash = super(except)
    # user informations
    hash[:sender] = (self.user) ? { :id => self.user.id, :username => self.user.username,
                                  :avatar => @url + self.user.avatar.url,
                                  :avatar_thumb => @url + self.user.avatar.thumb.url} : nil
    return hash
  end

  def except
    { :except => [ :created_at, :conversation_id, :updated_at, :sender_id ] }
  end
end
