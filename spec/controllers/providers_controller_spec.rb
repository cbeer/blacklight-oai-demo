require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProvidersController do

  before(:each) do 
    @one = Provider.new :endpoint => 'http://example.org', :title => 'ABC', :interval => 60, :last_consumed_at => Time.now - 60.minutes
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create provider" do
    assert_difference('Provider.count') do
      post :create, :provider => { :endpoint => 'http://example.org/2' }
    end

    assert_redirected_to edit_provider_path(assigns(:provider))
  end


  it "should get edit" do
    @one.save
    get :edit, :id => @one.to_param
    assert_response :success
  end

  describe "update" do
    it "should update provider" do
      @one.save
      put :update, :id => @one.to_param, :provider => { }
      assert_redirected_to provider_path(assigns(:provider))
    end

    it "should refuse invalid endpoints" do
      @one.save
      put :update, :id => @one.to_param, :provider => { :endpoint => 'bad-uri' }

    end
  end


  it "should destroy provider" do
    @one.save
    assert_difference('Provider.count', -1) do
      delete :destroy, :id => @one.to_param
    end

    assert_redirected_to providers_path
  end

  describe "index" do
    it "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:providers)
    end
    it "should be empty" do
      get :index
      @providers = assigns(:providers)
      @providers.length.should == 0
    end

    it "should list active providers" do
      @one.save
      get :index
      @providers = assigns(:providers)
      @providers.length.should == 1
    end
  end

  describe "show" do
    it "should show provider" do
      @one.save
      get :show, :id => @one.to_param
      assert_response :success
    end
  end

  describe "records" do
    it "should redirect the user to the appropriate catalog page" do
      @one.save
      get :records, :id => @one.to_param
      assert_redirected_to catalog_index_url(:q => "provider_id_i:#{@one.id}")

    end
  end

  describe "harvest" do
    it "should trigger a consume action" do
      @provider = mock("provider")
      @provider.should_receive('consume!').and_return(0)
      @provider.should_receive('to_param').any_number_of_times.and_return('ZZZ')

      Provider.should_receive(:find).with('ZZZ').and_return(@provider)
      get :harvest, :id => 'ZZZ'

      assert_redirected_to records_provider_url(:id => 'ZZZ')
    end
  end
end

