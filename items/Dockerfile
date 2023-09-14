# escape=`

ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS prep
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

COPY ./solution /temp/
COPY ./scripts /temp/scripts/
RUN Invoke-Expression 'robocopy C:/temp/src C:/serialization/src /s /ndl /njh /njs *.module.json'
RUN Invoke-Expression 'robocopy C:/temp C:/serialization /s /ndl /njh /njs sitecore.json'
RUN Invoke-Expression 'robocopy C:/temp/.config C:/serialization/.config /s /ndl /njh /njs dotnet-tools.json'
RUN Invoke-Expression 'robocopy C:/temp/scripts C:/serialization /s /ndl /njh /njs Entry.ps1'
RUN C:/temp/scripts/CopyItems.ps1


FROM ${BASE_IMAGE}

WORKDIR /artifacts


# Copy final build artifacts
COPY --from=prep ./serialization  ./

ENTRYPOINT ["powershell.exe", ".\\Entry.ps1"]