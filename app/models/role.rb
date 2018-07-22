# frozen_string_literal: true

# TODO:
class Role < ApplicationRecord
  belongs_to :user

  # TODO: make good validation
  validates :type, inclusion: { in: Rolable.role_class_names }
  
  def name
    self.class.to_s.demodulize.underscore
  end
end
