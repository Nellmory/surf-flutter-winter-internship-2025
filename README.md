# Fruit App

Nutrition-tech приложение, которое помогает подбирать фрукты и составлять из них рецепты под разные цели (завтрак, тренировка, диета и т. п.) на основе их пищевой ценности, с избранным и умными фильтрами.

## Требования к приложению

- Версия Flutter: **3.35.7**
- Версия Dart: **3.9.2**
- Поддержка ОС: **Android и (или) iOS**

## Описание приложения

Приложение должно предоставлять следующие функции:

- Просмотр списка фруктов из публичного API
- Сортировка и фильтрация фруктов по различным параметрам
- Просмотр пищевой ценности фруктов
- Добавление избранных фруктов в список и сохранение его на устройстве
- Создание рецептов из избранных фруктов и сохранение их на устройстве

### Архитектура
- Использовать паттерн(ы) проектирования на выбор
- Рекомендуется разделение на слои: презентационный слой, слой бизнес-логики, слой данных и т.п.
- Локальное хранилище для избранного и рецептов

### Примечания
- Сортировка и фильтрация проиcходит локально на устройстве. Не нужно делать запросы к API для этого.
- UI (конкретный визуальный дизайн, набор и стили виджетов, расположение элементов) может быть произвольным, за исключением верхнеуровневых требований из ТЗ (табы, экраны и основные состояния).
- UX (пользовательские сценарии, логика экранов) описан в данном ТЗ, и ему необходимо следовать.

## Api

Данные о фруктах, их пользе и питательных свойствах.

https://www.fruityvice.com/doc/index.html

https://thefreeapi.com/free-api/fruityvice-api

Авторизация не нужна

### Документация
https://www.fruityvice.com/doc/index.html 

### Запросы

#### Получить все фрукты
GET https://www.fruityvice.com/api/fruit/all

<details>
  <summary>Тело ответа</summary>

