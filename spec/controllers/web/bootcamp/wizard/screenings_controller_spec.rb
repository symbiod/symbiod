# frozen_string_literal: true

require 'rails_helper'

describe Web::Bootcamp::Wizard::ScreeningsController do
  describe 'GET #index' do
    context 'authenticated' do
      let(:user) { create(:user, :developer, :policy_accepted, :with_assignment) }
      before { login_user(user) }

      it 'renders template' do
        get :index
        expect(response).to render_template :index
      end

      it 'returns success status' do
        get :index
        expect(response.status).to eq 200
      end

      it 'assigns assigments' do
        get :index
        current_assignment = user.reload.test_task_assignments.uncompleted.first
        expect(assigns(:assignment)).to eq current_assignment
      end

      it_behaves_like 'checks step permissions' do
        let(:wrong_state) { :pending }

        def invoke_action
          get :index
        end
      end
    end

    context 'not authenticated' do
      it 'redirects to root landing page' do
        get :index
        expect(response).to redirect_to root_landing_url
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user, :developer, :policy_accepted, :with_assignment) }
    let(:assignment) { user.test_task_assignments.last }
    let(:params) do
      {
        id: assignment.id,
        developer_test_task_result: {
          link: 'some_value'
        }
      }
    end
    before { login_user(user) }

    context 'valid params' do
      let(:result) { double(success?: true) }

      it 'calls CompleteTask action' do
        expect(Ops::Developer::Screening::CompleteTask)
          .to receive(:call)
          .with(user: user, assignment_id: assignment.id.to_s, params: { 'link' => 'some_value' })
          .and_return(result)
        put :update, params: params
      end

      it 'redirects to screenings url' do
        put :update, params: params
        expect(response).to redirect_to bootcamp_wizard_screenings_url
      end
    end

    context 'invalid params' do
      let(:params) do
        {
          id: assignment.id,
          developer_test_task_result: {
            link: nil
          }
        }
      end

      it 'renders template' do
        put :update, params: params
        expect(response).to render_template :index
      end

      it 'assigns assignment variable' do
        put :update, params: params
        expect(assigns(:assignment)).to eq assignment
      end
    end

    it_behaves_like 'checks step permissions' do
      let(:wrong_state) { :pending }

      def invoke_action
        put :update, params: params
      end
    end
  end
end
