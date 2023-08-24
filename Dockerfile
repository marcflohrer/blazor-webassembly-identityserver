#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0-bookworm-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

RUN dotnet dev-certs https

COPY ["./Client/BlazorWasm.Client.csproj", "Client/"]
COPY ["./Server/BlazorWasm.Server.csproj", "Server/"]
COPY ["./Shared/BlazorWasm.Shared.csproj", "Shared/"]
RUN dotnet restore "Server/BlazorWasm.Server.csproj"
COPY . .

RUN dotnet build "Server/BlazorWasm.Server.csproj" -c Release
RUN ls -lisah

FROM build AS publish
RUN dotnet publish "Server/BlazorWasm.Server.csproj" -c Release -o /app/Server/publish --no-restore

FROM base AS final
WORKDIR /app

EXPOSE 44461 44462

COPY --from=build /root/.dotnet/corefx/cryptography/x509stores/my/* /root/.dotnet/corefx/cryptography/x509stores/my/
COPY --from=publish /app/Server/publish .

ENTRYPOINT ["dotnet", "BlazorWasm.Server.dll"]
