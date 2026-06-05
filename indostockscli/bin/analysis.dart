import 'package:indostockscli/indostockscli.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) async {
  // Prepend 'stock analysis' to arguments for direct analysis execution
  final fullArgs = ['stock', 'analysis', ...arguments];
  
  final runner = CommandRunner('an', 'Indonesian Stock Technical Analysis - Analisis Teknikal Saham')
    ..addCommand(StockBaseCommand())
    ..addCommand(WatchBaseCommand());
  try {
    await runner.run(fullArgs);
  }
  catch (e) {
    print('Error: $e');
  }
}
