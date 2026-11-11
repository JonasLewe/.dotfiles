# GitLab CI schema

`gitlab-ci.json` is a local copy of GitLab's [official CI schema](https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json), downloaded on 2026-10-16.

The only modification is `definitions.tags.minItems`: `1` → `0`. GitLab accepts
`tags: []` to clear inherited runner tags, but the upstream schema rejects it
([GitLab issue #551088](https://gitlab.com/gitlab-org/gitlab/-/issues/551088)).

`lua/jlewe/plugins/lsp.lua` assigns this schema through `yaml.schemas`, which
takes priority over SchemaStore. Other schema checks remain enabled. A
`# yaml-language-server: $schema=...` modeline in a CI file has higher priority;
remove it to use this configured schema.

To update, download the upstream schema and reapply the single `minItems` change
if still needed. Once upstream accepts empty tags, the local copy and explicit
schema mapping can be removed. Restart Neovim after changing the schema.
