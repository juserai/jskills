# Skill Lint 规则详情

规则分两层：Core（S01-S08）始终执行，Extended（S09-S16）需 `.skill-lint.json` 配置驱动。

## Core 结构检查规则（始终执行）

### S01: plugin.json 存在性

- **检查**: 根目录 `plugin.json` 和 `.claude-plugin/plugin.json` 是否都存在
- **级别**: error
- **说明**: 两个 plugin.json 是 Claude Code plugin 的基础元数据，缺失则无法发布

### S02: marketplace.json 存在性

- **检查**: `.claude-plugin/marketplace.json` 是否存在
- **级别**: error
- **说明**: marketplace.json 是 plugin 在 marketplace 中的入口文件

### S03: SKILL.md 存在性

- **检查**: `skills/` 下每个子目录是否包含 `SKILL.md`
- **级别**: error
- **说明**: SKILL.md 是 skill 的核心定义文件，缺失则 skill 无法被加载

### S04: Frontmatter 必填字段

- **检查**: 每个 SKILL.md 的 YAML frontmatter 中必须包含 `name` 和 `description`
- **级别**: error
- **说明**: name 用于 skill 路由，description 用于 marketplace 展示和触发匹配

### S05: Commands 对应（可选，仅在项目使用 commands routing 时检查）

- **检查**: 每个 `skills/<name>/` 是否有对应的 `skills/<name>/commands/<name>.md`
- **级别**: warning
- **说明**: 没有 command 入口的 skill 无法通过 `/name` 直接调用，但可作为被引用 skill。许多项目不使用 commands 目录，此规则跳过
- **脚本实现**: 未实现（AI 语义检查时按需判断）

### S05b: Per-skill plugin.json（可选）

- **检查**: 每个 `skills/<name>/` 是否有自己的 `plugin.json`
- **级别**: warning
- **说明**: 没有 plugin.json 的 skill 在 plugin 列表中会显示集合名而非 skill 名
- **脚本实现**: 未实现（AI 语义检查时按需判断）

### S06: marketplace.json 条目

- **检查**: 每个 skill 是否在 `.claude-plugin/marketplace.json` 的 `plugins` 数组中有对应条目
- **级别**: warning
- **说明**: 未列入 marketplace 的 skill 不会在安装时被发现

### S07: References 引用检查

- **检查**: SKILL.md 中通过 `references/` 路径引用的文件是否实际存在于 `skills/<name>/references/` 目录下
- **级别**: error
- **说明**: 断链引用会导致 AI 尝试读取不存在的文件

### S08: Evals 目录

- **检查**: `evals/<name>/scenarios.md` 是否存在
- **级别**: warning
- **说明**: 没有评估场景的 skill 难以验证质量，但不阻断使用

## Extended 结构检查规则（需 `.skill-lint.json` 配置）

以下规则仅在目标目录下存在 `.skill-lint.json` 且包含对应配置字段时执行。无配置文件的项目不会触发这些检查。

### S09: 命名规范

- **检查**: skill 目录名是否匹配配置中 `naming-pattern` 正则表达式
- **级别**: warning
- **配置**: `"naming-pattern": "^[a-z]+-[a-z]+$"`
- **说明**: 命名规范因项目而异，通过正则自定义

### S10: Category 字段

- **检查**: SKILL.md frontmatter 中 `category` 值是否在配置的 `category-values` 列表中
- **级别**: error
- **配置**: `"category-values": ["hammer", "crucible", "anvil", "quench"]`
- **说明**: category 值由项目自行定义，脚本仅校验值是否在允许列表内

### S11: 触发测试脚本

- **检查**: `evals/<name>/run-trigger-test.sh` 是否存在
- **级别**: warning
- **配置**: `"require-trigger-test": true`
- **说明**: 触发测试用于验证 skill 的注册完整性

### S12: 使用手册

- **检查**: `docs/guide/<name>-guide.md` 是否存在
- **级别**: warning
- **配置**: `"require-guide": true`
- **说明**: 使用手册是用户了解 skill 的入口

### S13: 设计文档

- **检查**: `docs/plans/<name>-design.md` 是否存在
- **级别**: warning
- **配置**: `"require-design-doc": true`
- **说明**: 设计文档记录 skill 的定位、机制和决策理由

### S14: 平台适配

- **检查**: 配置中 `platforms` 数组指定的每个平台目录下，是否有对应的 `SKILL.md` 和 `references/*.md`
- **级别**: warning
- **配置**: `"platforms": ["openclaw"]`
- **说明**: 支持任意平台名称，不限于 OpenClaw

### S15: i18n README 覆盖

- **检查**: 配置中 `i18n-dir` 指定目录下的每个 `README.*.md` 是否包含该 skill 名称
- **级别**: warning
- **配置**: `"i18n-dir": "docs/i18n"`
- **说明**: i18n 目录路径可自定义

### S16: i18n 使用手册覆盖

- **检查**: 对于 `i18n-dir` 下发现的每个语言，`docs/guide/i18n/<name>-guide.<lang>.md` 是否存在
- **级别**: warning
- **配置**: `"require-i18n-guide": true`（同时需要 `i18n-dir` 配置）
- **说明**: 使用手册的多语言版本存放在 `docs/guide/i18n/` 下，文件名格式为 `<skill>-guide.<lang>.md`，语言列表从 i18n README 文件名自动推断

### S17: i18n guide 路径守卫

- **检查**: `docs/i18n/guide/` 目录是否存在且包含 .md 文件（常见误放位置）
- **级别**: error
- **配置**: `"require-i18n-guide": true`（复用 S16 配置）
- **说明**: i18n guide 的正确位置是 `docs/guide/i18n/`，而非 `docs/i18n/guide/`。此规则防止文件放错位置

## 语义检查规则（AI 执行）

### M01: Description 质量

- **检查**: SKILL.md frontmatter 中的 description 是否清晰描述了 skill 的用途和触发条件
- **级别**: warning
- **不通过**: description 只是重复 name、过于模糊（如 "A useful skill"）、或缺少触发场景描述
- **通过**: 能让读者一眼明白 skill 做什么、何时触发

### M02: Frontmatter 一致性

- **检查**:
  - `name` 字段值与 `skills/<name>/` 目录名是否一致
  - `description` 在 SKILL.md 和 marketplace.json 的对应条目间是否语义对齐（不要求完全相同，但不能矛盾）
- **级别**: warning

### M03: Command 路由逻辑（可选，仅在项目使用 commands routing 时检查）

- **检查**: `commands/<name>.md` 中是否正确引用了对应 skill 名称（如 "使用 Skill 工具加载 `<name>` skill"）
- **级别**: warning
- **说明**: 错误的路由会导致 `/name` 加载错误的 skill。许多项目不使用 commands 目录，此规则跳过

### M04: References 内容连贯性

- **检查**:
  - SKILL.md 引用的 references 文件内容是否与主文件的逻辑一致
  - references 目录下是否有未被 SKILL.md 引用的孤立文件
- **级别**: warning
- **说明**: 需要 AI 读取并理解文件内容，纯结构检查无法覆盖

### M05: Eval 场景覆盖度

- **检查**: `scenarios.md` 是否覆盖 skill 的核心功能路径
- **要求**: 至少 5 个场景，覆盖正常路径、边界情况、错误处理
- **级别**: warning
