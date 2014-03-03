require 'rails'
require 'active_support'
require 'active_record'

module TinyValidations
  extend ActiveSupport::Concern

  included do
    attr_accessor :context_validation
  end

  def validations_when(key , &block)
    validations_base(key, &block)
  end

  def validations_when_not(key, &block)
    validations_base(key, :unless, &block)
  end

  def validations_base( key, condition = :if, &block)
    options = {}
    options[condition] = -> { context_key(key) == context_key(context_validation) }

    instance_eval do
      attr_accessor context_key(key)

      with_options(options) do |validations|
        yield validations
      end
    end
  end

  def context=(key)
    if self.respond_to?(context_key(key))
      self.send("context_validation=", key)
    else
      raise 'Context not found'
    end
  end

  private
  def context_key(key)
    "context_validations_#{key}".to_sym
  end
end

ActiveRecord::Base.send(:extend, TinyValidations)
