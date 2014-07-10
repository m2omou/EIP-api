class User < ActiveRecord::Base
  attr_accessible :id, :username, :firstname, :lastname, :email, :password, :avatar, :avatar_url, :password_confirmation, :auth_token
  attr_accessor :password

  # for the avatar gem carriewave
  mount_uploader :avatar, AvatarUploader

  before_save :encrypt_password

  # validations
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates :password, :presence => {:message => "Can't be blank"}, :allow_blank => true
  validates :username, :presence => {:message => "Can't be blank"}, :allow_blank => true
  validates :email, :presence => {:message => "Can't be blank"}, :allow_blank => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  # associations
  has_many :publications, :dependent => :destroy
  has_many :report_comments, :dependent => :destroy
  has_many :report_publications, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :followed_places, :dependent => :destroy
  has_many :conversations, :foreign_key => :creator_id, :dependent => :destroy
  has_many :messages, :foreign_key => :sender_id, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_one  :setting, :dependent => :destroy

  # overwrite the as_json method to add avatar and thumb
  def as_json(options={})
        url = options[:params][:url]
        settings = options[:params][:settings].nil? ? true : options[:params][:settings]
        hash = super(except)

        if (settings)
          hash[:settings_id] = self.setting
        end

        if self.avatar.nil?
          hash[:avatar] =  url + "/assets/avatar.jpg"
          hash[:avatar_thumb] =  url + "/assets/thumb_avatar.jpg"
        else
          hash[:avatar] =  url + self.avatar.url
          hash[:avatar_thumb] =  url + self.avatar.thumb.url
        end
        hash
  end

  # hide certain information
  def except
        { :except=>  [ :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at] }
  end

  # generate a hash and a salt for the password
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end  

  before_create { generate_token(:auth_token) }

  # reset password
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  # generate a new token
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # method to check the login authentification
  def self.authenticate(email, password)
    user = find_by_email(email) || find_by_username(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      begin
        user.auth_token = SecureRandom.urlsafe_base64
      end while User.exists?(:auth_token => user.auth_token)
      user.save
      return user
    else
      nil
    end
  end

end
