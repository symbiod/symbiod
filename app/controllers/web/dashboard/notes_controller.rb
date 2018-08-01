# frozen_string_literal: true

module Web
  module Dashboard
    # This controlle controls the creation of notes to noteables
    class NotesController < ApplicationController
      before_action :load_noteable, only: %i[new create]

      def new
        @note = @noteable.notes.new
        render 'notes/new', layout: 'dashboard'
      end

      def create
        @note = @noteable.notes.new(note_params)
        @note.commenter = current_user
        if @note.save
          redirect_to send("dashboard_#{@noteable.class.name.downcase}_url", @noteable),
                      flash: { success: t('notes.noties.success') }
        else
          flash.now[:danger] = t('notes.noties.danger')
          render 'notes/new', layout: 'dashboard'
        end
      end

      private

      def note_params
        params.require(:note).permit(:content)
      end

      def load_noteable
        resource, id = request.path.split('/')[1, 2]
        @noteable = resource.singularize.classify.constantize.find(id)
      end
    end
  end
end
