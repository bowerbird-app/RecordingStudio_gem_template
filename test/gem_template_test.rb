# frozen_string_literal: true

require "test_helper"

class GemTemplateTest < Minitest::Test
  def test_version_exists
    refute_nil ::GemTemplate::VERSION
  end

  def test_engine_exists
    assert_kind_of Class, ::GemTemplate::Engine
  end

  def test_dummy_app_uses_flatpack_sidebar_layout
    layout_path = File.expand_path("dummy/app/views/layouts/flat_pack_sidebar.html.erb", __dir__)
    assert File.exist?(layout_path)

    application_controller_path = File.expand_path("dummy/app/controllers/application_controller.rb", __dir__)
    controller_source = File.read(application_controller_path)
    assert_includes controller_source, "flat_pack_sidebar"
  end

  def test_recording_studio_capabilities_are_off_by_default
    initializer_path = File.expand_path("dummy/config/initializers/recording_studio.rb", __dir__)
    initializer_source = File.read(initializer_path)

    assert_includes initializer_source, "Built-in capabilities remain disabled"
    refute_includes initializer_source, "config.features."
  end

  def test_dummy_readme_explains_dummy_app_purpose
    readme_path = File.expand_path("dummy/README.md", __dir__)
    readme_source = File.read(readme_path)

    assert_includes readme_source, "This Rails app exists to validate the Recording Studio addon template"
    assert_includes readme_source, "/recording_studio"
  end

  def test_dummy_home_page_mentions_template_workflow
    view_path = File.expand_path("dummy/app/views/home/index.html.erb", __dir__)
    view_source = File.read(view_path)

    assert_includes view_source, "Template workflow"
    assert_includes view_source, "Workspace state"
    assert_includes view_source, "Recording Studio mount"
  end

  def test_dummy_app_layouts_link_flatpack_stylesheets_directly
    application_layout_path = File.expand_path("dummy/app/views/layouts/application.html.erb", __dir__)
    application_layout_source = File.read(application_layout_path)

    sidebar_layout_path = File.expand_path("dummy/app/views/layouts/flat_pack_sidebar.html.erb", __dir__)
    sidebar_layout_source = File.read(sidebar_layout_path)

    [application_layout_source, sidebar_layout_source].each do |layout_source|
      assert_includes layout_source, 'stylesheet_link_tag "flat_pack/variables"'
      assert_includes layout_source, 'stylesheet_link_tag "flat_pack/rich_text"'
      assert_includes layout_source, 'stylesheet_link_tag "flat_pack/content_editor"'
      refute_includes layout_source, 'stylesheet_link_tag "flat_pack/application"'
    end

    stylesheet_path = File.expand_path("dummy/app/assets/stylesheets/application.css", __dir__)
    stylesheet_source = File.read(stylesheet_path)

    refute_includes stylesheet_source, '@import "flat_pack/rich_text.css";'
    refute_includes stylesheet_source, '@import "flat_pack/variables.css";'
  end

  def test_dummy_app_importmap_includes_tiptap_pins
    importmap_path = File.expand_path("dummy/config/importmap.rb", __dir__)
    importmap_source = File.read(importmap_path)

    assert_includes importmap_source, 'tiptap_version = "2.11.5"'
    assert_includes importmap_source, 'preload: false'
    assert_includes importmap_source, 'pin "flat_pack/heroicons", to: "flat_pack/heroicons.js", preload: false'
    assert_includes importmap_source, 'pin "@tiptap/core"'
    assert_includes importmap_source, 'pin "@tiptap/starter-kit"'
  end

  def test_dummy_app_uses_lazy_flatpack_controller_loading
    controllers_index_path = File.expand_path("dummy/app/javascript/controllers/index.js", __dir__)
    controllers_index_source = File.read(controllers_index_path)

    assert_includes controllers_index_source, 'lazyLoadControllersFrom("controllers", application)'
    refute_includes controllers_index_source, 'eagerLoadControllersFrom("controllers/flat_pack", application)'
  end

  def test_engine_home_page_uses_flatpack_components
    view_path = File.expand_path("../app/views/gem_template/home/index.html.erb", __dir__)
    view_source = File.read(view_path)

    assert_includes view_source, "FlatPack::PageTitle::Component"
    assert_includes view_source, "FlatPack::Card::Component"
    assert_includes view_source, "FlatPack::Button::Component"
    assert_includes view_source, "FlatPack::Badge::Component"
  end
end
