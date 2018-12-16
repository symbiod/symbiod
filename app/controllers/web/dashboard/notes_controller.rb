# frozen_string_literal: true

module Web
  module Dashboard
    # This controlle controls the creation of notes to noteables
    class NotesController < BaseController
      before_action :load_noteable, except: %i[index show]
      before_action :note, only: %i[edit update destroy]
      before_action except: %i[edit update destroy] do
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
                      flash: { success: t('notes.noties.success.create') }
        else
          flash.now[:danger] = t('notes.noties.danger.create')
          render 'notes/new', layout: 'dashboard'
        end
      end

      def edit
        render 'notes/edit', layout: 'dashboard'
      end

      def update
        if @note.update(note_params)
          redirect_to send("dashboard_#{@noteable.class.name.underscore}_url", @noteable),
                      flash: { success: t('notes.noties.success.update') }
        else
          flash.now[:danger] = t('notes.noties.danger.update')
          render 'notes/edit', layout: 'dashboard'
        end
      end

      def destroy
        @note.destroy
        redirect_to send("dashboard_#{@noteable.class.name.underscore}_url", @noteable),
                    flash: { success: t('notes.noties.success.destroy') }
      end

      private

      def note_params
        params.require(:note).permit(:content)
      end

      def note
        @note ||= Note.find(params[:id])
        authorize @note, policy_class: ::Dashboard::NotePolicy
      end

      # On the basis of the transmitted path, we determine for which model
      # a note will be created and perform a search already by id
      def load_noteable
        _, resource, id = request.path.split('/')[1, 3]
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
