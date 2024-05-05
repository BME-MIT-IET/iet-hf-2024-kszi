FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app


COPY . .

RUN dotnet restore "InForm.Server/InForm.Server.csproj"


RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app/InForm.Server
EXPOSE 44336
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "InForm.Server.dll"]