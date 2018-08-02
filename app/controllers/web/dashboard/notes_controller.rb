# frozen_string_literal: true

module Web
  module Dashboard
    # This controlle controls the creation of notes to noteables
    class NotesController < BaseController
      before_action :load_noteable, only: %i[new create]
      before_action do
        authorize_role(%i[dashboard note])
      end
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_notable

      def new
        @note = @noteable.notes.build
        render 'notes/new', layout: 'dashboard'
      end

      def create
        build_note
        if @note.save
          redirect_to send("dashboard_#{@noteable.class.name.underscore}_url", @noteable),
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

      # On the basis of the transmitted path, we determine for which model
      # a note will be created and perform a search already by id
      def load_noteable
        resource, id = request.path.split('/')[1, 2]
        @noteable = resource.singularize.classify.constantize.find(id)
      end

      def redirect_to_dashboard_notable
        redirect_to send("dashboard_#{@noteable.class.name.underscore}_url", @noteable),
                    flash: { danger: t('notes.noties.access_denied') }
      end

      def build_note
        @note = @noteable.notes.build(note_params)
        @note.commenter = current_user
      end
    end
  end
end
