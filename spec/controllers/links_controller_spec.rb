require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:dummy_user) { User.create!(username: 'sam', password: 'password') }
  let(:valid_session) { {user_id: dummy_user.id} }
  let(:hacker_user) { User.create!(username: 'hacker', password: 'password') }
  let(:hacker_session) { {user_id: hacker_user.id} }
  let(:valid_attributes) {{full_url: "http://www.google.com", short_url: "thegoog", user: dummy_user}}
  let(:unowned_attributes) {{full_url: "http://www.linkedin.com", short_url: "li"}}
  let(:invalid_attributes) {{full_url: "not-a-url", short_url: ""}}

  describe "GET #reroute" do
    context "when the short url exists" do
      it "redirects to the full url that matches the short url" do
        link = Link.create! valid_attributes
        get :reroute, {wildcard: link.short_url}
        expect(response).to redirect_to(link.full_url)
      end

      it "creates a new request record" do
        link = Link.create! valid_attributes
        expect {
          get :reroute, {wildcard: link.short_url}
        }.to change(Request, :count).by(1)
      end
    end

    context "when the short url does not exist" do
      it "responds with a 404" do
        link = Link.create! valid_attributes
        get :reroute, {wildcard: "doesnoteexist"}
        expect(response.status).to eq(404)
        expect(response.body).to eq("404 Not Found")
      end
    end
  end

  describe "GET #index" do
    context "when logged in" do
      it "assigns all the current user's links as @links" do
        link = Link.create! valid_attributes
        unowned_link = Link.create! unowned_attributes
        get :index, {}, valid_session
        expect(assigns(:links)).to eq([link])
      end

      it "does not assign every link in the database to @links" do
        link = Link.create! valid_attributes
        unowned_link = Link.create! unowned_attributes
        get :index, {}, valid_session
        expect(assigns(:links)).to_not eq(Link.all)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        link = Link.create! valid_attributes
        unowned_link = Link.create! unowned_attributes
        get :index
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "GET #show" do
    context "when logged in" do
      context "as the owner" do
        it "assigns the requested link as @link" do
          link = Link.create! valid_attributes
          get :show, {:id => link.to_param}, valid_session
          expect(assigns(:link)).to eq(link)
        end

        it "renders the show template" do
          link = Link.create! valid_attributes
          get :show, {:id => link.to_param}, valid_session
          expect(response).to render_template("show")
        end
      end

      context "as a non-owner" do
        it "responds with a 403" do
          link = Link.create! valid_attributes
          get :show, {:id => link.to_param}, hacker_session
          expect(response.status).to eq(403)
          expect(response.body).to eq("403 Unauthorized")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        link = Link.create! valid_attributes
        get :show, {:id => link.to_param}
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "GET #new" do
    context "when logged in" do
      it "assigns a new link as @link" do
        get :new, {}, valid_session
        expect(assigns(:link)).to be_a_new(Link)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "GET #edit" do
    context "when logged in" do
      context "as the owner" do
        it "assigns the requested link as @link" do
          link = Link.create! valid_attributes
          get :edit, {:id => link.to_param}, valid_session
          expect(assigns(:link)).to eq(link)
        end

        it "renders the edit template" do
          link = Link.create! valid_attributes
          get :edit, {:id => link.to_param}, valid_session
          expect(response).to render_template("edit")
        end
      end

      context "as a non-owner" do
        it "responds with a 403" do
          link = Link.create! valid_attributes
          get :edit, {:id => link.to_param}, hacker_session
          expect(response.status).to eq(403)
          expect(response.body).to eq("403 Unauthorized")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        link = Link.create! valid_attributes
        get :edit, {:id => link.to_param}
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "POST #create" do
    context "when logged in" do
      context "with valid params" do
        it "creates a new Link" do
          expect {
            post :create, {:link => valid_attributes}, valid_session
          }.to change(Link, :count).by(1)
        end

        it "assigns a newly created link as @link" do
          post :create, {:link => valid_attributes}, valid_session
          expect(assigns(:link)).to be_a(Link)
          expect(assigns(:link)).to be_persisted
        end

        it "redirects to the created link" do
          post :create, {:link => valid_attributes}, valid_session
          expect(response).to redirect_to(Link.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved link as @link" do
          post :create, {:link => invalid_attributes}, valid_session
          expect(assigns(:link)).to be_a_new(Link)
        end

        it "re-renders the 'new' template" do
          post :create, {:link => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post :create, {:link => valid_attributes}
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) {{short_url: "google-home"}}

    context "when logged in" do
      context "as an owner" do
        context "with valid params" do
          it "updates the requested link" do
            link = Link.create! valid_attributes
            put :update, {:id => link.to_param, :link => new_attributes}, valid_session
            link.reload
            expect(link.short_url).to eq("google-home")
          end

          it "assigns the requested link as @link" do
            link = Link.create! valid_attributes
            put :update, {:id => link.to_param, :link => valid_attributes}, valid_session
            expect(assigns(:link)).to eq(link)
          end

          it "redirects to the link" do
            link = Link.create! valid_attributes
            put :update, {:id => link.to_param, :link => valid_attributes}, valid_session
            expect(response).to redirect_to(link)
          end
        end

        context "with invalid params" do
          it "assigns the link as @link" do
            link = Link.create! valid_attributes
            put :update, {:id => link.to_param, :link => invalid_attributes}, valid_session
            expect(assigns(:link)).to eq(link)
          end

          it "re-renders the 'edit' template" do
            link = Link.create! valid_attributes
            put :update, {:id => link.to_param, :link => invalid_attributes}, valid_session
            expect(response).to render_template("edit")
          end
        end
      end

      context "as a non-owner" do
        it "responds with a 403" do
          link = Link.create! valid_attributes
          put :update, {:id => link.to_param, :link => new_attributes}, hacker_session
          expect(response.status).to eq(403)
          expect(response.body).to eq("403 Unauthorized")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        link = Link.create! valid_attributes
        put :update, {:id => link.to_param, :link => new_attributes}
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in" do
      it "destroys the requested link" do
        link = Link.create! valid_attributes
        expect {
          delete :destroy, {:id => link.to_param}, valid_session
        }.to change(Link, :count).by(-1)
      end

      it "redirects to the links list" do
        link = Link.create! valid_attributes
        delete :destroy, {:id => link.to_param}, valid_session
        expect(response).to redirect_to(links_url)
      end

      context "as a non-owner" do
        it "responds with a 403" do
          link = Link.create! valid_attributes
          delete :destroy, {:id => link.to_param}, hacker_session
          expect(response.status).to eq(403)
          expect(response.body).to eq("403 Unauthorized")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        link = Link.create! valid_attributes
        delete :destroy, {:id => link.to_param}
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
