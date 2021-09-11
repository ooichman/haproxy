# haproxy
the HAproxy Container build directory

## How to use
This directory is a simple conatiner image build of HAproxy for redirecting TCP traffic.  
This Container image can be used to manage external service as a Kubernetes Cluster resource.

## Build the Image :

In order to build the image run the following steps :
```bash
# git clone https://github.com/ooichman/haproxy.git
# cd haproxy/
# buildah bud -f Containerfile -t haproxy
```

Once the Image is builded we can go ahead and deploy it :  

First create the projet :

```bash
# oc create ns haproxy-hs

```

Now let's deploy the image :
```bash
# export PORT_NUMBER=9100
# cat > deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: haproxy
spec:
  selector:
    matchLabels:
      app: haproxy
  replicas: 1
  template:
    metadata:
      labels:
        app: haproxy
    spec:
      containers:
        - name: haproxy
          image: quay.io/ooichman/haproxy:latest
          imagePullPolicy: Always
          ports:
            - containerPort: ${PORT_NUMBER}
          env:
          - name: DST_SERVER
            value: '192.168.1.1'
          - name: DST_PORT
            value: \'${PORT_NUMBER}\'
          - name: SRC_PORT
            value: \'${PORT_NUMBER}\'
EOF
# oc create -f deployment.yaml
```

and the Service
```bash
# cat > service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: haproxy
spec:
  selector:
    app: haproxy
  ports:
    - protocol: TCP
      port: ${PORT_NUMBER}
      targetPort: ${PORT_NUMBER}
EOF
# oc apply -f service.yaml
```

Now you can direct request to the HAproxy service and it will be sent to the extrenal service