# frozen_string_literal: true

require 'rails_helper'

describe Projects::ProjectsAuthorIdeaQuery do
  subject { described_class.new(author).call }
  let!(:author) { create(:user, :active, :author) }
  let!(:user) { create(:user, :active, :author) }

  let!(:idea_1) { create(:idea, :with_project, author: author) }
  let!(:idea_2) { create(:idea, :with_project, author: author) }
  let!(:idea_3) { create(:idea, :with_project, author: user) }

  describe '#call' do
    it 'returns only project with author idea' do
      is_expected.to match_array [idea_1.project, idea_2.project]
    end
  end
end
