# Migration Notes

## Current Requirements

- Ruby 3.3 or newer
- Rails 8.1 or newer
- Recording Studio 7 (`>= 7.0, < 8.0` in the gemspec; dummy GitHub tag `v7.0.0`)
- Accessible dummy tag `v0.44.1`, Trashable dummy tag `v0.17.0` (`require: false`), Root Switchable dummy tag `v0.16.0`, Metrics dummy tag `v0.9.0`, and Cache dummy tag `v0.7.0`
- FlatPack `v0.1.376` in the root Gemfile and the dummy Gemfile
- Public RubyGems and GitHub access for dependency installation

## Verification

Install both bundles and run the complete gem and dummy app test path:

```bash
bundle install
BUNDLE_GEMFILE=test/dummy/Gemfile bundle install
bundle exec rake test:all
```

Run the dummy app from its directory for browser verification:

```bash
cd test/dummy
bin/dev
```

Use the [FlatPack repository](https://github.com/bowerbird-app/flatpack) and the live FlatPack demo linked from the top-level README for current component documentation.
