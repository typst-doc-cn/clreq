// `base.override.css` should be put _after_ `base.css`.
// Reason: The former overrides the latter.
import "./base.css";
import "./base.override.css";

import "./language.css";
import { createLanguageSwitch } from "./language.ts";

import "./structure.css";
import { createStructure } from "./structure.ts";

import sidebar from "./sidebar.ts";

// The order of the following matters.
// Reason:
// - `createStructure` creates a new `#toc` and replaces the original one, discarding all former listeners.
// - `sidebar` add an event listener to `#toc`
createStructure({ maxTocLevel: 2 });
sidebar();

createLanguageSwitch();
