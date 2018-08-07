# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Dashboard::VotesController, type: :controller do
  before { create(:stack, :rails_monolith) }

  describe 'GET #index' do
    context 'not signed in' do
      let(:idea) { create(:idea, :voting) }
      before { get :index, params: { idea_id: idea.id } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'sign in' do
      let(:idea) { create(:idea, :voting) }
      let(:vote_1) { create(:vote, idea: idea) }

      before do
        login_user(user)
        get :index, params: { idea_id: idea.id }
      end

      shared_examples 'index tests' do
        it 'renders template' do
          expect(response).to render_template :index
        end

        it 'returns success status' do
          expect(response.status).to eq 200
        end

        it 'renders all votes ideas' do
          expect(assigns(:votes)).to eq ::Idea.find(idea.id).votes
        end
      end

      context 'user has role staff or mentor' do
        let(:user) { create(:user, :staff_or_mentor, :active) }

        it_behaves_like 'index tests'
      end

      context 'user has role developer or author' do
        let(:user) { create(:user, :developer_or_author, :active) }

        it_behaves_like 'index tests'
      end
    end
  end

  describe 'PUT #up' do
    context 'not signed in' do
      let(:idea) { create(:idea, :voting) }
      before { put :down, params: { idea_id: idea.id, id: 1 } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'sign in' do
      let(:idea) { create(:idea, :voting) }

      before { login_user(user) }

      shared_examples 'voting up user' do
        it 'redirects to root landing' do
          put :up, params: { idea_id: idea.id, id: 1 }
          expect(response).to redirect_to dashboard_idea_url(idea)
        end

        it 'vote was not created' do
          expect { put :up, params: { idea_id: idea.id, id: 1 } }
            .to change(Vote, :count).by(0)
        end
      end

      context 'current user did not vote' do
        context 'user has role staff or mentor' do
          let(:user) { create(:user, :staff_or_mentor, :active) }

          it_behaves_like 'voting up user'
        end

        context 'user has role author' do
          let(:user) { create(:user, :author, :active) }

          it_behaves_like 'voting up user'
        end

        context 'user has role developer' do
          let(:user) { create(:user, :developer, :active) }

          context 'idea has no votes' do
            it 'redirects to idea page' do
              put :up, params: { idea_id: idea.id, id: 1 }
              expect(response).to redirect_to dashboard_idea_url(idea)
            end

            it 'vote was created' do
              expect { put :up, params: { idea_id: idea.id, id: 1 } }
                .to change(Vote, :count).by(1)
            end
          end

          context 'idea has 4 votes' do
            before { create_list(:vote, 4, idea: idea) }

            it 'project was created' do
              expect { put :up, params: { idea_id: idea.id, id: 1 } }
                .to change(Project, :count).by(1)
            end

            it 'redirects to project page' do
              put :up, params: { idea_id: idea.id, id: 1 }
              expect(response).to redirect_to dashboard_project_url(idea.project)
            end

            it 'vote was created' do
              expect { put :up, params: { idea_id: idea.id, id: 1 } }
                .to change(Vote, :count).by(1)
            end
          end
        end
      end

      context 'current user was vote' do
        context 'user has role staff or mentor' do
          let(:user) { create(:user, :staff_or_mentor, :active) }
          let!(:vote) { create(:vote, user: user, idea: idea) }

          it_behaves_like 'voting up user'
        end

        context 'user has role author' do
          let(:user) { create(:user, :author, :active) }
          let!(:vote) { create(:vote, user: user, idea: idea) }

          it_behaves_like 'voting up user'
        end

        context 'user has role developer' do
          let(:user) { create(:user, :developer, :active) }
          let!(:vote) { create(:vote, user: user, idea: idea) }

          it_behaves_like 'voting up user'
        end
      end
    end
  end

  describe 'PUT #down' do
    context 'not signed in' do
      let(:idea) { create(:idea, :voting) }
      before { put :down, params: { idea_id: idea.id, id: 1 } }

      it 'redirects to root landing' do
        expect(response).to redirect_to root_landing_url
      end
    end

    context 'sign in' do
      let(:idea) { create(:idea, :voting) }

      before { login_user(user) }

      shared_examples 'voting down user' do
        it 'redirects to root landing' do
          put :down, params: { idea_id: idea.id, id: 1 }
          expect(response).to redirect_to dashboard_idea_url(idea)
        end

        it 'vote was not created' do
          expect { put :down, params: { idea_id: idea.id, id: 1 } }
            .to change(Vote, :count).by(0)
        end
      end

      context 'current user did not vote' do
        context 'user has role staff or mentor' do
          let(:user) { create(:user, :staff_or_mentor, :active) }

          it_behaves_like 'voting down user'
        end

        context 'user has role author' do
          let(:user) { create(:user, :author, :active) }

          it_behaves_like 'voting down user'
        end

        context 'user has role developer' do
          let(:user) { create(:user, :developer, :active) }

          it 'redirects to root landing' do
            put :down, params: { idea_id: idea.id, id: 1 }
            expect(response).to redirect_to dashboard_idea_url(idea)
          end

          it 'vote was created' do
            expect { put :down, params: { idea_id: idea.id, id: 1 } }
              .to change(Vote, :count).by(1)
          end
        end
      end

      context 'current user was vote' do
        context 'user has role staff or mentor' do
          let(:user) { create(:user, :staff_or_mentor, :active) }
          let!(:vote) { create(:vote, user: user, idea: idea) }

          it_behaves_like 'voting down user'
        end

        context 'user has role author' do
          let(:user) { create(:user, :author, :active) }
          let!(:vote) { create(:vote, user: user, idea: idea) }

          it_behaves_like 'voting down user'
        end

        context 'user has role developer' do
          let(:user) { create(:user, :developer, :active) }
          let!(:vote) { create(:vote, user: user, idea: idea) }

          it_behaves_like 'voting down user'
        end
      end
    end
  end
end
