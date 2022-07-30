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

oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=1 -p APP_NAME=$APP_NAME -p SRC=/usr/rsnapshot/rsnapshot.conf -p TARGET=backup  -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -


oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=2 -p APP_NAME=$APP_NAME -p SRC=cminion@dns.phillips11.cf:/etc/bind/ -p TARGET=dns  -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -

oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=3 -p APP_NAME=$APP_NAME -p SRC=core@192.168.1.37:/home/core/backup -p TARGET=ocp  -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -



oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=4 -p APP_NAME=$APP_NAME -p SRC=root@drydock.phillips11.cf:/var/install* -p TARGET=drydock/install  -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -
oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=5 -p APP_NAME=$APP_NAME -p SRC=root@drydock.phillips11.cf:/root/ -p TARGET=drydock/root -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -
oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=6 -p APP_NAME=$APP_NAME -p SRC=root@drydock.phillips11.cf:/etc/letsencrypt -p TARGET=drydock/certs -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -
oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=7 -p APP_NAME=$APP_NAME -p SRC=cminion@homebridge.phillips11.cf:/var/lib/homebridge -p TARGET=homebridge -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -
oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=8 -p APP_NAME=$APP_NAME -p SRC=cminion@pihole.phillips11.cf:/etc/pihole -p TARGET=pihole -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -
oc process -n $NAMESPACE -f openshift/app.cronjob.yaml -p CRON_SCHEDULE=9 -p APP_NAME=$APP_NAME -p SRC=cminion@blockbuster.phillips11.cf:/home/cminion/rdt -p TARGET=blockbuster -p INSTANCE=main -p NAMESPACE=$NAMESPACE -p REPO_NAME=$APP_NAME -o yaml | oc apply -n $NAMESPACE -f -

