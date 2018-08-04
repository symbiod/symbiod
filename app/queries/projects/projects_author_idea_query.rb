# frozen_string_literal: true

module Projects
  # Find projects for which the author is the current user
  class ProjectsAuthorIdeaQuery
    attr_reader :author

    def initialize(author)
      @author = author
    end

    def call
      Project
        .joins(:idea)
        .where(ideas: { author_id: author.id })
    end
  end
end
