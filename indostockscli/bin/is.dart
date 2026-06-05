import 'package:indostockscli/indostockscli.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('is', 'Alias CLI for indostockscli')
    ..addCommand(StockBaseCommand())
    ..addCommand(WatchBaseCommand());
  try {
    await runner.run(arguments);
  } catch (e) {
    print('Error: $e');
  }
}
