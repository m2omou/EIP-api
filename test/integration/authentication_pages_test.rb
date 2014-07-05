require 'test_helper'

class AuthenticationPagesTest < ActionDispatch::IntegrationTest
   test "test login" do
     # post the login and follow through to the home page

     # Create a new account
     @newUser = User.new(:email => 'test@gmail.com', :password => 'test',
                         :username => 'moomou',
                         :firstname => 'Mourad', :lastname => 'Sabour')
     # Create user settings
     @newUser.create_setting()
     # Save
     @newUser.save()

     # Try to login
     post "/sessions.json", :connection => {:email => 'test@gmail.com', :password =>'test'}

     # Parse the result
     @login = JSON.parse(@response.body)

     # Check the responseCode value
     assert_equal 0, @login['responseCode']


     # Check that all the fields excepted are returned
     @usr = @login["result"]["user"]
     assert @usr.has_key?("id")
     assert @usr.has_key?("username")
     assert @usr.has_key?("firstname")
     assert @usr.has_key?("lastname")
     assert @usr.has_key?("email")
     assert @usr.has_key?("avatar")
     assert @usr.has_key?("avatar_thumb")
     assert @usr.has_key?("settings_id")
     assert @usr.has_key?("auth_token")


     # And check some of their values
     assert_equal "moomou",         @usr["username"]
     assert_equal "test@gmail.com", @usr["email"]
     assert_equal "Mourad",       @usr["firstname"]
     assert_equal "Sabour",       @usr["lastname"]
   end
end
