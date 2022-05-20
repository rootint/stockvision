import 'package:stockadvisor/models/server_models/holdings_ticker.dart';

class Holdings {
  List<HoldingsTicker> tickerList;
  final double deltaToday;
  final double deltaTodayPercent;
  final double deltaAlltime;
  final double deltaAlltimePercent;
  final double currentWorth;
  Holdings({
    required this.tickerList,
    required this.deltaAlltime,
    required this.currentWorth,
    required this.deltaAlltimePercent,
    required this.deltaToday,
    required this.deltaTodayPercent,
  });
}
