<script setup lang="ts">
import { computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import type { RouteRecordRaw } from "vue-router";

import NavigationRail from "@/components/shell/NavigationRail.vue";
import SectionPanel from "@/components/shell/SectionPanel.vue";
import TitleBar from "@/components/shell/TitleBar.vue";
import { sectionRoutes } from "@/router";

const route = useRoute();
const router = useRouter();

// 当前分区: 从路由匹配链中定位 section 层 (路由配置是导航的唯一事实来源).
const currentSection = computed(() => {
  const matchedPaths = route.matched.map((m) => m.path);
  return sectionRoutes.find((s) => matchedPaths.includes(`/${s.path}`)) ?? sectionRoutes[0];
});

const sections = computed(() =>
  sectionRoutes.map((s) => ({
    key: s.path,
    title: String(s.meta?.title ?? ""),
    icon: s.meta?.icon,
  })),
);

const entries = computed(() =>
  (currentSection.value.children ?? []).map((child: RouteRecordRaw) => ({
    key: String(child.name ?? child.path),
    title: String(child.meta?.title ?? ""),
  })),
);

const currentEntryKey = computed(() => String(route.name ?? ""));

// 一级切换默认选中该分区第一项 (与原应用行为一致); 同一分区重复点击不切换.
function selectSection(key: string): void {
  const section = sectionRoutes.find((s) => s.path === key);
  const first = section?.children?.[0];
  if (!section || section.path === currentSection.value.path || !first) return;
  if (first.name) void router.push({ name: first.name });
}

function selectEntry(key: string): void {
  if (currentEntryKey.value === key) return;
  const child = currentSection.value.children?.find((c) => String(c.name ?? c.path) === key);
  if (child?.name) void router.push({ name: child.name });
}
</script>

<template>
  <div class="main-layout">
    <NavigationRail
      :sections="sections"
      :current-key="currentSection.path"
      @select="selectSection"
    />
    <TitleBar />
    <SectionPanel
      :title="String(currentSection.meta?.title ?? '')"
      :entries="entries"
      :current-key="currentEntryKey"
      @select="selectEntry"
    />
    <main class="content">
      <RouterView v-slot="{ Component }">
        <KeepAlive>
          <component :is="Component" />
        </KeepAlive>
      </RouterView>
    </main>
  </div>
</template>

<style scoped lang="scss">
/* 三栏两行: 56 / 240 / 自适应, 48 / 自适应 */
.main-layout {
  display: grid;
  grid-template-columns: 56px 240px 1fr;
  grid-template-rows: 48px 1fr;
  height: 100%;
  background-color: var(--bg-canvas);
}

.content {
  grid-row: 2;
  grid-column: 3;
  background-color: var(--bg-desktop);
  overflow: hidden;
}
</style>
