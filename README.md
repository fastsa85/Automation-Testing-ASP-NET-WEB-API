# Automation-Testing-ASP-NET-WEB-API
Example project for testing simple ASP.NET Web API

Integration Tests - project spins up web api on local host, replace dependency to mssql database by "In Memory" database and runs tests against this web api instance.

EndToEnd tests - project spins up web api and sql server in docker containers and runs tests against this instance
Note: before run needs to execute "docker-compose up" from solution folder, web app will be available on:
http://localhost:7000/swagger/index.html
(this action will be also automated soon)

# Technologies and Tools:
C#.Net Core  
Asp.Net Core   
Entity Framework  
LINQ  
NUnit  
SpecFlow  
RestSharp  
FluentAssertions  
Dependecy Injection  
Docker  
