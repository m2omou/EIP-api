class Conversation < ActiveRecord::Base
  attr_accessible :id, :creator_id, :recipient_id

  # associations
  has_many :messages, :dependent => :destroy
  belongs_to :recipient, :class_name => "User", :foreign_key => :recipient_id
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  # overwrite the as_json method to add user info, user vote status, number of comments
  def as_json(options={})
    @url = options[:params] ? options[:params] : ""
    hash = super(except)

    # check the creator of the conversation
    if (options[:user_id].to_i == self.creator.id)
      @recipient = self.recipient
    else
      @recipient = self.creator
    end

    # user informations
    hash[:recipient] = (@recipient) ? { :id => @recipient.id, :username => @recipient.username,
                                    :avatar => @url + @recipient.avatar.url,
                                    :avatar_thumb => @url + @recipient.avatar.thumb.url} : nil
    if (options[:opt] == "index")
      hash[:messages] = self.messages
    end
    return hash
  end

  def except
    { :except => [ :created_at, :creator_id, :updated_at, :recipient_id ] }
  end
end
