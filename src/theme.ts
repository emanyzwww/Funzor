const media = window.matchMedia("(prefers-color-scheme: dark)");

function apply(): void {
  document.documentElement.dataset.theme = media.matches ? "dark" : "light";
}

export function initTheme(): void {
  apply();
  media.addEventListener("change", apply);
}
