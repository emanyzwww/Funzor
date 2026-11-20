# Funzor 文档

这里是 Funzor 的项目文档入口, 按主题分目录. 每个目录有自己的 README, 先介绍该主题, 再路由到具体文档.

## 章节

| 目录      | 内容                                     | 入口                         |
|-----------|------------------------------------------|------------------------------|
| `design/` | 设计体系: 令牌, 语义层, 组件, 校验与维护 | [设计体系](design/README.md) |

后续内容变多时, 再在 `docs/` 下拆出开发, 发布, 贡献等目录, 而不是把所有内容堆在同一个 README 里.

## 文档约定

- 中文内容, 半角英文标点; 代码, 键名, 类型名保留英文.
- 每篇文档头部写明适用范围, 事实来源, 维护方式和更新触发条件.

## 目录结构

```text
docs/
├─ README.md
└─ design/
   ├─ components.md
   ├─ foundations.md
   ├─ maintenance.md
   ├─ README.md
   └─ reference.md
   ├─ semantic-layer.md
   ├─ tokens.md
```

