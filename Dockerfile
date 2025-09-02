# Use latest stable Rust that supports edition 2024 + lockfile v4
FROM rustlang/rust:nightly as builder

WORKDIR /app
RUN apt update && apt install lld clang -y
COPY . .

# Enable SQLx offline mode
ENV SQLX_OFFLINE=true



# Build in release mode
RUN cargo build --release

FROM rustlang/rust:nightly AS runtime


# Runtime image (lightweight)
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /app/target/release/zero2prod .
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./zero2prod"]