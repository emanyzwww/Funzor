<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute } from "vue-router";

import AppDialog from "@/components/ui/AppDialog.vue";
import {
  compareVersions,
  downloadAndRunInstaller,
  getCurrentVersion,
  getUpdateInfo,
} from "@/services/update";

const { t } = useI18n();
const route = useRoute();

// 页面标题来自路由 meta (对应原 OnNavigatedTo 里 e.Parameter 作为标题).
const title = computed(() => String(route.meta.title ?? ""));

const checking = ref(false);
const progress = ref(0);
const dialog = reactive({
  open: false,
  title: "",
  mode: "message" as "message" | "progress",
  message: "",
});

function showDialog(title: string, message: string): void {
  dialog.open = true;
  dialog.title = title;
  dialog.mode = "message";
  dialog.message = message;
}

async function onCheckUpdate(): Promise<void> {
  checking.value = true;
  try {
    const [latest, current] = await Promise.all([getUpdateInfo(), getCurrentVersion()]);
    if (compareVersions(latest.version, current) <= 0) {
      showDialog(t("NoUpdateTitle"), t("NoUpdateMessage"));
      return;
    }

    progress.value = 0;
    dialog.open = true;
    dialog.title = t("NoUpdateTitle");
    dialog.mode = "progress";
    try {
      await downloadAndRunInstaller(latest, (fraction) => {
        progress.value = fraction;
      });
    } finally {
      dialog.open = false;
    }
  } catch (error) {
    showDialog(t("NoUpdateTitle"), `更新失败: ${String(error)}`);
  } finally {
    checking.value = false;
  }
}
</script>

<template>
  <div class="page">
    <div class="page-stack">
      <h1 class="text-page-title">{{ title }}</h1>
      <p class="text-page-description">占位页面: 页面内容稍后在这里实现.</p>
      <button
        class="btn btn-primary"
        :disabled="checking"
        @click="onCheckUpdate"
      >
        {{ t("UpdateCheckButton.Content") }}
      </button>
    </div>
  </div>

  <AppDialog
    :open="dialog.open"
    :title="dialog.title"
    :show-actions="dialog.mode === 'message'"
    @close="dialog.open = false"
  >
    <template v-if="dialog.mode === 'message'">{{ dialog.message }}</template>
    <div
      v-else
      class="progress-track"
    >
      <div
        class="progress-fill"
        :style="{ width: `${Math.round(progress * 100)}%` }"
      />
    </div>
  </AppDialog>
</template>

<style scoped lang="scss">
/* 内边距 32, 纵向间距 16, 左对齐 */
.page {
  height: 100%;
  padding: 32px;
  overflow: hidden auto;
}

.page-stack {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 16px;
}

/* 进度条: 高 4, 胶囊 */
.progress-track {
  height: 4px;
  border-radius: 9999px;
  background-color: var(--track-bg);
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  border-radius: 9999px;
  background-color: var(--accent-bg);
  transition: width var(--duration-150) linear;
}
</style>
