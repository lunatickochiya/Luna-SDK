# OpenWrt SDK Package Builder

工作流使用 OpenWrt `24.10.8` SDK，为五个目标平台构建 IPK 包。

## Workflow Inputs

| 输入 | 说明 |
| --- | --- |
| `packages` | 要按包名编译的 OpenWrt 包，逗号分隔。可留空。 |
| `config_pkg` | 预置包配置，逗号分隔。可选值包括 `aria2`、`curl`、`openssl`、`openvpn`、`smartdns`、`iptables`、`nftables`。 |
| `compile_dirs` | SDK 内要直接编译的包目录，逗号分隔。目录必须以 `package/` 或 `feeds/` 开头。 |
| `package_files` | 要发布的文件或 glob，逗号分隔。文件名不含 `/` 时会在 `bin/packages/` 下递归匹配；留空时打包 `bin/packages/` 下的全部文件。 |

`MACH` 与 `patch_repo` 已移除，因为工作流没有使用它们。

## Examples

按包名构建：

```text
packages: luci-app-passwall,luci-theme-argon,luci-app-argon-config
config_pkg: aria2,openvpn,openssl,curl
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
