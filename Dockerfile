FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app


COPY . .

RUN dotnet restore

RUN dotnet publish  -c Release -o out




# RUN ls


FROM nginx:alpine
WORKDIR /app
EXPOSE 80


COPY --from=build-env /app/out/wwwroot /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf



# FROM mcr.microsoft.com/dotnet/aspnet:8.0
# EXPOSE 44336
# WORKDIR /app/InForm.Server
# COPY --from=build-env /app/out .
# ENTRYPOINT [ "dotnet","InForm.Server.dll" ]