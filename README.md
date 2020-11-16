Для сборки Docker-image по Dockerfile использовать команду: docker build . -t judge0/judge0:mytest1

Для развёртывания контейнера на основе собранного Docker-image judge0/judge0:mytest1, необходимо проверить что нужный image прописан в файле docker-compose.yml. 

Развернуть контейнер с помощью команд:
1) docker-compose up -d db redis
2) docker-compose up -d

Ссылка на api исходного проекта: https://ce.judge0.com/