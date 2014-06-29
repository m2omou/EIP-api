class AlphaUser < ActiveRecord::Base
	attr_accessible :email, :locate
  attr_accessor :locate

	validates_uniqueness_of :email, :message => :db_uniqueness
  validates :email, presence:   true, length: { maximum: 60 },
            format:     { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: :email_format_error },
            uniqueness: { case_sensitive: false }
end
