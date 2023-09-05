ARG PARENT_IMAGE

#FROM ${PARENT_IMAGE} as dependencies
FROM ${PARENT_IMAGE} as builder
USER ContainerAdministrator
WORKDIR /app
COPY . .
COPY package.json ./
RUN npm install
USER ContainerUser

#FROM ${PARENT_IMAGE} as builder
#WORKDIR /app
#COPY . .
#COPY --from=dependencies /app/node_modules ./node_modules
#ENV NEXT_TELEMETRY_DISABLED 1
#RUN npm run build

FROM ${PARENT_IMAGE} as runner
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
USER ContainerAdministrator
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# If you are using a custom next.config.js file, uncomment this line.

COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/tsconfig.scripts.json ./tsconfig.scripts.json
COPY --from=builder /app/tsconfig.json ./tsconfig.json
COPY --from=builder /app/next-env.d.ts ./next-env.d.ts
COPY --from=builder /app/public ./public
#COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/src ./src
COPY --from=builder /app/sitecore ./sitecore
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/.graphql-let.yml ./.graphql-let.yml

USER ContainerUser

EXPOSE 80
EXPOSE 443
ENTRYPOINT ["powershell.exe", "npm run start:production"]
