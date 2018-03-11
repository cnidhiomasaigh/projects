cls
:: login to  platform | org | space
(cf login -a api.run.pivotal.io -u cdempsey+pivotal@streets.ie -p Leix!ip1 -o cdempsey-org -s development) && (
             echo -- SUCCESSFULLY LOGGED IN
        )  || (
            echo -- EXITING LOGIN FAILURE
            exit /b
        )

:: provision the services
echo -- CREATING POSTGRES SERVICES
(cf service postgresqlservice) && (
        echo -- SKIP CREATE POSTGRES SERVICE -- ALREADY EXISTS
    ) || (
        echo -- CREATING postgresqlservice
        (cf create-service elephantsql turtle postgresqlservice) && (
             echo -- POSTGRES SERVICE CREATED
        )  || (
            echo -- EXITING POSTGRES SERVICE CREATION FAILED
            cf logout
            exit /b
        )
    )
    echo -- CREATING RABBITMQ SERVICES
    (cf service rabbitmqservice) && (
        echo -- SKIP CREATE RABBITMQ SERVICE -- ALREADY EXISTS
    ) || (
        echo -- CREATE RABBITMQ SERVICE
        (cf create-service cloudamqp lemur rabbitmqservice) && (
             echo --RABBITMQ SERVICE CREATED
        )  || (
            echo -- EXITING RABBITMQ SERVICE CREATION FAILED
            cf logout
            exit /b
        )
    )

    :: deploy app
    echo -- DEPLOYING APP
    (cf push) && (
        echo -- SUCCESS
        cf logout
        exit /b
    ) || (
        echo -- EXITING DEPLOY FAILURE
        cf logout
        exit /b
    )
cf logout