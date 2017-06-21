#!/bin/bash

# Check domain created
if [ ! -f ${DOMAIN_HOME}/servers/AdminServer/logs/AdminServer.log ]
then
    sed -i -e "s|welcome1|${ADMIN_PASSWORD}|g" /home/oracle/bin/create-domain.py
    wlst.sh -skipWLSModuleScanning /home/oracle/bin/create-domain.py
    # Create boot.properties
    mkdir -p ${DOMAIN_HOME}/servers/AdminServer/security/ 
    echo "username=weblogic" > ${DOMAIN_HOME}/servers/AdminServer/security/boot.properties 
    echo "password=$ADMIN_PASSWORD" >> ${DOMAIN_HOME}/servers/AdminServer/security/boot.properties 
    ${DOMAIN_HOME}/bin/setDomainEnv.sh 
    touch ${DOMAIN_HOME}/servers/AdminServer/logs/AdminServer.log
fi

# Start Admin Server
${DOMAIN_HOME}/startWebLogic.sh
