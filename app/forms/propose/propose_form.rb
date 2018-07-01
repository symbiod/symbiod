# frozen_string_literal: true

module Propose
  # Provides validations for idea
  # Allows us to extract validations from Idea model
  class ProposeForm < BaseForm
    property :name
    property :description
    property :author_id
    property :private
    property :skip_bootstrapping

    validation do
      required(:name).filled
      required(:description).filled
      required(:author_id).filled
      required(:private).filled
      required(:skip_bootstrapping).filled
    end
  end
end
