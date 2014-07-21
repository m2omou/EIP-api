# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
EIP::Application.initialize!

# ActionMailer::Base.smtp_settings = {
#     :user_name => 'neerbyy',
#     :password => 'd14mond',
#     :domain => 'neerbyy.com',
#     :address => 'smtp.sendgrid.net',
#     :port => 587,
#     :authentication => :plain,
#     :enable_starttls_auto => true
# }

# ActionMailer::Base.smtp_settings = {
#     :user_name => 'contact@neerbyy.com',
#     :password => 'veryHardPassword',
#     :domain => 'neerbyy.com',
#     :address => 'smtp.neerbyy.com',
#     :port => 587,
#     :authentication => :plain,
#     :enable_starttls_auto => true
# }