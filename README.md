# Elysia with Bun runtime

## Getting Started
To get started with this template, simply paste this command into your terminal:
```bash
bun create elysia ./elysia-example
```

## Development
To start the development server run:
```bash
bun run dev
```

Open http://localhost:3000/ with your browser to see the result.

## Menggunakan Docker untuk server database postgresql
Pertama-tama, setup docker terlebih dahulu

Step 1 
Install docker
https://docs.docker.com/get-docker/

check version docker
```bash
docker --version
```

Step 2
Karena saya menggunakan postgresql, maka saya akan menggunakan image postgres
```bash
docker pull postgres
```
Untuk melihat image yang sudah di download
```bash
docker images
```
Step 3
Membuat container
```bash
docker run --name itkombat-db -e POSTGRES_USER=prince -e POSTGRES_PASSWORD=admin 
-e POSTGRES_DB=itkombat -p 5433:5432 -d postgres
```
Kenapa memakai 5433:5432?
Karena saya sudah menggunakan port 5432 untuk postgresql yang sudah terinstall di laptop saya, 
maka saya menggunakan port 5433. Jika menggunakan port 5432:5432, maka yang akan terjadi error 
karena port 5432 itu digunakan oleh postgresql yang sudah terinstall di laptop saya
bukan dari docker

Jadi port 5433:5432 itu artinya port 5433 di docker diarahkan ke port 5432 di laptop saya yaitu menuju laptop saya
Jika 5433:5433 yang terjadi yaitu error karena port 5433 di docker tidak ada yang mendengarkan port tersebut

Untuk melihat container yang sudah berjalan
```bash
docker ps
```

Step 4
Mengakses container
```bash
docker exec -it itkombat-db bash
```
Untuk keluar dari container
```bash
exit
```

Step 5
Mengakses database
```bash
docker exec -it itkombat-db psql -U prince -d itkombat
```
Untuk keluar dari database
```bash
\q
```

Step 6 
Mengakses database dengan menggunakan DBeaver
-> Buka DBeaver -> Database ->
-> Select your database -> PostgreSQL ->
-> Host : localhost -> Port : 5433 -> Database : itkombat -> 
-> Username : prince -> Password : admin -> Test Connection 
-> Finish

Untuk Test Connection, jika berhasil akan muncul dialog box Connection test 
Memunculkan server version, server time, dan server timezone dari Debian (untuk docker)

Step 7
Menginstall Image pgAdmin4 untuk mengakses database dengan web browser
```bash
docker pull dpage/pgadmin4
```

Step 8
Membuat container
```bash
docker run --name itkombat-admin -p 80:80 
-e PGADMIN_DEFAULT_EMAIL princenizroh7@gmail.com 
-e PGADMIN_DEFAULT_PASSWORD=admin
-d dpage/pgadmin4
```

Step 9
Inspect container untuk melihat IP Address
Cari IP Address pada container itkombat-db
```bash
docker ps -a 
docker inspect <container_id>
```

Step 10
Mengakses pgAdmin4
```bash
http://localhost:80
```
Untuk login
```bash
Email : princenizroh7@gmail.com
Password : admin
```

Step 11
Register server
-> Klik kanan Servers -> Create -> Server ->
-> Name : itkombat-server -> Connection -> 
-> Hostname/address : <IP Address container itkombat-db> -> 
-> Port : 5432 -> Maintenance database : itkombat ->
-> Username : prince -> Password : admin -> Save

Step 12
Mengakses database
-> Servers -> itkombat-server -> Databases -> itkombat

Step 13 
Menghentikan container
```bash
docker stop itkombat-db
```

Step 14
Menghapus container
```bash
docker rm itkombat-db
```

Step 15
Menghapus image
```bash
docker rmi postgres
```

Step 16
Menghapus semua container yang berjalan
```bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

Step 17
Menghapus semua image
```bash
docker rmi $(docker images -q)
```

## Menggunakan dbmate untuk migrasi database
Step 1
Install dbmate
```bash
scoop install dbmate
```

Step 2
Membuat file dbmate
```bash
dbmate new <nama_tabel>
```

Step 3
Membuat file migrasi
```bash
dbmate up
```

Step 4
Menghapus file migrasi
```bash
dbmate down
```

Step 5
Menghapus semua file migrasi
```bash
dbmate drop
```

## Menggunakan Docker compose untuk konfigurasi container database
Step 1
Membuat file docker-compose.yml
Isi file docker-compose.yml
Kebetulan file docker-compose.yml sudah dibuat

Step 2
Membuat container
```bash
docker-compose up -d
```
Step 3
Menghentikan container
```bash
docker-compose down
```


