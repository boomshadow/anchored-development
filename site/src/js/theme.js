// Theme slider — light/dark toggle that remembers the visitor's choice.
//
// The initial theme is set by an inline <head> script: a saved choice
// (localStorage) wins, otherwise the OS preference is used. The choice is
// persisted so it survives reloads and navigation between pages. Until the
// visitor picks a theme, the page follows live OS preference changes.
(function () {
  const root = document.documentElement;
  const mq = window.matchMedia("(prefers-color-scheme: dark)");
  const toggle = document.querySelector(".theme-slider input");
  if (!toggle) return;

  const STORAGE_KEY = "theme";

  function save(value) {
    try {
      localStorage.setItem(STORAGE_KEY, value);
    } catch (e) {
      /* storage unavailable (e.g. private mode) — degrade to session-only */
    }
  }

  function saved() {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (e) {
      return null;
    }
  }

  function sync(isDark) {
    root.dataset.theme = isDark ? "dark" : "light";
    toggle.checked = isDark;
  }

  // Reflect whatever theme the inline head script already chose.
  sync(root.dataset.theme === "dark");

  // Persist the choice so it survives reloads and navigation.
  toggle.addEventListener("change", function () {
    save(toggle.checked ? "dark" : "light");
    sync(toggle.checked);
  });

  // With no saved choice, keep following live OS changes.
  mq.addEventListener("change", function (e) {
    if (!saved()) sync(e.matches);
  });
})();
