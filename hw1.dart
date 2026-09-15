// TASK 1
// OUTPUT MULTIPLICATION TABLE 1-10
void printMultiplicationTable(int digit) {
  for (int i = 1; i <= 10; i++) {
    print("$digit * $i = ${digit * i}");
  }
}


// TASK 2
// next day : examples:
// 05.09.2026 -> 06.09.2026
// 28.02.2024 -> 29.02.2024
// 28.02.2026 -> 01.03.2026
// 29.02.2026 -> invalid date
// 28.02.2100 -> 01.03.2100
// 28.02.2000 -> 29.02.2000
// 31.12.2025 -> 01.01.2026
// 2000,2400 leap year
// 2100,2200,2300 isn`t leap year
bool isLeapYear(int year) =>
    year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

int daysInMonth(int month, int year) {
  const daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (month == 2 && isLeapYear(year)) return 29;
  return daysPerMonth[month - 1];
}

void printNextDay(int day, int month, int year) {
  if (month < 1  || month > 12  || day < 1 || day > daysInMonth(month, year)) {
    print("invalid date");
    return;
  }

  int nextDay = day + 1;
  int nextMonth = month;
  int nextYear = year;

  if (nextDay > daysInMonth(month, year)) {
    nextDay = 1;
    nextMonth++;
    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }
  }

  String pad(int n) => n.toString().padLeft(2, '0');
  print(
    "${pad(day)}.${pad(month)}.$year -> ${pad(nextDay)}.${pad(nextMonth)}.$nextYear",
  );
}


// TASK 3
// Vowel Counter in a String -> "flutter mobile development" -> 8, actually 9
int countVowels(String text) {
  const vowels = "aeiouAEIOU";
  int count = 0;
  for (int i = 0; i < text.length; i++) {
    if (vowels.contains(text[i])) count++;
  }
  return count;
}


// TASK 4
// Manual min & max finder
// [14, 88, 3, 42, 99, 12, 67] -> max: 99, min: 3
// [234, 34, 123, 44, 949, 112, 67] -> max: 949, min: 34
String findMinMax(List<int> numbers) {
  int min = numbers[0];
  int max = numbers[0];
  for (int n in numbers) {
    if (n < min) min = n;
    if (n > max) max = n;
  }
  return "max: $max, min: $min";
}


// TASK 5
// Prime Number Checker
// 3 -> prime number
// 6 -> not prime number
bool isPrime(int n) {
  if (n < 2) return false;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}


//tests
void main() {
  printMultiplicationTable(7);

  printNextDay(5, 9, 2026);
  printNextDay(28, 2, 2024);
  printNextDay(28, 2, 2026);
  printNextDay(29, 2, 2026);
  printNextDay(28, 2, 2100);
  printNextDay(28, 2, 2000);
  printNextDay(31, 12, 2025);

  print(countVowels("flutter mobile development"));

  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  List<int> numbers1 = [234, 34, 123, 44, 949, 112, 67];
  print(findMinMax(numbers));
  print(findMinMax(numbers1));

  print(isPrime(3));
  print(isPrime(6));
  print(isPrime(137541));
  print(isPrime(13));
}