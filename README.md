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
### 1. 部署postgresqlHA
```
helm --namespace=harbor upgrade -i postgresql-ha ./postgresql
```

### 2. 部署redisHA
```
helm --namespace=harbor upgrade -i redis-ha ./redis-ha
```

### 3. 部署harbor-haproxy
#### **注意修改values.yaml，里面填写的第2步redis的地址**
```
helm --namespace=harbor upgrade -i harbor-haproxy ./harbor-haproxy
```

### 3. 部署harbor
#### **具体参考https://github.com/goharbor/harbor-helm**
```
helm --namespace=harbor upgrade -i harbor -f harbor-helm/values-ingress.yaml ./harbor-helm
```
或者
```
helm --namespace=harbor upgrade -i harbor -f harbor-helm/values-nodeport.yaml ./harbor-helm
```