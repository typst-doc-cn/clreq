// `base.override.css` should be put _after_ `base.css`.
// Reason: The former overrides the latter.
import "./base.css";
import "./base.override.css";

import { createLanguageSwitch } from "./language.js";
import { createStructure } from "./structure.js";
import sidebar from "./sidebar.js";

// The order of the following matters.
// Reason:
// - `createStructure` creates a new `#toc` and replaces the original one, discarding all former listeners.
// - `sidebar` add an event listener to `#toc`
createStructure({ maxTocLevel: 2 });
sidebar();

createLanguageSwitch();
