import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';

enum TickerInterval {
  oneMinute,
  twoMinute,
  fiveMinute,
  fifteenMinute,
  thirtyMinute,
  sixtyMinute,
  ninetyMinute,
  oneDay,
  fiveDay,
  oneWeek,
  oneMonth,
  threeMonth,
}

enum TickerRange {
  oneDay,
  fiveDay,
  oneMonth,
  sixMonth,
  oneYear,
  fiveYear,
  maxRange,
}

class YahooHelper {
  static const apiURL = "https://query1.finance.yahoo.com";
  static const mainApiString = "/v6/finance/quote";
  static const metaApiString = "/v10/finance/quoteSummary/";
  static const chartApiString = "/v8/finance/chart/";
  static const String tradingViewUrl =
      "https://s3-symbol-logo.tradingview.com/";
  YahooHelperChartData? cachedData;

  static const Map<TickerInterval, String> intervalMap = {
    TickerInterval.oneMinute: "1m",
    TickerInterval.twoMinute: "2m",
    TickerInterval.fiveMinute: "5m",
    TickerInterval.fifteenMinute: "15m",
    TickerInterval.thirtyMinute: "30m",
    TickerInterval.sixtyMinute: "60m",
    TickerInterval.ninetyMinute: "90m",
    TickerInterval.oneDay: "1d",
    TickerInterval.fiveDay: "5d",
    TickerInterval.oneWeek: "1wk",
    TickerInterval.oneMonth: "1mo",
    TickerInterval.threeMonth: "3mo",
  };

  static const Map<TickerRange, String> rangeMap = {
    TickerRange.oneDay: "1d",
    TickerRange.fiveDay: "5d",
    TickerRange.oneMonth: "1mo",
    TickerRange.oneYear: "1y",
    TickerRange.fiveYear: "5y",
    TickerRange.sixMonth: "6mo",
    TickerRange.maxRange: "max",
  };

  static const Map<String, String> marketsMap = {
    "MCX": "MOEX",
    "NMS": "NASDAQ",
    "NYQ": "NYSE",
    "GER": "XETR",
    "IOB": "LSIN",
    // add more
  };

