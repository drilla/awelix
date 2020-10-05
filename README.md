# Awelix
*.secret.exs убраны, здесь в них нет смысла

- предварительно установить docker, docker-compose
- скопировать .env.dist > .env и заполнить значения.
- docker-compose build
- docker-compose up web
- для запуска тестов 
   перейти в папку с приложением
    
  1. mix test - без докера. тестам окружение не нужно
   ИЛИ
  2. вариант с докером
  docker-compose run web /bin/bash
  MIX_ENV=test mix test

Покрытие тестами:
 mix.coveralls

приложение в докер стартует самостояетльно. 
кэшу нужен разогрев. обычно это 15-20 сек
 

а дальше как обычно
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
если через полминуты не произошла загрузка - проверьте лог, скорее всего токен не указан