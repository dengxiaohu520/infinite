# uwsgi

### 概述

## 注：apt-get
```
当您使用apt-get在ubuntu上安装uwsgi时，它将自动安装为服务/etc/init.d/uwsgi
/etc/init.d中的文件将由sysvinit加载
那么你可以像这样管理你的uwsgi服务:
sudo /etc/init.d/uwsgi start|stop|restart|reload
或者
sudo service uwsgi start|stop|restart|reload
service命令可以找到由sysvinit管理的服务
```

## 注：pip
```
如果你通过pip安装uwsgi，那么你只能在/usr/local/bin / uwsgi中有可执行文件，你需要自己守护进程。
当您打开/etc/init.d/中的某些文件时，您可能会感到难过：
我只想注册一个uwsgi作为一个服务，为什么我需要写这么长的脚本
好消息是，在Upstart的帮助下，这是一个很简单的方法，这是sysvinit的替代方法。它使用/ etc / init /而不是/etc/init.d/。
只需创建一个包含以下内容的文件/etc/init/uwsgi.conf：
description "uWSGI Emperor"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
exec /usr/local/bin/uwsgi --emperor /etc/uwsgi/vassals/ --logto /var/log/uwsgi.log
然后，您可以像这样管理uwsgi进程：
sudo initctl start|stop|restart|reload| uwsgi
或者
sudo service uwsgi start|stop|restart|reload
可以看到，service命令很聪明，它可以使用同样的命令从sysvinit和Upstart中管理服务。
```

# 重点：
```
如果你有/etc/init.d/uwsgi和/etc/init/uwsgi.conf，当你说：
sudo service uwsgi restart
它将重新启动Upstart文件/etc/init/uwsgi.conf。
sysvinit将被忽略，或类似的东西。

uwsgi为您的网站配置
我建议大家使用pip和Upstart方式，这比apt-get方式好多了。
如果是这样，你正在使用uwsgi的皇帝模式，这是非常方便和强大的。
现在，您可以在/etc/uwsgi/vassals中创建一个ini文件，如下所示：
[uwsgi]
virtualenv=/path/to/venv/
chdir=/path/to/project/root
module=wsgi:application
env=DJANGO_SETTINGS_MODULE=settings
master=True
vacuum=True
socket=/tmp/%n.sock
pidfile=/tmp/%n.pid
daemonize=/var/log/uwsgi/%n.log

％n表示您的文件名。例如，我的项目名称是“readfree”，我创建一个readfree.ini文件。那么％n表示’readfree’。你不需要用真实的名字替换它。 uwsgi会为你做这个。
然后重新启动或重新加载uwsgi：
sudo service uwsgi restart
```


### 安装
```
1. 第一种
sudo apt-get install uwsgi
或
pip install uwsgi

2. 通过网络安装
curl http://uwsgi.it/install | bash -s default /tmp/uwsgi
这种方式会在/tmp/uwsgi路径下安装二进制版本，并且可以随意改变它。

3. 通过下载源并编译它
wget https://projects.unbit.it/downloads/uwsgi-latest.tar.gz 
tar zxvf uwsgi-latest.tar.gz 
cd uwsgi-latest
make
这种方式构建完成后，uwsgi二进制文件会存在于当前路径下

注：在使用发行版提供的软件包时，你可能需要考虑的一件事，你的发行版很可能以模块化方式构建了uWSGI（每个功能都是必须加载的不同插件）。所以，你必须先安装好--plugin python,http插件，用来保证文章中的例子能正常运行。
```


### 卸载


### uwsgi 有多种配置可用：
1. ini 
2. xml 
3. json
4. yaml


### 命令参数方式启动单独文件的测试
`uwsgi --http :9000 --wsgi-file helloworld.py --processes 4 --threads 2 --stats 127.0.0.1:9100`

### 命令参数方式启动项目文件的测试
`uwsgi --http :9000 --chdir /var/www/chf-project/chfweb --wsgi-file chfweb/wsgi.py --master --processes 4 --threads 2 --stats 127.0.0.1:9100`

`uwsgi --http :9000 --chdir /opt/project/chf-project/chfweb/ --module chfweb.wsgi --processes 4 --threads 2 --stats /opt/project/chf-project/chfweb/uwsgi/uwsgi.pid --daemonize /opt/project/chf-project/chfweb/uwsgi/uwsgi.log`

### 命令参数发嗯是启动项目文件关联nginx测试
`uwsgi --socket :9000 --chdir /opt/project/chf-project/chfweb/ --module chfweb.wsgi --processes 4 --threads 2 --stats /opt/project/chf-project/chfweb/uwsgi/uwsgi.pid --daemonize /opt/project/chf-project/chfweb/uwsgi/uwsgi.log`

### 安装，将命令打包成配置文件的启动
`uwsgi --ini chfweb_uwsgi.ini`

### 启动
`/etc/init.d/uwsgi start`
`uwsgi --ini chfweb_uwsgi.ini`

### 停止
`/etc/init.d/uwsgi stop`
`uwsgi --stop uwsgi/uwsgi.pid`
停止uwsgi服务后，用ps命令查看uwsgi的进程，已经不存在了

### 将命令打包成配置文件修改后的重载
`uwsgi --reload chfweb_uwsgi.ini`

`uwsgi --connect-and-read uwsgi/uwsgi.status`
这个命令返回一个json串，显示进程和worker的状态很详细



### 查看安装后的路径


### 检查状态


### 检查版本

### 部署一个简单的uwsgi应用实例
```
def application(env, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b'Hello World']
uWSGI Python loader会默认查找并加载此函数

部署到http的9090端口
开启uWSGI，运行HTTP server转发请求到你的WSGI应用
uwsgi --http :9090 --wsgi-file helloworld.py
注：如果当前目录不再foobar.py路径中，则需要将命令中文件的路径也加上
注：当你有一个前端Webserver，或者你正在做某种形式的基准测试时，不要使用--http，使用--http-socket

为你的WSGI应用添加并发（concurrency）与监控（monitoring）
默认情况下uWSGI只会开启一个进程和一个线程
你可以用--processes选项和--threads选项添加更多的进程和线程
uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2
以上命令将会产生一个主进程，4个工作进程，和http路由。主进程会控制4个工作进程结束时再重新生成新的进程。每个工作进程下有2个线程。

监测。stats子系统允许你导出uWSGI的内部统计信息，格式为json。
uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
我运行--stats选项成功后，用浏览器访问9191端口，返回的是拒绝访问。查看了原文档写的是：telnet to the port 9191，猜的可能是浏览器是http访问，而不是telnet
你也可以使用uwsgitop工具，来监控实例。uwsgitop可用pip安装。
注：应该绑定stats socket到私有地址，否则每个人都能获取到uwsgi的状态信息。
```

### 与web服务器，如nginx，协同使用（putting behind a full webserver）
虽然uWSGI的http router具有耐用，高性能的特点。但是你可能还是想要和功能齐全的webserver搭配使用。

uWSGI本身支持http，FastCGI，SCGI和uwsgi协议。性能最佳的是uwsgi协议，它已经可以支持nginx和Cherokee（Apache的各种模块的都可以用）

uwsgi --socket 127.0.0.1:3031 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
uwsgi --http-socket 127.0.0.1:3031 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
注：--http-socket和—http不同，--http是自己生成代理。

### 自动开启uWSGI

### 部署到django上
Django基本上是使用最多的web框架了。部署它相当简单。
### 假设我们的django项目在/home/foobar/myproject，执行
uwsgi --socket 127.0.0.1:3031 --chdir /home/foobar/myproject/ --wsgi-file myproject/wsgi.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
成功后，我们用浏览器访问http://公网IP /，则可以看到django页面的小火箭了。

### 从命令行选项到ini配置文件
上面这个命令是用--chdir选项来改变文件路径。在django中此选项为必填项，这样才能加载正确的模块。
但是上面的命令太长了，所以uWSGI支持各种风格的配置文件。这里使用.ini文件
```
[uwsgi]
socket = 127.0.0.1:3031
chdir = /home/foobar/myproject/
wsgi-file = myproject/wsgi.py
processes = 4
threads = 2
stats = 127.0.0.1:9191
```

然后，运行这个配置文件
`uwsgi yourfile.ini`

如果你的django版本<1.4，那么你的django项目目录下（/home/foobar/myproject/myproject/wsgi.py）是没有wsgi.py文件的。那么你需要执行如下命令
`uwsgi --socket 127.0.0.1:3031 --chdir /home/foobar/myproject/ --pythonpath .. --env DJANGO_SETTINGS_MODULE=myproject.settings --module "django.core.handlers.wsgi:WSGIHandler()" --processes 4 --threads 2 --stats 127.0.0.1:9191`

转变成ini文件为：
```
[uwsgi]
socket = 127.0.0.1:3031
chdir = /home/foobar/myproject/
pythonpath = ..
env = DJANGO_SETTINGS_MODULE=myproject.settings
module = django.core.handlers.wsgi:WSGIHandler()
processes = 4
threads = 2
stats = 127.0.0.1:9191
```
### 部署Flask
Flask是比较流行的python轻量级Web框架。
保存如下示例内容，myflaskapp.py
```
from flask import Flask
 
app = Flask(__name__)
 
@app.route('/')
def index():
    return "<span style='color:red'>I am app 1</span>"
```
Flask会导入它的WSGI函数（即，以application为函数名的函数）作为app。执行如下命令：
```
uwsgi --socket 127.0.0.1:3031 --wsgi-file myflaskapp.py --callable app --processes 4 --threads 2 --stats 127.0.0.1:9191
```

### 部署web2py
也是一个很流行的选择。解压web2py源文件，新建uWSGI配置文件，内容如下：
```
[uwsgi]
http = :9090
chdir = path_to_web2py
module = wsgihandler
master = true
processes = 8
```
注：当前最近的web2py版本，你可能需要复制wsgihandler.py脚本到handlers文件夹外。

该配置仍然使用的是http router。用浏览器访问9090端口，可以看到web2py的欢迎页面。

