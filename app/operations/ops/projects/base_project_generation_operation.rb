# frozen_string_literal: true

module Ops
  module Projects
    # This base operation to generate project
    class BaseProjectGenerationOperation < BaseOperation
      private

      def members_project(project)
        (project.users + [project.author]).uniq
      end
    end
  end
end
