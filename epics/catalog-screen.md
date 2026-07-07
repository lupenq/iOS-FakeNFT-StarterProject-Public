# Эпик: Каталог

Декомпозиция эпика «Каталог» на три равноценные подфичи по [ТЗ](../Readme.md#каталог): **экран каталога** и **экран коллекции NFT**.

**Общая оценка:** ~18 часов  
**Архитектурный паттерн:** MVVM

---

## Подфича 1: Сетевой слой и ViewModel

Модели, запросы к API, сервисы и ViewModel для обоих экранов.

| Задача                                                                                                                                      | Оценка |
| ------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| Создать модель `NftCollection` по `GET /api/v1/collections`: `id`, `name`, `cover`, `nfts`, `description`, `author`, `website`, `createdAt` | 30 мин |
| Дополнить модель `Nft` по `GET /api/v1/nft`: `name`, `images`, `rating`, `price`, `description`, `author`, `website`, `createdAt`           | 30 мин |
| Реализовать `CollectionsRequest` - GET `/api/v1/collections` (query: `page`, `size`, `sortBy`)                                              | 30 мин |
| Реализовать `CollectionByIdRequest` - GET `/api/v1/collections/{collection_id}`                                                             | 20 мин |
| Реализовать загрузку NFT коллекции по id из массива `nfts` (batch-запрос или параллельные `GET /api/v1/nft/{nft_id}`)                       | 1 ч    |
| Создать `CollectionService` и подключить в `ServicesAssembly`                                                                               | 45 мин |
| Создать `CatalogViewModel`: загрузка списка, состояния `loading` / `data` / `failed`, сортировка                                            | 1 ч    |
| Создать `CollectionDetailViewModel`: загрузка коллекции + NFT, состояния `loading` / `data` / `failed`                                      | 1 ч    |
| Создать `CatalogAssembly` и `CollectionDetailAssembly`                                                                                      | 45 мин |
| Написать `CatalogCellModel` и `NftCellModel` для отображения в списке/сетке                                                                 | 30 мин |

**Итого подфича 1:** ~6 ч 20 мин

---

## Подфича 2: Экран каталога (Catalogue)

`UITableView` со списком коллекций, сортировка, лоадер, переход на экран коллекции.

| Задача                                                                                       | Оценка     |
| -------------------------------------------------------------------------------------------- | ---------- |
| Создать `CatalogViewController` и завести новый таб «Каталог» в `TabBarController` (не трогая `TestCatalogViewController`) | 30 мин     |
| Настроить `UITableView` (dataSource, delegate, регистрация ячейки)                           | 45 мин     |
| Сверстать `CatalogCollectionCell` по Figma: обложка, название, количество NFT (`nfts.count`) | 1 ч 30 мин |
| Загрузка обложки по URL                                                                      | 30 мин     |
| Добавить `UIActivityIndicatorView`, подключить `LoadingView`                                 | 30 мин     |
| Связать View с `CatalogViewModel` через замыкания                                            | 45 мин     |
| Кнопка сортировки в navigation bar + Action Sheet («По названию», «По количеству NFT»)       | 45 мин     |
| Сохранять критерий сортировки в `UserDefaults` (дефолт - по количеству NFT)                  | 30 мин     |
| `didSelectRowAt` - push `CollectionDetailViewController` с `collectionId`                    | 30 мин     |

**Итого подфича 2:** ~6 ч 15 мин

---

## Подфича 3: Экран коллекции NFT (Collection)

Шапка коллекции, сетка NFT, избранное и корзина.

| Задача                                                                                        | Оценка     |
| --------------------------------------------------------------------------------------------- | ---------- |
| Создать `CollectionDetailViewController` с `UICollectionView` (3 колонки, `FlowLayout`)       | 1 ч        |
| Сверстать header: обложка, название, описание, «Автор коллекции: …»                           | 1 ч 30 мин |
| Открытие сайта автора по тапу на ссылку в `WKWebView`                                         | 30 мин     |
| Сверстать `NftCollectionViewCell`: изображение, название, рейтинг, цена (ETH)                 | 1 ч 30 мин |
| Кнопка избранного (сердце) - добавление/удаление через Profile API (`likes`)                  | 45 мин     |
| Кнопка корзины - добавление/удаление через Order API; иконка крестика, если NFT уже в корзине | 45 мин     |
| Связать View с `CollectionDetailViewModel`, `UIActivityIndicator` при загрузке                | 45 мин     |
| `didSelectItemAt` - открыть экран NFT через `NftDetailAssembly` (реализован наставником)      | 30 мин     |

**Итого подфича 3:** ~6 ч 45 мин

---

## Критерии готовности эпика

### Экран каталога

- [x] `UITableView` отображает коллекции: обложка, название, количество NFT
- [x] Данные загружаются с сервера, во время загрузки виден `UIActivityIndicator`
- [x] Сортировка работает и сохраняется в `UserDefaults` между запусками
- [x] Тап по ячейке открывает экран коллекции NFT

### Экран коллекции NFT

- [x] Отображаются обложка, название, описание, ссылка на автора
- [x] Сайт автора открывается в `WKWebView`
- [x] `UICollectionView` показывает NFT: изображение, название, рейтинг, цена в ETH
- [x] Работают кнопки избранного и корзины (крестик, если NFT в корзине)
- [x] Тап по NFT открывает экран деталей NFT

### Архитектура

- [x] MVVM: View / ViewModel / Service разделены на обоих экранах
