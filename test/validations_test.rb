require_relative 'test_helper'

class ValidationsTest < Minitest::Unit::TestCase

  def test_set_contexts
    assert @user.respond_to?(:context_validations_password_reset)
    assert @user.respond_to?(:context_validations_facebook_auth)
    assert @user.respond_to?(:context_validations_user_subscription)
  end

  def test_validations_when
    # context: :password_reset
    @user.valid?(:password_reset)
    assert_includes @user.errors, :password,
      'password is not validating to :password_reset context'

    # context: :facebook_auth
    @user.valid?(:facebook_auth)
    assert_includes @user.errors, :fb_token_secret,
      'fb_token_secredt is not validating to :facebook_auth context'
  end

  def test_validations_when_not
    # context: :password_reset
    @user.valid?(:password_reset)
    asserts_when_not

    # context: :user_subscription
    @user.valid?(:user_subscription)
    asserts_when_not
  end
end
