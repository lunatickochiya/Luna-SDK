# OpenWrt SDK Package Builder

工作流使用 OpenWrt `24.10.8` SDK，为五个目标平台构建 IPK 包。

## Workflow Inputs

| 输入 | 说明 |
| --- | --- |
| `packages` | 要按包名编译的 OpenWrt 包，逗号分隔。可留空。 |
| `config_pkg` | 预置包配置，逗号分隔。可选值包括 `aria2`、`curl`、`openssl`、`openvpn`、`smartdns`、`iptables`、`nftables`。 |
| `custom_feeds` | 自定义 Git Feed，每行 `feed_name=https://repository.git[;branch]`。同名包优先于 `lunatic7`，但不覆盖标准 OpenWrt Feed；名称只能使用字母、数字和下划线。 |
| `compile_dirs` | SDK 内要直接编译的包目录，逗号分隔。目录必须以 `package/` 或 `feeds/` 开头。 |
| `package_files` | 要发布的文件或 glob，逗号分隔。文件名不含 `/` 时会在 `bin/packages/` 下递归匹配；留空时打包 `bin/packages/` 下的全部文件。 |

`MACH` 与 `patch_repo` 已移除，因为工作流没有使用它们。

## 缓存

工作流使用 GitHub Actions 缓存（`actions/cache@v4`）加速重复构建，共两层：

| 缓存 | Key | 内容 |
| --- | --- | --- |
| SDK tarball | `sdk-tar-<platform>-<sdk_ver>-v1` | 每个平台下载的 SDK 压缩包，命中后跳过 `wget` |
| dl | `dl-<packages/config 哈希>-v1`（带 `dl-` 前缀兜底） | `dl/` 下载的源码包，命中后 `make download` 只补齐缺失文件 |

要点：

- dl 缓存 key 基于 `packages`、`config_pkg`、`compile_dirs` 的哈希，并带 `dl-` 前缀的 `restore-keys`：即使输入变化，也会优先复用旧缓存再增量下载。
- 所有 `save` 步骤都带 `continue-on-error`，缓存写入失败（如超出配额）不会导致构建失败。
- SDK 压缩包缓存在同一平台（同一 SDK 版本）下永久复用；升级 SDK 版本时 key 会变化，自动重新下载。

## Examples

按包名构建：

```text
packages: luci-app-passwall,luci-theme-argon,luci-app-argon-config
config_pkg: aria2,openvpn,openssl,curl
```

使用自定义 Feed 覆盖 `lunatic7` 中的同名包：

```text
custom_feeds: myfeed=https://github.com/example/openwrt-packages.git;main
packages: luci-app-example
```

可配置多个 Feed，每行一个，越靠前优先级越高：

```text
custom_feeds: myfeed=https://github.com/example/openwrt-packages.git;main
anotherfeed=https://github.com/example/extra-packages.git;openwrt-24.10
```

直接构建指定目录，并仅发布匹配的 IPK：

```text
packages:
compile_dirs: package/feeds/luci/luci-app-argon-config,package/kochiya/package/kochiya/luci-app-example
package_files: luci-app-argon*.ipk,luci-app-example*.ipk
```

需要发布 SDK 中其他产物时，`package_files` 可使用完整相对路径，例如：

```text
package_files: bin/packages/**/*.ipk,bin/targets/**/*.bin
```
