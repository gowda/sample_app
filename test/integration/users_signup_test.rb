require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_select "form[action='/signup']"

    # FIXME: doesn't look like integration test in any sense
    # FIXME: is it possible to click on the submit button instead?
    # FIXME: RSpec + capybara does a much better job, readability-wise
    assert_no_difference "User.count" do
      post signup_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_template "users/new"
    assert_select "div#error-explanation"
    assert_select "div.field_with_errors input#user_name"
    assert_select "div.field_with_errors input#user_email"
    assert_select "div.field_with_errors input#user_password"
    assert_select "div.field_with_errors input#user_password_confirmation"
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, params: {
        user: {
          name: "Test User",
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash[:success].blank?
  end
end
