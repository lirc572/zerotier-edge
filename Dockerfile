FROM docker.io/library/node:21-slim as frontend-builder

WORKDIR /app
COPY . .
RUN corepack enable
RUN pnpm install && pnpm run build-ui


FROM docker.io/library/rust:1.77-slim as backend-builder

WORKDIR /app
COPY . .
COPY --from=frontend-builder /app/webui/dist /app/webui/dist
RUN cargo build --release


FROM docker.io/library/debian:bookworm-slim

WORKDIR /app
COPY --from=backend-builder /app/target/release/zerotier-edge /app/zerotier-edge
ENTRYPOINT ["/app/zerotier-edge"]
