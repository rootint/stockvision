///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pbenum.dart';

export 'message.pbenum.dart';

class yaticker extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'yaticker', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.OF)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OS6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currency')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'exchange')
    ..e<yaticker_QuoteType>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quoteType', $pb.PbFieldType.OE, protoName: 'quoteType', defaultOrMaker: yaticker_QuoteType.NONE, valueOf: yaticker_QuoteType.valueOf, enumValues: yaticker_QuoteType.values)
    ..e<yaticker_MarketHoursType>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marketHours', $pb.PbFieldType.OE, protoName: 'marketHours', defaultOrMaker: yaticker_MarketHoursType.PRE_MARKET, valueOf: yaticker_MarketHoursType.valueOf, enumValues: yaticker_MarketHoursType.values)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changePercent', $pb.PbFieldType.OF, protoName: 'changePercent')
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dayVolume', $pb.PbFieldType.OS6, protoName: 'dayVolume', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dayHigh', $pb.PbFieldType.OF, protoName: 'dayHigh')
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dayLow', $pb.PbFieldType.OF, protoName: 'dayLow')
    ..a<$core.double>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'change', $pb.PbFieldType.OF)
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shortName', protoName: 'shortName')
    ..a<$fixnum.Int64>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expireDate', $pb.PbFieldType.OS6, protoName: 'expireDate', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'openPrice', $pb.PbFieldType.OF, protoName: 'openPrice')
    ..a<$core.double>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previousClose', $pb.PbFieldType.OF, protoName: 'previousClose')
    ..a<$core.double>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strikePrice', $pb.PbFieldType.OF, protoName: 'strikePrice')
    ..aOS(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'underlyingSymbol', protoName: 'underlyingSymbol')
    ..a<$fixnum.Int64>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'openInterest', $pb.PbFieldType.OS6, protoName: 'openInterest', defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<yaticker_OptionType>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'optionsType', $pb.PbFieldType.OE, protoName: 'optionsType', defaultOrMaker: yaticker_OptionType.CALL, valueOf: yaticker_OptionType.valueOf, enumValues: yaticker_OptionType.values)
    ..a<$fixnum.Int64>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'miniOption', $pb.PbFieldType.OS6, protoName: 'miniOption', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastSize', $pb.PbFieldType.OS6, protoName: 'lastSize', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bid', $pb.PbFieldType.OF)
    ..a<$fixnum.Int64>(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bidSize', $pb.PbFieldType.OS6, protoName: 'bidSize', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ask', $pb.PbFieldType.OF)
    ..a<$fixnum.Int64>(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'askSize', $pb.PbFieldType.OS6, protoName: 'askSize', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priceHint', $pb.PbFieldType.OS6, protoName: 'priceHint', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'vol24hr', $pb.PbFieldType.OS6, protoName: 'vol_24hr', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volAllCurrencies', $pb.PbFieldType.OS6, protoName: 'volAllCurrencies', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fromcurrency')
    ..aOS(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastMarket', protoName: 'lastMarket')
    ..a<$core.double>(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'circulatingSupply', $pb.PbFieldType.OD, protoName: 'circulatingSupply')
    ..a<$core.double>(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marketcap', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  yaticker._() : super();
  factory yaticker({
    $core.String? id,
    $core.double? price,
    $fixnum.Int64? time,
    $core.String? currency,
    $core.String? exchange,
    yaticker_QuoteType? quoteType,
    yaticker_MarketHoursType? marketHours,
    $core.double? changePercent,
    $fixnum.Int64? dayVolume,
    $core.double? dayHigh,
    $core.double? dayLow,
    $core.double? change,
    $core.String? shortName,
    $fixnum.Int64? expireDate,
    $core.double? openPrice,
    $core.double? previousClose,
    $core.double? strikePrice,
    $core.String? underlyingSymbol,
    $fixnum.Int64? openInterest,
    yaticker_OptionType? optionsType,
    $fixnum.Int64? miniOption,
    $fixnum.Int64? lastSize,
    $core.double? bid,
    $fixnum.Int64? bidSize,
    $core.double? ask,
    $fixnum.Int64? askSize,
    $fixnum.Int64? priceHint,
    $fixnum.Int64? vol24hr,
    $fixnum.Int64? volAllCurrencies,
    $core.String? fromcurrency,
    $core.String? lastMarket,
    $core.double? circulatingSupply,
    $core.double? marketcap,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (price != null) {
      _result.price = price;
    }
    if (time != null) {
      _result.time = time;
    }
    if (currency != null) {
      _result.currency = currency;
    }
    if (exchange != null) {
      _result.exchange = exchange;
    }
    if (quoteType != null) {
      _result.quoteType = quoteType;
    }
    if (marketHours != null) {
      _result.marketHours = marketHours;
    }
    if (changePercent != null) {
      _result.changePercent = changePercent;
    }
    if (dayVolume != null) {
      _result.dayVolume = dayVolume;
    }
    if (dayHigh != null) {
      _result.dayHigh = dayHigh;
    }
    if (dayLow != null) {
      _result.dayLow = dayLow;
    }
    if (change != null) {
      _result.change = change;
    }
    if (shortName != null) {
      _result.shortName = shortName;
    }
    if (expireDate != null) {
      _result.expireDate = expireDate;
    }
    if (openPrice != null) {
      _result.openPrice = openPrice;
    }
    if (previousClose != null) {
      _result.previousClose = previousClose;
    }
    if (strikePrice != null) {
      _result.strikePrice = strikePrice;
    }
    if (underlyingSymbol != null) {
      _result.underlyingSymbol = underlyingSymbol;
    }
    if (openInterest != null) {
      _result.openInterest = openInterest;
    }
    if (optionsType != null) {
      _result.optionsType = optionsType;
    }
    if (miniOption != null) {
      _result.miniOption = miniOption;
    }
    if (lastSize != null) {
      _result.lastSize = lastSize;
    }
    if (bid != null) {
      _result.bid = bid;
    }
    if (bidSize != null) {
      _result.bidSize = bidSize;
    }
    if (ask != null) {
      _result.ask = ask;
    }
    if (askSize != null) {
      _result.askSize = askSize;
    }
    if (priceHint != null) {
      _result.priceHint = priceHint;
    }
    if (vol24hr != null) {
      _result.vol24hr = vol24hr;
    }
    if (volAllCurrencies != null) {
      _result.volAllCurrencies = volAllCurrencies;
    }
    if (fromcurrency != null) {
      _result.fromcurrency = fromcurrency;
    }
    if (lastMarket != null) {
      _result.lastMarket = lastMarket;
    }
    if (circulatingSupply != null) {
      _result.circulatingSupply = circulatingSupply;
    }
    if (marketcap != null) {
      _result.marketcap = marketcap;
    }
    return _result;
  }
  factory yaticker.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory yaticker.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  yaticker clone() => yaticker()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  yaticker copyWith(void Function(yaticker) updates) => super.copyWith((message) => updates(message as yaticker)) as yaticker; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static yaticker create() => yaticker._();
  yaticker createEmptyInstance() => create();
  static $pb.PbList<yaticker> createRepeated() => $pb.PbList<yaticker>();
  @$core.pragma('dart2js:noInline')
  static yaticker getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<yaticker>(create);
  static yaticker? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get price => $_getN(1);
  @$pb.TagNumber(2)
  set price($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get time => $_getI64(2);
  @$pb.TagNumber(3)
  set time($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get exchange => $_getSZ(4);
  @$pb.TagNumber(5)
  set exchange($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExchange() => $_has(4);
  @$pb.TagNumber(5)
  void clearExchange() => clearField(5);

  @$pb.TagNumber(6)
  yaticker_QuoteType get quoteType => $_getN(5);
  @$pb.TagNumber(6)
  set quoteType(yaticker_QuoteType v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasQuoteType() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuoteType() => clearField(6);

  @$pb.TagNumber(7)
  yaticker_MarketHoursType get marketHours => $_getN(6);
  @$pb.TagNumber(7)
  set marketHours(yaticker_MarketHoursType v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMarketHours() => $_has(6);
  @$pb.TagNumber(7)
  void clearMarketHours() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get changePercent => $_getN(7);
  @$pb.TagNumber(8)
  set changePercent($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasChangePercent() => $_has(7);
  @$pb.TagNumber(8)
  void clearChangePercent() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get dayVolume => $_getI64(8);
  @$pb.TagNumber(9)
  set dayVolume($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDayVolume() => $_has(8);
  @$pb.TagNumber(9)
  void clearDayVolume() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get dayHigh => $_getN(9);
  @$pb.TagNumber(10)
  set dayHigh($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDayHigh() => $_has(9);
  @$pb.TagNumber(10)
  void clearDayHigh() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get dayLow => $_getN(10);
  @$pb.TagNumber(11)
  set dayLow($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasDayLow() => $_has(10);
  @$pb.TagNumber(11)
  void clearDayLow() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get change => $_getN(11);
  @$pb.TagNumber(12)
  set change($core.double v) { $_setFloat(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasChange() => $_has(11);
  @$pb.TagNumber(12)
  void clearChange() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get shortName => $_getSZ(12);
  @$pb.TagNumber(13)
  set shortName($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasShortName() => $_has(12);
  @$pb.TagNumber(13)
  void clearShortName() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get expireDate => $_getI64(13);
  @$pb.TagNumber(14)
  set expireDate($fixnum.Int64 v) { $_setInt64(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasExpireDate() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpireDate() => clearField(14);

  @$pb.TagNumber(15)
  $core.double get openPrice => $_getN(14);
  @$pb.TagNumber(15)
  set openPrice($core.double v) { $_setFloat(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasOpenPrice() => $_has(14);
  @$pb.TagNumber(15)
  void clearOpenPrice() => clearField(15);

  @$pb.TagNumber(16)
  $core.double get previousClose => $_getN(15);
  @$pb.TagNumber(16)
  set previousClose($core.double v) { $_setFloat(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasPreviousClose() => $_has(15);
  @$pb.TagNumber(16)
  void clearPreviousClose() => clearField(16);

  @$pb.TagNumber(17)
  $core.double get strikePrice => $_getN(16);
  @$pb.TagNumber(17)
  set strikePrice($core.double v) { $_setFloat(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasStrikePrice() => $_has(16);
  @$pb.TagNumber(17)
  void clearStrikePrice() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get underlyingSymbol => $_getSZ(17);
  @$pb.TagNumber(18)
  set underlyingSymbol($core.String v) { $_setString(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasUnderlyingSymbol() => $_has(17);
  @$pb.TagNumber(18)
  void clearUnderlyingSymbol() => clearField(18);

  @$pb.TagNumber(19)
  $fixnum.Int64 get openInterest => $_getI64(18);
  @$pb.TagNumber(19)
  set openInterest($fixnum.Int64 v) { $_setInt64(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasOpenInterest() => $_has(18);
  @$pb.TagNumber(19)
  void clearOpenInterest() => clearField(19);

  @$pb.TagNumber(20)
  yaticker_OptionType get optionsType => $_getN(19);
  @$pb.TagNumber(20)
  set optionsType(yaticker_OptionType v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasOptionsType() => $_has(19);
  @$pb.TagNumber(20)
  void clearOptionsType() => clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get miniOption => $_getI64(20);
  @$pb.TagNumber(21)
  set miniOption($fixnum.Int64 v) { $_setInt64(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasMiniOption() => $_has(20);
  @$pb.TagNumber(21)
  void clearMiniOption() => clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get lastSize => $_getI64(21);
  @$pb.TagNumber(22)
  set lastSize($fixnum.Int64 v) { $_setInt64(21, v); }
  @$pb.TagNumber(22)
  $core.bool hasLastSize() => $_has(21);
  @$pb.TagNumber(22)
  void clearLastSize() => clearField(22);

  @$pb.TagNumber(23)
  $core.double get bid => $_getN(22);
  @$pb.TagNumber(23)
  set bid($core.double v) { $_setFloat(22, v); }
  @$pb.TagNumber(23)
  $core.bool hasBid() => $_has(22);
  @$pb.TagNumber(23)
  void clearBid() => clearField(23);

  @$pb.TagNumber(24)
  $fixnum.Int64 get bidSize => $_getI64(23);
  @$pb.TagNumber(24)
  set bidSize($fixnum.Int64 v) { $_setInt64(23, v); }
  @$pb.TagNumber(24)
  $core.bool hasBidSize() => $_has(23);
  @$pb.TagNumber(24)
  void clearBidSize() => clearField(24);

  @$pb.TagNumber(25)
  $core.double get ask => $_getN(24);
  @$pb.TagNumber(25)
  set ask($core.double v) { $_setFloat(24, v); }
  @$pb.TagNumber(25)
  $core.bool hasAsk() => $_has(24);
  @$pb.TagNumber(25)
  void clearAsk() => clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get askSize => $_getI64(25);
  @$pb.TagNumber(26)
  set askSize($fixnum.Int64 v) { $_setInt64(25, v); }
  @$pb.TagNumber(26)
  $core.bool hasAskSize() => $_has(25);
  @$pb.TagNumber(26)
  void clearAskSize() => clearField(26);

  @$pb.TagNumber(27)
  $fixnum.Int64 get priceHint => $_getI64(26);
  @$pb.TagNumber(27)
  set priceHint($fixnum.Int64 v) { $_setInt64(26, v); }
  @$pb.TagNumber(27)
  $core.bool hasPriceHint() => $_has(26);
  @$pb.TagNumber(27)
  void clearPriceHint() => clearField(27);

  @$pb.TagNumber(28)
  $fixnum.Int64 get vol24hr => $_getI64(27);
  @$pb.TagNumber(28)
  set vol24hr($fixnum.Int64 v) { $_setInt64(27, v); }
  @$pb.TagNumber(28)
  $core.bool hasVol24hr() => $_has(27);
  @$pb.TagNumber(28)
  void clearVol24hr() => clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get volAllCurrencies => $_getI64(28);
  @$pb.TagNumber(29)
  set volAllCurrencies($fixnum.Int64 v) { $_setInt64(28, v); }
  @$pb.TagNumber(29)
  $core.bool hasVolAllCurrencies() => $_has(28);
  @$pb.TagNumber(29)
  void clearVolAllCurrencies() => clearField(29);

  @$pb.TagNumber(30)
  $core.String get fromcurrency => $_getSZ(29);
  @$pb.TagNumber(30)
  set fromcurrency($core.String v) { $_setString(29, v); }
  @$pb.TagNumber(30)
  $core.bool hasFromcurrency() => $_has(29);
  @$pb.TagNumber(30)
  void clearFromcurrency() => clearField(30);

  @$pb.TagNumber(31)
  $core.String get lastMarket => $_getSZ(30);
  @$pb.TagNumber(31)
  set lastMarket($core.String v) { $_setString(30, v); }
  @$pb.TagNumber(31)
  $core.bool hasLastMarket() => $_has(30);
  @$pb.TagNumber(31)
  void clearLastMarket() => clearField(31);

  @$pb.TagNumber(32)
  $core.double get circulatingSupply => $_getN(31);
  @$pb.TagNumber(32)
  set circulatingSupply($core.double v) { $_setDouble(31, v); }
  @$pb.TagNumber(32)
  $core.bool hasCirculatingSupply() => $_has(31);
  @$pb.TagNumber(32)
  void clearCirculatingSupply() => clearField(32);

  @$pb.TagNumber(33)
  $core.double get marketcap => $_getN(32);
  @$pb.TagNumber(33)
  set marketcap($core.double v) { $_setDouble(32, v); }
  @$pb.TagNumber(33)
  $core.bool hasMarketcap() => $_has(32);
  @$pb.TagNumber(33)
  void clearMarketcap() => clearField(33);
}

