FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app


COPY . .

RUN dotnet restore

RUN dotnet publish  -c Release -o out


ENTRYPOINT [ "bash" ]

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/InForm.*/bin/Release .
RUN ls

# ENTRYPOINT ["dotnet", "InForm.Web.dll"]