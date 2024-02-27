# Dubhe Cluster Infrastructure as Code

## 目录结构
```shell
.
├── README.md
├── Taskfile.yaml # 任务脚本
├── addons # 集群插件目录
│   ├── charts # helm chart 目录
│   ├── values # helm chart values 目录
│   └── yaml # yaml 插件目录
├── bin # kubekey 工作目录
│   ├── kk # kk 命令编译自：https://github.com/will4j/kubekey
│   └── kubekey # kk 执行缓存目录
├── kubesphere-config.yaml # 集群配置文件
└── scripts # 集群构建时使用的 shell 脚本
    ├── install_nfs_server.sh
    └── taint_control_plane.sh
```

## 集群构建
```shell
$ task --list
task: Available tasks for this project:
* addons:apply:                          apply cluster addons by kubesphere config
* cluster:create:                        create cluster by kubesphere config
* cluster:delete:                        delete cluster by kubesphere config
* cluster:show-supported-versions:       show supported cluster versions
* cluster:upgrade:                       upgrade cluster by kubesphere config
* os:init:                               init os with precondition
```
```shell
# 配置好 kubesphere-config.yaml 文件
$ task os:init # 系统软件安装
$ task cluster:create # 集群安装构建+插件安装
```

## 插件安装
插件安装支持 helm chart 及纯 yaml 文件，在 `kubesphere-config.yaml` 中配置如下：
```yaml
enabledAddons: [ "*" ] # 指定启用的插件，"*" 表示全部启用，可指定插件列表，或者置空跳过所有插件安装
addons:
- name: csi-driver-nfs # 插件名称
  namespace: storage # 命名空间
  sources:
    chart: # helm chart 依赖
      # https://github.com/kubernetes-csi/csi-driver-nfs/tree/master/charts
      release: csi-driver-nfs
      path: ./addons/charts/csi-driver-nfs-v4.6.0.tgz
      valuesFile: ./addons/values/csi-driver-nfs.yaml
    yaml: # yaml 依赖
      path:
        - ./addons/yaml/nfs-storage-class.yaml
```
```shell
# 执行 task 安装插件
$ task addons:apply
```

## 参考资料
1. https://github.com/kubesphere/kubekey/blob/master/docs/config-example.md 
