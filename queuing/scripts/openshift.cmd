cls
(oc login https://api.pro-eu-west-1.openshift.com -u "%CLOUD_USER%" -p "%CLOUD_PASS%") && ( 
    echo -- SUCCESSFULLY LOGGED IN
)  || (
    echo -- EXITING LOGIN FAILURE
    exit /b
)
(oc project migration-project) && (
    echo -- MIGRATION PROJECT ALREADY HERE -- 
) || (
    (oc new-project migration-project) && (
        echo -- SUCCESSFULLY CREATE PROJECT
    ) || (
        echo -- EXITING FAILED TO CREATE PROJECT 
        oc logout
        exit /b
    )
)
(oc describe svc postgresql-94-rhel7) && (
    echo -- postgresql-94-rhel7 ALREADY HERE 
) || (
    (oc new-app -e POSTGRESQL_USER=cnid_admin -e POSTGRESQL_PASSWORD=cnid_admin -e POSTGRESQL_DATABASE=mypostgredb registry.access.redhat.com/rhscl/postgresql-94-rhel7) && (
        echo -- SUCCESSFULLY CREATE PROGRES APP 
    ) || (
        echo -- EXITING FAILED TO CREATE PORGRES SERVICE
        oc logout
        exit /b
    )
)
(oc describe svc openshift-rabbitmq) && (
    echo --  openshift-rabbitmq EXISTS -- 
) || (
    (oc new-app luiscoms/openshift-rabbitmq:management) && (
        echo -- SUCCESSFULLy CREATED RABBITMQ SERVICE
    ) || (
        echo -- EXITING FAILED TO CREATE RABBITMQ SERVICE
        oc logout
        exit /b
    )
)
(oc describe build openjdk-app) && (
    echo --  openjdk-app EXISTS -- 
) || (
    (oc new-build https://github.com/cnidhiomasaigh/projects.git#develop --strategy=source -e OPENSHIFT_RABBITMQ_HOST=openshift-rabbitmq.migration-project.svc -e OPENSHIFT_RABBITMQ_POST=5672 --image-stream=openshift/redhat-openjdk18-openshift:1.2 --context-dir=queuing --name=openjdk-app) && (
         echo -- SUCCESSFULLy CREATED APP SERVICE
    ) || (
        echo -- EXITING FAILED TO CREATE APP SERVICE
        exit /b
    )
)
(oc start-build openjdk-app -n migration-project) && (
    echo -- SUCCESSFULLy BUILT APP SERVICE
) || (
    echo -- EXITING FAILED TO BUILD APP 
    oc logout
    exit /b
)
(oc describe svc openjdk-app) && (
    echo --  openjdk-app EXISTS -- CONTINUE
) || (
    (oc new-app openjdk-app -e OPENSHIFT_MYSQL_DB_USERNAME=cnid_admin -e OPENSHIFT_MYSQL_DB_PASSWORD=cnid_admin -e  OPENSHIFT_MYSQL_DB_HOST=jdbc:postgresql://postgresql-94-rhel7.migration-project.svc -e OPENSHIFT_MYSQL_DB_PORT=5432 -e OPENSHIFT_RABBITMQ_HOST=openshift-rabbitmq.migration-project.svc -e OPENSHIFT_RABBITMQ_POST=5672) && (
        echo -- SUCCESSFULLY CREATED THE SERVICE
        oc logout
        echo -- CHECK APP
        exit /b
    ) || (
        echo -- EXITING FAILED TO BUILD APP 
         oc logout
        exit /b
    )
)
(oc deploy openjdk-app) && (
    echo --  DEPLOYING 
) || (
    echo --  FAILED TO DEPLOY APP
)
echo --EXITING
oc logout
exit /b
