# Context Validations

```ruby
class User < ActiveRecord::Base
  include ContextValidations

  validates :name, :email, presence: true

  validations_when_not :email_subscription do |model|
    model.validates :city, :state, :country, presence: true
  end

  validations_when :upgrading_account do |model|
    model.validates_presence_of :credit_card_number
  end
end

@user = user.new(name: 'Nando Sousa', email: 'nandosousafr@gmail.com')
@ser.context = :email_subscription
@user.save #=> true

@user.context = :upgrading_account
@user.valid? #=> false

@user.credit_card = '324324-242342-2342423-232423'
@user.save #=> true




```
