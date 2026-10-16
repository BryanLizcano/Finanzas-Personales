import '../../../../core/money/money.dart';
import 'account.dart';

class AccountWithBalance {
  final Account account;
  final Money balance;

  const AccountWithBalance({required this.account, required this.balance});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountWithBalance &&
          runtimeType == other.runtimeType &&
          account == other.account &&
          balance == other.balance;

  @override
  int get hashCode => Object.hash(account, balance);
}
