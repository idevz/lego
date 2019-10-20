# 乐高 / lego

本项目是 runX 的乐高积木版，灵感来自对 runX、k8s-start、wtool（微博内部工具包） 几个项目的总结，旨在像搭积木一样来组合各种系统部署、管理功能，高效的代码复用、提高工作效率、解放双手。

## 主要功能及思想

* 快速搭建实验环境，部署 pvm，并通过 prlctl 工具来管理 pvm（目前只针对 Parallels）
* 分为内建和第三方两类模块，模块的组织方式相同，功能都由各模块下 `legoes` 目录下的脚本提供
* 默认会根据 `common/legoes/export` 文件中的配置及顺序载入项目的通用函数库及功能
* 其他模块的功能则通过命令反解的方式来加载，如 `o pvm deploy::echo` 命令将会加载 `pvm` 模块下的 `deploy.sh` 文件，从而可以运行当中的 `pvm::deploy::echo` 方法（注意方法名必须为 ”模块名::shell文件名::子功能名“ 组成），通过命令反推加载对应的文件，同时与自动补全对接（自动补全还未实现）

## TODO

* [自动补全][auto_completion]
* 在线安装
* 添加、删除模块

[auto_completion]:https://www.infoq.cn/article/bash-programmable-completion-tutorial
[runX]:https://github.com/idevz/runx
[k8s-start]:https://github.com/idevz/k8s-start
