# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Pin FlatPack controllers
pin_all_from FlatPack::Engine.root.join("app/javascript/flat_pack/controllers"), under: "controllers/flat_pack", to: "flat_pack/controllers", preload: false
pin_all_from FlatPack::Engine.root.join("app/javascript/flat_pack/tiptap"), under: "flat_pack/tiptap", to: "flat_pack/tiptap", preload: false
pin "flat_pack/heroicons", to: "flat_pack/heroicons.js", preload: false

tiptap_version = "2.11.5"

# ── TipTap Rich Text Editor (built-in FlatPack support) ─────────────────
# Packages pinned from esm.sh at a consistent version.
# See docs/components/inputs.md for usage, preset details, and the
# framework-specific wrapper exclusion policy.
# Core
pin "@tiptap/core",        to: "https://esm.sh/@tiptap/core@#{tiptap_version}"
pin "@tiptap/starter-kit", to: "https://esm.sh/@tiptap/starter-kit@#{tiptap_version}"

# Menus
pin "@tiptap/extension-bubble-menu",   to: "https://esm.sh/@tiptap/extension-bubble-menu@#{tiptap_version}"
pin "@tiptap/extension-floating-menu", to: "https://esm.sh/@tiptap/extension-floating-menu@#{tiptap_version}"

# Minimal preset
pin "@tiptap/extension-placeholder",     to: "https://esm.sh/@tiptap/extension-placeholder@#{tiptap_version}"
pin "@tiptap/extension-character-count", to: "https://esm.sh/@tiptap/extension-character-count@#{tiptap_version}"
pin "@tiptap/extension-link",            to: "https://esm.sh/@tiptap/extension-link@#{tiptap_version}"
pin "@tiptap/extension-underline",       to: "https://esm.sh/@tiptap/extension-underline@#{tiptap_version}"
pin "@tiptap/extension-text-align",      to: "https://esm.sh/@tiptap/extension-text-align@#{tiptap_version}"

# Content preset
pin "@tiptap/extension-highlight",           to: "https://esm.sh/@tiptap/extension-highlight@#{tiptap_version}"
pin "@tiptap/extension-text-style",          to: "https://esm.sh/@tiptap/extension-text-style@#{tiptap_version}"
pin "@tiptap/extension-color",               to: "https://esm.sh/@tiptap/extension-color@#{tiptap_version}"
pin "@tiptap/extension-typography",          to: "https://esm.sh/@tiptap/extension-typography@#{tiptap_version}"
pin "@tiptap/extension-image",               to: "https://esm.sh/@tiptap/extension-image@#{tiptap_version}"
pin "@tiptap/extension-code-block-lowlight", to: "https://esm.sh/@tiptap/extension-code-block-lowlight@#{tiptap_version}"
pin "@tiptap/extension-task-list",           to: "https://esm.sh/@tiptap/extension-task-list@#{tiptap_version}"
pin "@tiptap/extension-task-item",           to: "https://esm.sh/@tiptap/extension-task-item@#{tiptap_version}"
pin "@tiptap/extension-table",               to: "https://esm.sh/@tiptap/extension-table@#{tiptap_version}"
pin "@tiptap/extension-table-row",           to: "https://esm.sh/@tiptap/extension-table-row@#{tiptap_version}"
pin "@tiptap/extension-table-cell",          to: "https://esm.sh/@tiptap/extension-table-cell@#{tiptap_version}"
pin "@tiptap/extension-table-header",        to: "https://esm.sh/@tiptap/extension-table-header@#{tiptap_version}"

# Full preset
pin "@tiptap/extension-subscript",            to: "https://esm.sh/@tiptap/extension-subscript@#{tiptap_version}"
pin "@tiptap/extension-superscript",          to: "https://esm.sh/@tiptap/extension-superscript@#{tiptap_version}"
pin "@tiptap/extension-font-family",          to: "https://esm.sh/@tiptap/extension-font-family@#{tiptap_version}"
pin "@tiptap/extension-mention",              to: "https://esm.sh/@tiptap/extension-mention@#{tiptap_version}"
pin "@tiptap/extension-youtube",              to: "https://esm.sh/@tiptap/extension-youtube@#{tiptap_version}"
pin "@tiptap/extension-audio",                to: "https://esm.sh/@tiptap/extension-audio@#{tiptap_version}"
pin "@tiptap/extension-details",              to: "https://esm.sh/@tiptap/extension-details@#{tiptap_version}"
pin "@tiptap/extension-details-content",      to: "https://esm.sh/@tiptap/extension-details-content@#{tiptap_version}"
pin "@tiptap/extension-details-summary",      to: "https://esm.sh/@tiptap/extension-details-summary@#{tiptap_version}"
pin "@tiptap/extension-trailing-node",        to: "https://esm.sh/@tiptap/extension-trailing-node@#{tiptap_version}"
pin "@tiptap/extension-unique-id",            to: "https://esm.sh/@tiptap/extension-unique-id@#{tiptap_version}"
pin "@tiptap/extension-focus",                to: "https://esm.sh/@tiptap/extension-focus@#{tiptap_version}"
pin "@tiptap/extension-list-keymap",          to: "https://esm.sh/@tiptap/extension-list-keymap@#{tiptap_version}"
pin "@tiptap/extension-collaboration",        to: "https://esm.sh/@tiptap/extension-collaboration@#{tiptap_version}"
pin "@tiptap/extension-collaboration-cursor", to: "https://esm.sh/@tiptap/extension-collaboration-cursor@#{tiptap_version}"
pin "@tiptap/extension-drag-handle",          to: "https://esm.sh/@tiptap/extension-drag-handle@#{tiptap_version}"
# Optional / may require TipTap Pro — loaded dynamically, gracefully skipped if absent
pin "@tiptap/extension-mathematics",          to: "https://esm.sh/@tiptap/extension-mathematics@#{tiptap_version}"
pin "@tiptap/extension-emoji",                to: "https://esm.sh/@tiptap/extension-emoji@#{tiptap_version}"
pin "@tiptap/extension-invisible-characters", to: "https://esm.sh/@tiptap/extension-invisible-characters@#{tiptap_version}"
pin "@tiptap/extension-table-of-contents",    to: "https://esm.sh/@tiptap/extension-table-of-contents@#{tiptap_version}"
