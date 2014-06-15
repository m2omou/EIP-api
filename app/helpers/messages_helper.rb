module MessagesHelper

  def self.conversation_exist?(user_id, recipient_id)
    if (!Conversation.exists?(:creator_id => user_id, :recipient_id => recipient_id) &&
        !Conversation.exists?(:creator_id => recipient_id, :recipient_id => user_id))
      return true
    end
    return false
  end

  def self.find_conversation_id(user_id, recipient_id)
    @conversation = Conversation.find_by_recipient_id_and_creator_id(user_id, recipient_id)
    if (@conversation.nil?)
      @conversation = Conversation.find_by_recipient_id_and_creator_id(recipient_id, user_id)
    end
    return @conversation.nil? ? -1 : @conversation.id
  end
end
