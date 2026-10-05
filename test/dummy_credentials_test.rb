# frozen_string_literal: true

require "test_helper"
require "yaml"
require "active_support/encrypted_file"

class DummyCredentialsTest < Minitest::Test
  def test_encrypted_credentials_file_is_present
    path = dummy_credentials_path
    assert File.exist?(path), "Expected #{path} so new gems reuse the shared dummy credentials"
    assert File.size(path).positive?
  end

  def test_master_key_is_gitignored_and_untracked
    gitignore = File.read(File.expand_path("../.gitignore", __dir__))
    assert_includes gitignore, "test/dummy/config/master.key"

    tracked = Dir.chdir(File.expand_path("..", __dir__)) do
      `git ls-files -- test/dummy/config/master.key`.strip
    end
    assert_equal "", tracked, "test/dummy/config/master.key must not be committed"
  end

  def test_dummy_credentials_decrypt_when_master_key_is_available
    skip "Set RAILS_MASTER_KEY or test/dummy/config/master.key to the shared dummy key" unless master_key_available?

    content = ActiveSupport::EncryptedFile.new(
      content_path: dummy_credentials_path,
      key_path: dummy_master_key_path,
      env_key: "RAILS_MASTER_KEY",
      raise_if_missing_key: true
    ).read

    parsed = YAML.safe_load(content)
    assert parsed.key?("secret_key_base"), "dummy credentials must include secret_key_base"
    assert_operator parsed.fetch("secret_key_base").to_s.length, :>=, 64
  end

  private

  def dummy_credentials_path
    File.expand_path("../test/dummy/config/credentials.yml.enc", __dir__)
  end

  def dummy_master_key_path
    File.expand_path("../test/dummy/config/master.key", __dir__)
  end

  def master_key_available?
    ENV["RAILS_MASTER_KEY"].to_s.strip.present? || File.exist?(dummy_master_key_path)
  end
end
