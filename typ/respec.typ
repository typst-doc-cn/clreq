/// Loader of the table of contents (a ReSpec module)

/// The table of contents that will be created by this module
///
/// Usage: `#show outline: toc`
#let toc = html.nav(id: "toc")

/// The summary that will be created by this module
///
/// Usage: `#summary`
#let summary = html.ol(id: "summary")
