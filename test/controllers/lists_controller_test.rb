require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:one)
  end

  test "should get index" do
    get lists_url
    assert_response :success
  end

  test "index shows each list in a table with show, edit, and destroy actions" do
    get lists_url

    assert_response :success
    assert_select "table tbody tr##{dom_id(@list)}" do
      assert_select "td:first-child form input[type=checkbox][name='list[completed]']"
      assert_select "td:first-child", text: /#{Regexp.escape(@list.description)}/
      assert_select "td:nth-child(2) .badge", text: @list.completed? ? "Completed" : "Incomplete"
      assert_select "a[href='#{list_path(@list)}']", text: "Show"
      assert_select "a[href='#{edit_list_path(@list)}']", text: "Edit"
      assert_select "form[action='#{list_path(@list)}'] input[name='_method'][value='delete']"
      assert_select "button", text: "Destroy"
    end
  end

  test "should get new" do
    get new_list_url
    assert_response :success
    assert_select ".row.justify-content-center .col-lg-8"
    assert_select "input[type=submit][value='Add Item']"
  end

  test "should create list" do
    assert_difference("List.count") do
      post lists_url, params: { list: { completed: @list.completed, description: @list.description } }
    end

    assert_redirected_to list_url(List.last)
  end

  test "should show list" do
    get list_url(@list)
    assert_response :success
    assert_select ".card"
    assert_select ".badge", text: @list.completed? ? "Completed" : "Not completed"
  end

  test "should get edit" do
    get edit_list_url(@list)
    assert_response :success
    assert_select "input[type=checkbox][name='list[completed]']"
  end

  test "should update list" do
    patch list_url(@list), params: { list: { completed: @list.completed, description: @list.description } }
    assert_redirected_to list_url(@list)
  end

  test "should update completion from the index" do
    patch list_url(@list), params: { list: { completed: !@list.completed }, return_to: "index" }

    assert_redirected_to lists_url
    assert_equal !@list.completed, @list.reload.completed
  end

  test "should destroy list" do
    assert_difference("List.count", -1) do
      delete list_url(@list)
    end

    assert_redirected_to lists_url
  end
end
