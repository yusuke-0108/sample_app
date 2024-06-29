require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end
end

class MicropostsInterfaceTest < MicropostsInterface

  test "should paginate microposts" do
    get root_path
    assert_select 'div.pagination'
  end

  test "should show errors but not create micropost on invalid submission" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { context: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'  # 正しいページネーションリンク
  end

  test "should create a micropost on valid submission" do
    context = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { context: context } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match context, response.body
  end

  test "should have micropost delete links on own profile page" do
    get user_path(@user)
    assert_select 'a', text: 'delete'
  end

  test "should be able to delete own micropost" do
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  test "should not have delete links on other user's profile page" do
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end
end

class ImageUploadTest < MicropostsInterface

  test "should have a file input field for image" do
    get root_path
    assert_select 'input[type=file]'
  end

  test "should be able to attach an image" do
    cont = "This micropost really ties the room together"
    img = fixture_file_upload('kitten.jpg', 'image/jpeg')
    post microposts_path, params: { micropost: { context: cont, image: img } }
    assert assigns(:micropost).image.attached?
  end
end
