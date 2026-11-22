<script setup lang="ts">
import { reactive } from "vue";
import type { Component } from "vue";

import Tooltip from "@/components/ui/Tooltip.vue";

export interface RailSection {
  key: string;
  title: string;
  icon?: Component;
}

const props = defineProps<{
  sections: RailSection[];
  currentKey: string;
}>();

const emit = defineEmits<{
  (e: "select", key: string): void;
}>();

const tip = reactive({ visible: false, text: "", x: 0, y: 0 });
let tipTimer: number | undefined;

function showTip(event: MouseEvent, text: string): void {
  const rect = (event.currentTarget as HTMLElement).getBoundingClientRect();
  tip.text = text;
  tip.x = rect.right + 8;
  tip.y = rect.top + rect.height / 2;
  tipTimer = window.setTimeout(() => {
    tip.visible = true;
  }, 1000);
}

function hideTip(): void {
  window.clearTimeout(tipTimer);
  tip.visible = false;
}

function select(key: string): void {
  emit("select", key);
}

function onKeydown(event: KeyboardEvent, index: number): void {
  const count = props.sections.length;
  if (event.key === "ArrowDown" || event.key === "ArrowUp") {
    event.preventDefault();
    const delta = event.key === "ArrowDown" ? 1 : -1;
    const next = (index + delta + count) % count;
    (event.currentTarget as HTMLElement).parentElement
      ?.querySelectorAll<HTMLElement>(".rail-item")
      [next]?.focus();
    return;
  }
  if (event.key === "Enter" || event.key === " ") {
    event.preventDefault();
    emit("select", props.sections[index].key);
  }
}
</script>

<template>
  <nav
    class="rail"
    aria-label="分区导航"
  >
    <ul
      class="rail-list"
      role="listbox"
      aria-orientation="vertical"
    >
      <li
        v-for="(section, index) in sections"
        :key="section.key"
        class="rail-item"
        :class="{ selected: section.key === currentKey }"
        role="option"
        :aria-selected="section.key === currentKey"
        :aria-label="section.title"
        :tabindex="section.key === currentKey ? 0 : -1"
        @click="select(section.key)"
        @keydown="onKeydown($event, index)"
        @mouseenter="showTip($event, section.title)"
        @mouseleave="hideTip"
      >
        <span class="layer selected-layer" />
        <span class="layer hover-layer" />
        <span class="layer pressed-layer" />
        <component
          :is="section.icon"
          class="rail-icon"
        />
      </li>
    </ul>
    <Tooltip
      :visible="tip.visible"
      :text="tip.text"
      :x="tip.x"
      :y="tip.y"
    />
  </nav>
</template>

<style scoped lang="scss">
/* 56 宽通高, 条目 40×40 Margin 8,2 圆角 8, 图标 20 */
.rail {
  grid-row: 1 / 3;
  grid-column: 1;
  background-color: var(--bg-nav);
  overflow: hidden;
}

.rail-list {
  height: 100%;
  padding: 8px 0;
  overflow-y: auto;
  overflow-x: hidden;

  &::-webkit-scrollbar-thumb {
    background-color: var(--scroll-thumb-nav);
  }
  &::-webkit-scrollbar-thumb:hover {
    background-color: var(--scroll-thumb-nav-hover);
  }
  &::-webkit-scrollbar-thumb:active {
    background-color: var(--scroll-thumb-nav-pressed);
  }
}

.rail-item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  margin: 2px 8px;
  border-radius: var(--radius-8);
  color: var(--text-nav);
  background-color: transparent;

  &:focus {
    outline: none;
    box-shadow:
      inset 0 0 0 3px var(--focus-ring-nav),
      inset 0 0 0 1px var(--bg-nav);
  }

  &:hover {
    color: var(--text-nav-hover);
  }

  &.selected,
  &.selected:hover {
    color: var(--text-nav-selected);
  }
}

.layer {
  position: absolute;
  inset: 0;
  border-radius: var(--radius-8);
  opacity: 0;
  transition: opacity var(--duration-150) linear;
  pointer-events: none;
}

.hover-layer {
  background-color: var(--nav-item-hover);
}
.rail-item:hover .hover-layer {
  opacity: 1;
}
.pressed-layer {
  background-color: var(--nav-item-pressed);
}
.rail-item:active .pressed-layer {
  opacity: 1;
}
.selected-layer {
  background-color: var(--nav-item-selected);
}
.rail-item.selected .selected-layer {
  opacity: 1;
}

.rail-icon {
  width: 20px;
  height: 20px;
}
</style>
