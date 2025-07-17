import 'dart:io';

void main() {
  stdout.write('write the number 3 :');
  int x = int.parse(stdin.readLineSync()!);

  if (x == 3) {
    print('it is right');
  } else {
    print('dont be dumb');
  }
}