### 关于https请求
点击管理界面，你会发现不起作用，因为它需要https。因此，你需要安装OpenSSL开发头文件，然后再重新构建uWSGI，构建系统则将会自动探测到https请求了。

#### 步骤如下：:
首先，生成自己的密钥和证书
```
openssl genrsa -out foobar.key 2048
openssl req -new -key foobar.key -out foobar.csr
openssl x509 -req -days 365 -in foobar.csr -signkey foobar.key -out foobar.crt
```
然后，会有三个文件，foobar.csr, foobar.key and foobar.crt。修改uWSGI配置文件如下：
```
[uwsgi]
https = :9090,foobar.crt,foobar.key
chdir = path_to_web2py
module = wsgihandler
master = true
processes = 8
```
重新运行uWSGI，并使用https协议连接9090端口。

### 关于python线程的说明
如果你启动uWSI服务器时不使用线程，那么python GIL也不会启动，所以你的应用线程也不会运行。你可能不太喜欢这个设置，但是uWSGI是语言独立的服务器，所以它大多数的选择都会保持”不可知”。

但是对于开发人员来说，基本上所有的uWSGI配置都可以通过选项来设置。

如果你想要在不启动应用程序的多个线程的情况下维护Python线程支持，只需添加--enable-threads选项（或ini样式的enable-threads = true）。

### Virtualenvs
可以通过添加virtualenv = <path>选线来配置指定的运行环境

### 安全性和可用性（Security and availability）
为了避免用root用户身份运行uWSGI实例，你可以使用uid和gid选项来删除权限。配置如下：
```
[uwsgi]
https = :9090,foobar.crt,foobar.key
uid = foo
gid = bar
chdir = path_to_web2py
module = wsgihandler
master = true
processes = 8
```

如果需要绑定到特权端口（例如HTTPS用的443端口号），那么使用共享套接字shared-socket。它们是在删除权限之前创建的，可以使用= N语法引用，其中N是套接字号（从0开始）：
```
[uwsgi]
shared-socket = :443
https = =0,foobar.crt,foobar.key
uid = foo
gid = bar
chdir = path_to_web2py
module = wsgihandler
master = true
processes = 8
```

### 常见问题之“卡住请求”
Web应用程序部署的一个常见问题是“卡住请求”。 这时所有线程/工作线程都会被卡住（请求被阻止），应用不能接受更多请求。 为了避免这个问题，你可以设置harakiri计时器。 它是一个监视器（由主进程管理），它将摧毁超过指定秒数的进程。 示例如下，关闭超过30秒的进程：
```
[uwsgi]
shared-socket = :443
https = =0,foobar.crt,foobar.key
uid = foo
gid = bar
chdir = path_to_web2py
module = wsgihandler
master = true
processes = 8
harakiri = 30
```

除此之外，自uWSGI1.9版本之后，stats服务器会导出整个请求变量，所以你可以及时查看你的uWSGI实例在做什么。

### 卸载
uWSGI卸载子系统允许在某些特定模式匹配时尽快释放工作线程，并且可以委派给pure-c线程。 例如，从文件系统发送静态文件，将数据从网络传输到客户端等等。

卸载非常复杂，但它的使用对最终用户是透明的。 如果你想尝试卸载，可以添加--offload-threads <n>选项，其中<n>是要生成的线程数（每个CPU 1个是一个很好的值）。

当卸载线程被允许执行时，所有可以被优化的部分都会被自动检测到。

### 多个python版本共用相同的uWSGI服务器
正如我们所见，uWSGI由一个小内核和各种插件组成。插件能够在二进制中嵌入，或者动态的加载。当你为python构建uWSGI时，一系列的插件和python嵌入到二进制文件中。

那么，这会带来一个问题，如果你想很多版本python，但是又不想为每一个版本构建一个二进制文件，怎么办？

最好的方式是将语言独立（languang-independent）的各项配置构建成二进制文件，然后对每个版本的python制作成插件，当需要时再加载。

### 这里不太明白怎么才能构建python插件，不知道一下代码是在哪里配置还是执行
我们从同一个目录下开始构建python插件
```
PYTHON=python3.4 ./uwsgi --build-plugin "plugins/python python34"
PYTHON=python2.7 ./uwsgi --build-plugin "plugins/python python27"
PYTHON=python2.6 ./uwsgi --build-plugin "plugins/python python26"
```

你将会以python34_plugin.so, python27_plugin.so, python26_plugin.so，这三个文件结束。复制这三个文件到你的目标路径。（默认情况下，uWSGI会再当前工作目录下搜索插件）

现在，在你的配置文件中你可以在最顶上添加插件路径和插件指令了。
```
[uwsgi]
plugins-dir = <path_to_your_plugin_directory>
plugin = python26
```
然后它会从目录中加载python26_plugin.so插件库到你复制的插件中。


