// Homework 2: Safe ATM Banking Terminal Simulator

// 1. checkBalance
void checkBalance({required String name, required double balance}) =>
    print("Текущий баланс $name: $balance");


// 2. deposit
double deposit({required double currentBalance, double? amount}) {
  double depositAmount = amount ?? 0.0;
  double updatedBalance = currentBalance + depositAmount;
  print("Пополнение: $depositAmount. Новый баланс: $updatedBalance");
  return updatedBalance;
}


// 3. withdraw
double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  const int correctPin = 1234;
  int enteredPin = pinCode ?? 0000;

  if (enteredPin != correctPin) {
    print("Транзакция отклонена: неверный PIN-код.");
    return currentBalance;
  }

  double withdrawAmount = amount ?? 0.0;

  if (withdrawAmount > currentBalance) {
    print("Транзакция отклонена: недостаточно средств.");
    return currentBalance;
  }

  double updatedBalance = currentBalance - withdrawAmount;
  print("$name Снятие $withdrawAmount. Новый баланс: $updatedBalance");
  return updatedBalance;
}

void main() {
  double balance = 5000.0;

  checkBalance(name: "Aidana", balance: balance);

  balance = deposit(currentBalance: balance, amount: 1500.0);

  balance = withdraw(
    name: "Aidana",
    currentBalance: balance,
    amount: 2000.0,
    pinCode: 1234,
  );
  balance = withdraw(
    name: "Aidana",
    currentBalance: balance,
    amount: 2000.0,
    pinCode: 9999,
  );
  balance = withdraw(
    name: "Aidana",
    currentBalance: balance,
    amount: 999999.0,
    pinCode: 1234,
  );
  balance = withdraw(
    name: "Aidana",
    currentBalance: balance,
    amount: 500.0,
    pinCode: null,
  );

  checkBalance(name: "Aidana", balance: balance);
}