# **harbor-ha-helm**

## 特殊说明
* 使用的是Ｈarbor V1.8.1版本
* 支持NodePort和Ingress
* HarborHA 组件内部使用redisHA, postgresqlHA
* HarborHA不支持redisHA,专门定制了harbor-haproxy
* 支持初始化postgresql关于habor的相关数据库

## 参考文档
* **https://github.com/goharbor/harbor-helm/blob/master/docs/High%20Availability.md**


## 部署方式
### 1. 修改harbor.cfg
```
CLUSTER_MASTER_IP=''  # 集群节点ip,只有当nodeport的情况下才会用到
HARBOR_DEPLOY_TYPE='nodeport'　＃集群默认部署方式，只支持nodeport和ingress
NAMESPACE='harbor'   # 部署所在的ns
REDIS_RELEASE_NAME='redis-ha'  # redis的release名称，方便渲染haproxy和harbor的依赖配置
POSTGRES_RELEASE_NAME='postgres-ha'　# postgres的release名称，方便渲染harbor的依赖配置
HAPROXY_RELEASE_NAME='harbor-haproxy' #harbor haproxy的release 名称
HARBOR_RELEASE_NAME='harbor'　#harbor的release 名称
```

### 2. 执行prepare.sh脚本，渲染values模板
```
sh -x prepare.sh
```

```
执行prepare.sh会生成values目录，里面包含了各个组件的values.yaml  
执行prepare.sh会生成deploy.sh脚本，里面包含了helm upgrade安装各组件的命令
```

### 3. 查看修改生成出来的配置
#### **具体参考https://github.com/goharbor/harbor-helm**
```
如有需要，进行修改values目录下的各组件的配置文件
```

### 4. 进行安装集群
```
sh -x deploy.sh
```