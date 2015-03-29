require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe AttendeesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Attendee. As you add validations to Attendee, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: 'Some Attendee' }
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AttendeesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let!(:room) { create(:room) }
  let!(:attendee) { create(:attendee, room: room) }

  describe "GET #index" do
    it "assigns all attendees as @attendees" do
      get :index, {:room_id => room.to_param}, valid_session
      expect(assigns(:attendees)).to eq([attendee])
    end
  end

  describe "GET #show" do
    it "assigns the requested attendee as @attendee" do
      get :show, {:id => attendee.to_param}, valid_session
      expect(assigns(:attendee)).to eq(attendee)
    end
  end

  describe "GET #new" do
    it "assigns a new attendee as @attendee" do
      get :new, {:room_id => room.to_param}, valid_session
      expect(assigns(:attendee)).to be_a_new(Attendee)
    end
  end

  describe "GET #edit" do
    it "assigns the requested attendee as @attendee" do
      get :edit, {:id => attendee.to_param}, valid_session
      expect(assigns(:attendee)).to eq(attendee)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Attendee" do
        expect {
          post :create, {:room_id => room.to_param, :attendee => valid_attributes}, valid_session
        }.to change(Attendee, :count).by(1)
      end

      it "assigns a newly created attendee as @attendee" do
        post :create, {:room_id => room.to_param, :attendee => valid_attributes}, valid_session
        expect(assigns(:attendee)).to be_a(Attendee)
        expect(assigns(:attendee)).to be_persisted
      end

      it "adds the attendee to the room" do
        post :create, {:room_id => room.to_param, :attendee => valid_attributes}, valid_session
        expect(assigns(:attendee).room).to eq(room)
      end

      it "redirects to the appropriate room" do
        post :create, {:room_id => room.to_param, :attendee => valid_attributes}, valid_session
        expect(response).to redirect_to(room)
      end

      it "notifies the channel" do
        allow(WebsocketRails["room:#{room.to_param}"]).to receive(:trigger)
        post :create, {:room_id => room.to_param, :attendee => valid_attributes}, valid_session
        expect(WebsocketRails["room:#{room.to_param}"]).to have_received(:trigger).with(:updated, {attendee_id: assigns(:attendee).id})
      end

      it "sets the attendee_id cookie" do
        post :create, {:room_id => room.to_param, :attendee => valid_attributes}, valid_session
        expect(response.cookies['attendee_id']).to eq(assigns(:attendee).to_param)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved attendee as @attendee" do
        post :create, {:room_id => room.to_param, :attendee => invalid_attributes}, valid_session
        expect(assigns(:attendee)).to be_a_new(Attendee)
      end

      it "re-renders the 'new' template" do
        post :create, {:room_id => room.to_param, :attendee => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "POST #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Another Attendee' }
      }

      it "updates the requested attendee" do
        put :update, {:id => attendee.to_param, :attendee => new_attributes}, valid_session
        attendee.reload
        expect(attendee.name).to eq(new_attributes[:name])
      end

      it "assigns the requested attendee as @attendee" do
        put :update, {:id => attendee.to_param, :attendee => valid_attributes}, valid_session
        expect(assigns(:attendee)).to eq(attendee)
      end

      it "redirects to the attendee" do
        put :update, {:id => attendee.to_param, :attendee => valid_attributes}, valid_session
        expect(response).to redirect_to(attendee)
      end

      it "notifies the channel" do
        expect(WebsocketRails["room:#{room.to_param}"]).to receive(:trigger).with(:updated, {attendee_id: attendee.id})
        put :update, {:id => attendee.to_param, :attendee => valid_attributes}, valid_session
      end
    end

    context "with invalid params" do
      it "assigns the attendee as @attendee" do
        put :update, {:id => attendee.to_param, :attendee => invalid_attributes}, valid_session
        expect(assigns(:attendee)).to eq(attendee)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => attendee.to_param, :attendee => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested attendee" do
      expect {
        delete :destroy, {:id => attendee.to_param}, valid_session
      }.to change(Attendee, :count).by(-1)
    end

    it "redirects to the attendees list" do
      delete :destroy, {:id => attendee.to_param}, valid_session
      expect(response).to redirect_to(room_attendees_url(room))
    end

    it "notifies the channel" do
      expect(WebsocketRails["room:#{room.to_param}"]).to receive(:trigger).with(:updated, {attendee_id: attendee.id})
      delete :destroy, {:id => attendee.to_param}, valid_session
    end
  end

end
