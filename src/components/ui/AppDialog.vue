<script setup lang="ts">
withDefaults(
  defineProps<{
    open: boolean;
    title: string;
    showActions?: boolean;
  }>(),
  { showActions: true },
);

const emit = defineEmits<{
  (e: "close"): void;
}>();
</script>

<template>
  <Teleport to="body">
    <div
      v-if="open"
      class="dialog-scrim"
    >
      <div
        class="dialog"
        role="dialog"
        aria-modal="true"
        :aria-label="title"
      >
        <div class="dialog-title">{{ title }}</div>
        <div class="dialog-content"><slot /></div>
        <div
          v-if="showActions"
          class="dialog-actions"
        >
          <button
            class="btn btn-primary"
            @click="emit('close')"
          >
            确定
          </button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<style scoped lang="scss">
/* 遮罩 + 圆角 8 + 内边距 24, 标题 20/28 SemiBold, 底部按钮区带分隔线 */
.dialog-scrim {
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--scrim);
  z-index: 1000;
}

.dialog {
  min-width: 320px;
  max-width: 480px;
  padding: 24px;
  border: 1px solid var(--border-dialog);
  border-radius: var(--radius-8);
  background-color: var(--bg-dialog);
  color: var(--text-primary);
}

.dialog-title {
  font-size: var(--font-size-20);
  line-height: var(--line-height-28);
  font-weight: 600;
  color: var(--text-primary);
}

.dialog-content {
  margin-top: 12px;
  font-size: var(--font-size-14);
  line-height: var(--line-height-20);
  color: var(--text-secondary);
}

.dialog-actions {
  margin: 24px -24px -24px;
  padding: 16px 24px;
  border-top: 1px solid var(--dialog-separator);
  display: flex;
  justify-content: flex-end;
}
</style>
