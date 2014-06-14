describe PoemsController do
  describe "GET #index" do
    let(:poems){double(:poems)}
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the posts into @posts" do
      allow(Poem).to receive(:all) {poems}
      get :index

      expect(assigns(:poems)).to eq(poems)
    end
  end

  describe "POST #create" do
    it "responds successfully with an HTTP redirect" do
      @request.env["HTTP_REFERER"] = 'http://www.example.com'
      get :create
      expect(response).to redirect_to(:back)
    end
  end
end
