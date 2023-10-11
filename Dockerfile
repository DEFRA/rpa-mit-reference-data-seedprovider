ARG PARENT_VERSION=1.5.0-dotnet6.0

# Development
FROM defradigital/dotnetcore-development:$PARENT_VERSION AS development

LABEL uk.gov.defra.parent-image=defra-dotnetcore-development:${PARENT_VERSION}

RUN mkdir -p /home/dotnet/rpa-mit-reference-data/RPA.MIT.ReferenceData.Data/ /home/dotnet/RPA.MIT.ReferenceData.SeedProvider/

COPY --chown=dotnet:dotnet ./rpa-mit-reference-data/RPA.MIT.ReferenceData.Data/*.csproj ./rpa-mit-reference-data/RPA.MIT.ReferenceData.Data/
RUN dotnet restore ./rpa-mit-reference-data/RPA.MIT.ReferenceData.Data/RPA.MIT.ReferenceData.Data.csproj

COPY --chown=dotnet:dotnet ./RPA.MIT.ReferenceData.SeedProvider/*.csproj ./RPA.MIT.ReferenceData.SeedProvider/
RUN dotnet restore ./RPA.MIT.ReferenceData.SeedProvider/RPA.MIT.ReferenceData.SeedProvider.csproj

COPY --chown=dotnet:dotnet ./RPA.MIT.ReferenceData.SeedProvider/ ./RPA.MIT.ReferenceData.SeedProvider/
COPY --chown=dotnet:dotnet ./rpa-mit-reference-data/RPA.MIT.ReferenceData.Data/ ./rpa-mit-reference-data/RPA.MIT.ReferenceData.Data/

RUN dotnet publish ./RPA.MIT.ReferenceData.SeedProvider/ -c Release -o /home/dotnet/out

WORKDIR /home/dotnet/out
CMD dotnet ./RPA.MIT.ReferenceData.SeedProvider.dll
