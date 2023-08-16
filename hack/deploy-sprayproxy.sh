#!/bin/bash

# ------------------------------------------------------------------------------------
# Spray Proxy that is used for distrubuting Github App requests to ephemeral clusters
# ------------------------------------------------------------------------------------
SPRAYPROXY_QE_TEM_DIR=/tmp/prayproxy-qe

echo
echo "Deploying SprayProxy on the cluster"
rm -rf ${SPRAYPROXY_QE_TEM_DIR} 2>/dev/null || true
git clone --depth=1 https://github.com/xinredhat/sprayproxy-qe.git -b update_variables ${SPRAYPROXY_QE_TEM_DIR}
cd "${SPRAYPROXY_QE_TEM_DIR}" || exit

${SPRAYPROXY_QE_TEM_DIR}/deploy.sh
# wait until sprayproxy is ready
kubectl wait --for=condition=available --timeout=180s deployment/sprayproxy -n sprayproxy

# verify sprayproxy is ready
# pod_name=$(kubectl get pods -n sprayproxy -l app=sprayproxy -o jsonpath='{.items[0].metadata.name}')
# token=$(kubectl exec -n sprayproxy "$pod_name" -c kube-rbac-proxy -i -t -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
# hostname=https://$(kubectl get -n sprayproxy -o template --template="{{.spec.host}}" route/sprayproxy-route)
# curl -k -X GET -H "Authorization: Bearer $token" "https://${hostname}/backends"

