# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "tmpdir"
require "generators/gem_template/install/install_generator"

class InstallGeneratorTest < Minitest::Test
  def with_temp_app
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "app/assets/tailwind"))
      yield dir
    end
  end

  def build_generator(destination_root, options = {})
    GemTemplate::Generators::InstallGenerator.new([], options, destination_root: destination_root)
  end

  def test_mount_engine_uses_configured_mount_path
    generator = build_generator("/tmp", mount_path: "/addons/recording")
    routes = []

    generator.stub(:route, ->(value) { routes << value }) do
      generator.mount_engine
    end

    assert_equal ['mount GemTemplate::Engine, at: "/addons/recording"'], routes
  end

  def test_add_tailwind_source_injects_engine_and_flatpack_sources
    with_temp_app do |dir|
      css_path = File.join(dir, "app/assets/tailwind/application.css")
      File.write(css_path, "@import \"tailwindcss\";\n")

      generator = build_generator(dir)

      Rails.stub(:root, Pathname.new(dir)) do
        generator.stub(:say, nil) do
          generator.add_tailwind_source
        end
      end

      css = File.read(css_path)
      assert_includes css, '@source "../../vendor/bundle/**/gem_template/app/views/**/*.erb";'
      assert_includes css, '@source "../../../../../../usr/local/bundle/ruby/**/bundler/gems/gem_template-*/app/views/**/*.erb";'
      assert_includes css, '@source "../../vendor/bundle/**/flatpack/app/components/**/*.{rb,erb}";'
      assert_includes css, '@source "../../../../../../usr/local/bundle/ruby/**/bundler/gems/flatpack-*/app/components/**/*.{rb,erb}";'
    end
  end

  def test_add_tailwind_source_does_not_duplicate_existing_entries
    with_temp_app do |dir|
      css_path = File.join(dir, "app/assets/tailwind/application.css")
      File.write(css_path, <<~CSS)
        @import "tailwindcss";
        @source "../../vendor/bundle/**/gem_template/app/views/**/*.erb";
        @source "../../../../../../usr/local/bundle/ruby/**/bundler/gems/gem_template-*/app/views/**/*.erb";
        @source "../../vendor/bundle/**/flatpack/app/components/**/*.{rb,erb}";
        @source "../../../../../../usr/local/bundle/ruby/**/bundler/gems/flatpack-*/app/components/**/*.{rb,erb}";
      CSS

      generator = build_generator(dir)

      Rails.stub(:root, Pathname.new(dir)) do
        generator.stub(:say, nil) do
          generator.add_tailwind_source
        end
      end

      css = File.read(css_path)
      assert_equal 1, css.scan('@source "../../vendor/bundle/**/gem_template/app/views/**/*.erb";').size
      assert_equal 1, css.scan('@source "../../../../../../usr/local/bundle/ruby/**/bundler/gems/gem_template-*/app/views/**/*.erb";').size
      assert_equal 1, css.scan('@source "../../vendor/bundle/**/flatpack/app/components/**/*.{rb,erb}";').size
      assert_equal 1, css.scan('@source "../../../../../../usr/local/bundle/ruby/**/bundler/gems/flatpack-*/app/components/**/*.{rb,erb}";').size
    end
  end
end