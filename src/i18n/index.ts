import { createI18n } from "vue-i18n";

import { zhCN } from "@/i18n/zh-CN";

// vue-i18n 标准配置; 当前只有 zh-CN, 新增语言时往 messages 里挂对应对象即可.
export const i18n = createI18n({
  legacy: false,
  locale: "zh-CN",
  fallbackLocale: "zh-CN",
  messages: { "zh-CN": zhCN },
});
