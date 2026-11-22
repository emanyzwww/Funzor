<script setup lang="ts">
export interface PanelEntry {
  key: string;
  title: string;
}

const props = defineProps<{
  title: string;
  entries: PanelEntry[];
  currentKey: string;
}>();

const emit = defineEmits<{
  (e: "select", key: string): void;
}>();

function onKeydown(event: KeyboardEvent, index: number): void {
  const count = props.entries.length;
  if (event.key === "ArrowDown" || event.key === "ArrowUp") {
    event.preventDefault();
    const delta = event.key === "ArrowDown" ? 1 : -1;
    const next = (index + delta + count) % count;
    (event.currentTarget as HTMLElement).parentElement
      ?.querySelectorAll<HTMLElement>(".panel-item")
      [next]?.focus();
    return;
  }
  if (event.key === "Enter" || event.key === " ") {
    event.preventDefault();
    emit("select", props.entries[index].key);
  }
}
</script>

<template>
  <div class="panel">
    <div class="panel-header">
      <span class="panel-title">{{ title }}</span>
    </div>
    <ul
      class="panel-list"
      role="listbox"
      aria-orientation="vertical"
    >
      <li
        v-for="(entry, index) in entries"
        :key="entry.key"
        class="panel-item"
        :class="{ selected: entry.key === currentKey }"
        role="option"
        :aria-selected="entry.key === currentKey"
        :tabindex="entry.key === currentKey ? 0 : -1"
        @click="emit('select', entry.key)"
        @keydown="onKeydown($event, index)"
      >
        <span class="layer selected-layer" />
        <span class="layer hover-layer" />
        <span class="layer pressed-layer" />
        <span class="item-text">{{ entry.title }}</span>
      </li>
    </ul>
  </div>
</template>

<style scoped lang="scss">
/* 240 宽, 标题行 56, 条目最小高 36 圆角 6, 右侧 1px 分隔 */
.panel {
  grid-row: 2;
  grid-column: 2;
  display: flex;
  flex-direction: column;
  background-color: var(--bg-panel);
  border-right: 1px solid var(--border-default);
  overflow: hidden;
}

.panel-header {
  flex: none;
  height: 56px;
  display: flex;
  align-items: center;
}

.panel-title {
  margin-left: 16px;
  font-size: var(--font-size-14);
  line-height: var(--line-height-20);
  font-weight: 600;
  color: var(--text-primary);
}

.panel-list {
  flex: 1;
  padding: 4px 0 8px;
  overflow-y: auto;
  overflow-x: hidden;
}

.panel-item {
  position: relative;
  display: flex;
  align-items: center;
  min-height: 36px;
  margin: 1px 8px;
  padding: 0 12px;
  border-radius: var(--radius-6);
  color: var(--text-secondary);
  background-color: transparent;

  &:focus {
    outline: none;
    box-shadow:
      inset 0 0 0 3px var(--focus-ring),
      inset 0 0 0 1px var(--bg-panel);
  }

  &:hover {
    color: var(--text-primary);
  }

  &.selected,
  &.selected:hover {
    color: var(--text-primary);
  }
}

.layer {
  position: absolute;
  inset: 0;
  border-radius: var(--radius-6);
  opacity: 0;
  transition: opacity var(--duration-150) linear;
  pointer-events: none;
}

.hover-layer {
  background-color: var(--panel-item-hover);
}
.panel-item:hover .hover-layer {
  opacity: 1;
}
.pressed-layer {
  background-color: var(--panel-item-pressed);
}
.panel-item:active .pressed-layer {
  opacity: 1;
}
.selected-layer {
  background-color: var(--bg-panel-item-selected);
}
.panel-item.selected .selected-layer {
  opacity: 1;
}

.item-text {
  position: relative;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
