# Test Specifitation

## Описание проекта
Данный проект – Rails-API-приложение, в котором реализована декларативная бизнес-логика создания пользователя с помощью [ActiveInteraction](https://github.com/AaronLasseigne/active_interaction). В проекте исправлены опечатки и связи, а также написаны тесты для проверки работы сервиса.

## Стек технологий
- Ruby 3.3.1
- Ruby on Rails 7.2.2.1
- Sqlite3

## Запуск проекта (инструкция для Linux)

### Rails API
1. Клонируйте репозиторий:
    - HTTPS
    ```sh
    https://github.com/IvanGaevskiy/test-specification.git
    ```
    - SSH
    ```sh
    git@github.com:IvanGaevskiy/test-specification.git
    ```

2. В консоли перейдите в папку с проектом:

3. Установите зависимости:
   ```sh
   bundle install
   ```
4. Настройте базу данных:
   ```sh
   rails db:create 
   rails db:migrate
   ```
   
4. Запустите тесты:
   ```sh
   rspec spec/interactions/users/create_spec.rb
   ```

5. Запустите сервер:
   ```sh
   rails s
   ```


## API

### Добавление пользователя
```sh
curl -X POST http://localhost:3000/api/users   -H "Content-Type: application/json"   -d '{
        "surname": "Иванов",
        "name": "Иван",
        "patronymic": "Иванович",
        "email": "ivan@example.com",
        "age": 20,
        "nationality": "русский",
        "country": "Россия",
        "gender": "male",
        "interests": ["гиря", "кот"],
        "skills": "ноутбук, пк"
      }'

```

## Другой вариант исправления опечатки
```ruby
class Skil < ApplicationRecord
  has_and_belongs_to_many :users, class_name: 'Skil'
end
```

## Контакты
Автор: Иван Гаевский

Telegram: https://t.me/Ivan_Ruby_Developer

