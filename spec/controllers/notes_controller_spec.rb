require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  let!(:user) { create(:user) }

  context 'User Logged in' do
    before :each do
      sign_in_as(user)
    end

    context 'GET #index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(200)
      end

      context 'checking instance variable' do
        let!(:note) { create(:note, user: user) }
        let!(:note2) { create(:note, title: 'randomness', user: user) }
        let!(:note3) { create(:note, title: 'Random Title') }

        it 'returns all the notes if no search field passed for the user' do
          get :index
          expect(assigns(:notes)).to include(note)
        end

        it 'should not include notes from other user' do
          get :index
          expect(assigns(:notes)).not_to include(:note3)
        end

        it 'returns user notes which having search field' do
          get :index, params: { search_field: 'random' }
          expect(assigns(:notes)).to include(note2)
          expect(assigns(:notes)).not_to include(note, note3)
        end
      end
    end

    context 'Get #new' do
      it 'renders new template' do
        get :new
        expect(response).to render_template(:new)
      end

      it 'creates an empty Note record' do
        get :new
        expect(assigns(:note).class).to eq Note
      end
    end

    context 'Get #edit' do
      let!(:note) { create(:note, user: user) }
      let!(:note2) { create(:note) }

      it 'render edit template' do
        get :edit, params: { id: note.id }
        expect(response).to render_template(:edit)
      end

      it 'return http success' do
        get :edit, params: { id: note.id }
        expect(response).to have_http_status(200)
      end

      it 'has record not found flash message when wrong id is passed' do
        get :edit, params: { id: (note.id + 100) }
        expect(flash[:warning]).to eq 'Record Not Found'
      end

      it 'not authorized error when trying to edit other user note' do
        get :edit, params: { id: note2.id }
        expect(flash[:danger]).to eq 'You are not authorized for this action'
      end
    end

    context 'Post #create' do
      it 'create a note when correct params are passed' do
        expect { post :create, params: { note: { title: 'title', text: 'text' } } }.to change { Note.count }.by 1
      end

      it 'redirects to notes_path when note is created and have success flash message' do
        post :create, params: { note: { title: 'title', text: 'text' } }
        expect(response).to redirect_to(notes_path)
        expect(flash[:success]).to eq 'Note successfully created'
      end

      it 'render new page and expect instance variable to have error when title and text are empty' do
        post :create, params: { note: { title: '', text: '' } }
        expect(response).to render_template(:new)
        expect(assigns(:note).errors.present?).to eq true
      end

      it 'has errors when wrong params are sent' do
        post :create, params: { note: { sdf: 'title', sdff: 'text' } }
        expect(assigns(:note).errors.present?).to eq true
      end

      it 'should not create a note record when wrong params are passed' do
        expect { post :create, params: { note: { sdf: 'title', sdff: 'text' } } }.to change { Note.count }.by 0
      end
    end

    context 'Patch #update' do
      let!(:note) { create(:note, title: 'title', text: 'text', user: user) }
      let(:note2) { create(:note) }

      it 'redirects to notes_path and have success flash message' do
        patch :update, params: { id: note.id,  note: { title: 'title', text: 'text' } }
        expect(response).to redirect_to(notes_path)
        expect(flash[:success]).to eq 'Note successfully updated'
      end

      it 'render edit page and expect instance variable to have error when title and text are empty' do
        patch :update, params: { id: note.id, note: { title: '', text: '' } }
        expect(response).to render_template(:edit)
        expect(assigns(:note).errors.present?).to eq true
      end

      it 'does not change note title and text when wrong params are sent' do
        patch :update, params: { id: note.id, note: { sdf: 'cute', sdff: 'little' } }
        expect(assigns(:note).title).to eq 'title'
        expect(assigns(:note).text).to eq 'text'
      end

      it 'has record not found warning when non existing id is send' do
        patch :update, params: { id: (note.id + 100), note: { title: 'title', text: 'text' } }
        expect(flash[:warning]).to eq 'Record Not Found'
      end

      it 'not authorized error when trying to update other user note' do
        patch :update, params: { id: note2.id, note: { title: 'title', text: 'text' } }
        expect(flash[:danger]).to eq 'You are not authorized for this action'
      end
    end

    context 'Delete #destroy' do
      let!(:note) { create(:note, user: user) }
      let!(:note2) { create(:note) }

      it 'deletes one note record' do
        expect { delete :destroy, params: { id: note.id } }.to change { Note.count }.by(-1)
      end

      it 'have success flash message when note deleted and redirects to notes_path' do
        delete :destroy, params: { id: note.id }
        expect(flash[:success]).to eq 'Note has been deleted'
        expect(response).to redirect_to(notes_path)
      end

      it 'has record not found warning when non existing id is passed and redirects to notes_path' do
        delete :destroy, params: { id: note.id + 100 }
        expect(flash[:warning]).to eq 'Record Not Found'
        expect(response).to redirect_to(notes_path)
      end

      it 'does not delete note record when wrong id is passed' do
        expect { delete :destroy, params: { id: note.id + 100 } }.to change { Note.count }.by 0
      end

      it 'not authorized error when trying to delete other user note' do
        patch :update, params: { id: note2.id }
        expect(flash[:danger]).to eq 'You are not authorized for this action'
      end
    end
  end

  context 'no user' do
    let(:note) { create(:note, user_id: user.id) }

    it 'get new should return to login path' do
      get :new
      expect(:response).to redirect_to login_path
    end

    it 'create new should return to login path' do
      post :create, params: { note: { title: 'title', text: 'text' } }
      expect(:response).to redirect_to login_path
    end

    it 'get edit should return to login path' do
      get :edit, params: { id: note.id }
      expect(:response).to redirect_to login_path
    end

    it 'get index should return to login path' do
      get :index
      expect(:response).to redirect_to login_path
    end

    it 'update should return to login path' do
      patch :update, params: { id: note.id, note: { title: 'title', text: 'text' } }
      expect(:response).to redirect_to login_path
    end

    it 'update should return to login path' do
      delete :destroy, params: { id: note.id }
      expect(:response).to redirect_to login_path
    end
  end
end
