#!/bin/bash

# This code loads the environment variables from the .env file.
. .env

# The purpose of this code is to exit immediately if any command in the script fails.
set -e

cd Identity

mkdir -p Data/mssql/data

run_cmd="dotnet Identity.dll"

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

# create a variable DatabaseConnectionString for MSSQL and set password from .env file where the container name is investordb and database name is  master, user is sa and password is from .env file
ConnectionStringName="ConnectionStrings:DefaultConnection"
DatabaseContainerName="localhost,1433"
DatabaseConnectionString="Server=${DatabaseContainerName};Database=master;User=sa;Password=${DatabasePassword};TrustServerCertificate=True;"
# Set DatabaseConnectionString as user
dotnet user-secrets init && dotnet user-secrets set "$ConnectionStringName" "$DatabaseConnectionString" --project .

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: 0 SECRETS SET UP $0 !!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: 1 SECRETS SET UP $1 !!!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"

dotnet tool update --global dotnet-ef

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"
>&2 echo "Running entrypoint.sh :: EF IS INSTALLED !!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11!!!!!!11!!!1!!!!!!11!!!!!"

dotnet build Identity.csproj 

now_hourly=$(date +%Y-%d-%b-%H_%M) 
>&2 echo "dotnet ef migrations add" $now_hourly"ChangeDatabase"
dotnet ef migrations add $now_hourly"ChangeDb" --context Identity.Data.ApplicationDbContext --output-dir Data/Migrations;

>&2 echo "dotnet ef database update"
until dotnet ef database update; do
>&2 echo "SQL Server is starting up --> " + $DatabaseConnectionString + " <-- --> " + $ConnectionStringName + " <--"
sleep 1
done

>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!1!"
>&2 echo "Migration done !!!!!!!11!!!!!"
>&2 echo "!!!11!!!!!!11!!!!!!11!!!!!!11"