### 参数配置说明
```
Usage: /home/flack/.local/share/virtualenvs/chf-project-2dIFyAVw/bin/uwsgi [options...]
    -s|--socket                             bind to the specified UNIX/TCP socket using default protocol
    -s|--uwsgi-socket                       bind to the specified UNIX/TCP socket using uwsgi protocol
    --suwsgi-socket                         bind to the specified UNIX/TCP socket using uwsgi protocol over SSL
    --ssl-socket                            bind to the specified UNIX/TCP socket using uwsgi protocol over SSL
    --http-socket                           bind to the specified UNIX/TCP socket using HTTP protocol
    --http-socket-modifier1                 force the specified modifier1 when using HTTP protocol
    --http-socket-modifier2                 force the specified modifier2 when using HTTP protocol
    --http11-socket                         bind to the specified UNIX/TCP socket using HTTP 1.1 (Keep-Alive) protocol
    --https-socket                          bind to the specified UNIX/TCP socket using HTTPS protocol
    --https-socket-modifier1                force the specified modifier1 when using HTTPS protocol
    --https-socket-modifier2                force the specified modifier2 when using HTTPS protocol
    --fastcgi-socket                        bind to the specified UNIX/TCP socket using FastCGI protocol
    --fastcgi-nph-socket                    bind to the specified UNIX/TCP socket using FastCGI protocol (nph mode)
    --fastcgi-modifier1                     force the specified modifier1 when using FastCGI protocol
    --fastcgi-modifier2                     force the specified modifier2 when using FastCGI protocol
    --scgi-socket                           bind to the specified UNIX/TCP socket using SCGI protocol
    --scgi-nph-socket                       bind to the specified UNIX/TCP socket using SCGI protocol (nph mode)
    --scgi-modifier1                        force the specified modifier1 when using SCGI protocol
    --scgi-modifier2                        force the specified modifier2 when using SCGI protocol
    --raw-socket                            bind to the specified UNIX/TCP socket using RAW protocol
    --raw-modifier1                         force the specified modifier1 when using RAW protocol
    --raw-modifier2                         force the specified modifier2 when using RAW protocol
    --puwsgi-socket                         bind to the specified UNIX/TCP socket using persistent uwsgi protocol (puwsgi)
    --protocol                              force the specified protocol for default sockets
    --socket-protocol                       force the specified protocol for default sockets
    --shared-socket                         create a shared socket for advanced jailing or ipc
    --undeferred-shared-socket              create a shared socket for advanced jailing or ipc (undeferred mode)
    -p|--processes                          spawn the specified number of workers/processes
    -p|--workers                            spawn the specified number of workers/processes
    --thunder-lock                          serialize accept() usage (if possible)
    -t|--harakiri                           set harakiri timeout
    --harakiri-verbose                      enable verbose mode for harakiri
    --harakiri-no-arh                       do not enable harakiri during after-request-hook
    --no-harakiri-arh                       do not enable harakiri during after-request-hook
    --no-harakiri-after-req-hook            do not enable harakiri during after-request-hook
    --backtrace-depth                       set backtrace depth
    --mule-harakiri                         set harakiri timeout for mule tasks
    -x|--xmlconfig                          load config from xml file
    -x|--xml                                load config from xml file
    --config                                load configuration using the pluggable system
    --fallback-config                       re-exec uwsgi with the specified config when exit code is 1
    --strict                                enable strict mode (placeholder cannot be used)
    --skip-zero                             skip check of file descriptor 0
    --skip-atexit                           skip atexit hooks (ignored by the master)
    --skip-atexit-teardown                  skip atexit teardown (ignored by the master)
    -S|--set                                set a placeholder or an option
    --set-placeholder                       set a placeholder
    --set-ph                                set a placeholder
    --get                                   print the specified option value and exit
    --declare-option                        declare a new uWSGI custom option
    --declare-option2                       declare a new uWSGI custom option (non-immediate)
    --resolve                               place the result of a dns query in the specified placeholder, sytax: placeholder=name (immediate option)
    --for                                   (opt logic) for cycle
    --for-glob                              (opt logic) for cycle (expand glob)
    --for-times                             (opt logic) for cycle (expand the specified num to a list starting from 1)
    --for-readline                          (opt logic) for cycle (expand the specified file to a list of lines)
    --endfor                                (opt logic) end for cycle
    --end-for                               (opt logic) end for cycle
    --if-opt                                (opt logic) check for option
    --if-not-opt                            (opt logic) check for option
    --if-env                                (opt logic) check for environment variable
    --if-not-env                            (opt logic) check for environment variable
    --ifenv                                 (opt logic) check for environment variable
    --if-reload                             (opt logic) check for reload
    --if-not-reload                         (opt logic) check for reload
    --if-hostname                           (opt logic) check for hostname
    --if-not-hostname                       (opt logic) check for hostname
    --if-exists                             (opt logic) check for file/directory existence
    --if-not-exists                         (opt logic) check for file/directory existence
    --ifexists                              (opt logic) check for file/directory existence
    --if-plugin                             (opt logic) check for plugin
    --if-not-plugin                         (opt logic) check for plugin
    --ifplugin                              (opt logic) check for plugin
    --if-file                               (opt logic) check for file existance
    --if-not-file                           (opt logic) check for file existance
    --if-dir                                (opt logic) check for directory existance
    --if-not-dir                            (opt logic) check for directory existance
    --ifdir                                 (opt logic) check for directory existance
    --if-directory                          (opt logic) check for directory existance
    --endif                                 (opt logic) end if
    --end-if                                (opt logic) end if
    --blacklist                             set options blacklist context
    --end-blacklist                         clear options blacklist context
    --whitelist                             set options whitelist context
    --end-whitelist                         clear options whitelist context
    --ignore-sigpipe                        do not report (annoying) SIGPIPE
    --ignore-write-errors                   do not report (annoying) write()/writev() errors
    --write-errors-tolerance                set the maximum number of allowed write errors (default: no tolerance)
    --write-errors-exception-only           only raise an exception on write errors giving control to the app itself
    --disable-write-exception               disable exception generation on write()/writev()
    --inherit                               use the specified file as config template
    --include                               include the specified file as immediate configuration
    --inject-before                         inject a text file before the config file (advanced templating)
    --inject-after                          inject a text file after the config file (advanced templating)
    -d|--daemonize                          daemonize uWSGI
    --daemonize2                            daemonize uWSGI after app loading
    --stop                                  stop an instance
    --reload                                reload an instance
    --pause                                 pause an instance
    --suspend                               suspend an instance
    --resume                                resume an instance
    --connect-and-read                      connect to a socket and wait for data from it
    --extract                               fetch/dump any supported address to stdout
    -l|--listen                             set the socket listen queue size
    -v|--max-vars                           set the amount of internal iovec/vars structures
    --max-apps                              set the maximum number of per-worker applications
    -b|--buffer-size                        set internal buffer size
    -m|--memory-report                      enable memory report
    --profiler                              enable the specified profiler
    -c|--cgi-mode                           force CGI-mode for plugins supporting it
    -a|--abstract-socket                    force UNIX socket in abstract mode (Linux only)
    -C|--chmod-socket                       chmod-socket
    -C|--chmod                              chmod-socket
    --chown-socket                          chown unix sockets
    --umask                                 set umask
    --freebind                              put socket in freebind mode
    --map-socket                            map sockets to specific workers
    -T|--enable-threads                     enable threads
    --no-threads-wait                       do not wait for threads cancellation on quit/reload
    --auto-procname                         automatically set processes name to something meaningful
    --procname-prefix                       add a prefix to the process names
    --procname-prefix-spaced                add a spaced prefix to the process names
    --procname-append                       append a string to process names
    --procname                              set process names
    --procname-master                       set master process name
    -i|--single-interpreter                 do not use multiple interpreters (where available)
    --need-app                              exit if no app can be loaded
    -M|--master                             enable master process
    --honour-stdin                          do not remap stdin to /dev/null
    --emperor                               run the Emperor
    --emperor-proxy-socket                  force the vassal to became an Emperor proxy
    --emperor-wrapper                       set a binary wrapper for vassals
    --emperor-wrapper-override              set a binary wrapper for vassals to try before the default one
    --emperor-wrapper-fallback              set a binary wrapper for vassals to try as a last resort
    --emperor-nofollow                      do not follow symlinks when checking for mtime
    --emperor-procname                      set the Emperor process name
    --emperor-freq                          set the Emperor scan frequency (default 3 seconds)
    --emperor-required-heartbeat            set the Emperor tolerance about heartbeats
    --emperor-curse-tolerance               set the Emperor tolerance about cursed vassals
    --emperor-pidfile                       write the Emperor pid in the specified file
    --emperor-tyrant                        put the Emperor in Tyrant mode
    --emperor-tyrant-nofollow               do not follow symlinks when checking for uid/gid in Tyrant mode
    --emperor-stats                         run the Emperor stats server
    --emperor-stats-server                  run the Emperor stats server
    --early-emperor                         spawn the emperor as soon as possibile
    --emperor-broodlord                     run the emperor in BroodLord mode
    --emperor-throttle                      set throttling level (in milliseconds) for bad behaving vassals (default 1000)
    --emperor-max-throttle                  set max throttling level (in milliseconds) for bad behaving vassals (default 3 minutes)
    --emperor-magic-exec                    prefix vassals config files with exec:// if they have the executable bit
    --emperor-on-demand-extension           search for text file (vassal name + extension) containing the on demand socket name
    --emperor-on-demand-ext                 search for text file (vassal name + extension) containing the on demand socket name
    --emperor-on-demand-directory           enable on demand mode binding to the unix socket in the specified directory named like the vassal + .socket
    --emperor-on-demand-dir                 enable on demand mode binding to the unix socket in the specified directory named like the vassal + .socket
    --emperor-on-demand-exec                use the output of the specified command as on demand socket name (the vassal name is passed as the only argument)
    --emperor-extra-extension               allows the specified extension in the Emperor (vassal will be called with --config)
    --emperor-extra-ext                     allows the specified extension in the Emperor (vassal will be called with --config)
    --emperor-no-blacklist                  disable Emperor blacklisting subsystem
    --emperor-use-clone                     use clone() instead of fork() passing the specified unshare() flags
    --imperial-monitor-list                 list enabled imperial monitors
    --imperial-monitors-list                list enabled imperial monitors
    --vassals-inherit                       add config templates to vassals config (uses --inherit)
    --vassals-include                       include config templates to vassals config (uses --include instead of --inherit)
    --vassals-inherit-before                add config templates to vassals config (uses --inherit, parses before the vassal file)
    --vassals-include-before                include config templates to vassals config (uses --include instead of --inherit, parses before the vassal file)
    --vassals-start-hook                    run the specified command before each vassal starts
    --vassals-stop-hook                     run the specified command after vassal's death
    --vassal-sos                            ask emperor for reinforcement when overloaded
    --vassal-sos-backlog                    ask emperor for sos if backlog queue has more items than the value specified
    --vassals-set                           automatically set the specified option (via --set) for every vassal
    --vassal-set                            automatically set the specified option (via --set) for every vassal
    --heartbeat                             announce healthiness to the emperor
    --reload-mercy                          set the maximum time (in seconds) we wait for workers and other processes to die during reload/shutdown
    --worker-reload-mercy                   set the maximum time (in seconds) a worker can take to reload/shutdown (default is 60)
    --mule-reload-mercy                     set the maximum time (in seconds) a mule can take to reload/shutdown (default is 60)
    --exit-on-reload                        force exit even if a reload is requested
    --die-on-term                           exit instead of brutal reload on SIGTERM
    --force-gateway                         force the spawn of the first registered gateway without a master
    -h|--help                               show this help
    -h|--usage                              show this help
    --print-sym                             print content of the specified binary symbol
    --print-symbol                          print content of the specified binary symbol
    -r|--reaper                             call waitpid(-1,...) after each request to get rid of zombies
    -R|--max-requests                       reload workers after the specified amount of managed requests
    --min-worker-lifetime                   number of seconds worker must run before being reloaded (default is 60)
    --max-worker-lifetime                   reload workers after the specified amount of seconds (default is disabled)
    -z|--socket-timeout                     set internal sockets timeout
    --no-fd-passing                         disable file descriptor passing
    --locks                                 create the specified number of shared locks
    --lock-engine                           set the lock engine
    --ftok                                  set the ipcsem key via ftok() for avoiding duplicates
    --persistent-ipcsem                     do not remove ipcsem's on shutdown
    -A|--sharedarea                         create a raw shared memory area of specified pages (note: it supports keyval too)
    --safe-fd                               do not close the specified file descriptor
    --fd-safe                               do not close the specified file descriptor
    --cache                                 create a shared cache containing given elements
    --cache-blocksize                       set cache blocksize
    --cache-store                           enable persistent cache to disk
    --cache-store-sync                      set frequency of sync for persistent cache
    --cache-no-expire                       disable auto sweep of expired items
    --cache-expire-freq                     set the frequency of cache sweeper scans (default 3 seconds)
    --cache-report-freed-items              constantly report the cache item freed by the sweeper (use only for debug)
    --cache-udp-server                      bind the cache udp server (used only for set/update/delete) to the specified socket
    --cache-udp-node                        send cache update/deletion to the specified cache udp server
    --cache-sync                            copy the whole content of another uWSGI cache server on server startup
    --cache-use-last-modified               update last_modified_at timestamp on every cache item modification (default is disabled)
    --add-cache-item                        add an item in the cache
    --load-file-in-cache                    load a static file in the cache
    --load-file-in-cache-gzip               load a static file in the cache with gzip compression
    --cache2                                create a new generation shared cache (keyval syntax)
    --queue                                 enable shared queue
    --queue-blocksize                       set queue blocksize
    --queue-store                           enable persistent queue to disk
    --queue-store-sync                      set frequency of sync for persistent queue
    -Q|--spooler                            run a spooler on the specified directory
    --spooler-external                      map spoolers requests to a spooler directory managed by an external instance
    --spooler-ordered                       try to order the execution of spooler tasks
    --spooler-chdir                         chdir() to specified directory before each spooler task
    --spooler-processes                     set the number of processes for spoolers
    --spooler-quiet                         do not be verbose with spooler tasks
    --spooler-max-tasks                     set the maximum number of tasks to run before recycling a spooler
    --spooler-harakiri                      set harakiri timeout for spooler tasks
    --spooler-frequency                     set spooler frequency
    --spooler-freq                          set spooler frequency
    --mule                                  add a mule
    --mules                                 add the specified number of mules
    --farm                                  add a mule farm
    --mule-msg-size                         set mule message buffer size
    --signal                                send a uwsgi signal to a server
    --signal-bufsize                        set buffer size for signal queue
    --signals-bufsize                       set buffer size for signal queue
    --signal-timer                          add a timer (syntax: <signal> <seconds>)
    --timer                                 add a timer (syntax: <signal> <seconds>)
    --signal-rbtimer                        add a redblack timer (syntax: <signal> <seconds>)
    --rbtimer                               add a redblack timer (syntax: <signal> <seconds>)
    --rpc-max                               maximum number of rpc slots (default: 64)
    -L|--disable-logging                    disable request logging
    --flock                                 lock the specified file before starting, exit if locked
    --flock-wait                            lock the specified file before starting, wait if locked
    --flock2                                lock the specified file after logging/daemon setup, exit if locked
    --flock-wait2                           lock the specified file after logging/daemon setup, wait if locked
    --pidfile                               create pidfile (before privileges drop)
    --pidfile2                              create pidfile (after privileges drop)
    --safe-pidfile                          create safe pidfile (before privileges drop)
    --safe-pidfile2                         create safe pidfile (after privileges drop)
    --chroot                                chroot() to the specified directory
    --pivot-root                            pivot_root() to the specified directories (new_root and put_old must be separated with a space)
    --pivot_root                            pivot_root() to the specified directories (new_root and put_old must be separated with a space)
    --uid                                   setuid to the specified user/uid
    --gid                                   setgid to the specified group/gid
    --add-gid                               add the specified group id to the process credentials
    --immediate-uid                         setuid to the specified user/uid IMMEDIATELY
    --immediate-gid                         setgid to the specified group/gid IMMEDIATELY
    --no-initgroups                         disable additional groups set via initgroups()
    --unshare                               unshare() part of the processes and put it in a new namespace
    --unshare2                              unshare() part of the processes and put it in a new namespace after rootfs change
    --setns-socket                          expose a unix socket returning namespace fds from /proc/self/ns
    --setns-socket-skip                     skip the specified entry when sending setns file descriptors
    --setns-skip                            skip the specified entry when sending setns file descriptors
    --setns                                 join a namespace created by an external uWSGI instance
    --setns-preopen                         open /proc/self/ns as soon as possible and cache fds
    --jailed                                mark the instance as jailed (force the execution of post_jail hooks)
    --refork                                fork() again after privileges drop. Useful for jailing systems
    --re-fork                               fork() again after privileges drop. Useful for jailing systems
    --refork-as-root                        fork() again before privileges drop. Useful for jailing systems
    --re-fork-as-root                       fork() again before privileges drop. Useful for jailing systems
    --refork-post-jail                      fork() again after jailing. Useful for jailing systems
    --re-fork-post-jail                     fork() again after jailing. Useful for jailing systems
    --hook-asap                             run the specified hook as soon as possible
    --hook-pre-jail                         run the specified hook before jailing
    --hook-post-jail                        run the specified hook after jailing
    --hook-in-jail                          run the specified hook in jail after initialization
    --hook-as-root                          run the specified hook before privileges drop
    --hook-as-user                          run the specified hook after privileges drop
    --hook-as-user-atexit                   run the specified hook before app exit and reload
    --hook-pre-app                          run the specified hook before app loading
    --hook-post-app                         run the specified hook after app loading
    --hook-post-fork                        run the specified hook after each fork
    --hook-accepting                        run the specified hook after each worker enter the accepting phase
    --hook-accepting1                       run the specified hook after the first worker enters the accepting phase
    --hook-accepting-once                   run the specified hook after each worker enter the accepting phase (once per-instance)
    --hook-accepting1-once                  run the specified hook after the first worker enters the accepting phase (once per instance)
    --hook-master-start                     run the specified hook when the Master starts
    --hook-touch                            run the specified hook when the specified file is touched (syntax: <file> <action>)
    --hook-emperor-start                    run the specified hook when the Emperor starts
    --hook-emperor-stop                     run the specified hook when the Emperor send a stop message
    --hook-emperor-reload                   run the specified hook when the Emperor send a reload message
    --hook-emperor-lost                     run the specified hook when the Emperor connection is lost
    --hook-as-vassal                        run the specified hook before exec()ing the vassal
    --hook-as-emperor                       run the specified hook in the emperor after the vassal has been started
    --hook-as-mule                          run the specified hook in each mule
    --hook-as-gateway                       run the specified hook in each gateway
    --after-request-hook                    run the specified function/symbol after each request
    --after-request-call                    run the specified function/symbol after each request
    --exec-asap                             run the specified command as soon as possible
    --exec-pre-jail                         run the specified command before jailing
    --exec-post-jail                        run the specified command after jailing
    --exec-in-jail                          run the specified command in jail after initialization
    --exec-as-root                          run the specified command before privileges drop
    --exec-as-user                          run the specified command after privileges drop
    --exec-as-user-atexit                   run the specified command before app exit and reload
    --exec-pre-app                          run the specified command before app loading
    --exec-post-app                         run the specified command after app loading
    --exec-as-vassal                        run the specified command before exec()ing the vassal
    --exec-as-emperor                       run the specified command in the emperor after the vassal has been started
    --mount-asap                            mount filesystem as soon as possible
    --mount-pre-jail                        mount filesystem before jailing
    --mount-post-jail                       mount filesystem after jailing
    --mount-in-jail                         mount filesystem in jail after initialization
    --mount-as-root                         mount filesystem before privileges drop
    --mount-as-vassal                       mount filesystem before exec()ing the vassal
    --mount-as-emperor                      mount filesystem in the emperor after the vassal has been started
    --umount-asap                           unmount filesystem as soon as possible
    --umount-pre-jail                       unmount filesystem before jailing
    --umount-post-jail                      unmount filesystem after jailing
    --umount-in-jail                        unmount filesystem in jail after initialization
    --umount-as-root                        unmount filesystem before privileges drop
    --umount-as-vassal                      unmount filesystem before exec()ing the vassal
    --umount-as-emperor                     unmount filesystem in the emperor after the vassal has been started
    --wait-for-interface                    wait for the specified network interface to come up before running root hooks
    --wait-for-interface-timeout            set the timeout for wait-for-interface
    --wait-interface                        wait for the specified network interface to come up before running root hooks
    --wait-interface-timeout                set the timeout for wait-for-interface
    --wait-for-iface                        wait for the specified network interface to come up before running root hooks
    --wait-for-iface-timeout                set the timeout for wait-for-interface
    --wait-iface                            wait for the specified network interface to come up before running root hooks
    --wait-iface-timeout                    set the timeout for wait-for-interface
    --wait-for-fs                           wait for the specified filesystem item to appear before running root hooks
    --wait-for-file                         wait for the specified file to appear before running root hooks
    --wait-for-dir                          wait for the specified directory to appear before running root hooks
    --wait-for-mountpoint                   wait for the specified mountpoint to appear before running root hooks
    --wait-for-fs-timeout                   set the timeout for wait-for-fs/file/dir
    --wait-for-socket                       wait for the specified socket to be ready before loading apps
    --wait-for-socket-timeout               set the timeout for wait-for-socket
    --call-asap                             call the specified function as soon as possible
    --call-pre-jail                         call the specified function before jailing
    --call-post-jail                        call the specified function after jailing
    --call-in-jail                          call the specified function in jail after initialization
    --call-as-root                          call the specified function before privileges drop
    --call-as-user                          call the specified function after privileges drop
    --call-as-user-atexit                   call the specified function before app exit and reload
    --call-pre-app                          call the specified function before app loading
    --call-post-app                         call the specified function after app loading
    --call-as-vassal                        call the specified function() before exec()ing the vassal
    --call-as-vassal1                       call the specified function(char *) before exec()ing the vassal
    --call-as-vassal3                       call the specified function(char *, uid_t, gid_t) before exec()ing the vassal
    --call-as-emperor                       call the specified function() in the emperor after the vassal has been started
    --call-as-emperor1                      call the specified function(char *) in the emperor after the vassal has been started
    --call-as-emperor2                      call the specified function(char *, pid_t) in the emperor after the vassal has been started
    --call-as-emperor4                      call the specified function(char *, pid_t, uid_t, gid_t) in the emperor after the vassal has been started
    --ini                                   load config from ini file
    -y|--yaml                               load config from yaml file
    -y|--yml                                load config from yaml file
    --weight                                weight of the instance (used by clustering/lb/subscriptions)
    --auto-weight                           set weight of the instance (used by clustering/lb/subscriptions) automatically
    --no-server                             force no-server mode
    --command-mode                          force command mode
    --no-defer-accept                       disable deferred-accept on sockets
    --tcp-nodelay                           enable TCP NODELAY on each request
    --so-keepalive                          enable TCP KEEPALIVEs
    --so-send-timeout                       set SO_SNDTIMEO
    --socket-send-timeout                   set SO_SNDTIMEO
    --so-write-timeout                      set SO_SNDTIMEO
    --socket-write-timeout                  set SO_SNDTIMEO
    --socket-sndbuf                         set SO_SNDBUF
    --socket-rcvbuf                         set SO_RCVBUF
    --shutdown-sockets                      force calling shutdown() in addition to close() when sockets are destroyed
    --limit-as                              limit processes address space/vsz
    --limit-nproc                           limit the number of spawnable processes
    --reload-on-as                          reload if address space is higher than specified megabytes
    --reload-on-rss                         reload if rss memory is higher than specified megabytes
    --evil-reload-on-as                     force the master to reload a worker if its address space is higher than specified megabytes
    --evil-reload-on-rss                    force the master to reload a worker if its rss memory is higher than specified megabytes
    --mem-collector-freq                    set the memory collector frequency when evil reloads are in place
    --reload-on-fd                          reload if the specified file descriptor is ready
    --brutal-reload-on-fd                   brutal reload if the specified file descriptor is ready
    --ksm                                   enable Linux KSM
    --never-swap                            lock all memory pages avoiding swapping
    --touch-reload                          reload uWSGI if the specified file is modified/touched
    --touch-workers-reload                  trigger reload of (only) workers if the specified file is modified/touched
    --touch-mules-reload                    reload mules if the specified file is modified/touched
    --touch-spoolers-reload                 reload spoolers if the specified file is modified/touched
    --touch-chain-reload                    trigger chain reload if the specified file is modified/touched
    --touch-logrotate                       trigger logrotation if the specified file is modified/touched
    --touch-logreopen                       trigger log reopen if the specified file is modified/touched
    --touch-exec                            run command when the specified file is modified/touched (syntax: file command)
    --touch-signal                          signal when the specified file is modified/touched (syntax: file signal)
    --fs-reload                             graceful reload when the specified filesystem object is modified
    --fs-brutal-reload                      brutal reload when the specified filesystem object is modified
    --fs-signal                             raise a uwsgi signal when the specified filesystem object is modified (syntax: file signal)
    --check-mountpoint                      destroy the instance if a filesystem is no more reachable (useful for reliable Fuse management)
    --mountpoint-check                      destroy the instance if a filesystem is no more reachable (useful for reliable Fuse management)
    --check-mount                           destroy the instance if a filesystem is no more reachable (useful for reliable Fuse management)
    --mount-check                           destroy the instance if a filesystem is no more reachable (useful for reliable Fuse management)
    --propagate-touch                       over-engineering option for system with flaky signal management
    --limit-post                            limit request body
    --no-orphans                            automatically kill workers if master dies (can be dangerous for availability)
    --prio                                  set processes/threads priority
    --cpu-affinity                          set cpu affinity
    --post-buffering                        set size in bytes after which will buffer to disk instead of memory
    --post-buffering-bufsize                set buffer size for read() in post buffering mode
    --body-read-warning                     set the amount of allowed memory allocation (in megabytes) for request body before starting printing a warning
    --upload-progress                       enable creation of .json files in the specified directory during a file upload
    --no-default-app                        do not fallback to default app
    --manage-script-name                    automatically rewrite SCRIPT_NAME and PATH_INFO
    --ignore-script-name                    ignore SCRIPT_NAME
    --catch-exceptions                      report exception as http output (discouraged, use only for testing)
    --reload-on-exception                   reload a worker when an exception is raised
    --reload-on-exception-type              reload a worker when a specific exception type is raised
    --reload-on-exception-value             reload a worker when a specific exception value is raised
    --reload-on-exception-repr              reload a worker when a specific exception type+value (language-specific) is raised
    --exception-handler                     add an exception handler
    --enable-metrics                        enable metrics subsystem
    --metric                                add a custom metric
    --metric-threshold                      add a metric threshold/alarm
    --metric-alarm                          add a metric threshold/alarm
    --alarm-metric                          add a metric threshold/alarm
    --metrics-dir                           export metrics as text files to the specified directory
    --metrics-dir-restore                   restore last value taken from the metrics dir
    --metric-dir                            export metrics as text files to the specified directory
    --metric-dir-restore                    restore last value taken from the metrics dir
    --metrics-no-cores                      disable generation of cores-related metrics
    --udp                                   run the udp server on the specified address
    --stats                                 enable the stats server on the specified address
    --stats-server                          enable the stats server on the specified address
    --stats-http                            prefix stats server json output with http headers
    --stats-minified                        minify statistics json output
    --stats-min                             minify statistics json output
    --stats-push                            push the stats json to the specified destination
    --stats-pusher-default-freq             set the default frequency of stats pushers
    --stats-pushers-default-freq            set the default frequency of stats pushers
    --stats-no-cores                        disable generation of cores-related stats
    --stats-no-metrics                      do not include metrics in stats output
    --multicast                             subscribe to specified multicast group
    --multicast-ttl                         set multicast ttl
    --multicast-loop                        set multicast loop (default 1)
    --master-fifo                           enable the master fifo
    --notify-socket                         enable the notification socket
    --subscription-notify-socket            set the notification socket for subscriptions
    --legion                                became a member of a legion
    --legion-mcast                          became a member of a legion (shortcut for multicast)
    --legion-node                           add a node to a legion
    --legion-freq                           set the frequency of legion packets
    --legion-tolerance                      set the tolerance of legion subsystem
    --legion-death-on-lord-error            declare itself as a dead node for the specified amount of seconds if one of the lord hooks fails
    --legion-skew-tolerance                 set the clock skew tolerance of legion subsystem (default 30 seconds)
    --legion-lord                           action to call on Lord election
    --legion-unlord                         action to call on Lord dismiss
    --legion-setup                          action to call on legion setup
    --legion-death                          action to call on legion death (shutdown of the instance)
    --legion-join                           action to call on legion join (first time quorum is reached)
    --legion-node-joined                    action to call on new node joining legion
    --legion-node-left                      action to call node leaving legion
    --legion-quorum                         set the quorum of a legion
    --legion-scroll                         set the scroll of a legion
    --legion-scroll-max-size                set max size of legion scroll buffer
    --legion-scroll-list-max-size           set max size of legion scroll list buffer
    --subscriptions-sign-check              set digest algorithm and certificate directory for secured subscription system
    --subscriptions-sign-check-tolerance    set the maximum tolerance (in seconds) of clock skew for secured subscription system
    --subscriptions-sign-skip-uid           skip signature check for the specified uid when using unix sockets credentials
    --subscriptions-credentials-check       add a directory to search for subscriptions key credentials
    --subscriptions-use-credentials         enable management of SCM_CREDENTIALS in subscriptions UNIX sockets
    --subscription-algo                     set load balancing algorithm for the subscription system
    --subscription-dotsplit                 try to fallback to the next part (dot based) in subscription key
    --subscribe-to                          subscribe to the specified subscription server
    --st                                    subscribe to the specified subscription server
    --subscribe                             subscribe to the specified subscription server
    --subscribe2                            subscribe to the specified subscription server using advanced keyval syntax
    --subscribe-freq                        send subscription announce at the specified interval
    --subscription-tolerance                set tolerance for subscription servers
    --unsubscribe-on-graceful-reload        force unsubscribe request even during graceful reload
    --start-unsubscribed                    configure subscriptions but do not send them (useful with master fifo)
    --subscribe-with-modifier1              force the specififed modifier1 when subscribing
    --snmp                                  enable the embedded snmp server
    --snmp-community                        set the snmp community string
    --ssl-verbose                           be verbose about SSL errors
    --ssl-verify-depth                      set maximum certificate verification depth
    --sni                                   add an SNI-governed SSL context
    --sni-dir                               check for cert/key/client_ca file in the specified directory and create a sni/ssl context on demand
    --sni-dir-ciphers                       set ssl ciphers for sni-dir option
    --ssl-enable3                           enable SSLv3 (insecure)
    --ssl-enable-sslv3                      enable SSLv3 (insecure)
    --ssl-enable-tlsv1                      enable TLSv1 (insecure)
    --ssl-option                            set a raw ssl option (numeric value)
    --ssl-tmp-dir                           store ssl-related temp files in the specified directory
    --check-interval                        set the interval (in seconds) of master checks
    --forkbomb-delay                        sleep for the specified number of seconds when a forkbomb is detected
    --binary-path                           force binary path
    --privileged-binary-patch               patch the uwsgi binary with a new command (before privileges drop)
    --unprivileged-binary-patch             patch the uwsgi binary with a new command (after privileges drop)
    --privileged-binary-patch-arg           patch the uwsgi binary with a new command and arguments (before privileges drop)
    --unprivileged-binary-patch-arg         patch the uwsgi binary with a new command and arguments (after privileges drop)
    --async                                 enable async mode with specified cores
    --max-fd                                set maximum number of file descriptors (requires root privileges)
    --logto                                 set logfile/udp address
    --logto2                                log to specified file or udp address after privileges drop
    --log-format                            set advanced format for request logging
    --logformat                             set advanced format for request logging
    --logformat-strftime                    apply strftime to logformat output
    --log-format-strftime                   apply strftime to logformat output
    --logfile-chown                         chown logfiles
    --logfile-chmod                         chmod logfiles
    --log-syslog                            log to syslog
    --log-socket                            send logs to the specified socket
    --req-logger                            set/append a request logger
    --logger-req                            set/append a request logger
    --logger                                set/append a logger
    --logger-list                           list enabled loggers
    --loggers-list                          list enabled loggers
    --threaded-logger                       offload log writing to a thread
    --log-encoder                           add an item in the log encoder chain
    --log-req-encoder                       add an item in the log req encoder chain
    --use-abort                             call abort() on segfault/fpe, could be useful for generating a core dump
    --alarm                                 create a new alarm, syntax: <alarm> <plugin:args>
    --alarm-cheap                           use main alarm thread rather than create dedicated threads for curl-based alarms
    --alarm-freq                            tune the anti-loop alarm system (default 3 seconds)
    --alarm-fd                              raise the specified alarm when an fd is read for read (by default it reads 1 byte, set 8 for eventfd)
    --alarm-segfault                        raise the specified alarm when the segmentation fault handler is executed
    --segfault-alarm                        raise the specified alarm when the segmentation fault handler is executed
    --alarm-backlog                         raise the specified alarm when the socket backlog queue is full
    --backlog-alarm                         raise the specified alarm when the socket backlog queue is full
    --lq-alarm                              raise the specified alarm when the socket backlog queue is full
    --alarm-lq                              raise the specified alarm when the socket backlog queue is full
    --alarm-listen-queue                    raise the specified alarm when the socket backlog queue is full
    --listen-queue-alarm                    raise the specified alarm when the socket backlog queue is full
    --alarm-list                            list enabled alarms
    --alarms-list                           list enabled alarms
    --alarm-msg-size                        set the max size of an alarm message (default 8192)
    --log-master                            delegate logging to master process
    --log-master-bufsize                    set the buffer size for the master logger. bigger log messages will be truncated
    --log-master-stream                     create the master logpipe as SOCK_STREAM
    --log-master-req-stream                 create the master requests logpipe as SOCK_STREAM
    --log-reopen                            reopen log after reload
    --log-truncate                          truncate log on startup
    --log-maxsize                           set maximum logfile size
    --log-backupname                        set logfile name after rotation
    --logdate                               prefix logs with date or a strftime string
    --log-date                              prefix logs with date or a strftime string
    --log-prefix                            prefix logs with a string
    --log-zero                              log responses without body
    --log-slow                              log requests slower than the specified number of milliseconds
    --log-4xx                               log requests with a 4xx response
    --log-5xx                               log requests with a 5xx response
    --log-big                               log requestes bigger than the specified size
    --log-sendfile                          log sendfile requests
    --log-ioerror                           log requests with io errors
    --log-micros                            report response time in microseconds instead of milliseconds
    --log-x-forwarded-for                   use the ip from X-Forwarded-For header instead of REMOTE_ADDR
    --master-as-root                        leave master process running as root
    --drop-after-init                       run privileges drop after plugin initialization, superseded by drop-after-apps
    --drop-after-apps                       run privileges drop after apps loading, superseded by master-as-root
    --force-cwd                             force the initial working directory to the specified value
    --binsh                                 override /bin/sh (used by exec hooks, it always fallback to /bin/sh)
    --chdir                                 chdir to specified directory before apps loading
    --chdir2                                chdir to specified directory after apps loading
    --lazy                                  set lazy mode (load apps in workers instead of master)
    --lazy-apps                             load apps in each worker instead of the master
    --cheap                                 set cheap mode (spawn workers only after the first request)
    --cheaper                               set cheaper mode (adaptive process spawning)
    --cheaper-initial                       set the initial number of processes to spawn in cheaper mode
    --cheaper-algo                          choose to algorithm used for adaptive process spawning
    --cheaper-step                          number of additional processes to spawn at each overload
    --cheaper-overload                      increase workers after specified overload
    --cheaper-algo-list                     list enabled cheapers algorithms
    --cheaper-algos-list                    list enabled cheapers algorithms
    --cheaper-list                          list enabled cheapers algorithms
    --cheaper-rss-limit-soft                don't spawn new workers if total resident memory usage of all workers is higher than this limit
    --cheaper-rss-limit-hard                if total workers resident memory usage is higher try to stop workers
    --idle                                  set idle mode (put uWSGI in cheap mode after inactivity)
    --die-on-idle                           shutdown uWSGI when idle
    --mount                                 load application under mountpoint
    --worker-mount                          load application under mountpoint in the specified worker or after workers spawn
    --threads                               run each worker in prethreaded mode with the specified number of threads
    --thread-stacksize                      set threads stacksize
    --threads-stacksize                     set threads stacksize
    --thread-stack-size                     set threads stacksize
    --threads-stack-size                    set threads stacksize
    --vhost                                 enable virtualhosting mode (based on SERVER_NAME variable)
    --vhost-host                            enable virtualhosting mode (based on HTTP_HOST variable)
    --error-page-403                        add an error page (html) for managed 403 response
    --error-page-404                        add an error page (html) for managed 404 response
    --error-page-500                        add an error page (html) for managed 500 response
    --websockets-ping-freq                  set the frequency (in seconds) of websockets automatic ping packets
    --websocket-ping-freq                   set the frequency (in seconds) of websockets automatic ping packets
    --websockets-pong-tolerance             set the tolerance (in seconds) of websockets ping/pong subsystem
    --websocket-pong-tolerance              set the tolerance (in seconds) of websockets ping/pong subsystem
    --websockets-max-size                   set the max allowed size of websocket messages (in Kbytes, default 1024)
    --websocket-max-size                    set the max allowed size of websocket messages (in Kbytes, default 1024)
    --chunked-input-limit                   set the max size of a chunked input part (default 1MB, in bytes)
    --chunked-input-timeout                 set default timeout for chunked input
    --clock                                 set a clock source
    --clock-list                            list enabled clocks
    --clocks-list                           list enabled clocks
    --add-header                            automatically add HTTP headers to response
    --rem-header                            automatically remove specified HTTP header from the response
    --del-header                            automatically remove specified HTTP header from the response
    --collect-header                        store the specified response header in a request var (syntax: header var)
    --response-header-collect               store the specified response header in a request var (syntax: header var)
    --pull-header                           store the specified response header in a request var and remove it from the response (syntax: header var)
    --check-static                          check for static files in the specified directory
    --check-static-docroot                  check for static files in the requested DOCUMENT_ROOT
    --static-check                          check for static files in the specified directory
    --static-map                            map mountpoint to static directory (or file)
    --static-map2                           like static-map but completely appending the requested resource to the docroot
    --static-skip-ext                       skip specified extension from staticfile checks
    --static-index                          search for specified file if a directory is requested
    --static-safe                           skip security checks if the file is under the specified path
    --static-cache-paths                    put resolved paths in the uWSGI cache for the specified amount of seconds
    --static-cache-paths-name               use the specified cache for static paths
    --mimefile                              set mime types file path (default /etc/mime.types)
    --mime-file                             set mime types file path (default /etc/mime.types)
    --static-expires-type                   set the Expires header based on content type
    --static-expires-type-mtime             set the Expires header based on content type and file mtime
    --static-gzip-all                       check for a gzip version of all requested static files
    --static-gzip-dir                       check for a gzip version of all requested static files in the specified dir/prefix
    --static-gzip-prefix                    check for a gzip version of all requested static files in the specified dir/prefix
    --static-gzip-ext                       check for a gzip version of all requested static files with the specified ext/suffix
    --static-gzip-suffix                    check for a gzip version of all requested static files with the specified ext/suffix
    --honour-range                          enable support for the HTTP Range header
    --offload-threads                       set the number of offload threads to spawn (per-worker, default 0)
    --offload-thread                        set the number of offload threads to spawn (per-worker, default 0)
    --file-serve-mode                       set static file serving mode
    --fileserve-mode                        set static file serving mode
    --disable-sendfile                      disable sendfile() and rely on boring read()/write()
    --check-cache                           check for response data in the specified cache (empty for default cache)
    --close-on-exec                         set close-on-exec on connection sockets (could be required for spawning processes in requests)
    --close-on-exec2                        set close-on-exec on server sockets (could be required for spawning processes in requests)
    --mode                                  set uWSGI custom mode
    --env                                   set environment variable
    --envdir                                load a daemontools compatible envdir
    --early-envdir                          load a daemontools compatible envdir ASAP
    --unenv                                 unset environment variable
    --vacuum                                try to remove all of the generated file/sockets
    --file-write                            write the specified content to the specified file (syntax: file=value) before privileges drop
    --cgroup                                put the processes in the specified cgroup
    --cgroup-opt                            set value in specified cgroup option
    --cgroup-dir-mode                       set permission for cgroup directory (default is 700)
    --namespace                             run in a new namespace under the specified rootfs
    --namespace-keep-mount                  keep the specified mountpoint in your namespace
    --ns                                    run in a new namespace under the specified rootfs
    --namespace-net                         add network namespace
    --ns-net                                add network namespace
    --enable-proxy-protocol                 enable PROXY1 protocol support (only for http parsers)
    --reuse-port                            enable REUSE_PORT flag on socket (BSD only)
    --tcp-fast-open                         enable TCP_FASTOPEN flag on TCP sockets with the specified qlen value
    --tcp-fastopen                          enable TCP_FASTOPEN flag on TCP sockets with the specified qlen value
    --tcp-fast-open-client                  use sendto(..., MSG_FASTOPEN, ...) instead of connect() if supported
    --tcp-fastopen-client                   use sendto(..., MSG_FASTOPEN, ...) instead of connect() if supported
    --zerg                                  attach to a zerg server
    --zerg-fallback                         fallback to normal sockets if the zerg server is not available
    --zerg-server                           enable the zerg server on the specified UNIX socket
    --cron                                  add a cron task
    --cron2                                 add a cron task (key=val syntax)
    --unique-cron                           add a unique cron task
    --cron-harakiri                         set the maximum time (in seconds) we wait for cron command to complete
    --legion-cron                           add a cron task runnable only when the instance is a lord of the specified legion
    --cron-legion                           add a cron task runnable only when the instance is a lord of the specified legion
    --unique-legion-cron                    add a unique cron task runnable only when the instance is a lord of the specified legion
    --unique-cron-legion                    add a unique cron task runnable only when the instance is a lord of the specified legion
    --loop                                  select the uWSGI loop engine
    --loop-list                             list enabled loop engines
    --loops-list                            list enabled loop engines
    --worker-exec                           run the specified command as worker
    --worker-exec2                          run the specified command as worker (after post_fork hook)
    --attach-daemon                         attach a command/daemon to the master process (the command has to not go in background)
    --attach-control-daemon                 attach a command/daemon to the master process (the command has to not go in background), when the daemon dies, the master dies too
    --smart-attach-daemon                   attach a command/daemon to the master process managed by a pidfile (the command has to daemonize)
    --smart-attach-daemon2                  attach a command/daemon to the master process managed by a pidfile (the command has to NOT daemonize)
    --legion-attach-daemon                  same as --attach-daemon but daemon runs only on legion lord node
    --legion-smart-attach-daemon            same as --smart-attach-daemon but daemon runs only on legion lord node
    --legion-smart-attach-daemon2           same as --smart-attach-daemon2 but daemon runs only on legion lord node
    --daemons-honour-stdin                  do not change the stdin of external daemons to /dev/null
    --attach-daemon2                        attach-daemon keyval variant (supports smart modes too)
    --plugins                               load uWSGI plugins
    --plugin                                load uWSGI plugins
    --need-plugins                          load uWSGI plugins (exit on error)
    --need-plugin                           load uWSGI plugins (exit on error)
    --plugins-dir                           add a directory to uWSGI plugin search path
    --plugin-dir                            add a directory to uWSGI plugin search path
    --plugins-list                          list enabled plugins
    --plugin-list                           list enabled plugins
    --autoload                              try to automatically load plugins when unknown options are found
    --dlopen                                blindly load a shared library
    --allowed-modifiers                     comma separated list of allowed modifiers
    --remap-modifier                        remap request modifier from one id to another
    --dump-options                          dump the full list of available options
    --show-config                           show the current config reformatted as ini
    --binary-append-data                    return the content of a resource to stdout for appending to a uwsgi binary (for data:// usage)
    --print                                 simple print
    --iprint                                simple print (immediate version)
    --exit                                  force exit() of the instance
    --cflags                                report uWSGI CFLAGS (useful for building external plugins)
    --dot-h                                 dump the uwsgi.h used for building the core  (useful for building external plugins)
    --config-py                             dump the uwsgiconfig.py used for building the core  (useful for building external plugins)
    --build-plugin                          build a uWSGI plugin for the current binary
    --version                               print uWSGI version
    --response-headers-limit                set response header maximum size (default: 64k)
    --wsgi-file                             load .wsgi file
    --file                                  load .wsgi file
    --eval                                  eval python code
    -w|--module                             load a WSGI module
    -w|--wsgi                               load a WSGI module
    --callable                              set default WSGI callable name
    -J|--test                               test a module import
    -H|--home                               set PYTHONHOME/virtualenv
    -H|--virtualenv                         set PYTHONHOME/virtualenv
    -H|--venv                               set PYTHONHOME/virtualenv
    -H|--pyhome                             set PYTHONHOME/virtualenv
    --py-programname                        set python program name
    --py-program-name                       set python program name
    --pythonpath                            add directory (or glob) to pythonpath
    --python-path                           add directory (or glob) to pythonpath
    --pp                                    add directory (or glob) to pythonpath
    --pymodule-alias                        add a python alias module
    --post-pymodule-alias                   add a python module alias after uwsgi module initialization
    --import                                import a python module
    --pyimport                              import a python module
    --py-import                             import a python module
    --python-import                         import a python module
    --shared-import                         import a python module in all of the processes
    --shared-pyimport                       import a python module in all of the processes
    --shared-py-import                      import a python module in all of the processes
    --shared-python-import                  import a python module in all of the processes
    --spooler-import                        import a python module in the spooler
    --spooler-pyimport                      import a python module in the spooler
    --spooler-py-import                     import a python module in the spooler
    --spooler-python-import                 import a python module in the spooler
    --pyargv                                manually set sys.argv
    -O|--optimize                           set python optimization level
    --pecan                                 load a pecan config file
    --paste                                 load a paste.deploy config file
    --paste-logger                          enable paste fileConfig logger
    --web3                                  load a web3 app
    --pump                                  load a pump app
    --wsgi-lite                             load a wsgi-lite app
    --ini-paste                             load a paste.deploy config file containing uwsgi section
    --ini-paste-logged                      load a paste.deploy config file containing uwsgi section (load loggers too)
    --reload-os-env                         force reload of os.environ at each request
    --no-site                               do not import site module
    --pyshell                               run an interactive python shell in the uWSGI environment
    --pyshell-oneshot                       run an interactive python shell in the uWSGI environment (one-shot variant)
    --python                                run a python script in the uWSGI environment
    --py                                    run a python script in the uWSGI environment
    --pyrun                                 run a python script in the uWSGI environment
    --py-tracebacker                        enable the uWSGI python tracebacker
    --py-auto-reload                        monitor python modules mtime to trigger reload (use only in development)
    --py-autoreload                         monitor python modules mtime to trigger reload (use only in development)
    --python-auto-reload                    monitor python modules mtime to trigger reload (use only in development)
    --python-autoreload                     monitor python modules mtime to trigger reload (use only in development)
    --py-auto-reload-ignore                 ignore the specified module during auto-reload scan (can be specified multiple times)
    --wsgi-env-behaviour                    set the strategy for allocating/deallocating the WSGI env
    --wsgi-env-behavior                     set the strategy for allocating/deallocating the WSGI env
    --start_response-nodelay                send WSGI http headers as soon as possible (PEP violation)
    --wsgi-strict                           try to be fully PEP compliant disabling optimizations
    --wsgi-accept-buffer                    accept CPython buffer-compliant objects as WSGI response in addition to string/bytes
    --wsgi-accept-buffers                   accept CPython buffer-compliant objects as WSGI response in addition to string/bytes
    --wsgi-disable-file-wrapper             disable wsgi.file_wrapper feature
    --python-version                        report python version
    --python-raw                            load a python file for managing raw requests
    --py-sharedarea                         create a sharedarea from a python bytearray object of the specified size
    --py-call-osafterfork                   enable child processes running cpython to trap OS signals
    --python-worker-override                override worker with the specified python script
    --symcall                               load the specified C symbol as the symcall request handler (supports <mountpoint=func> too)
    --symcall-use-next                      use RTLD_NEXT when searching for symbols
    --symcall-register-rpc                  load the specified C symbol as an RPC function (syntax: name function)
    --symcall-post-fork                     call the specified C symbol after each fork()
    --ping                                  ping specified uwsgi host
    --ping-timeout                          set ping timeout
    --gevent                                a shortcut enabling gevent loop engine with the specified number of async cores and optimal parameters
    --gevent-monkey-patch                   call gevent.monkey.patch_all() automatically on startup
    --gevent-early-monkey-patch             call gevent.monkey.patch_all() automatically before app loading
    --gevent-wait-for-hub                   wait for gevent hub's death instead of the control greenlet
    --nagios                                nagios check
    --rrdtool                               store rrd files in the specified directory
    --rrdtool-freq                          set collect frequency
    --rrdtool-lib                           set the name of rrd library (default: librrd.so)
    --carbon                                push statistics to the specified carbon server
    --carbon-timeout                        set carbon connection timeout in seconds (default 3)
    --carbon-freq                           set carbon push frequency in seconds (default 60)
    --carbon-id                             set carbon id
    --carbon-no-workers                     disable generation of single worker metrics
    --carbon-max-retry                      set maximum number of retries in case of connection errors (default 1)
    --carbon-retry-delay                    set connection retry delay in seconds (default 7)
    --carbon-root                           set carbon metrics root node (default 'uwsgi')
    --carbon-hostname-dots                  set char to use as a replacement for dots in hostname (dots are not replaced by default)
    --carbon-name-resolve                   allow using hostname as carbon server address (default disabled)
    --carbon-resolve-names                  allow using hostname as carbon server address (default disabled)
    --carbon-idle-avg                       average values source during idle period (no requests), can be "last", "zero", "none" (default is last)
    --carbon-use-metrics                    don't compute all statistics, use metrics subsystem data instead (warning! key names will be different)
    --fastrouter                            run the fastrouter on the specified port
    --fastrouter-processes                  prefork the specified number of fastrouter processes
    --fastrouter-workers                    prefork the specified number of fastrouter processes
    --fastrouter-zerg                       attach the fastrouter to a zerg server
    --fastrouter-use-cache                  use uWSGI cache as hostname->server mapper for the fastrouter
    --fastrouter-use-pattern                use a pattern for fastrouter hostname->server mapping
    --fastrouter-use-base                   use a base dir for fastrouter hostname->server mapping
    --fastrouter-fallback                   fallback to the specified node in case of error
    --fastrouter-use-code-string            use code string as hostname->server mapper for the fastrouter
    --fastrouter-use-socket                 forward request to the specified uwsgi socket
    --fastrouter-to                         forward requests to the specified uwsgi server (you can specify it multiple times for load balancing)
    --fastrouter-gracetime                  retry connections to dead static nodes after the specified amount of seconds
    --fastrouter-events                     set the maximum number of concurrent events
    --fastrouter-quiet                      do not report failed connections to instances
    --fastrouter-cheap                      run the fastrouter in cheap mode
    --fastrouter-subscription-server        run the fastrouter subscription server on the specified address
    --fastrouter-subscription-slot          *** deprecated ***
    --fastrouter-timeout                    set fastrouter timeout
    --fastrouter-post-buffering             enable fastrouter post buffering
    --fastrouter-post-buffering-dir         put fastrouter buffered files to the specified directory (noop, use TMPDIR env)
    --fastrouter-stats                      run the fastrouter stats server
    --fastrouter-stats-server               run the fastrouter stats server
    --fastrouter-ss                         run the fastrouter stats server
    --fastrouter-harakiri                   enable fastrouter harakiri
    --fastrouter-uid                        drop fastrouter privileges to the specified uid
    --fastrouter-gid                        drop fastrouter privileges to the specified gid
    --fastrouter-resubscribe                forward subscriptions to the specified subscription server
    --fastrouter-resubscribe-bind           bind to the specified address when re-subscribing
    --fastrouter-buffer-size                set internal buffer size (default: page size)
    --fastrouter-fallback-on-no-key         move to fallback node even if a subscription key is not found
    --fastrouter-subscription-fallback-key  key to use for fallback fastrouter
    --http                                  add an http router/server on the specified address
    --httprouter                            add an http router/server on the specified address
    --https                                 add an https router/server on the specified address with specified certificate and key
    --https2                                add an https/spdy router/server using keyval options
    --https-export-cert                     export uwsgi variable HTTPS_CC containing the raw client certificate
    --https-session-context                 set the session id context to the specified value
    --http-to-https                         add an http router/server on the specified address and redirect all of the requests to https
    --http-processes                        set the number of http processes to spawn
    --http-workers                          set the number of http processes to spawn
    --http-var                              add a key=value item to the generated uwsgi packet
    --http-to                               forward requests to the specified node (you can specify it multiple time for lb)
    --http-zerg                             attach the http router to a zerg server
    --http-fallback                         fallback to the specified node in case of error
    --http-modifier1                        set uwsgi protocol modifier1
    --http-modifier2                        set uwsgi protocol modifier2
    --http-use-cache                        use uWSGI cache as key->value virtualhost mapper
    --http-use-pattern                      use the specified pattern for mapping requests to unix sockets
    --http-use-base                         use the specified base for mapping requests to unix sockets
    --http-events                           set the number of concurrent http async events
    --http-subscription-server              enable the subscription server
    --http-subscription-fallback-key        key to use for fallback http handler
    --http-timeout                          set internal http socket timeout
    --http-manage-expect                    manage the Expect HTTP request header (optionally checking for Content-Length)
    --http-keepalive                        HTTP 1.1 keepalive support (non-pipelined) requests
    --http-auto-chunked                     automatically transform output to chunked encoding during HTTP 1.1 keepalive (if needed)
    --http-auto-gzip                        automatically gzip content if uWSGI-Encoding header is set to gzip, but content size (Content-Length/Transfer-Encoding) and Content-Encoding are not specified
    --http-raw-body                         blindly send HTTP body to backends (required for WebSockets and Icecast support in backends)
    --http-websockets                       automatically detect websockets connections and put the session in raw mode
    --http-chunked-input                    automatically detect chunked input requests and put the session in raw mode
    --http-use-code-string                  use code string as hostname->server mapper for the http router
    --http-use-socket                       forward request to the specified uwsgi socket
    --http-gracetime                        retry connections to dead static nodes after the specified amount of seconds
    --http-quiet                            do not report failed connections to instances
    --http-cheap                            run the http router in cheap mode
    --http-stats                            run the http router stats server
    --http-stats-server                     run the http router stats server
    --http-ss                               run the http router stats server
    --http-harakiri                         enable http router harakiri
    --http-stud-prefix                      expect a stud prefix (1byte family + 4/16 bytes address) on connections from the specified address
    --http-uid                              drop http router privileges to the specified uid
    --http-gid                              drop http router privileges to the specified gid
    --http-resubscribe                      forward subscriptions to the specified subscription server
    --http-buffer-size                      set internal buffer size (default: page size)
    --http-server-name-as-http-host         force SERVER_NAME to HTTP_HOST
    --http-headers-timeout                  set internal http socket timeout for headers
    --http-connect-timeout                  set internal http socket timeout for backend connections
    --http-manage-source                    manage the SOURCE HTTP method placing the session in raw mode
    --http-manage-rtsp                      manage RTSP sessions
    --http-enable-proxy-protocol            manage PROXY protocol requests
    --ugreen                                enable ugreen coroutine subsystem
    --ugreen-stacksize                      set ugreen stack size in pages
    --rsyslog-packet-size                   set maximum packet size for syslog messages (default 1024) WARNING! using packets > 1024 breaks RFC 3164 (#4.1)
    --rsyslog-split-messages                split big messages into multiple chunks if they are bigger than allowed packet size (default is false)
    --zergpool                              start a zergpool on specified address for specified address
    --zerg-pool                             start a zergpool on specified address for specified address
    --rawrouter                             run the rawrouter on the specified port
    --rawrouter-processes                   prefork the specified number of rawrouter processes
    --rawrouter-workers                     prefork the specified number of rawrouter processes
    --rawrouter-zerg                        attach the rawrouter to a zerg server
    --rawrouter-use-cache                   use uWSGI cache as hostname->server mapper for the rawrouter
    --rawrouter-use-pattern                 use a pattern for rawrouter hostname->server mapping
    --rawrouter-use-base                    use a base dir for rawrouter hostname->server mapping
    --rawrouter-fallback                    fallback to the specified node in case of error
    --rawrouter-use-code-string             use code string as hostname->server mapper for the rawrouter
    --rawrouter-use-socket                  forward request to the specified uwsgi socket
    --rawrouter-to                          forward requests to the specified uwsgi server (you can specify it multiple times for load balancing)
    --rawrouter-gracetime                   retry connections to dead static nodes after the specified amount of seconds
    --rawrouter-events                      set the maximum number of concurrent events
    --rawrouter-max-retries                 set the maximum number of retries/fallbacks to other nodes
    --rawrouter-quiet                       do not report failed connections to instances
    --rawrouter-cheap                       run the rawrouter in cheap mode
    --rawrouter-subscription-server         run the rawrouter subscription server on the spcified address
    --rawrouter-subscription-slot           *** deprecated ***
    --rawrouter-timeout                     set rawrouter timeout
    --rawrouter-stats                       run the rawrouter stats server
    --rawrouter-stats-server                run the rawrouter stats server
    --rawrouter-ss                          run the rawrouter stats server
    --rawrouter-harakiri                    enable rawrouter harakiri
    --rawrouter-xclient                     use the xclient protocol to pass the client addres
    --rawrouter-buffer-size                 set internal buffer size (default: page size)
    --sslrouter                             run the sslrouter on the specified port
    --sslrouter2                            run the sslrouter on the specified port (key-value based)
    --sslrouter-session-context             set the session id context to the specified value
    --sslrouter-processes                   prefork the specified number of sslrouter processes
    --sslrouter-workers                     prefork the specified number of sslrouter processes
    --sslrouter-zerg                        attach the sslrouter to a zerg server
    --sslrouter-use-cache                   use uWSGI cache as hostname->server mapper for the sslrouter
    --sslrouter-use-pattern                 use a pattern for sslrouter hostname->server mapping
    --sslrouter-use-base                    use a base dir for sslrouter hostname->server mapping
    --sslrouter-fallback                    fallback to the specified node in case of error
    --sslrouter-use-code-string             use code string as hostname->server mapper for the sslrouter
    --sslrouter-use-socket                  forward request to the specified uwsgi socket
    --sslrouter-to                          forward requests to the specified uwsgi server (you can specify it multiple times for load balancing)
    --sslrouter-gracetime                   retry connections to dead static nodes after the specified amount of seconds
    --sslrouter-events                      set the maximum number of concurrent events
    --sslrouter-max-retries                 set the maximum number of retries/fallbacks to other nodes
    --sslrouter-quiet                       do not report failed connections to instances
    --sslrouter-cheap                       run the sslrouter in cheap mode
    --sslrouter-subscription-server         run the sslrouter subscription server on the spcified address
    --sslrouter-timeout                     set sslrouter timeout
    --sslrouter-stats                       run the sslrouter stats server
    --sslrouter-stats-server                run the sslrouter stats server
    --sslrouter-ss                          run the sslrouter stats server
    --sslrouter-harakiri                    enable sslrouter harakiri
    --sslrouter-sni                         use SNI to route requests
    --sslrouter-buffer-size                 set internal buffer size (default: page size)
    --cheaper-busyness-max                  set the cheaper busyness high percent limit, above that value worker is considered loaded (default 50)
    --cheaper-busyness-min                  set the cheaper busyness low percent limit, below that value worker is considered idle (default 25)
    --cheaper-busyness-multiplier           set initial cheaper multiplier, worker needs to be idle for cheaper-overload*multiplier seconds to be cheaped (default 10)
    --cheaper-busyness-penalty              penalty for respawning workers to fast, it will be added to the current multiplier value if worker is cheaped and than respawned back too fast (default 2)
    --cheaper-busyness-verbose              enable verbose log messages from busyness algorithm
    --cheaper-busyness-backlog-alert        spawn emergency worker(s) if any time listen queue is higher than this value (default 33)
    --cheaper-busyness-backlog-multiplier   set cheaper multiplier used for emergency workers (default 3)
    --cheaper-busyness-backlog-step         number of emergency workers to spawn at a time (default 1)
    --cheaper-busyness-backlog-nonzero      spawn emergency worker(s) if backlog is > 0 for more then N seconds (default 60)
```

