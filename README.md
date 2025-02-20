# Tracker
Приложение помогает пользователям формировать полезные привычки и контролировать их выполнение.
Цели приложения:
* Контроль привычек по дням недели;
* Просмотр прогресса по привычкам;

<img src="https://github.com/user-attachments/assets/252b0e2a-38e0-4ad5-bf84-056e89c81619" width="250">
<img src="https://github.com/user-attachments/assets/ef10ebc3-ed35-43ed-baaf-f934179c3aff" width="250">
<img src="https://github.com/user-attachments/assets/adf990af-36a9-470b-8e14-a1f1b778befa" width="250">
<img src="https://github.com/user-attachments/assets/9ec5332b-0ad5-4dc3-bad0-f989946ec5ed" width="250">
<img src="https://github.com/user-attachments/assets/07c5e693-3d0b-4417-8fb7-e7fd170f9a70" width="250">

## Краткое описание приложения
* Приложение состоит из карточек-трекеров, которые создает пользователь. Он может указать название, категорию и задать расписание. Также можно выбрать эмодзи и цвет, чтобы отличать карточки друг от друга.
* Карточки отсортированы по категориям. Пользователь может искать их с помощью поиска и фильтровать.
* С помощью календаря пользователь может посмотреть какие привычки у него запланированы на конкретный день.
* В приложении есть статистика, которая отражает успешные показатели пользователя, его прогресс и средние значения.
## Инструкция по развёртыванию
Чтобы подключить библиотеку с обработкой крэшей, добавьте в Podfile проекта зависимость:
```
pod 'YandexMobileMetrica/Dynamic', '4.5.2'
```
## Системные требования
* Swift 5.9
* iOS 13.4+
* [YandexMobileMetrica](https://github.com/onevcat/Kingfisher)
* [swift-syntax](github.com/apple/swift-syntax.git)
* [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)
## Стек технологий
* UICollectionView, UITabBarController, UINavigationController
* GCD
* запросы HTTP (URLSession) и REST
* MVVM
* CoreData
* Snapshot-тесты
• Сервис аналитики YandexMobileMetrica
