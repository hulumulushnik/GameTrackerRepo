# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# Перемикаємося на root, щоб встановити необхідні бібліотеки
USER root
RUN apt-get update && apt-get install -y --no-install-recommends libicu-dev && rm -rf /var/lib/apt/lists/*

# Повертаємо безпечного користувача назад
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Lesson_6(GameTracker)/Lesson_6(GameTracker).csproj", "Lesson_6(GameTracker)/"]
RUN dotnet restore "./Lesson_6(GameTracker)/Lesson_6(GameTracker).csproj"
COPY . .
WORKDIR "/src/Lesson_6(GameTracker)"
RUN dotnet build "./Lesson_6(GameTracker).csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Lesson_6(GameTracker).csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lesson_6(GameTracker).dll"]