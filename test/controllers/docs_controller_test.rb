# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require_relative "../test_helper"
require_relative "../dummy/config/environment"

require "devise/test/integration_helpers"
require "rails/test_help"

class DocsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  TEST_PASSWORD = "DocsTestPassword!2026"

  setup do
    @user = User.find_or_create_by!(email: "docs-test@example.com") do |user|
      user.password = TEST_PASSWORD
      user.password_confirmation = TEST_PASSWORD
    end

    sign_in @user
  end

  test "install page renders successfully" do
    get docs_install_path
    assert_response :success
    assert_select "h1", text: "Install"
    assert_includes response.body, "gem_template:install"
    assert_includes response.body, "gem_template:migrations"
  end

  test "config page renders successfully" do
    get docs_config_path
    assert_response :success
    assert_select "h1", text: "Config"
    assert_includes response.body, "config/gem_template.yml"
    assert_includes response.body, "config.x.gem_template"
  end

  test "recordings tree page renders successfully" do
    workspace = Workspace.create!(name: "Tree Workspace")
    root_recording = RecordingStudio::Recording.create!(recordable: workspace)
    access_boundary = RecordingStudio::AccessBoundary.create!(minimum_role: :edit)
    boundary_recording = RecordingStudio::Recording.create!(
      recordable: access_boundary,
      parent_recording: root_recording
    )
    access = RecordingStudio::Access.create!(actor: @user, role: :admin)
    RecordingStudio::Recording.create!(recordable: access, parent_recording: boundary_recording)

    get docs_recordings_tree_path

    assert_response :success
    assert_select "h1", text: "Recordings tree"
    assert_includes response.body, "Workspace: Tree Workspace"
    assert_includes response.body, "Access boundary: Edit"
    assert_includes response.body, "Access: Admin for #{@user.email}"
  end

  test "gem_views page renders successfully" do
    get docs_gem_views_path
    assert_response :success
    assert_select "h1", text: "Gem Views"
    assert_includes response.body, "app/views/gem_template/home/index.html.erb"
  end

  test "methods page renders successfully" do
    get docs_methods_path
    assert_response :success
    assert_select "h1", text: "Methods"
    assert_includes response.body, "GemTemplate::Services::BaseService.call"
    assert_includes response.body, "before_initialize"
  end

  test "sidebar includes documentation links" do
    get docs_install_path

    assert_select %(a[href="#{docs_install_path}"]), text: /Install/
    assert_select %(a[href="#{docs_config_path}"]), text: /Config/
    assert_select %(a[href="#{docs_recordings_tree_path}"]), text: /Recordings tree/
    assert_select %(a[href="#{docs_gem_views_path}"]), text: /Gem Views/
    assert_select %(a[href="#{docs_methods_path}"]), text: /Methods/
  end
end
