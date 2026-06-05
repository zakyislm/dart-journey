import 'analysis/analysis_command.dart';
import 'history/history_command.dart';
import 'info_command.dart';
import 'price_command.dart';
import 'package:args/command_runner.dart';

class StockBaseCommand extends Command {
  @override
  final name = 'stock';
  @override
  final description = 'Commands related to stock information';

  StockBaseCommand(){
    addSubcommand(PriceCommand());
    addSubcommand(InfoCommand());
    addSubcommand(HistoryCommand());
    addSubcommand(AnalysisCommand());
  }
  @override
  void run(){
    print('Please specify a subcommand: price, info, history, or analysis');
    print('Example: is stock price --symbol BBCA');

  }
}
