/// Apply a function to the following content until next heading or `#till-next`.
///
/// = Usage
///
/// == Input
///
/// ```
/// #show: mark-till-next
///
/// A
///
/// #till-next(wrapper)
///
/// B
///
/// C
///
/// = Heading
///
/// D
/// ```
///
/// == Equivalent output
///
/// ```
/// A
///
/// #wrapper[
///   B
///
///   C
/// ]
///
/// = Heading
///
/// D
/// ```
///
/// = Known behaviours
///
// - `#till-next` should be put at the same level of `#show: mark-till-next`, or it will be ignored.
// - If you put two `#till-next` consecutively, then the former `#till-next` will receive a space `[ ]`, not `none`.
#let till-next(fn) = metadata((till-next: fn))

/// A show rule that makes `#till-next(fn)` effective.
///
/// Usage: `#show: mark-till-next`
#let mark-till-next(body) = {
  // The wrapper function
  let fn = none
  // The fenced elements to be wrapped
  let fenced = ()

  for it in body.children {
    let is-the-metadata = it.func() == metadata and it.value.keys().contains("till-next")
    let is-heading = it.func() == heading

    if is-the-metadata or is-heading {
      if fn != none {
        // Complete the last fence
        fn(fenced.join())
        fn = none
        fenced = ()
      }
      if is-the-metadata {
        // Start a new fence
        fn = it.value.till-next
      } else {
        it
      }
    } else if fn != none {
      // Continue the fence
      fenced.push(it)
    } else {
      it // if not in any fence
    }
  }

  // Complete the last fence
  if fn != none {
    fn(fenced.join())
  }
}