```
[
  {
    "name": "Persimmon",
    "id": 52,
    "family": "Ebenaceae",
    "order": "Rosales",
    "genus": "Diospyros",
    "nutritions": {
      "calories": 81,
      "fat": 0.0,
      "sugar": 18.0,
      "carbohydrates": 18.0,
      "protein": 0.0
    }
  },
  {
    "name": "Strawberry",
    "id": 3,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Fragaria",
    "nutritions": {
      "calories": 29,
      "fat": 0.4,
      "sugar": 5.4,
      "carbohydrates": 5.5,
      "protein": 0.8
    }
  },
  {
    "name": "Banana",
    "id": 1,
    "family": "Musaceae",
    "order": "Zingiberales",
    "genus": "Musa",
    "nutritions": {
      "calories": 96,
      "fat": 0.2,
      "sugar": 17.2,
      "carbohydrates": 22.0,
      "protein": 1.0
    }
  },
  {
    "name": "Tomato",
    "id": 5,
    "family": "Solanaceae",
    "order": "Solanales",
    "genus": "Solanum",
    "nutritions": {
      "calories": 74,
      "fat": 0.2,
      "sugar": 2.6,
      "carbohydrates": 3.9,
      "protein": 0.9
    }
  },
  {
    "name": "Pear",
    "id": 4,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Pyrus",
    "nutritions": {
      "calories": 57,
      "fat": 0.1,
      "sugar": 10.0,
      "carbohydrates": 15.0,
      "protein": 0.4
    }
  },
  {
    "name": "Durian",
    "id": 60,
    "family": "Malvaceae",
    "order": "Malvales",
    "genus": "Durio",
    "nutritions": {
      "calories": 147,
      "fat": 5.3,
      "sugar": 6.75,
      "carbohydrates": 27.1,
      "protein": 1.5
    }
  },
  {
    "name": "Blackberry",
    "id": 64,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Rubus",
    "nutritions": {
      "calories": 40,
      "fat": 0.4,
      "sugar": 4.5,
      "carbohydrates": 9.0,
      "protein": 1.3
    }
  },
  {
    "name": "Lingonberry",
    "id": 65,
    "family": "Ericaceae",
    "order": "Ericales",
    "genus": "Vaccinium",
    "nutritions": {
      "calories": 50,
      "fat": 0.34,
      "sugar": 5.74,
      "carbohydrates": 11.3,
      "protein": 0.75
    }
  },
  {
    "name": "Kiwi",
    "id": 66,
    "family": "Actinidiaceae",
    "order": "Struthioniformes",
    "genus": "Apteryx",
    "nutritions": {
      "calories": 61,
      "fat": 0.5,
      "sugar": 9.0,
      "carbohydrates": 15.0,
      "protein": 1.1
    }
  },
  {
    "name": "Lychee",
    "id": 67,
    "family": "Sapindaceae",
    "order": "Sapindales",
    "genus": "Litchi",
    "nutritions": {
      "calories": 66,
      "fat": 0.44,
      "sugar": 15.0,
      "carbohydrates": 17.0,
      "protein": 0.8
    }
  },
  {
    "name": "Pineapple",
    "id": 10,
    "family": "Bromeliaceae",
    "order": "Poales",
    "genus": "Ananas",
    "nutritions": {
      "calories": 50,
      "fat": 0.12,
      "sugar": 9.85,
      "carbohydrates": 13.12,
      "protein": 0.54
    }
  },
  {
    "name": "Fig",
    "id": 68,
    "family": "Moraceae",
    "order": "Rosales",
    "genus": "Ficus",
    "nutritions": {
      "calories": 74,
      "fat": 0.3,
      "sugar": 16.0,
      "carbohydrates": 19.0,
      "protein": 0.8
    }
  },
  {
    "name": "Gooseberry",
    "id": 69,
    "family": "Grossulariaceae",
    "order": "Saxifragales",
    "genus": "Ribes",
    "nutritions": {
      "calories": 44,
      "fat": 0.6,
      "sugar": 0.0,
      "carbohydrates": 10.0,
      "protein": 0.9
    }
  },
  {
    "name": "Passionfruit",
    "id": 70,
    "family": "Passifloraceae",
    "order": "Malpighiales",
    "genus": "Passiflora",
    "nutritions": {
      "calories": 97,
      "fat": 0.7,
      "sugar": 11.2,
      "carbohydrates": 22.4,
      "protein": 2.2
    }
  },
  {
    "name": "Plum",
    "id": 71,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Prunus",
    "nutritions": {
      "calories": 46,
      "fat": 0.28,
      "sugar": 9.92,
      "carbohydrates": 11.4,
      "protein": 0.7
    }
  },
  {
    "name": "Orange",
    "id": 2,
    "family": "Rutaceae",
    "order": "Sapindales",
    "genus": "Citrus",
    "nutritions": {
      "calories": 43,
      "fat": 0.2,
      "sugar": 8.2,
      "carbohydrates": 8.3,
      "protein": 1.0
    }
  },
  {
    "name": "GreenApple",
    "id": 72,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Malus",
    "nutritions": {
      "calories": 21,
      "fat": 0.1,
      "sugar": 6.4,
      "carbohydrates": 3.1,
      "protein": 0.4
    }
  },
  {
    "name": "Raspberry",
    "id": 23,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Rubus",
    "nutritions": {
      "calories": 53,
      "fat": 0.7,
      "sugar": 4.4,
      "carbohydrates": 12.0,
      "protein": 1.2
    }
  },
  {
    "name": "Watermelon",
    "id": 25,
    "family": "Cucurbitaceae",
    "order": "Cucurbitales",
    "genus": "Citrullus",
    "nutritions": {
      "calories": 30,
      "fat": 0.2,
      "sugar": 6.0,
      "carbohydrates": 8.0,
      "protein": 0.6
    }
  },
  {
    "name": "Lemon",
    "id": 26,
    "family": "Rutaceae",
    "order": "Sapindales",
    "genus": "Citrus",
    "nutritions": {
      "calories": 29,
      "fat": 0.3,
      "sugar": 2.5,
      "carbohydrates": 9.0,
      "protein": 1.1
    }
  },
  {
    "name": "Mango",
    "id": 27,
    "family": "Anacardiaceae",
    "order": "Sapindales",
    "genus": "Mangifera",
    "nutritions": {
      "calories": 60,
      "fat": 0.38,
      "sugar": 13.7,
      "carbohydrates": 15.0,
      "protein": 0.82
    }
  },
  {
    "name": "Blueberry",
    "id": 33,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Fragaria",
    "nutritions": {
      "calories": 29,
      "fat": 0.4,
      "sugar": 5.4,
      "carbohydrates": 5.5,
      "protein": 0.0
    }
  },
  {
    "name": "Apple",
    "id": 6,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Malus",
    "nutritions": {
      "calories": 52,
      "fat": 0.4,
      "sugar": 10.3,
      "carbohydrates": 11.4,
      "protein": 0.3
    }
  },
  {
    "name": "Guava",
    "id": 37,
    "family": "Myrtaceae",
    "order": "Myrtales",
    "genus": "Psidium",
    "nutritions": {
      "calories": 68,
      "fat": 1.0,
      "sugar": 9.0,
      "carbohydrates": 14.0,
      "protein": 2.6
    }
  },
  {
    "name": "Apricot",
    "id": 35,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Prunus",
    "nutritions": {
      "calories": 15,
      "fat": 0.1,
      "sugar": 3.2,
      "carbohydrates": 3.9,
      "protein": 0.5
    }
  },
  {
    "name": "Melon",
    "id": 41,
    "family": "Cucurbitaceae",
    "order": "Cucurbitaceae",
    "genus": "Cucumis",
    "nutritions": {
      "calories": 34,
      "fat": 0.0,
      "sugar": 8.0,
      "carbohydrates": 8.0,
      "protein": 0.0
    }
  },
  {
    "name": "Tangerine",
    "id": 77,
    "family": "Rutaceae",
    "order": "Sapindales",
    "genus": "Citrus",
    "nutritions": {
      "calories": 45,
      "fat": 0.4,
      "sugar": 9.1,
      "carbohydrates": 8.3,
      "protein": 0.0
    }
  },
  {
    "name": "Pitahaya",
    "id": 78,
    "family": "Cactaceae",
    "order": "Caryophyllales",
    "genus": "Cactaceae",
    "nutritions": {
      "calories": 36,
      "fat": 0.4,
      "sugar": 3.0,
      "carbohydrates": 7.0,
      "protein": 1.0
    }
  },
  {
    "name": "Lime",
    "id": 44,
    "family": "Rutaceae",
    "order": "Sapindales",
    "genus": "Citrus",
    "nutritions": {
      "calories": 25,
      "fat": 0.1,
      "sugar": 1.7,
      "carbohydrates": 8.4,
      "protein": 0.3
    }
  },
  {
    "name": "Pomegranate",
    "id": 79,
    "family": "Lythraceae",
    "order": "Myrtales",
    "genus": "Punica",
    "nutritions": {
      "calories": 83,
      "fat": 1.2,
      "sugar": 13.7,
      "carbohydrates": 18.7,
      "protein": 1.7
    }
  },
  {
    "name": "Dragonfruit",
    "id": 80,
    "family": "Cactaceae",
    "order": "Caryophyllales",
    "genus": "Selenicereus",
    "nutritions": {
      "calories": 60,
      "fat": 1.5,
      "sugar": 8.0,
      "carbohydrates": 9.0,
      "protein": 9.0
    }
  },
  {
    "name": "Grape",
    "id": 81,
    "family": "Vitaceae",
    "order": "Vitales",
    "genus": "Vitis",
    "nutritions": {
      "calories": 69,
      "fat": 0.16,
      "sugar": 16.0,
      "carbohydrates": 18.1,
      "protein": 0.72
    }
  },
  {
    "name": "Morus",
    "id": 82,
    "family": "Moraceae",
    "order": "Rosales",
    "genus": "Morus",
    "nutritions": {
      "calories": 43,
      "fat": 0.39,
      "sugar": 8.1,
      "carbohydrates": 9.8,
      "protein": 1.44
    }
  },
  {
    "name": "Feijoa",
    "id": 76,
    "family": "Myrtaceae",
    "order": "Myrtoideae",
    "genus": "Sellowiana",
    "nutritions": {
      "calories": 44,
      "fat": 0.4,
      "sugar": 3.0,
      "carbohydrates": 8.0,
      "protein": 0.6
    }
  },
  {
    "name": "Avocado",
    "id": 84,
    "family": "Lauraceae",
    "order": "Laurales",
    "genus": "Persea",
    "nutritions": {
      "calories": 160,
      "fat": 14.66,
      "sugar": 0.66,
      "carbohydrates": 8.53,
      "protein": 2.0
    }
  },
  {
    "name": "Kiwifruit",
    "id": 85,
    "family": "Actinidiaceae",
    "order": "Ericales",
    "genus": "Actinidia",
    "nutritions": {
      "calories": 61,
      "fat": 0.5,
      "sugar": 8.9,
      "carbohydrates": 14.6,
      "protein": 1.14
    }
  },
  {
    "name": "Cranberry",
    "id": 87,
    "family": "Ericaceae",
    "order": "Ericales",
    "genus": "Vaccinium",
    "nutritions": {
      "calories": 46,
      "fat": 0.1,
      "sugar": 4.0,
      "carbohydrates": 12.2,
      "protein": 0.4
    }
  },
  {
    "name": "Cherry",
    "id": 9,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Prunus",
    "nutritions": {
      "calories": 50,
      "fat": 0.3,
      "sugar": 8.0,
      "carbohydrates": 12.0,
      "protein": 1.0
    }
  },
  {
    "name": "Peach",
    "id": 86,
    "family": "Rosaceae",
    "order": "Rosales",
    "genus": "Prunus",
    "nutritions": {
      "calories": 39,
      "fat": 0.25,
      "sugar": 8.4,
      "carbohydrates": 9.5,
      "protein": 0.9
    }
  },
  {
    "name": "Jackfruit",
    "id": 94,
    "family": "Moraceae",
    "order": "Rosales",
    "genus": "Artocarpus",
    "nutritions": {
      "calories": 95,
      "fat": 0.0,
      "sugar": 19.1,
      "carbohydrates": 23.2,
      "protein": 1.72
    }
  },
  {
    "name": "Horned Melon",
    "id": 95,
    "family": "Cucurbitaceae",
    "order": "Cucurbitales",
    "genus": "Cucumis",
    "nutritions": {
      "calories": 44,
      "fat": 1.26,
      "sugar": 0.5,
      "carbohydrates": 7.56,
      "protein": 1.78
    }
  },
  {
    "name": "Hazelnut",
    "id": 96,
    "family": "Betulaceae",
    "order": "Fagales",
    "genus": "Corylus",
    "nutritions": {
      "calories": 628,
      "fat": 61.0,
      "sugar": 4.3,
      "carbohydrates": 17.0,
      "protein": 15.0
    }
  },
  {
    "name": "Pomelo",
    "id": 98,
    "family": "Rutaceae",
    "order": "Sapindales",
    "genus": "Citrus",
    "nutritions": {
      "calories": 37,
      "fat": 0.0,
      "sugar": 8.5,
      "carbohydrates": 9.67,
      "protein": 0.82
    }
  },
  {
    "name": "Mangosteen",
    "id": 99,
    "family": "Clusiaceae",
    "order": "Malpighiales",
    "genus": "Garcinia",
    "nutritions": {
      "calories": 73,
      "fat": 0.58,
      "sugar": 16.11,
      "carbohydrates": 17.91,
      "protein": 0.41
    }
  },
  {
    "name": "Pumpkin",
    "id": 100,
    "family": "Cucurbitaceae",
    "order": "Cucurbitales",
    "genus": "Cucurbita",
    "nutritions": {
      "calories": 25,
      "fat": 0.3,
      "sugar": 3.3,
      "carbohydrates": 4.6,
      "protein": 1.1
    }
  },
  {
    "name": "Japanese Persimmon",
    "id": 101,
    "family": " Ebenaceae",
    "order": " Ericales",
    "genus": "Diospyros",
    "nutritions": {
      "calories": 70,
      "fat": 0.2,
      "sugar": 13.0,
      "carbohydrates": 19.0,
      "protein": 0.6
    }
  },
  {
    "name": "Papaya",
    "id": 42,
    "family": "Caricaceae",
    "order": "Brassicales",
    "genus": "Carica",
    "nutritions": {
      "calories": 39,
      "fat": 0.3,
      "sugar": 4.4,
      "carbohydrates": 5.8,
      "protein": 0.5
    }
  },
  {
    "name": "Annona",
    "id": 103,
    "family": "Annonaceae",
    "order": "Rosales",
    "genus": "Annonas",
    "nutritions": {
      "calories": 92,
      "fat": 0.29,
      "sugar": 3.4,
      "carbohydrates": 19.1,
      "protein": 1.5
    }
  },
  {
    "name": "Ceylon Gooseberry",
    "id": 104,
    "family": "Salicaceae",
    "order": "Malpighiales",
    "genus": "Dovyalis",
    "nutritions": {
      "calories": 47,
      "fat": 0.3,
      "sugar": 8.1,
      "carbohydrates": 9.6,
      "protein": 1.2
    }
  }
]
```

