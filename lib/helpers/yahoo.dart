import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/models/yahoo_models/search_data.dart';
import 'package:stockadvisor/models/yahoo_models/search_item.dart';
import 'package:stockadvisor/models/yahoo_models/spark_data.dart';

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
  static const mainApiString = "/v7/finance/quote";
  static const metaApiString = "/v11/finance/quoteSummary/";
  static const chartApiString = "/v8/finance/chart/";
  static const searchApiString = "/v1/finance/search?q=";
  static const String tradingViewUrl =
      "https://s3-symbol-logo.tradingview.com/";

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

  static const Map<String, String> currencies = {
    'USD': '\$',
    'RUB': '₽',
    'EUR': '€',
    'GBP': '£',
    // add more
  };

  /// Returns a [YahooHelperPriceData] object with
  /// price data of a ticker.
  ///
  /// Throws [Exception] if the response was faulty.
  static Future<YahooHelperPriceData> getCurrentPrice(String ticker) async {
    try {
      final response = await http
          .get(Uri.parse(apiURL + mainApiString + '?symbols=' + ticker));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseParsed =
            jsonDecode(response.body)["quoteResponse"]["result"][0];
        final marketState = responseParsed["marketState"];
        double? currentMarketPrice;
        double? currentPercentage;

        // CHECKING MARKET STATE
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

        // DELTA CALCULATION
        final double lastPriceDelta =
            responseParsed["regularMarketPreviousClose"] *
                responseParsed["regularMarketChangePercent"] /
                100;
        late double currentDelta;
        if (currentMarketPrice == null || currentPercentage == null) {
          currentDelta = lastPriceDelta;
        } else {
          currentDelta = currentMarketPrice * currentPercentage / 100;
        }

        return YahooHelperPriceData(
          currentDelta: currentDelta,
          lastCloseDelta: lastPriceDelta,
          marketState: marketState,
          currentMarketPrice:
              currentMarketPrice ?? responseParsed["regularMarketPrice"],
          currentPercentage:
              currentPercentage ?? responseParsed["regularMarketChangePercent"],
          dayHigh: responseParsed["regularMarketDayHigh"],
          dayLow: responseParsed["regularMarketDayLow"],
          openPrice: responseParsed["regularMarketOpen"],
          lastClosePrice: responseParsed["regularMarketPrice"],
          lastPercentage: responseParsed["regularMarketChangePercent"],
          pe: responseParsed["trailingPE"] ?? 'N/A',
          previousDayClose: responseParsed["regularMarketPreviousClose"],
          currency: responseParsed['currency'],
          extendedMarketAvailable:
              responseParsed.containsKey("postMarketPrice") ||
                  responseParsed.containsKey("preMarketPrice"),
          fiftyTwoWeekHigh: responseParsed["fiftyTwoWeekHigh"],
          fiftyTwoWeekLow: responseParsed["fiftyTwoWeekLow"],
          trailingAnnualDividendRate:
              responseParsed["trailingAnnualDividendRate"] ?? 0,
          trailingAnnualDividendYield:
              responseParsed["trailingAnnualDividendYield"] ?? 0,
          lastDividendTimestamp: responseParsed["dividendDate"] ?? 0,
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
  static Future<String> getIconSvg({required String ticker}) async {
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

  /// Returns [YahooHelperChartData] /spark/ ticker graph over a 52-week period
  ///
  /// Throws [Exception] if a response failed.
  static Future<YahooHelperSparkData> getSparkData(String ticker) async {
    try {
      final response = await http.get(Uri.parse(
          apiURL + '/v8/finance/spark?symbols=$ticker&range=1y&interval=5d'));
      if (response.statusCode == 200) {
        final responseParsed = jsonDecode(response.body)[ticker];
        final List<double> closeList =
            responseParsed['close'].whereType<double>().toList();
        return YahooHelperSparkData(
          chartPreviousClose: responseParsed["chartPreviousClose"],
          close: closeList,
          firstTimestamp: responseParsed["timestamp"][0] ?? 0,
        );
      }
      throw Exception("getSparkData ${response.statusCode} Error");
    } catch (error) {
      rethrow;
    }
  }

  /// Returns ticker's info [YahooHelperInfoData] for cards under the graph.
  ///
  /// Throws [Exception] if a response failed.
  static Future<YahooHelperInfoData> getTickerInfo(String ticker) async {
    try {
      final response = await http.get(Uri.parse(apiURL +
          metaApiString +
          ticker +
          "?modules=defaultKeyStatistics,financialData,earnings"));
      if (response.statusCode == 200) {
        final responseParsed =
            jsonDecode(response.body)["quoteSummary"]["result"][0];
        final defaultKeyStats = responseParsed["defaultKeyStatistics"];
        final financialData = responseParsed["financialData"];
        final earnings = responseParsed["earnings"]["earningsChart"];
        print(defaultKeyStats["52WeekChange"]);
        final earningsList = earnings["quarterly"];
        List<Map<String, dynamic>> earningsHistory = [];
        for (var item in earningsList) {
          earningsHistory.add(
            {
              "quarter": 'Q' + (item["date"] as String)[0],
              "year": (item["date"] as String).substring(2),
              "estimate": item["estimate"]["raw"] ?? 0.0,
              "actual": item["actual"]["raw"] ?? 0.0,
            },
          );
        }
        print(earningsHistory);
        return YahooHelperInfoData(
          recommendationMean: financialData["recommendationMean"]["raw"] ?? 0.0,
          recommendationKey: financialData["recommendationKey"],
          targetMedianPrice: financialData["targetMedianPrice"]["raw"] ?? 0.0,
          yearChange: defaultKeyStats["52WeekChange"]["raw"] ?? 0.0,
          sAndPYearChange: defaultKeyStats["SandP52WeekChange"]["raw"] ?? 0.0,
          currentEarningsYear: earnings["currentQuarterEstimateYear"],
          currentEarningsQuarter: earnings["currentQuarterEstimateDate"],
          currentEarningsTimestamp: (earnings["earningsDate"].isNotEmpty)
              ? earnings["earningsDate"][0]["raw"]
              : 0,
          currentEarningsEstimate:
              earnings["currentQuarterEstimate"]["raw"] ?? 0,
          earningsHistory: earningsHistory,
        );
      }
      throw Exception("getTickerInfo ${response.statusCode} Error");
    } catch (error) {
      rethrow;
    }
  }

  /// Returns ticker's metadata [YahooHelperMetaData]. (currency, company name, market cap, stock exchange name
  /// and the iconSvg)
  ///
  /// Throws [Exception] if a response failed.
  static Future<YahooHelperMetaData> getStockMetadata(
      {required String ticker}) async {
    try {
      final response = await http.get(Uri.parse(apiURL +
          mainApiString +
          '?symbols=$ticker' +
          "&fields=longName,currency"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseParsed =
            jsonDecode(response.body)["quoteResponse"]["result"][0];
        return YahooHelperMetaData(
          currency: currencies[responseParsed["currency"]]!,
          companyLongName: responseParsed["longName"],
          exchangeName: responseParsed["fullExchangeName"],
          type: responseParsed["quoteType"],
          iconSvg: await getIconSvg(ticker: ticker),
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
  static Future<YahooHelperChartData> getChartData(
      Map<String, dynamic> input) async {
    String ticker = input['ticker']!;
    TickerInterval interval = input['interval']!;
    TickerRange range = input['range']!;
    try {
      final response = await http.get(Uri.parse(apiURL +
          chartApiString +
          ticker +
          '?interval=' +
          intervalMap[interval]! +
          '&range=' +
          rangeMap[range]!));
      print('$ticker CHART RESPONSE ENDED $interval $range');
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

  static Future<YahooHelperSearchData> getSearchData(
      {required String query}) async {
    print(apiURL + searchApiString + query);
    try {
      Map<String, YahooHelperSearchItem> searchResults = {};
      final response =
          await http.get(Uri.parse(apiURL + searchApiString + query));
      if (response.statusCode == 200) {
        var responseParsed = jsonDecode(response.body)["quotes"];
        for (var item in responseParsed) {
          searchResults[item["symbol"]] = YahooHelperSearchItem(
            exchangeName: item["exchDisp"],
            type: item["typeDisp"],
            longName: item["longname"] ?? '',
          );
        }
        return YahooHelperSearchData(
          searchResult: searchResults,
        );
      }
      print('api failure');
      final meta = await YahooHelper.getStockMetadata(ticker: query);
      final result = YahooHelperSearchItem(
        exchangeName: meta.exchangeName,
        type: meta.type,
        longName: meta.companyLongName,
      );
      searchResults[query] = result;
      return YahooHelperSearchData(searchResult: searchResults);
    } catch (error) {
      rethrow;
    }
  }
}
