# escape=`

ARG PARENT_IMAGE
ARG TOOLS_IMAGE
ARG HEADLESS_SERVICES_IMAGE
ARG SXA_IMAGE

FROM ${TOOLS_IMAGE} as tools
FROM ${HEADLESS_SERVICES_IMAGE} AS headless_services
FROM ${SXA_IMAGE} as sxa
FROM ${PARENT_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\inetpub\wwwroot

# Copy developer tools and entrypoint
COPY --from=tools C:\tools C:\tools

# Add SXA module
COPY --from=sxa \module\cd\content .\
COPY --from=sxa \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Copy and init the JSS / Headless Services Module
COPY --from=headless_services C:\module\cd\content C:\inetpub\wwwroot
COPY --from=headless_services C:\module\tools C:\module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath C:\inetpub\wwwroot; `
    Remove-Item -Path C:\module -Recurse -Force;


ARG ENVIRONMENT

RUN Remove-Item -Path C:\inetpub\wwwroot\App_Config\Modules\SXA\Z.LayoutService\Sitecore.LayoutService.config -Force;