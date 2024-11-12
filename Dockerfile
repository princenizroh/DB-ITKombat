# Gunakan image resmi PostgreSQL
FROM postgres:latest AS postgres

# Set environment variables untuk PostgreSQL
ENV POSTGRES_USER=prince
ENV POSTGRES_PASSWORD=admin123
ENV POSTGRES_DB=itkombat

# Buat stage baru untuk aplikasi Bun
FROM jarredsumner/bun:latest AS bun

# Buat direktori kerja untuk aplikasi
WORKDIR /app

# Salin file bun.lockb dan package.json
COPY bun.lockb package.json ./

# Install dependencies
RUN bun install

# Expose port yang digunakan oleh aplikasi Bun
EXPOSE 3000

# Jalankan aplikasi Bun
CMD ["bun", "run", "start"]