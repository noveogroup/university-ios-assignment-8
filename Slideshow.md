
class: middle, TitlePage

.inverted[

### лекция 8

# Работа с сетью

### Загрузка в NSData

### NSURLRequest, NSURLConnection

### Работа с JSON

### AFNetworking

]

---

# Работа с сетью в iOS

- Ошибки при работе с сетью — штатная ситуация
- Сеть может быть медленная
- Сети может вообще не быть
- Загрузка данных может стоить пользователю денег :)

--

Как жить:
- Проверяем доступность сервера
- Обрабатываем возможные ошибки сети
- Обрабатываем возможные ошибки в формате данных
- Ограничиваем количество одновременных запросов
- Один большой запрос быстрее, чем много маленьких
- Никогда не работаем с сетью в главном потоке
- Уважаем пользователя: кэшируем что можно, экономим трафик, показываем спиннер

---

# Загрузка в NSData

- Самый простой способ загрузить данные из сети (в одну строку)
- Сам по себе способ *синхронный* (блокирует текущий поток)
- Практически не применим в реальной работе:
  - Слабая обработка ошибок
  - Только HTTP GET
  - Нет управления заголовками
  - Нет докачки
  - ...

---

# Загрузка в NSData

Выполним синхронную загрузку данных:

.spaced[
```
NSURL *url = [NSURL URLWithString:@"http://server.org/some/path"];
*NSData *data = [NSData dataWithContentsOfURL:url];
// Данные загружены, можно использовать.
// ...
```
]

---

# Загрузка в NSData

Сделаем загрузку асинхронной:

.spaced[
```
*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://server.org/some/path"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        // Данные загружены, можно использовать.
        // ...
    });

// Здесь данные ещё не загружены! Хотя кто знает... :)
// ...
```
]

---

# NSURLRequest, NSURLConnection

- Есть обработка ошибок и кодов ответа
- Можно делать запросы с любым методом (GET / POST / PUT / DELETE / ...)
- Поддержка редиректов, авторизации, управление кешированием и т.д.
- Можно управлять заголовками запроса
- Можно организовать докачку
- Применимо на практике, но ...
  - Много кода
  - Желательно выделить всю низкоуровневую работу в переиспользуемый компонент

---

# NSURLRequest, NSURLConnection

Необходимый минимум для работы с NSURLConnection:
- Создаём и конфигурируем NSURLRequest
- Создаём и конфигурируем NSURLConnection для request-а
- Задаём объект-делегат для connection-а
- Переопределяем методы делегата

---

# NSURLConnection: методы делегата

- Проверить код ответа. Подготовиться к получению данных (выделить/очистить буфер для данных).
    ```
    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
    ```
- Сохранить полученные данные. Обновить прогресс-бар, если он есть.
    ```
    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
    ```
- Обработать ошибку.
    ```
    - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
    ```
- Обработать завершение запроса (данные уже получены/отправлены).
    ```
    - (void)connectionDidFinishLoading:(NSURLConnection *)connection
    ```

---

# NSURLSession

`NSURLSession` — "продвинутый" API для работы с сетью, появился в iOS 7.

- Загрузка/отправка данных в background-режиме
- Возможность остановить и продолжить загрузку
- Возможность задать общие настройки для всех запросов сессии
- Автоматическое скачивание в файл
- Гибкое управление количеством одновременных соединений и возможность отложить загрузку до подходящего момента (когда появится Wi-Fi)
- Возможность определить хранилища для cookie и кэша

---

# NSURLSession

.center.inverted[
##Необходимо добавить пример использования
]

---

.block[
.left-column-20[

![JSON logo](images/JSONLogo.png)

]
.right-column-80[

# JSON

]
]

.block[
**JSON** (JavaScript Object Notation) — простой формат обмена данными, удобный для чтения и написания как человеком, так и компьютером.

- Используется большей частью современных сетевых API
- Лаконичнее чем XML
- Однозначнее чем XML (легко транслируется в термины стандартных коллекций)
- Поддерживается стандартной библиотекой iOS SDK
]

---

# JSON: терминология

Всего три базовых понятия:
- **Словарь** (коллекция пар ключ/значение, ассоциативный массив, объект)
- **Массив** (упорядоченный список значений, вектор)
- **Значение** одного из типов:
    - строка (в кавычках, экранирующий символ — обратный слэш)
    - целое число
    - число с плавающей точкой
    - булево значение (true/false)
    - null
    - *словарь\** (пары "ключ":значение через запятую в фигурных скобках)
    - *массив\** (значения через запятую в квадратных скобках)

.footnote[\* Последние два типа поддерживают вложенность.]

---

# JSON: пример

.spaced[
```json
{
    "firstName": "Иван",
    "lastName": "Иванов",
    "age": 42,
    "address": {
        "streetAddress": "Московское ш., 101, кв.101",
        "city": "Ленинград",
        "postalCode": 101101
    },
    "phoneNumbers": [
        "812 123-1234",
        "916 123-4567"
    ]
}
```
]

---

# NSJSONSerialization

Класс `NSJSONSerialization` реализует сериализацию и десериализацию JSON-объектов.

.spaced[
```
NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
NSError *__autoreleasing error = nil;
*NSDictionary *jsonObject =
*    [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

if (error != nil) {
    // Обработка ошибки.
    // ...
}
else {
    // Работа с полученной структурой данных.
    // ...
}
```
]

---

.center[
![AFNetworking logo](images/AFNetworkingLogo.png)
]

AFNetworking — популярная библиотека для работы с сетью под iOS и MacOS. Последние годы является стандартом де-факто в области работы с сетью.

- Высокоуровневое API (абстракции для запросов, очередей, типов данных, кэша и т.д.)
- Модульная архитектура (сессии, reachability, JSON, security, загрузка картинок и т.д.)
- Относительно немного кода для решения простых задач
- Поддержка решения сложных задач (AFIncrementalStore и т.д.)

---

# Пример: запрос JSON

```
#import <AFNetworking/AFNetworking.h>

// ...
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
// ...

- (instancetype)initWithBaseURL:(NSURL *)baseAPIURL
{
    // ...
    _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseAPIURL];
    // ...
}
 
- (void)downloadObjectWithURL:(NSString *)objectURL
{
*    [self.requestManager GET:objectURL parameters:nil
*        success:^(AFHTTPRequestOperation *operation, NSDictionary *someObject) {
*            // В объекте someObject — уже разобранный JSON-ответ.
*        }
*        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
*            // Обработка ошибки.
*        }];
}

```

---

# Пример: проверка соединения

```
#import <AFNetworking/AFNetworkReachabilityManager.h>
 
// ...
 
AFNetworkReachabilityManager *rm = [AFNetworkReachabilityManager sharedManager];
[rm setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // Пропал доступ к сети.
            // ...
        }
        else {
            // Появился доступ к сети.
            // ...
        }
	}];
[rm startMonitoring];
	
if ([rm isReachable]) {
    // Есть доступ к сети.
    // ...
}
else {
    // Нет доступа к сети.
    // ...
}
```

---

# Пример: работа с операциями и очередями

```
#import <AFNetworking/AFNetworking.h>

// ...
 
AFHTTPRequestOperation *myOperation = 
    [[AFHTTPRequestOperation alloc] initWithRequest:getAvatarRequest];
[myOperation setCompletionBlockWithSuccess:
    ^(AFHTTPRequestOperation *operation, id response) {
        // ...
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // ...
    }];
	
NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
[operationQueue addOperation:myOperation];
```
