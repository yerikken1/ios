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