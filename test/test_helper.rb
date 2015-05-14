require 'bundler/setup'
Bundler.require(:default)
require 'minitest/autorun'
require 'minitest/pride'

ENV['RACK_ENV'] = 'test'

require 'active_record'

# for debugging
# ActiveRecord::Base.logger = Logger.new(STDOUT)

# rails does this in activerecord/lib/active_record/railtie.rb
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.time_zone_aware_attributes = true

# migrations
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'tiny_validation_test'

ActiveRecord::Migration.create_table :users, force: true do |t|
  t.string :name
  t.string :email
  t.string :city
  t.string :state
  t.string :password
  t.string :fb_token_secret

  t.timestamps
end


class User < ActiveRecord::Base
  include TinyValidations

  validates :name, :email, presence: true

  validations_when_not [:password_reset, :user_subscription] do |m|
    m.validates :city, :state, presence: true
    m.validates_inclusion_of :state, in: ['NY']
  end

  validations_when :facebook_auth do |m|
    m.validates_presence_of :fb_token_secret
  end

  validations_when :password_reset do |m|
    m.validates :password, presence: true
  end
end


class Minitest::Unit::TestCase
  def setup
    User.destroy_all
    @user = User.new(name: 'Nando Sousa',
                     email: 'nandosousafr@gmail.com')

  end

  def asserts_when_not
    refute_includes @user.errors, :city,
      'city is validating to :password_reset_context'

    refute_includes @user.errors, :state,
      'state is validating to :password_reset_context'
  end
end

