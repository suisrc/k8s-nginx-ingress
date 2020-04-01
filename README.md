#说明

## 部署注意事项
该项目主要用于kubernetes部署nginx-ingress入口路由，为了防止跟既有的nginx发生冲突，最好选择部署节点
```
# 为节点增加标签
kubectl label nodes master.021 k8s3-ingress=worker
# 为节点删除标签
kubectl label nodes worker.102 k8s3-ingress-
```

当然完全可以忽略以上内容

默认部署会使用节点的30080和30442端口。

## 执行部署
```
kubectl apply -k https://raw.githubusercontent.com/suisrc/k8s-nginx-ingress/master/kustomization.yaml
```

在原有的quay.io/kubernetes-ingress-controller/nginx-ingress-controller上增加了geoip2的支持

免责声明：
    软件完全来自开源，由于geoip2有使用限制，内容仅供学习