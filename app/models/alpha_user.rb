class AlphaUser < ActiveRecord::Base
	attr_accessible :email
	validates_uniqueness_of :email, :message => I18n.t("db_uniqueness")
	validates :email, email_format: { message: I18n.t("email_format_error") }

end
