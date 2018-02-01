require "reform/form/dry"

Reform::Form.class_eval do
  include Reform::Form::Dry
end

Rails.application.config.reform.validations = :dry