### 参数配置示例
master = true 
#启动主进程，来管理其他进程，其它的uwsgi进程都是这个master进程的子进程，如果kill这个master进程，相当于重启所有的uwsgi进程。

chdir = /web/www/mysite 
#在app加载前切换到当前目录， 指定运行目录

module = mysite.wsgi 
# 加载一个WSGI模块,这里加载mysite/wsgi.py这个模块

py-autoreload=1  
#监控python模块mtime来触发重载 (只在开发时使用)

lazy-apps=true  
#在每个worker而不是master中加载应用

socket = /test/myapp.sock 
#指定socket文件，也可以指定为127.0.0.1:9000，这样就会监听到网络套接字

processes = 2 #启动2个工作进程，生成指定数目的worker/进程

buffer-size = 32768 
#设置用于uwsgi包解析的内部缓存区大小为64k。默认是4k。

daemonize = /var/log/myapp_uwsgi.log 
# 使进程在后台运行，并将日志打到指定的日志文件或者udp服务器

log-maxsize = 5000000 #设置最大日志文件大小

disable-logging = true #禁用请求日志记录

vacuum = true #当服务器退出的时候自动删除unix socket文件和pid文件。

listen = 120 #设置socket的监听队列大小（默认：100）

pidfile = /var/run/uwsgi.pid #指定pid文件