</details>

## Техническое задание

### Общее  
Табы:
1. Список всех фруктов  
2. Избранное  
3. Рецепты

### Экран "Список всех фруктов"

Позволяет просматривать список фруктов из публичного API. К списку могут быть применены фильтр и сортировка.

В карточках представлена краткая информация, а также есть возможность добавления (удаления) в избранное и перехода на экран детальной информации.

1. Аппбар:  
   1. Заголовок "Фрукты"  
   2. Кнопка сортировки, по нажатию открывается экран сортировки  
2. Список карточек фруктов:  
   1. Фрукты получаются из API
   2. Возможно применение фильтров и сортировки к списку
   3. Во время загрузки - лоадер  
   4. При ошибке загрузки отображаем текст "Произошла ошибка" и кнопку "Повторить"
   5. После загрузки отображаем список карточек фруктов
3. Карточка фрукта:
   1. Заголовок - Название фрукта  
   2. Подзаголовок - Семейство (family)
   3. Кнопка добавления (удаления) в избранное  
   4. По нажатию на карточку открывается экран деталки  

### Экран "Сортировка"

Позволяет выбрать способ сортировки списка фруктов.

Также возможно применение фильтров к списку. Несколько фильтров могут объединяться между собой. В таком случае, в список должны попасть только те фрукты, которые подходят под все условия примененных фильтров.

