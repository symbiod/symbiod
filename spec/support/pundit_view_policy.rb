# frozen_string_literal: true

# This fixes the following error:
# expected no Exception, got #<ActionView::Template::Error: undefined method `policy'
# for #<#<Class:0x000055f155524c88>:0x000055f1554e78b0>> with backtrace
# https://github.com/varvet/pundit/issues/163#issuecomment-108115021
# https://gist.github.com/mkhairi/5148a107d2ed2d8d797f
module PunditViewPolicy
  extend ActiveSupport::Concern

  included do
    before do
      controller.singleton_class.class_eval do
        def policy(_instance)
          Class.new do
            def method_missing(method_name, *args)
              return true if method_name[-1] == '?'
              super
            end

            def respond_to_missing?(method_name, _include_private = false)
              method_name[-1] == '?'
            end
          end.new
        end
        helper_method :policy
      end
    end
  end
end
