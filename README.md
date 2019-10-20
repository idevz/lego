# lego / 乐高

this is the lego version for runX, its soul is came from the summarize about [runX][runX], [k8s-start][k8s-start], wtool(a inner tools set for weibo staffs). It is designed to combine various system deployment and management functions like building blocks, effectively reuse code, improve work efficiency and free hands.

## Main functions and ideas

* Quickly set up the experimental environment, deploy PVM, and manage PVM via the PRLCTL tool (currently Parallels only)
* The modules are divided into built-in and third-party modules. The modules are organized in the same way, and the functions are provided by scripts in the `legoes` directory under each module
* By default, the project's common libraries and functions are loaded sequentially according to the configuration and sequence in the `common/legoes/export` file
* The `o pvm deploy::echo` command will load the `deploy.sh` file under the `pvm` module so that the `pvm::deploy::echo` method can be run(note that the method name must be composed of "module_name::shell_file_name::subfunction_name"). The corresponding file can be backloaded by the command, and it can also dock with the automatic completion (the automatic completion has not been implemented yet).

## TODO

* [auto completion][auto_completion]
* online installation
* add,remove modules

[auto_completion]:https://www.infoq.cn/article/bash-programmable-completion-tutorial
[runX]:https://github.com/idevz/runx
[k8s-start]:https://github.com/idevz/k8s-start
