import { createApp } from "vue";

import App from "@/App.vue";
import { i18n } from "@/i18n";
import { router } from "@/router";
import { initTheme } from "@/theme";

import "@/styles/reset.scss";
import "@/styles/tokens.scss";
import "@/styles/themes/light.scss";
import "@/styles/themes/dark.scss";
import "@/styles/base.scss";
import "@/styles/typography.scss";
import "@/styles/buttons.scss";

initTheme();

createApp(App).use(router).use(i18n).mount("#app");
