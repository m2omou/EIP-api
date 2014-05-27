class ReportPublication < ActiveRecord::Base
  attr_accessible :id, :user_id, :publication_id, :reason, :content

  belongs_to :publication
  belongs_to :user

  # overwrite the as_json method to add user info
  def as_json(options={})
    @url = options[:params] ? options[:params] : ""
    hash = super(except)
    hash[:user] = (self.user) ? { :id => self.user.id, :username => self.user.username,
                                  :avatar => @url + self.user.avatar.url,
                                  :avatar_thumb => @url + self.user.avatar.thumb.url} : nil
    hash
  end

  def except
    { :except => [ :user_id ] }
  end

  # validations
  validates :publication_id, :presence => {:message => "Please specify the publication_id"}, :allow_blank => false
  validates :reason, :presence => {:message => "Please specify the reason"}, :inclusion => {:in => [0, 1, 2, 3]}
  validates :content, :presence => {:message => "Please specify the content"}, :allow_blank => false
  validates :user_id, :presence => {:message => "Please specify the user_id"}, :allow_blank => false
end
