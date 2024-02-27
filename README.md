# Cluster of Infrastructure as Code

## 目录结构
```shell
.
├── README.md
├── Taskfile.yaml
├── addons # 插件目录
│   ├── charts # helm charts 目录
│   │   ├── argo-cd-5.53.14.tgz
│   │   ├── cert-manager-v1.14.1.tgz
│   │   ├── csi-driver-nfs-v4.6.0.tgz
│   │   ├── ingress-nginx-4.9.1.tgz
│   │   └── kubernetes-dashboard-7.0.0-alpha1.tgz
│   ├── values # helm values 文件目录
│   │   ├── argo-cd.yaml
│   │   ├── cert-manager.yaml
│   │   ├── csi-driver-nfs.yaml
│   │   ├── ingress-nginx.yaml
│   │   ├── kubernetes-dashboard.yaml
│   │   └── metrics-server.yaml
│   └── yaml # yaml 资源目录
│       ├── cluster-issuer.yaml
│       └── nfs-storage-class.yaml
├── bin # Kubekey 命令路径，通过 Kubekey 源码编译获得
│   ├── kk # Kubekey 命令行程序，编译自：https://github.com/will4j/kubekey
│   └── kubekey # kk 执行本地缓存目录
│       └── ...
├── kubekey-config.yaml # kubekey 集群配置文件
└── scripts # 自定义 shell 脚本
    ├── control_plane_taint.sh
    └── install_nfs_server.sh
```

## 集群构建
```shell
$ task --list
task: Available tasks for this project:
* addons:apply:                          apply cluster addons by kubekey config
* cluster:create:                        create cluster by kubekey config
* cluster:delete:                        delete cluster by kubekey config
* cluster:show-supported-versions:       show supported cluster versions
* cluster:upgrade:                       upgrade cluster by kubekey config
* os:init:                               init os with precondition
```
```shell
# 配置好 kubekey-config.yaml 文件
$ task os:init # 系统软件安装
$ task cluster:create # 集群安装构建+插件安装
```

## 插件安装
插件安装支持 helm chart 及纯 yaml 文件，在 `kubekey-config.yaml` 中配置如下：
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
