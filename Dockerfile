FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Виправлені шляхи: тепер Docker шукає файл у тій самій папці
COPY ["Lesson_6(GameTracker).csproj", "."]
RUN dotnet restore "./Lesson_6(GameTracker).csproj"

COPY . .
WORKDIR "/src/."
RUN dotnet build "./Lesson_6(GameTracker).csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Lesson_6(GameTracker).csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lesson_6(GameTracker).dll"]
