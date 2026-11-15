# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "open3"
require "tmpdir"

class RenameTemplateDocsTest < Minitest::Test
  OLD_NAME = %w[gem template].join("_")
  NEW_NAME = "sample_addon"
  TEMPLATE_DOCS = File.join("docs", OLD_NAME)

  def test_rename_removes_template_docs
    Dir.mktmpdir("rename-gem") do |root|
      build_fixture(root)

      output, status = run_rename(root, NEW_NAME, stdin: "y\n")

      assert status.success?, output
      refute File.exist?(File.join(root, TEMPLATE_DOCS)), output
      refute File.exist?(moved_notes_path(root)), output
      assert File.exist?(File.join(root, "#{NEW_NAME}.gemspec")), output
      assert File.exist?(File.join(root, "lib", "#{NEW_NAME}.rb")), output
      assert_includes output, "Removed #{TEMPLATE_DOCS}"
      readme = File.read(File.join(root, "README.md"))
      assert_includes readme, "https://github.com/bowerbird-app/#{NEW_NAME}"
    end

    assert Dir.exist?(repo_template_docs), "template repository keeps #{TEMPLATE_DOCS}"
  end

  def test_dry_run_keeps_template_docs
    Dir.mktmpdir("rename-gem-dry") do |root|
      build_fixture(root)

      output, status = run_rename(root, NEW_NAME, "--dry-run")

      assert status.success?, output
      assert File.exist?(File.join(root, TEMPLATE_DOCS, notes_name)), output
      assert File.exist?(File.join(root, "#{OLD_NAME}.gemspec")), output
      assert_includes output, TEMPLATE_DOCS
      refute_includes output, "Removed #{TEMPLATE_DOCS}"
    end
  end

  def test_template_docs_use_core_hooks_and_base_service
    hooks = File.join(repo_template_docs, "HOOKS.md")
    services = File.join(repo_template_docs, "SERVICES.md")
    skip unless File.exist?(hooks) && File.exist?(services)

    old_pascal = OLD_NAME.split("_").map(&:capitalize).join
    hooks_body = File.read(hooks)
    services_body = File.read(services)

    refute_includes hooks_body, "#{old_pascal}::Hooks.run"
    assert_includes hooks_body, "RecordingStudio::Hooks"
    assert_includes hooks_body, "configuration.hooks.run"
    assert_includes services_body, "RecordingStudio::Services::BaseService"
    refute_includes services_body, "ExampleService.call"
    refute_includes services_body, "< BaseService"
  end

  private

  def repo_template_docs
    File.expand_path("../#{TEMPLATE_DOCS}", __dir__)
  end

  def notes_name
    "#{OLD_NAME}_notes.md"
  end

  def moved_notes_path(root)
    File.join(root, "docs", NEW_NAME, "#{NEW_NAME}_notes.md")
  end

  def build_fixture(root)
    FileUtils.mkdir_p(File.join(root, "bin"))
    FileUtils.mkdir_p(File.join(root, "lib"))
    FileUtils.mkdir_p(File.join(root, TEMPLATE_DOCS))
    FileUtils.cp(File.expand_path("../bin/rename_gem", __dir__), File.join(root, "bin", "rename_gem"))

    old_pascal = OLD_NAME.split("_").map(&:capitalize).join
    template_repo = ["RecordingStudio", OLD_NAME].join("_")
    homepage = "https://github.com/bowerbird-app/#{template_repo}"

    File.write(File.join(root, "#{OLD_NAME}.gemspec"), <<~GEMSPEC)
      Gem::Specification.new do |spec|
        spec.name = "#{OLD_NAME}"
        spec.summary = "template"
        spec.homepage = "#{homepage}"
      end
    GEMSPEC
    File.write(File.join(root, "lib", "#{OLD_NAME}.rb"), "module #{old_pascal}\nend\n")
    File.write(File.join(root, "README.md"), "# #{old_pascal}\n\n#{homepage}\n")
    File.write(File.join(root, TEMPLATE_DOCS, notes_name), "keep this out of the addon\n")
  end

  def run_rename(root, new_name, *, stdin: "")
    Open3.capture2e(
      "ruby",
      File.join(root, "bin", "rename_gem"),
      new_name,
      *,
      chdir: root,
      stdin_data: stdin
    )
  end
end
