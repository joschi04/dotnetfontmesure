FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# install libgdiplus
#RUN apt-get update && apt-get install -y apt-utils libgdiplus libc6-dev fonts-freefont-ttf
RUN apt-get update

# install fontconfig
RUN apt-get update; apt-get install -y fontconfig

# refresh system font cache
RUN fc-cache -f -v
RUN fc-list
#RUN apt-get install -y fonts-freefont-ttf
COPY FreeSans.ttf /usr/share/fonts/truetype/freefont/FreeSans.ttf
RUN fc-cache -f -v
RUN fc-list
#RUN find / -iname "*font*" 
#RUN ls 
#RUN apt-get update -y && apt-get install -y apt-utils

#RUN apt-get install -y libgdiplus && apt-get install -y libc6-dev

# ---------
# MS CORE FONTS
# ---------
#Add these two lines
#RUN sed -i'.bak' 's/$/ contrib/' /etc/apt/sources.list
#RUN apt-get update; apt-get install -y ttf-mscorefonts-installer fontconfig

WORKDIR /src
COPY ["DotNetFontsMeasure.csproj", "./"]
RUN dotnet restore "DotNetFontsMeasure.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetFontsMeasure.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetFontsMeasure.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY --chown=appuser Logo_Datev.png /app/Logo_Datev.png
ENTRYPOINT ["dotnet", "DotNetFontsMeasure.dll"]
