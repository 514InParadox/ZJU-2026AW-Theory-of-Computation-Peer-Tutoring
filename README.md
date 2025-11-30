# 浙江大学 2025 年秋冬计算理论朋辈辅学资料

本 repo 包含浙江大学 2025 年秋冬计算理论朋辈辅学的教学资料。

## 构建

教学资料使用 [Typst](https://typst.app/) 编写，模板使用 [梦源宋体](https://github.com/Pal3love/dream-han-cjk) 作为主要字体。

各幻灯片源文件名均以 `.typ` 结尾，构建时确保已安装梦源宋体：

```shell
typst compile preview.typ output.pdf
```

以上命令从 `preview.typ` 构建 PDF 文件输出并写入至 `output.pdf`。

## 许可证

本文档仓库，除非另有说明，均采用 [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/) 许可。

本项目包含的第三方素材位于 `images/` 目录下，其许可证状态各不相同。请参阅 [`images/README.md`](images/README.md) 了解详细使用条款与归属要求。