enable-threads = true 
#允许用内嵌的语言启动线程。这将允许你在app程序中产生一个子线程

reload-mercy = 8 
#设置在平滑的重启（直到接收到的请求处理完才重启）一个工作子进程中，等待这个工作结束的最长秒数。这个配置会使在平滑地重启工作子进程中，如果工作进程结束时间超过了8秒就会被强行结束（忽略之前已经接收到的请求而直接结束）

max-requests = 5000 
#为每个工作进程设置请求数的上限。当一个工作进程处理的请求数达到这个值，那么该工作进程就会被回收重用（重启）。你可以使用这个选项来默默地对抗内存泄漏

limit-as = 256 
#通过使用POSIX/UNIX的setrlimit()函数来限制每个uWSGI进程的虚拟内存使用数。这个配置会限制uWSGI的进程占用虚拟内存不超过256M。如果虚拟内存已经达到256M，并继续申请虚拟内存则会使程序报内存错误，本次的http请求将返回500错误。

harakiri = 60 
#一个请求花费的时间超过了这个harakiri超时时间，那么这个请求都会被丢弃，并且当前处理这个请求的工作进程会被回收再利用（即重启）


### 注意事项

1. 当uwsgi无法访问时候
首先查看进程是否在运行
```
netstat -tpln
```
2. 再确认进程有情况下，试着重启
```
uwsgi --reload xxx.ini
```
3. 如果步骤2没有解决问题，则组要重新配置xxx.ini
```
uwsgi --ini xxx.ini
```
提示如下错误：probably another instance of uWSGI is running on the same address (:8024)，说明该端口被占用，结束掉占用该端口的进程
```
sudo fuser -k 8024/tcp
```
4. 重新启动uwsgi
```
uwsgi --ini xxx.ini
```




