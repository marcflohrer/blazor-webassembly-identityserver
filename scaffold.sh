#!/bin/bash
. .env
# create a variable DatabaseConnectionString for MSSQL and set password from .env file where the container name is investordb and database name is  master, user is sa and password is from .env file
DatabaseContainerName="localhost,1433"
DatabaseConnectionString="Server=${DatabaseContainerName};Database=master;User=sa;Password=${DatabasePassword};TrustServerCertificate=True;"
dontnet user-secrets init --project InvestorDashboard/InvestorDashboard.csproj && dotnet user-secrets set ConnectionStrings:DefaultConnection "${DatabaseConnectionString};" --project InvestorDashboard/InvestorDashboard.csproj

set -e

mkdir -p mssql/data

run_cmd="dotnet InvestorDashboard.dll"

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!"
>&2 echo "Running entrypoint.sh !!!11!!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!"

until PATH="$PATH:/root/.dotnet/tools"; do
>&2 echo "Setting up env variables..."
sleep 1
done

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: PATH IS SET!!!11!!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"

ConnectionStringName="ConnectionStrings:DefaultConnection"
>&2 echo "!!!11!!ConnectionStringName set1!!!1!!!!!!11!!!!!!!!!!"
cd InvestorDashboard
dotnet user-secrets init && dotnet user-secrets set "$ConnectionStringName" "$1" --project .
>&2 echo "!!!11!!dotnet user-secrets init !!1!!!!!!11!!!!!!!!!!" 

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: 0 SECRETS SET UP $0 !!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: 1 SECRETS SET UP $1 !!!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"

dotnet tool update --global dotnet-ef

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: EF IS INSTALLED !!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"

dotnet build InvestorDashboard.csproj 

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: MS SQL DB RUNNING !!!!!!!!!11"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"

>&2 echo "SQL Server is up - starting scaffolding ..."
dotnet user-secrets init && dotnet user-secrets set "${ConnectionStringName}" "${DatabaseConnectionString}"
dotnet ef dbcontext scaffold Name="${ConnectionStringName}" Microsoft.EntityFrameworkCore.SqlServer -o DbModels -f --context ApplicationDbContext --context-dir DbModels --namespace InvestorDashboard.Models --context-namespace InvestorDashboard.Models

>&2 echo "SQL Server is up - done scaffolding ..."