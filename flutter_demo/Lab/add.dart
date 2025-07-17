import 'dart:io';

void main() {
  stdout.write('num1: ');
  int num1 = int.parse(stdin.readLineSync()!);

  stdout.write('num2: ');
  int num2 = int.parse(stdin.readLineSync()!);

  print(num1 + num2);
}
