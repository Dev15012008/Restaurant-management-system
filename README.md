# Restaurant Management System (IU2541230010 - CPP07)

A console-based **C++ object-oriented** project. It manages a restaurant's menu, customers, orders,
bills and payments, and keeps all records in text files so nothing is lost when the program is closed.

## 1. Features
| Menu option | What it does |
|---|---|
| 1. Add Record | Add a **menu item** (Food or Beverage) or a **customer** |
| 2. Display Records | Show menu, customers, orders or bills as tables |
| 3. Search Record | Menu by ID / name / category, customer by ID / name / phone, order by ID / customer, bill by ID |
| 4. Update Record | Change an item's price, name or category; a customer's name or phone; add items to an OPEN order |
| 5. Delete Record | Delete a menu item, a customer (only if no orders) or an order (only OPEN / CANCELLED) |
| 6. Main Transaction | **Place order -> Generate bill (with discount) -> Pay bill**, and Cancel order |
| 7. Report | Counts, revenue, outstanding amount, discounts, best-selling item, top customer |
| 8. Save / Load | Write all records to `Data/` or reload them from disk |
| 9. Exit | Offers to save, then releases all memory |

The program **loads `Data/` automatically at start-up**, so old records are always available.

## 2. How to build and run

**Linux / macOS**
```
g++ -std=c++17 -Wall -Wextra -o restaurant src/*.cpp
./restaurant
```
(or just run `make`, or `./build.sh`)

**Windows** (MinGW / MSYS2 / Code::Blocks / Dev-C++ with GCC 9 or newer)
```
g++ -std=c++17 -Wall -Wextra -o restaurant.exe src\*.cpp
restaurant.exe
```
(or double-click `build.bat`)

**VS Code / Code::Blocks / Dev-C++:** create a project, add every file in `src/`, set the language
standard to **C++17**, build, and run from the folder that contains `Data/`.

Important: run the program from the project folder so it finds `Data/`. You can also point it to another
data folder:  `./restaurant path/to/DataFolder`

> The `restaurant` file in this folder was built on Linux. On Windows, build `restaurant.exe` with the command above.

## 3. Source structure
```
src/
  main.cpp            menus only - creates Restaurant and calls its functions
  Restaurant.h/.cpp   SYSTEM class: owns dynamic arrays, implements every operation
  MenuItem.h/.cpp     abstract base class (virtual functions)
  FoodItem.h/.cpp     derived class (5% tax)
  BeverageItem.h/.cpp derived class (12% tax)
  Customer.h/.cpp     customer entity
  Order.h/.cpp        order entity, owns a dynamic array of OrderLine
  Bill.h/.cpp         bill entity (discount, payment)
  FileManager.h/.cpp  save() / load() of all records
  Utils.h/.cpp        validated input helpers (Input::readInt ...) and string helpers
  Common.h            RestaurantException, InputClosedException
Data/                 menu.txt, customers.txt, orders.txt, bills.txt  (sample records included)
UML/                  Use Case, Class, 2 Sequence diagrams (PNG) + source/ to edit them
tests/                15 test cases: run_tests.py, inputs/, Test_Results.txt, seed_data/
docs/                 filled Project Report, Submission form
```

## 4. Where each C++ concept is used
| Concept | Where |
|---|---|
| Classes & objects | `MenuItem`, `FoodItem`, `BeverageItem`, `Customer`, `Order`, `Bill`, `Restaurant`, `FileManager` |
| Encapsulation | all data members are `private` / `protected`; access through getters / setters that validate |
| Default + parameterized constructors | every entity class (e.g. `Order()` and `Order(orderId, customerId)`) |
| Copy constructor / assignment (Rule of Three) | `Order` (it owns a dynamic array, so it must deep-copy) |
| Destructors | all classes; `~Order()` -> `delete[] lines`, `~Restaurant()` -> deletes every array and object |
| Inheritance | `FoodItem` and `BeverageItem` inherit from `MenuItem` |
| Runtime polymorphism | `MenuItem** menu` holds both kinds; `menu[i]->display()`, `getTaxRate()`, `serialize()` are virtual |
| Dynamic memory | `new MenuItem*[cap]`, `new Customer[cap]`, `new Order[cap]`, `new Bill[cap]`, `new OrderLine[cap]`; grown with `grow*()`, released with `delete` / `delete[]` |
| File handling | `FileManager::save()` / `load()` with `ifstream` / `ofstream` |
| Validation | `Input::readInt / readDouble / readPhone / readName / readYesNo`, constructor checks |
| Exception handling | `RestaurantException` thrown by validation, caught in `main()`; `std::bad_alloc` handled too |

### Why dynamic memory?
The number of menu items, customers, orders and bills is not known when the program is compiled. Arrays start
small (4) and are **doubled when full** (`growMenu`, `growOrders`, ...), so the program never has a fixed limit.
Menu items must also be allocated on the heap because the array stores *base-class pointers* to objects of
different derived types (needed for polymorphism).

## 5. Data files (all in `Data/`, one record per line, fields separated by `|`)
```
menu.txt       F|id|name|category|price|isVeg|spiceLevel          (Food)
               B|id|name|category|price|sizeMl|isCold             (Beverage)
customers.txt  C|id|name|phone
orders.txt     O|orderId|customerId|status|lineCount              (status 0 OPEN,1 BILLED,2 PAID,3 CANCELLED)
               L|itemId|qty|unitPrice|taxRate|name                (one line per item, lineCount of them)
bills.txt      B|billId|orderId|subtotal|tax|discountPercent|paid|paymentMode|date
```
Damaged lines are skipped with a warning instead of crashing the program.

## 6. Business rules
- Tax: Food 5%, Beverage 12% (illustrative rates, set in `getTaxRate()`).
- Order lines **copy** the item name and price when added, so changing the menu later never changes old orders/bills.
- A bill can be created only for an OPEN order; paying needs an amount >= the bill amount (change is shown).
- Customers with orders cannot be deleted; BILLED / PAID orders cannot be deleted or cancelled.

## 7. Suggested demo for the viva (about 3 minutes)
1. Start the program -> it prints how many records were loaded.
2. Option 2 -> 1: show the menu (Food / Beverage rows come from different derived classes - polymorphism).
3. Option 6 -> 1: place an order for customer 1 (items 1, 3, 8). Option 6 -> 2: bill with 10% discount. Option 6 -> 3: pay.
4. Option 7: report. Option 9 -> `y`: save and exit (it prints the memory-release message).
5. Start again: the same records are loaded back from `Data/`.

## 8. Tests
`cd tests && python3 run_tests.py` runs the 15 test cases against the executable (a fresh copy of `tests/seed_data` each time)
and writes `results.json` and `Test_Results.txt`. Expected result: `15/15 passed`.
