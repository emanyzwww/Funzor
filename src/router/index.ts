import type { Component } from "vue";
import { createMemoryHistory, createRouter, type RouteRecordRaw } from "vue-router";

import IconSettings from "@/components/ui/icons/IconSettings.vue";
import { i18n } from "@/i18n";
import MainLayout from "@/layouts/MainLayout.vue";

declare module "vue-router" {
  interface RouteMeta {
    /** 导航与页面显示的标题 (已翻译) */
    title?: string;
    /** 一级导航分区图标 */
    icon?: Component;
  }
}

// 导航结构完全由路由配置表达: MainLayout 的 children 是分区, 分区的 children 是条目.
// 不再维护独立的导航目录模型 (原 WinUI 的 NavigationCatalog 是平台限制下的产物).
export const sectionRoutes: RouteRecordRaw[] = [
  {
    path: "settings",
    meta: { title: i18n.global.t("Nav.Settings"), icon: IconSettings },
    children: [
      {
        path: "update",
        name: "settings.update",
        component: () => import("@/views/pages/PlaceholderPage.vue"),
        meta: { title: i18n.global.t("Nav.Settings.Update") },
      },
    ],
  },
];

const routes: RouteRecordRaw[] = [
  {
    path: "/",
    component: MainLayout,
    redirect: "/settings/update",
    children: sectionRoutes,
  },
  { path: "/:pathMatch(.*)*", redirect: "/settings/update" },
];

// 桌面应用不暴露 URL, 用 memory history (对应原 Frame.Navigate + 清空返回栈的语义).
export const router = createRouter({
  history: createMemoryHistory(),
  routes,
});
