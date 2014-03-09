# Context Validations

## Get Started

Add this line to your application’s Gemfile:

```ruby
gem 'tiny_validations'
```

Add TinyValidations to models you want to add this.

```ruby
class User < ActiveRecord::Base
  include TinyValidations

  validates :name, :email, presence: true

  validations_when_not [:email_subscription, :upgrading_account] do |model|
    model.validates :city, :state, :country, presence: true
  end

  validations_when :upgrading_account do |model|
    model.validates_presence_of :credit_card_number
  end
end

@user = user.new(name: 'Nando Sousa', email: 'nandosousafr@gmail.com')
@user.valid?(context: :email_subscription)
#=> true

@user.valid?(:upgrading_account) 
#=> false

@user.credit_card = '324324-242342-2342423-232423'
@user.valid?(context: :upgrading_account) 
#=> true
```
