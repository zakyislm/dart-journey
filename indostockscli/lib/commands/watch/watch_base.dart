import 'add_command.dart';
import 'list_command.dart';
import 'package:args/command_runner.dart';

class WatchBaseCommand extends Command {
  @override
  final name = 'watch';
  @override
  final description = 'Commands related to watchlist';
  WatchBaseCommand(){
    addSubcommand(AddCommand());
    addSubcommand(ListCommand());
  }
}