Сортировка и фильтрация происходит локально, без новых запросов к АПИ.

1. Аппбар:  
   1. Заголовок "Фильтры"  
   2. Кнопка назад  
2. Варианты сортировки:  
   1. По названию (A-Z), (Z-A)
   2. По количеству калорий (возрастание), (убывание)
3. Заготовленные фильтры:
   1. Примеры ниже (можно придумать свои или поменять значения)
   2. Пользователь может выбрать несколько фильтров.
   3. Выбранные фильтры визуально выделены.
4. Кнопка применить (применяет и возвращает на обновленный экран списка фруктов)

<details>
  <summary>Примеры фильтров</summary>
  
**Завтрак**

- `calories`: 40–80 ккал
- `carbohydrates`: ≥ 10 г
- `sugar`: ≤ 12 г
- `fat`: ≤ 0.5 г

**Тренировка**

- `calories`: 50–100 ккал
- `carbohydrates`: ≥ 12 г
- `fat`: ≤ 0.3 г

**Сытость**

- `calories`: 50–90 ккал
- `carbohydrates`: 10–15 г
- `sugar`: ≤ 10 г
- `protein`: ≥ 0.5 г
- `fat`: любой

**Перекус**

- `calories`: ≤ 50 ккал
- `sugar`: ≤ 7 г
- `fat`: ≤ 0.4 г

