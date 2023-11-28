# escape=`

ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS prep
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy serialized items and script from the build context folder to the prep stage.

COPY ./solution /temp/
COPY ./scripts /temp/scripts/

# Copy Sitecore serialization *.module.json definitions to the image with keeping folders structure

RUN Invoke-Expression 'robocopy C:/temp/src C:/serialization/src /s /ndl /njh /njs *.module.json'

# Copy Sitecore serialization sitecore.json configuration to the image 

RUN Invoke-Expression 'robocopy C:/temp C:/serialization /s /ndl /njh /njs sitecore.json'

# Copy dotnet modules configuration to the image with keeping folders structure

RUN Invoke-Expression 'robocopy C:/temp/.config C:/serialization/.config /s /ndl /njh /njs dotnet-tools.json'

# Copy entrypoint  Entry.ps1 script to the image 

RUN Invoke-Expression 'robocopy C:/temp/scripts C:/serialization /s /ndl /njh /njs Entry.ps1'

# Execute CopyItems.ps1 script to copy serialized items to the image with keeping folders structure

RUN C:/temp/scripts/CopyItems.ps1

# Define the final build stage 

FROM ${BASE_IMAGE}

WORKDIR /artifacts


# Copy final build artifacts
COPY --from=prep ./serialization  ./

ENTRYPOINT ["powershell.exe", ".\\Entry.ps1"]
