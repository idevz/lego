# Lego / [乐高][lego]

```bash
   ██▓    ▓█████   ▄████  ▒█████  
  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░ 
  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░ 
    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒  
      ░  ░   ░  ░      ░     ░ ░  
```

this is the lego version for runX, its soul is came from the summarize about [runX][runX],
[k8s-start][k8s-start], wtool(a inner tools set for weibo staffs).
It is designed to combine various system deployment and management functions like building blocks,
effectively reuse code, improve work efficiency and free hands.

## quick start

To be quick start with Lego, please view the [quick start docs](./qs.md)
sh -c "$(curl -sSL https://get.docker.com/)"


## Main functions and ideas

* Quickly set up the experimental environment, deploy PVM(Parallels Virtual Machines),
  and manage PVM via the PRLCTL tool.
* The modules are divided into built-in and third-party modules.
  The modules are organized in the same way,
  and the functions are provided by scripts in the `legoes` directory under each module
* By default, the project's common libraries and functions are loaded sequentially
  according to the configuration and sequence in the `lego/legoes/export` file
* There are two types of functions, command and module functions.
  Although they can theoretically be called directly,
  they are named differently and functionally positioned differently.
* Module function is the encapsulation of various scattered functions in each module.
  "Command::module-name::function-name", For example, "pvm::deploy::init_etc" means
  the function `init_etc` in the deploy module under the `pvm` command
  In principle, direct calls are avoided, but if they must be,
  the corresponding command is `o pvm deploy::init_etc`.
* Command function is the carrier of various command operation,
  which is the encapsulation and combination of "module function".
  Lego's idea is mainly reflected in this part. The name is called "command name",
  but it is important to note that command functions can only be defined in "helpers.sh" files
  for each module, File names must be "helpers.sh",
  such as the "start" function in `pvm/legoes/helpers.sh`, which corresponds
  to the command `o pvm start`
* With the exception of the global module in the lego directory,
  all the other functions use the command to backload the corresponding file,
  and it can also dock with the automatic completion
  (the automatic completion has not been implemented yet).

## TODO

* [auto completion][auto_completion]
* online installation
* add,remove modules

[lego]:https://github.com/idevz/lego/blob/master/README-zh.md
[auto_completion]:https://www.infoq.cn/article/bash-programmable-completion-tutorial
[runX]:https://github.com/idevz/runx
[k8s-start]:https://github.com/idevz/k8s-start
