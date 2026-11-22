<script setup lang="ts">
import { getCurrentWindow } from "@tauri-apps/api/window";

import IconClose from "@/components/ui/icons/IconClose.vue";
import IconMinimize from "@/components/ui/icons/IconMinimize.vue";

function minimize(): void {
  void getCurrentWindow().minimize();
}

function close(): void {
  void getCurrentWindow().close();
}
</script>

<template>
  <div
    class="title-bar"
    data-tauri-drag-region
  >
    <span
      class="title"
      data-tauri-drag-region
      >Funzor</span
    >
    <div class="buttons">
      <button
        class="tb-btn"
        :aria-label="$t('TitleBar.Minimize')"
        @click="minimize"
      >
        <IconMinimize class="tb-icon" />
      </button>
      <button
        class="tb-btn"
        :aria-label="$t('TitleBar.Close')"
        @click="close"
      >
        <IconClose class="tb-icon" />
      </button>
    </div>
    <div class="separator" />
  </div>
</template>

<style scoped lang="scss">
/* 覆盖二级菜单与内容区, 48 高; 按钮 32×32 圆角 6, 间距 8, 右边距 12 */
.title-bar {
  grid-row: 1;
  grid-column: 2 / 4;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: var(--bg-titlebar);
}

.title {
  margin-left: 16px;
  font-size: var(--font-size-14);
  line-height: var(--line-height-20);
  font-weight: 600;
  color: var(--text-primary);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.buttons {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-right: 12px;
}

.tb-btn {
  width: 32px;
  height: 32px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  border-radius: var(--radius-6);
  color: var(--text-secondary);

  &:hover {
    background-color: var(--state-hover);
  }
  &:active {
    background-color: var(--state-pressed);
  }
}

.tb-icon {
  width: 20px;
  height: 20px;
}

.separator {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 1px;
  background-color: var(--border-default);
  pointer-events: none;
}
</style>
