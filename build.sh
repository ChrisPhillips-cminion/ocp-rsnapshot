NAMESPACE=backup
APP_NAME=backup
#git clone https://github.com/ChrisPhillips-cminion/clamav-mirror/

#cd clamav-mirror

oc create ns $NAMESPACE
oc project $NAMESPACE

oc process -n $NAMESPACE -f openshift/app.bc.yaml -p REPO_NAME=clamav-mirror -p SOURCE_REPO_URL=https://github.com/ChrisPhillips-cminion/clamav-mirror.git -p SOURCE_REPO_REF=master -o yaml | oc apply -n $NAMESPACE -f -

oc start-build -n $NAMESPACE $APP_NAME-app --follow

oc tag -n $NAMESPACE $APP_NAME-app:latest $APP_NAME-app:master

oc delete configmap rsnapshot-conf
oc create configmap rsnapshot-conf --from-file=./cm/rsnapshot.conf
oc create configmap ssh-key --from-file=~/.ssh/id_rsa

oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p APP_NAME=$APP_NAME -p UNIT=daily -p SRC=/usr/rsnapshot/rsnapshot.conf -p TARGET=backup  -p INSTANCE=master -p NAMESPACE=$NAMESPACE -p REPO_NAME=clamav-mirror -o yaml | oc apply -n $NAMESPACE -f -
