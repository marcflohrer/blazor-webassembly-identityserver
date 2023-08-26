. .env
docker rm mssql migration
# create a variable DatabaseConnectionString for MSSQL and set password from .env file where the database ontainer name is db and database name is  master, user is sa and password is from .env file
DatabaseContainerName="investordb"
DatabaseConnectionString="Server=${DatabaseContainerName};Database=master;User=sa;Password=${DatabasePassword};TrustServerCertificate=True;"
dotnet user-secrets set ConnectionStrings:DefaultConnection "${DatabaseConnectionString};" --project .
docker compose -f docker-compose-dbmigrate.yml up --build --remove-orphans 
