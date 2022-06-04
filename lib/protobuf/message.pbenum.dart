///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class yaticker_QuoteType extends $pb.ProtobufEnum {
  static const yaticker_QuoteType NONE = yaticker_QuoteType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NONE');
  static const yaticker_QuoteType ALTSYMBOL = yaticker_QuoteType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ALTSYMBOL');
  static const yaticker_QuoteType HEARTBEAT = yaticker_QuoteType._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HEARTBEAT');
  static const yaticker_QuoteType EQUITY = yaticker_QuoteType._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EQUITY');
  static const yaticker_QuoteType INDEX = yaticker_QuoteType._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'INDEX');
  static const yaticker_QuoteType MUTUALFUND = yaticker_QuoteType._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MUTUALFUND');
  static const yaticker_QuoteType MONEYMARKET = yaticker_QuoteType._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MONEYMARKET');
  static const yaticker_QuoteType OPTION = yaticker_QuoteType._(13, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OPTION');
  static const yaticker_QuoteType CURRENCY = yaticker_QuoteType._(14, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CURRENCY');
  static const yaticker_QuoteType WARRANT = yaticker_QuoteType._(15, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WARRANT');
  static const yaticker_QuoteType BOND = yaticker_QuoteType._(17, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BOND');
  static const yaticker_QuoteType FUTURE = yaticker_QuoteType._(18, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FUTURE');
  static const yaticker_QuoteType ETF = yaticker_QuoteType._(20, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ETF');
  static const yaticker_QuoteType COMMODITY = yaticker_QuoteType._(23, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMODITY');
  static const yaticker_QuoteType ECNQUOTE = yaticker_QuoteType._(28, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ECNQUOTE');
  static const yaticker_QuoteType CRYPTOCURRENCY = yaticker_QuoteType._(41, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CRYPTOCURRENCY');
  static const yaticker_QuoteType INDICATOR = yaticker_QuoteType._(42, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'INDICATOR');
  static const yaticker_QuoteType INDUSTRY = yaticker_QuoteType._(1000, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'INDUSTRY');

  static const $core.List<yaticker_QuoteType> values = <yaticker_QuoteType> [
    NONE,
    ALTSYMBOL,
    HEARTBEAT,
    EQUITY,
    INDEX,
    MUTUALFUND,
    MONEYMARKET,
    OPTION,
    CURRENCY,
    WARRANT,
    BOND,
    FUTURE,
    ETF,
    COMMODITY,
    ECNQUOTE,
    CRYPTOCURRENCY,
    INDICATOR,
    INDUSTRY,
  ];

  static final $core.Map<$core.int, yaticker_QuoteType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static yaticker_QuoteType? valueOf($core.int value) => _byValue[value];

  const yaticker_QuoteType._($core.int v, $core.String n) : super(v, n);
}

class yaticker_OptionType extends $pb.ProtobufEnum {
  static const yaticker_OptionType CALL = yaticker_OptionType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CALL');
  static const yaticker_OptionType PUT = yaticker_OptionType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUT');

  static const $core.List<yaticker_OptionType> values = <yaticker_OptionType> [
    CALL,
    PUT,
  ];

  static final $core.Map<$core.int, yaticker_OptionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static yaticker_OptionType? valueOf($core.int value) => _byValue[value];

  const yaticker_OptionType._($core.int v, $core.String n) : super(v, n);
}

class yaticker_MarketHoursType extends $pb.ProtobufEnum {
  static const yaticker_MarketHoursType PRE_MARKET = yaticker_MarketHoursType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PRE_MARKET');
  static const yaticker_MarketHoursType REGULAR_MARKET = yaticker_MarketHoursType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'REGULAR_MARKET');
  static const yaticker_MarketHoursType POST_MARKET = yaticker_MarketHoursType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POST_MARKET');
  static const yaticker_MarketHoursType EXTENDED_HOURS_MARKET = yaticker_MarketHoursType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EXTENDED_HOURS_MARKET');

  static const $core.List<yaticker_MarketHoursType> values = <yaticker_MarketHoursType> [
    PRE_MARKET,
    REGULAR_MARKET,
    POST_MARKET,
    EXTENDED_HOURS_MARKET,
  ];

  static final $core.Map<$core.int, yaticker_MarketHoursType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static yaticker_MarketHoursType? valueOf($core.int value) => _byValue[value];

  const yaticker_MarketHoursType._($core.int v, $core.String n) : super(v, n);
}

