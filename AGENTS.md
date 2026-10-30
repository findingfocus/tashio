# Tashio Project Rules
- **Language:** This is a **Lua / Love2D** project. search for `.lua` files.
- **File Search:** Search for `.lua` files using `glob` with `"**/*.lua"` or use `grep`.
- **Target File:** Primary pathfinding / map logic lives in `.lua` files under `./`.
- **File Access Rules:** Always use relative paths starting from the current directory (e.g., `./src/Entity.lua` or `src/Entity.lua`).
- **No Mock Paths:** Do NOT use `/home/user/workspace/` or `/home/user/code/`. Those paths do not exist.
# Execution Rules for Local LLM
- **No Planning Loops:** Do not output `THOUGHT:` blocks, fake bash executions, or hypothetical user dialogue.
- **Direct File Operations:** Use `read`, `grep`, `glob`, `edit`, and `write` directly on relative paths (`./src/Entity.lua`).
- **No Sub-Agents:** Do not attempt to invoke `explore`, `task`, or external agent runners.
- **Action over Conversation:** When asked to edit a file, read the target file first, then apply the `edit` tool immediately.
