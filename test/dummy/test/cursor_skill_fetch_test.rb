# frozen_string_literal: true

require "test_helper"

class CursorSkillFetchTest < ActiveSupport::TestCase
  test "fetch-skills extras come from the plugin catalog without hardcoded extra URLs" do
    root = GemTemplate::Engine.root
    script = File.read(root.join(".cursor/fetch-skills.sh"))
    install = File.read(root.join(".cursor/install.sh"))

    assert_includes install, "fetch-skills.sh"
    assert_includes script, "skill-sources.json"
    refute_includes script, "cursor/plugins"
    refute_includes script, "poteto-mode"
    refute_includes script, "pstack"
  end

  test "gem version stays 0.2.1 and gemspec still excludes .cursor" do
    assert_equal "0.2.1", GemTemplate::VERSION

    spec = Gem::Specification.load(GemTemplate::Engine.root.join("gem_template.gemspec").to_s)
    cursor_files = spec.files.select { |path| path == ".cursor" || path.split("/").include?(".cursor") }

    assert_empty cursor_files
  end
end