**Диета**

- `calories`: ≤ 40 ккал
- `sugar`: ≤ 6 г
- `fat`: ≤ 0.3 г

</details>

### Экран "Деталка фрукта"

Позволяет просматривать детальную информацию о выбранном фрукте и добавлять (удалять) в избранное.

1. Аппбар:  
   1. Заголовок - название фрукта  
   2. Кнопка назад   
   3. Кнопка добавления в избранное  
2. Вся информация о фрукте:  
   1. Family  
   2. Order  
   3. Genus  
   4. Питательные свойства:  
      1. Calories  
      2. Far  
      3. Sugar  
      4. Carbohydrates  
      5. Protein

### Экран "Избранное"

Позволяет просматривать список избранных фруктов. 

Данные о фруктах получены из АПИ.
Список избранного сохраняется локально на устройстве пользователя.

Имеется возможность удаления фрукта из избранного.

1. Аппбар:
  1. Заголовок "Избранное"  
2. Список карточек фруктов:  
  1. Список фруктов получен на основе АПИ, данные об избранных фруктах получены из локального хранилища.
  2. Нет избранных фруктов - "Вы пока ничего не добавили в избранное"
  3. Во время загрузки - лоадер  
  4. При ошибке загрузки - отображаем текст "Произошла ошибка" и кнопку "Перезагрузить"
  5. После успешной загрузки отображаем список карточек избранных фруктов
