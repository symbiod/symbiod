# frozen_string_literal: true

# This fixes the following error:
# expected no Exception, got #<ActionView::Template::Error: undefined method `policy'
# for #<#<Class:0x000055f155524c88>:0x000055f1554e78b0>> with backtrace
module PunditViewPolicy
  extend ActiveSupport::Concern

  included do
    before do
      controller.singleton_class.class_eval do
        def policy(instance)
          Class.new do
            def method_missing(*args, &block); true; end
          end.new
        end
        helper_method :policy
      end
    end
  end
end
