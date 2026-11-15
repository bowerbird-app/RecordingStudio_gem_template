# Recording Studio kit pins

Copied addons start on Recording Studio 7.

- Gemspec: `add_dependency "recording_studio", ">= 7.0", "< 8.0"`
- Dummy GitHub tags: Recording Studio `v7.0.0`, Accessible `v0.44.1`, Trashable `v0.17.0`, Root Switchable `v0.16.0`, Metrics `v0.9.0`, Cache `v0.7.0`, FlatPack `v0.1.376`
- Root Gemfile pins Recording Studio `v7.0.0` and FlatPack `v0.1.376`. FlatPack is not on RubyGems, and core 7 depends on it.
- Authenticated dummy layout: `recording_studio_layout`, which resolves to Recording Studio's default layout (FlatPack page layout and top nav)
- Hooks and BaseService come from core. Do not copy them into a new addon.
- Recordable declarations remain required
- `root_recording_for` only finds a root. Create one with `create_root_recording!(recordable, actor:)`.
- Set `config.authorize_write`. Do not set `allow_unauthorized_writes`.
- Optional example mixin: `include RecordingStudio::Capabilities::Example.to(**opts)` wraps `RecordingStudio::Capabilities.include_for`. Installing the gem does not enable it globally.
