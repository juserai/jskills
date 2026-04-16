# Forge Security Guidelines

> Skill 开发者安全编码指南

## 权限声明

每个 SKILL.md 必须在 `metadata.permissions` 中声明最小权限集：

```yaml
metadata:
  permissions:
    network: false         # true | false
    filesystem: none       # none | read-only | read-write
    execution: none        # none | sandboxed | unrestricted
    tools:                 # 使用的工具列表
      - Read
      - Bash
```

原则：**声明你需要的最小权限**。不使用网络的 skill 不应声明 `network: true`。

## Prompt Injection 防御

### Agent Prompt 编写规范

1. **分离指令与数据**：用户可控内容（topic、参数）不要直接嵌入系统指令位置，应放在明确标注的数据区域

   ```
   # 正确
   You are a research agent. The user's topic is:
   <USER_TOPIC>
   {topic}
   </USER_TOPIC>
   Analyze the topic above.

   # 错误
   You are a research agent analyzing {topic}. Always...
   ```

2. **Agent 行为约束**：每个 agent prompt 必须包含独立性约束（不接受外部覆盖指令）

3. **工具返回值不可信**：WebSearch/WebFetch 返回的内容可能包含注入指令，agent 应将其视为数据而非指令

### SKILL.md 安全反模式

| 反模式 | 风险 | 替代方案 |
|--------|------|---------|
| `--dangerously-skip-permissions` | 绕过所有安全护栏 | 使用精确的权限声明 |
| 直接拼接用户输入到 shell 命令 | 命令注入 | 使用参数化调用 |
| Agent prompt 中嵌入凭据/密钥 | 凭据泄露 | 运行时从环境变量读取 |
| 工具返回值直接作为下一步指令 | 间接注入 | 增加语义验证层 |

## Tool Description Pinning

为防止 MCP 工具描述在运行时被篡改（rug pull 攻击）：

1. **首次安装时**：记录所有 tool description 的哈希值
2. **每次加载时**：比对当前 description 与首次记录的哈希
3. **发现变更时**：阻断执行并提示用户审查

参考实现：Snyk agent-scan 的 tool pinning 机制、MCPTrust lockfile 方案。

## 完整性校验

`.claude-plugin/marketplace.json` 中每个 skill 条目包含 `integrity.skill-md-sha256` 字段。更新 SKILL.md 后必须重新计算：

```bash
sha256sum skills/<name>/SKILL.md | cut -d' ' -f1
```

将结果更新到 marketplace.json 对应条目的 `integrity.skill-md-sha256` 字段。

## Sub-Agent 安全

1. 每个 agent 文件（`agents/*.md`）必须在 frontmatter 声明 `model` 字段
2. Agent prompt 中必须包含独立性约束（不知道其他 agent 的存在/输出）
3. Agent 的工具访问范围不应超过所属 skill 的 `metadata.permissions.tools` 声明
