NAMESPACE=backup
APP_NAME=backup

oc create ns $NAMESPACE
oc project $NAMESPACE

oc process -n $NAMESPACE -f openshift/app.bc.yaml -p REPO_NAME=$APP_NAME -p SOURCE_REPO_URL=https://github.com/ChrisPhillips-cminion/ocp-rsnapshot -p SOURCE_REPO_REF=main -o yaml | oc apply -n $NAMESPACE -f -

oc start-build -n $NAMESPACE $APP_NAME-app --follow

oc tag -n $NAMESPACE $APP_NAME-app:latest $APP_NAME-app:main

oc delete configmap rsnapshot-conf
oc create configmap rsnapshot-conf --from-file=./cm/rsnapshot.conf
oc create configmap ssh-key --from-file=~/.ssh/id_rsa

oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p APP_NAME=$APP_NAME -p SRC=/usr/rsnapshot/rsnapshot.conf -p TARGET=backup  -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -
