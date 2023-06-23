# RPA.MIT.ReferenceData.SeedProvider
A minimal api for supplying invoice template reference data (.NET 6)

## Running Application
### Requirements
* Git
* .NET 6 SDK
* PostgreSQL
* Access to the DEFRA-EST ADO Artifact Feed
* **Optional:** Docker - Only needed if running PostgreSQL within container

### Environment Variables
The following environment variables are required by the application.

| Name              	| Description                         	| Default                         	|
|-------------------	|-------------------------------------	|---------------------------------	|
| POSTGRES_HOST     	| Hostname of the Postgres server     	| rpa-mit-reference-data-postgres 	|
| POSTGRES_DB       	| Name of the reference data database 	| rpa_mit_reference_data          	|
| POSTGRES_USER     	| Postgres username                   	| postgres                        	|
| POSTGRES_PASSWORD 	| Postgres password                   	| password                        	|
| POSTGRES_PORT     	| Postgres server port                	| 5432                            	|
| SCHEMA_DEFAULT    	| Default schema name                 	| public                          	|

When running using Docker / Docker Compose these values are populated from environment variables.

If running locally using `dotnet run` the values are populated from dotnet user-secrets. Please see [Safe storage of app secrets in development in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets?view=aspnetcore-6.0&tabs=windows)

### Add Private Package Feed
This project uses a private NuGet package to store seed data.

Follow this guide to add the private feed to Visual Studio:
[Install NuGet packages with Visual Studio](https://learn.microsoft.com/en-us/azure/devops/artifacts/nuget/consume?view=azure-devops&tabs=windows)

### Seeding Reference Data
**Important**: The seed ref data provider will reset the connected database to reference data defaults.

The seed provider uses dotnet user secrets to store Postgres connection parameters.
```cs
cd RPA.MIT.ReferenceData.SeedProvider
dotnet run
```

This application dynamically seeds reference data into the database based on Json files from the `RPA.MIT.Reference` package.

#### Export Reference Data
You can export the seed data to SQL scripts by using `docker-compose.seed.yaml`.

```ps
docker compose -f docker-compose.seed.yaml
```

The seed operation has completed when the following log entry is displayed:
```log
info: Program[0]
      Seeding reference data completed in 14 seconds
```

Once the logs show that the seed operation has completed, run the following command to dump tables:
```ps
docker exec -it rpa-mit-referencedata-rpa-mit-reference-data-postgres-1 sh /home/postgres/extract-seed-data.sh
```

This will store the SQL INSERT scripts for each table in the `mit_reference_data` database in `{SOLUTION_DIR}/seed-data-scripts`.
