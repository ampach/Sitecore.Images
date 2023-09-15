# escape=`

ARG PARENT_IMAGE

FROM ${PARENT_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\Identity

# Copy identity artifacts
COPY ./Config /Identity/Config

ENTRYPOINT ["dotnet", "Sitecore.IdentityServer.Host.dll"]