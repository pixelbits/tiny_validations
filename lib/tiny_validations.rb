require 'rails'
require 'active_support'
require 'active_record'

module TinyValidations
  extend ActiveSupport::Concern

  def validations_when(key , &block)
    validations_base(key, &block)
  end

  def validations_when_not(key, &block)
    validations_base(key, :unless, &block)
  end

  def validations_base(rule, condition = :if, &block)
    if rule.is_a?(Array)
      keys = rule.map { |r| context_key(r) }
    else
      keys = Array(context_key(rule))
    end

    options = {}
    options[condition] = -> { keys.include?(context_key(validation_context)) }

    instance_eval do
      keys.each { |k| attr_accessor k }
      with_options(options) { |validations| yield validations }
    end
  end

  def context=(key)
    if self.respond_to?(context_key(key))
      self.validation_context = key
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
