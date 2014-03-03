require_relative 'test_helper'

class ValidationsTest < Minitest::Unit::TestCase

  def test_set_contexts
    assert @user.respond_to?(:context_validations_password_reset)
    assert @user.respond_to?(:context_validations_facebook_auth)

    assert @user.respond_to?(:context_validation)
  end

  def test_validatios_when
    # context :password_reset
    @user.context = :password_reset
    @user.password = 'pass19822'
    assert @user.valid?

    #context :facebook_auth
    @user.context = :facebook_auth
    @user.fb_token_secret = 'fff22111fff'
    assert_equal false, @user.valid?

    @user.city = 'New York'
    @user.state = 'NY'
    assert @user.valid?
  end
end
