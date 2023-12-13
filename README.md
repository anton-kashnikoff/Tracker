# Tracker
Приложение помогает пользователям формировать полезные привычки и контролировать их выполнение.
Цели приложения:
* Контроль привычек по дням недели;
* Просмотр прогресса по привычкам;

<img src="https://github.com/prostokot14/Tracker/assets/86567361/fa581fbd-125a-4f2a-9d3e-f5383eb84505" width="250">
<img src="https://github.com/prostokot14/Tracker/assets/86567361/9fa52ba4-ae30-4c05-abf8-2d11ae07a71e" width="250">
<img src="https://github.com/prostokot14/Tracker/assets/86567361/5ef35760-c6ad-435c-ba07-bffe1e6cc67d" width="250">
<img src="https://github.com/prostokot14/Tracker/assets/86567361/a7c3b248-0357-4177-8031-dd85b69dd858" width="250">

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
