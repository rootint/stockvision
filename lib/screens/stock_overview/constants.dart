import 'package:stockadvisor/helpers/yahoo.dart';

const rangeConversionMap = {
  '1D': TickerRange.oneDay,
  '5D': TickerRange.fiveDay,
  '1M': TickerRange.oneMonth,
  '6M': TickerRange.sixMonth,
  '1Y': TickerRange.oneYear,
  '5Y': TickerRange.fiveYear,
  'MAX': TickerRange.maxRange,
};

const List<String> availableTimeframes = [
  "1D",
  "5D",
  "1M",
  "6M",
  "1Y",
  "5Y",
  "MAX"
];
const marketStateConversionMap = {
  'PREPRE': 'Post:',
  'PRE': 'Pre:',
  'REGULAR': '',
  'POST': 'Post:',
  'POSTPOST': 'Post:',
  'CLOSED': 'After mkt:',
};

enum RowPosition {
  left,
  right,
  center,
}