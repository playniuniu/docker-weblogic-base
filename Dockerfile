FROM playniuniu/centos-serverjre:8
MAINTAINER playniuniu <playniuniu@gmail.com>

ENV FMW_PKG=fmw_12.2.1.2.0_wls_quick_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.2.0_wls_quick.jar \
    ORACLE_WEBLOGIC12_URL="http://download.oracle.com/otn/nt/middleware/12c/12212/fmw_12.2.1.2.0_wls_quick_Disk1_1of1.zip" \
    SCRIPT_FILE=/u01/oracle/createAndStartEmptyDomain.sh \
    ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    DEBUG_FLAG=true \
    PRODUCTION_MODE=dev \
    DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" \
    DOMAIN_HOME=/u01/oracle/user_projects/domains/${DOMAIN_NAME:-base_domain} \
    ADMIN_PORT="${ADMIN_PORT:-8001}" \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin

COPY config/install.file config/oraInst.loc /u01/
COPY container-scripts/createAndStartEmptyDomain.sh container-scripts/create-wls-domain.py /u01/oracle/

RUN chmod a+xr /u01 \
    && curl -jk#SLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /u01/${FMW_PKG} ${ORACLE_WEBLOGIC12_URL} \
    && chmod +xr $SCRIPT_FILE \
    && useradd -b /u01 -M -s /bin/bash oracle \
    && chown oracle:oracle -R /u01 \
    && echo oracle:oracle | chpasswd \
    && cd /u01 && $JAVA_HOME/bin/jar xf /u01/$FMW_PKG \
    && cd - \
    && su -c "$JAVA_HOME/bin/java -jar /u01/$FMW_JAR -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME" - oracle \
    && rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/oraInst.loc /u01/install.file

WORKDIR ${ORACLE_HOME} 

CMD ["/u01/oracle/createAndStartEmptyDomain.sh"]