3. Карточка избранного фрукта
   1. Заголовок - Название фрукта  
   2. Кнопка удаления из избранного  
   3. По нажатию на карточку открываем экран деталки  

### Экран "Рецепты"

Позволяет просматривать список рецептов.

Рецепт включает название, описание и список фруктов.

Рецепты сохраняются локально на устройстве пользователя.

Имеется возможность создания нового и удаления рецепта.

1. Аппбар:  
   1. Заголовок "Рецепты"
2. Кнопка для создания нового рецепта
3. Список карточек рецептов:
   1. Данные о рецептах получены из локального хранилища.
   2. Данные о фруктах получены из АПИ.
   3. Нет рецептов - отобразить текст "Создайте свой первый рецепт"
   4. Во время загрузки - лоадер  
   5. При ошибке загрузки - отображаем текст "Произошла ошибка" и кнопку "Перезагрузить"
   6. После успешной загрузки отображаем список карточек рецептов
4. Карточка рецепта:
   1. Название рецепта
   2. Описание рецепта
   3. Состав - перечисление всех фруктов в рецепте в строку.
   4. Данные по составу: сумма показателей питательных веществ (nutritions) для всех фруктов в рецепте.
   5. Кнопка удаления рецепта

### Экран "Создание рецепта"

Позволяет создать рецепт.

Рецепт включает название, описание и список фруктов.

Рецепты сохраняются локально на устройстве пользователя.

1. Аппбар: 
   1. Заголовок "Создание рецепта"
2. Текстовое поле "Название рецепта" (обязательное, должно быть непустое)
3. Текстовое поле "Описание рецепта" (опциональное, в несколько строк)
4. Список с фруктами из избранного, с возможностью выбора для добавления в рецепт.
5. Кнопка "Сохранить"

# Представление результатов

Необходимо форкнуть репозиторий.

Создать ветку `implementation` и запушить в неё код приложения.

В текущем проекте есть файл `/docs/results/RESULT.md`. Этот шаблон нужен для того, чтобы вы могли поделиться результатами вашей работы. Вы можете записать скринкаст, сделать скриншоты и добавить описание проделанной работы.
Умение защитить результаты своей работы - невероятно важный навык для разработчика. Поэтому, добавляйте в описание всё, что посчитаете нужным.
