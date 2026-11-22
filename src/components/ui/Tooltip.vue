<script setup lang="ts">
defineProps<{
  visible: boolean;
  text: string;
  x: number;
  y: number;
}>();
</script>

<template>
  <Teleport to="body">
    <div
      v-if="visible"
      class="tooltip"
      :style="{ left: `${x}px`, top: `${y}px` }"
    >
      {{ text }}
    </div>
  </Teleport>
</template>

<style scoped lang="scss">
/* 几何沿用 WinUI ToolTip (圆角 4, 内边距 5/10, 字号 12) */
.tooltip {
  position: fixed;
  transform: translateY(-50%);
  padding: 5px 10px;
  border: 1px solid var(--tooltip-border);
  border-radius: var(--radius-4);
  font-size: var(--font-size-12);
  line-height: var(--line-height-16);
  background-color: var(--tooltip-bg);
  color: var(--tooltip-fg);
  pointer-events: none;
  white-space: nowrap;
  z-index: 1000;
}
</style>
