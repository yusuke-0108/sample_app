require "test_helper"

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(context: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "context should be present" do
    @micropost.context = "   "
    assert_not @micropost.valid?
  end

  test "context should be at most 140 characters" do
    @micropost.context = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most resent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
