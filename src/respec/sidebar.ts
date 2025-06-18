/**
 * The following script is copied from W3C/ReSpec under CC0-1.0 license
 * https://github.com/speced/bikeshed/blob/527e9641607d686e5c439f9999d40360607ee792/bikeshed/spec-data/readonly/boilerplate/footer.include
 * https://www.w3.org/scripts/TR/2021/fixup.js
 */

// @ts-nocheck

export default function () {

var collapseSidebarText = '<span aria-hidden="true">←</span> '
                        + '<span>Collapse Sidebar</span>';
var expandSidebarText   = '<span aria-hidden="true">→</span> '
                        + '<span>Pop Out Sidebar</span>';
var tocJumpText         = '<span aria-hidden="true">↑</span> '
                        + '<span>Jump to Table of Contents</span>';

var sidebarMedia = window.matchMedia('screen and (min-width: 78em)');
var autoToggle   = function(e){ toggleSidebar(e.matches) };
if(sidebarMedia.addListener) {
  sidebarMedia.addListener(autoToggle);
}

function toggleSidebar(on) {
  if (on == undefined) {
    on = !document.body.classList.contains('toc-sidebar');
  }

  /* Don't scroll to compensate for the ToC if we're above it already. */
  var headY = 0;
  var head = document.querySelector('.head');
  if (head) {
    // terrible approx of "top of ToC"
    headY += head.offsetTop + head.offsetHeight;
  }
  var skipScroll = window.scrollY < headY;

  var toggle = document.getElementById('toc-toggle');
  var tocNav = document.getElementById('toc');
  if (on) {
    var tocHeight = tocNav.offsetHeight;
    document.body.classList.add('toc-sidebar');
    document.body.classList.remove('toc-inline');
    toggle.innerHTML = collapseSidebarText;
    if (!skipScroll) {
      window.scrollBy(0, 0 - tocHeight);
    }
    tocNav.focus();
    sidebarMedia.addListener(autoToggle); // auto-collapse when out of room
  }
  else {
    document.body.classList.add('toc-inline');
    document.body.classList.remove('toc-sidebar');
    toggle.innerHTML = expandSidebarText;
    if (!skipScroll) {
      window.scrollBy(0, tocNav.offsetHeight);
    }
    if (toggle.matches(':hover')) {
      /* Unfocus button when not using keyboard navigation,
          because I don't know where else to send the focus. */
      toggle.blur();
    }
  }
}

function createSidebarToggle() {
  /* Create the sidebar toggle in JS; it shouldn't exist when JS is off. */
  var toggle = document.createElement('a');
    /* This should probably be a button, but appearance isn't standards-track.*/
  toggle.id = 'toc-toggle';
  toggle.class = 'toc-toggle';
  toggle.href = '#toc';
  toggle.innerHTML = collapseSidebarText;

  sidebarMedia.addListener(autoToggle);
  var toggler = function(e) {
    e.preventDefault();
    sidebarMedia.removeListener(autoToggle); // persist explicit off states
    toggleSidebar();
    return false;
  }
  toggle.addEventListener('click', toggler, false);


  /* Get <nav id=toc-nav>, or make it if we don't have one. */
  var tocNav = document.getElementById('toc-nav');
  if (!tocNav) {
    tocNav = document.createElement('p');
    tocNav.id = 'toc-nav';
    /* Prepend for better keyboard navigation */
    document.body.insertBefore(tocNav, document.body.firstChild);
  }
  /* While we're at it, make sure we have a Jump to Toc link. */
  var tocJump = document.getElementById('toc-jump');
  if (!tocJump) {
    tocJump = document.createElement('a');
    tocJump.id = 'toc-jump';
    tocJump.href = '#toc';
    tocJump.innerHTML = tocJumpText;
    tocNav.appendChild(tocJump);
  }

  tocNav.appendChild(toggle);
}

var toc = document.getElementById('toc');
if (toc) {
  createSidebarToggle();
  toggleSidebar(sidebarMedia.matches);

  /* If the sidebar has been manually opened and is currently overlaying the text
      (window too small for the MQ to add the margin to body),
      then auto-close the sidebar once you click on something in there. */
  toc.addEventListener('click', function(e) {
    if(document.body.classList.contains('toc-sidebar') && !sidebarMedia.matches) {
      var el = e.target;
      while (el != toc) { // find closest <a>
        if (el.tagName.toLowerCase() == "a") {
          toggleSidebar(false);
          return;
        }
        el = el.parentElement;
      }
    }
  }, false);
}
else {
  console.warn("Can't find Table of Contents. Please use <nav id='toc'> around the ToC.");
}

/* Wrap tables in case they overflow */
var tables = document.querySelectorAll(':not(.overlarge) > table.data, :not(.overlarge) > table.index');
var numTables = tables.length;
for (var i = 0; i < numTables; i++) {
  var table = tables[i];
  var wrapper = document.createElement('div');
  wrapper.className = 'overlarge';
  table.parentNode.insertBefore(wrapper, table);
  wrapper.appendChild(table);
}

}
