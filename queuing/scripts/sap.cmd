cls
:: login to  platform | org | space
cf login -a api.cf.eu10.hana.ondemand.com -u cdempsey+sap@streets.ie -p Leix!ip1 -o P2000199689trial_trial -s dev
:: provision the services
echo -- CREATING POSTGRES SERVICES
(cf service postgresqlservice) && (
        echo -- postgresqlservice ALREADY EXISTS
) || (
    echo -- CREATING postgresqlservice
    (cf create-service postgresql v9.4-dev postgresqlservice) && (
            echo -- postgresqlservice CREATED
    )  || (
            echo -- FAILURE postgresqlservice CREATION FAILED
            exit /b
    )
)
echo -- CREATING RABBITMQ SERVICES
(cf service rabbitmqservice) && (
    echo -- rabbitmqservice ALREADY EXISTS
) || (
    echo -- create-service rabbitmqservice
    (cf create-service rabbitmq v3.6-dev rabbitmqservice) && (
            echo -- rabbitmqservice CREATED
    )  || (
            echo -- FAILURE rabbitmqservice CREATION FAILED
            exit /b
    )
)
:: deploy app
echo -- DEPLOYING APP
(cf push) && (
    echo -- SUCCESS
    exit /b
) || (
    echo -- FAILURE DEPLOY
    exit /b
)
