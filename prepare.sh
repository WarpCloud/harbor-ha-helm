#!/bin/bash
set -e
set -x 

basedir=$(cd `dirname $0`; pwd)

source ${basedir}/harbor.cfg
if [ "${HARBOR_DEPLOY_TYPE}" == "nodeport" -a "${CLUSTER_MASTER_IP}" == "" ];then
   echo "CLUSTER_MASTER_IP: is valid, which cannot be null ..."
   exit 1
fi

if [ "${HARBOR_DEPLOY_TYPE}" != "nodeport" -o "${HARBOR_DEPLOY_TYPE}" != "ingress"  ] ;then
  echo "harbor only support nodeport/ingress(HARBOR_DEPLOY_TYPE) install"
  exit 1
fi

[ ! -e ${basedir}/templates ] && echo "cannot found values templates" && exit 1
[ -e ${basedir}/values ] && rm -rf ${basedir}/values && mkdir -p ${basedir}/values/

# prepare postgres-ha
echo "begin render postgresql ha template"
[ ! -e ${basedir}/templates/postgres-ha-values.yaml ] && echo "cannot found postgresql values templates" && exit 1
cp -r ${basedir}/templates/postgres-ha-values.yaml ${basedir}/values/postgres-ha-values.yaml
[ ! -e ${basedir}/values/postgres-ha-values.yaml ] && echo "render postgres ha template fail..."  && exit 1
echo "render postgresql ha template suc.."

# prepare redis-ha
echo "begin render redis ha template"
[ ! -e ${basedir}/templates/redis-ha-values.yaml ] && echo "cannot found redis values templates" && exit 1
cp -r ${basedir}/templates/redis-ha-values.yaml ${basedir}/values/redis-ha-values.yaml
[ ! -e ${basedir}/values/redis-ha-values.yaml ] && echo "render redis ha template fail..."  && exit 1
echo "render redis ha template suc.."

# prepare harbor haproxy
echo "begin render haproxy template"
[ ! -e ${basedir}/templates/haproxy-values.yaml.tmpl ] && echo "cannot found haproxy values templates" && exit 1
set -e
${basedir}/envtpl -m error ${basedir}/templates/haproxy-values.yaml.tmpl > ${basedir}/values/haproxy-values.yaml
set +e
[ ! -e ${basedir}/values/haproxy-values.yaml ] && echo "render haproxy template fail..."  && exit 1
echo "render harbor haproxy template suc.."

# prepare harbor
echo "begin render harbor template"
[ -e ${basedir}/templates/harbor-${HARBOR_DEPLOY_TYPE}-values.yaml.tmpl ] && echo "cannot found harbor ${HARBOR_DEPLOY_TYPE} values templates" && exit 1
set -e
${basedir}/envtpl -m error ${basedir}/templates/harbor-${HARBOR_DEPLOY_TYPE}-values.yaml.tmpl > ${basedir}/templates/harbor-${HARBOR_DEPLOY_TYPE}-values.yaml
set +e
[ ! -e ${basedir}/values/harbor-${HARBOR_DEPLOY_TYPE}-values.yaml ] && echo "render harbor ${HARBOR_DEPLOY_TYPE} template fail..." && exit 1

[ -e ${basedir}/deploy.sh ] && rm -f ${basedir}/deploy.sh

cat > ${basedir}/deploy.sh <<EOF
echo "begin install postgres ha..."
helm --namespace ${NAMESPACE} upgrade -i -f ${basedir}/values/postgres-ha-values.yaml ${POSTGRES_RELEASE_NAME} ${basedir}/charts/postgresql
echo "install postgres ha suc..."

# install redis-ha
echo "begin install redis ha..."
helm --namespace ${NAMESPACE} upgrade -i -f ${basedir}/values/redis-ha-values.yaml ${REDIS_RELEASE_NAME} ${basedir}/charts/redis-ha
echo "install redis ha suc..."

# install harbor haproxy
echo "begin install harbor haproxy.."
helm --namespace ${NAMESPACE} upgrade -i -f ${basedir}/values/haproxy-values.yaml ${HAPROXY_RELEASE_NAME} ${basedir}/charts/harbor-haproxy
echo "install harbor haproxy suc..."

# install harbor
echo "begin install harbor.."
echo "HARBOR_DEPLOY_TYPE: ${HARBOR_DEPLOY_TYPE}"
helm --namespace ${NAMESPACE} upgrade -i -f ${basedir}/values/harbor-${HARBOR_DEPLOY_TYPE}-values.yaml ${HARBOR_RELEASE_NAME} ${basedir}/charts/harbor-helm
echo "install harbor suc..."
EOF

chmod a+x ${basedir}/deploy.sh




