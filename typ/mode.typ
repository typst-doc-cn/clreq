/// The mode of compilation.
///
/// - pre: External cache is not ready yet, and typst code should skip these files or create alternatives. `typst query` typically sets `pre`.
/// - build: External cache is ready, and typst code could use cached files. `typst compile` typically sets `build`.
/// - dev: The project is running in watch mode. External cache is ready or will be ready soon, and typst code should could cached files or delegate to the vite dev server. `typst watch` typically sets `dev`.
///
/// -> str
#let mode = sys.inputs.at("mode", default: "build")
#assert(("pre", "build", "dev").contains(mode))

#let cache-ready = ("build", "dev").contains(mode)

/// Path to the external cache root.
#let cache-dir = "/public/generated/"
