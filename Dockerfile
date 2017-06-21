FROM playniuniu/oracle-server-jre:8
LABEL maintainer="playniuniu@gmail.com"

ENV FMW_PKG=fmw_12.2.1.2.0_wls_quick_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.2.0_wls_quick.jar \
    WEBLOGIC_DOWNLOAD_LINK="https://storage.googleapis.com/weblogic/${FMW_PKG}" \
    ORACLE_HOME=/home/oracle/weblogic/ \
    DOMAIN_NAME=${DOMAIN_NAME:-base_domain} \
    DOMAIN_HOME=/home/oracle/domains/${DOMAIN_NAME:-base_domain} \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    ADMIN_PORT=8001 \
    ADMIN_PASSWORD=welcome1 \
    PATH=$PATH:/home/oracle/weblogic/oracle_common/common/bin

COPY files/install.file files/oraInst.loc /tmp/
COPY scripts/create-domain.py scripts/create-domain.sh /tmp/

RUN useradd -m -s /bin/bash oracle \
    && echo oracle:oracle | chpasswd \
    && curl -#SL ${WEBLOGIC_DOWNLOAD_LINK} -o /tmp/$FMW_PKG \
    && cd /tmp \
    && $JAVA_HOME/bin/jar xf /tmp/$FMW_PKG \
    && su - oracle -c "mkdir /home/oracle/bin/" \
    && su - oracle -c "$JAVA_HOME/bin/java -jar /tmp/$FMW_JAR -ignoreSysPrereqs -force -novalidation \
    -invPtrLoc /tmp/oraInst.loc -jreLoc $JAVA_HOME ORACLE_HOME=${ORACLE_HOME}" \
    && mv /tmp/create-domain.py /tmp/create-domain.sh /home/oracle/bin/ \
    && rm -rf /tmp/*

EXPOSE ${ADMIN_PORT}
USER oracle
WORKDIR /home/oracle
CMD ["/home/oracle/bin/create-domain.sh"]
