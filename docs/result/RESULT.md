# Fruits App - Flutter

Flutter приложение для подбора фруктов и составления рецептов на основе их пищевой ценности.

## Технологии

- **Flutter**: 3.35.7
- **Dart**: 3.9.2
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Networking**: Dio
- **Serialization**: json_serializable

## Функциональность

- ✅ Просмотр списка фруктов из API FruityVice
- ✅ Сортировка фруктов по названию и калориям
- ✅ Фильтрация фруктов по питательным свойствам (завтрак, тренировка, диета и т.п.)
- ✅ Добавление фруктов в избранное с сохранением на устройстве
- ✅ Просмотр детальной информации о фруктах
- ✅ Создание рецептов из избранных фруктов
- ✅ Просмотр суммарных питательных свойств рецептов
- ✅ Сохранение рецептов на устройстве

## Установка

1. Убедитесь, что у вас установлен Flutter 3.35.7:
```bash
flutter --version
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Сгенерируйте код:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Запустите приложение:
```bash
flutter run
```

## Генерация кода

Проект использует code generation для:
- JSON сериализации (`json_serializable`)
- Hive адаптеров (`hive_generator`)

После изменения моделей запустите:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Архитектура

Приложение следует принципам Clean Architecture:

- **Presentation Layer**: UI компоненты и провайдеры состояния
- **Domain Layer**: Бизнес-логика и use cases
- **Data Layer**: Источники данных (API и локальное хранилище)

## API

Приложение использует публичный API FruityVice:
- Документация: https://www.fruityvice.com/doc/index.html
- Endpoint: https://www.fruityvice.com/api/fruit/all

Авторизация не требуется.