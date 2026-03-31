# Skill Lint 规则详情

## 结构检查规则（Bash 脚本执行）

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

### S05: Commands 对应

- **检查**: 每个 `skills/<name>/` 是否有对应的 `skills/<name>/commands/<name>.md`（或 legacy `commands/<name>.md`）
- **级别**: warning
- **说明**: 没有 command 入口的 skill 无法通过 `/name` 直接调用，但可作为被引用 skill

### S05b: Per-skill plugin.json

- **检查**: 每个 `skills/<name>/` 是否有自己的 `plugin.json`
- **级别**: warning
- **说明**: 没有 plugin.json 的 skill 在 plugin 列表中会显示集合名而非 skill 名

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

### M03: Command 路由逻辑

- **检查**: `commands/<name>.md` 中是否正确引用了对应 skill 名称（如 "使用 Skill 工具加载 `<name>` skill"）
- **级别**: warning
- **说明**: 错误的路由会导致 `/name` 加载错误的 skill

### M04: References 内容连贯性

- **检查**:
  - SKILL.md 引用的 references 文件内容是否与主文件的逻辑一致
  - references 目录下是否有未被 SKILL.md 引用的孤立文件
- **级别**: warning

### M05: Eval 场景覆盖度

- **检查**: `scenarios.md` 是否覆盖 skill 的核心功能路径
- **要求**: 至少 5 个场景，覆盖正常路径、边界情况、错误处理
- **级别**: warning
