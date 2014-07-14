# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
EIP::Application.initialize!

ActionMailer::Base.smtp_settings = {
    :user_name => 'neerbyy',
    :password => 'd14mond',
    :domain => 'neerbyy.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}