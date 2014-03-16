class User < ActiveRecord::Base
  attr_accessible :id, :username, :firstname, :lastname, :email, :password, :avatar, :avatar_url, :password_confirmation
  
  mount_uploader :avatar, AvatarUploader
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password

  validates_presence_of :password, :on => :create
  validates_presence_of :email
  
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  
  validates :password, :presence => {:message => "Can't be blank"}, :allow_blank => true
  validates :username, :presence => {:message => "Can't be blank"}, :allow_blank => true
  validates :email, :presence => {:message => "Can't be blank"}, :allow_blank => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  
  has_many :publications
  has_many :relationships
  has_many :reports
  has_many :place_messages
  has_many :votes
  has_many :messages
  
  
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end  
  
  
  before_create { generate_token(:auth_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  
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
