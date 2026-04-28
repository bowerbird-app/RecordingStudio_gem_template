// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom, lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load FlatPack controllers on first use.
// FlatPack identifiers are namespaced (e.g. flat-pack--sidebar-layout),
// so loading must start at "controllers" to avoid doubled path segments.
lazyLoadControllersFrom("controllers", application)
