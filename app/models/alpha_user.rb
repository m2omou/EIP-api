class AlphaUser < ActiveRecord::Base
	attr_accessible :email
	validates_uniqueness_of :email, :message => "already exists in the database. You already subscribed!"
	validates :email, email_format: { message: "doesn't look like an email address" }
end