  /// Returns a [YahooHelperPriceData] object with
  /// price data of a ticker.
  ///
  /// Throws [Exception] if the response was faulty.
  static Future<YahooHelperPriceData> getCurrentPrice(
      {required String ticker}) async {
    try {
      final response = await http
          .get(Uri.parse(apiURL + mainApiString + "?symbols=" + ticker));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseParsed =
            jsonDecode(response.body)["quoteResponse"]["result"][0];
        final marketState = responseParsed["marketState"];
        double? currentMarketPrice;
        double? currentPercentage;
        if (marketState == 'PRE') {
          currentMarketPrice = responseParsed["preMarketPrice"];
          currentPercentage = responseParsed["preMarketChangePercent"];
        } else if (marketState == 'POST' ||
            marketState == 'POSTPOST' ||
            marketState == 'PREPRE' ||
            marketState == "CLOSED") {
          currentMarketPrice = responseParsed["postMarketPrice"];
          currentPercentage = responseParsed["postMarketChangePercent"];
        }
        return YahooHelperPriceData(
          marketState: marketState,
          currentMarketPrice:
              currentMarketPrice ?? responseParsed["regularMarketPrice"],
          currentPercentage:
              currentPercentage ?? responseParsed["regularMarketChangePercent"],
          dayHigh: responseParsed["regularMarketDayHigh"],
          dayLow: responseParsed["regularMarketDayLow"],
          lastClosePrice: responseParsed["regularMarketPrice"],
          lastPercentage: responseParsed["regularMarketChangePercent"],
          pe: responseParsed["trailingPE"] ?? 'N/A',
          previousDayClose: responseParsed["regularMarketPreviousClose"],
          currency: responseParsed['currency']
        );
      }
      throw Exception("getCurrentPrice ${response.statusCode} Error");
    } catch (error) {
      rethrow;
    }
  }

  /// Returns a string of an SVG of a ticker (taken from TradingView)
  ///
  /// Creates a link to tradingview using the ticker and the market name,
  /// then takes a stock image from meta tags of the page.
  /// However, the image from meta tags is too heavy (600x600 png), but
  /// the link to the svg format of the same image is the same except for
  /// the extension, so I am able to grab the svg.
  /// However, flutter_svg doesn't "like" that the <defs> tag is
  /// at the bottom, so I manually replace those tags and return
  /// an SVG in a string format. Nevertheless, sometimes the images
  /// don't contain <defs> tags at all, so I don't to anything.
  ///
  /// Note: I no more use meta tags, as a simple search in a response.body
  /// string is ~8% faster.
  ///
  /// Throws [Exception] if either Yahoo or TradingView response failed.
  static Future<String> getPictureLink({required String ticker}) async {
    try {
      String marketName = "";
      final responseYahoo = await http
          .get(Uri.parse(apiURL + mainApiString + "?symbols=" + ticker));
      // exchange name is needed for link generation
      if (responseYahoo.statusCode == 200) {
        final responseParsed =
            jsonDecode(responseYahoo.body)["quoteResponse"]["result"][0];
        marketName = responseParsed['exchange'].toUpperCase();
      }
      // preparing ticker for obtaining an image
      if (ticker.contains('.')) {
        ticker = ticker.substring(0, ticker.indexOf('.'));
      }
      ticker = ticker.replaceAll('-', '.');

      final responseTV = await http.get(Uri.parse(
          'https://www.tradingview.com/symbols/${marketsMap[marketName]}-${ticker.toUpperCase()}/'));
      if (responseTV.statusCode == 200) {
        // searching the response.body string for the link to the png
        var body = responseTV.body.toString();
        final pngLink = body.substring(
            body.indexOf(tradingViewUrl), body.indexOf('.png') + 4);

        // converting image link to svg link
        final svgLink = pngLink.substring(0, pngLink.length - 7) + 'big.svg';
        // swapping tags in svg
        final response = await http.get(Uri.parse(svgLink));
        body = response.body;
        final index0 = body.indexOf('<path');
        final index1 = body.indexOf('<defs>');
        final index2 = body.indexOf('</svg>');
        // if the link hasn't got these tags, then do nothing
        final String resultSvg;
        if (index1 != -1) {
          resultSvg = body.substring(0, index0) +
              body.substring(index1, index2) +
              body.substring(index0, index1) +
              body.substring(index2);
        } else {
          resultSvg = body;
        }
        return resultSvg;
      } else {
        return "";
      }
    } catch (error) {
      rethrow;
    }
  }

  /// Returns ticker's metadata [YahooHelperMetaData]. (currency, company name, market cap & stock exchange name)
  ///
  /// Throws [Exception] if a response failed.
  static Future<YahooHelperMetaData> getStockMetadata(
      {required String ticker}) async {
    try {
      final response = await http
          .get(Uri.parse(apiURL + metaApiString + ticker + "?modules=price"));
      if (response.statusCode == 200) {
        final responseParsed =
            jsonDecode(response.body)["quoteSummary"]["result"][0]["price"];
        return YahooHelperMetaData(
          currency: responseParsed["currencySymbol"],
          companyLongName: responseParsed["longName"],
          marketCap: responseParsed["marketCap"]["fmt"],
          exchangeName: responseParsed["exchangeName"],
        );
      }
      throw Exception("getStockMetadata ${response.statusCode} Error");
    } catch (error) {
      rethrow;
    }
  }

  /// Returns a [YahooHelperChartData] object of lists with chart data (timestamp, open, close, high, low,
  /// previous close, range percentage, range high and range low)
  ///
  /// Note: there is a weird bug in the API that makes some elements null,
  /// so remove all the null elements from the arrays, as small
  /// gaps in the graphs are totally negligible.
  ///
  /// Throws [Exception] if a response failed.
  static Future<YahooHelperChartData> getChartData({
    required String ticker,
    TickerInterval interval = TickerInterval.oneMinute,
    TickerRange range = TickerRange.oneDay,
  }) async {
    try {
      final response = await http.get(Uri.parse(apiURL +
          chartApiString +
          ticker +
          '?interval=' +
          intervalMap[interval]! +
          '&range=' +
          rangeMap[range]!));
      if (response.statusCode == 200) {
        final responseParsed = jsonDecode(response.body)['chart']['result'][0];
        final responsePricesParsed = responseParsed['indicators']['quote'][0];
        // conversion to int and double removes null values from the list
        final List<int> responseTimestamp =
            responseParsed['timestamp'].whereType<int>().toList();
        final List<double> responsePricesOpen =
            responsePricesParsed['open'].whereType<double>().toList();
        final List<double> responsePricesClose =
            responsePricesParsed['close'].whereType<double>().toList();
        final List<double> responsePricesHigh =
            responsePricesParsed['high'].whereType<double>().toList();
        final List<double> responsePricesLow =
            responsePricesParsed['low'].whereType<double>().toList();
        final List<int> responsePricesVolume =
            responsePricesParsed['volume'].whereType<int>().toList();
        final double previousClose =
            responseParsed["meta"]["chartPreviousClose"];
        final double currentPrice =
            responseParsed["meta"]["regularMarketPrice"];
        final int timestampEnd =
            responseParsed["meta"]['currentTradingPeriod']['regular']['end'];
        final int timestampStart = responseTimestamp[0];
        return YahooHelperChartData(
          timestamp: responseTimestamp,
          open: responsePricesOpen,
          close: responsePricesClose,
          high: responsePricesHigh,
          low: responsePricesLow,
          volume: responsePricesVolume,
          percentage: (currentPrice - previousClose) / previousClose * 100,
          previousClose: previousClose,
          periodHigh: responsePricesHigh.reduce(max),
          periodLow: responsePricesLow.reduce(min),
          timestampEnd: timestampEnd,
          timestampStart: timestampStart,
          lastClosePrice: currentPrice,
        );
      }
      throw Exception('getChartData ${response.statusCode} Error');
    } catch (error) {
      rethrow;
    }
  }
}
