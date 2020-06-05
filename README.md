# Automation-Testing-ASP-NET-WEB-API
Example project for testing simple ASP.NET Web API

Integration Tests - project spin up web api on local host, replace dependency to mssql database by "In Memory" database and runs tests agains this web api instance.

EndToEnd tests - project spin uo web api and sql server in docker containers and runs tests agains this instance
Note: before run needs to execute "docker-compose up" from solution folder, web app will be available on:
http://localhost:7000/swagger/index.html
(this action will be also automated soon)
