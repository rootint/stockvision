///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use yatickerDescriptor instead')
const yaticker$json = const {
  '1': 'yaticker',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'price', '3': 2, '4': 1, '5': 2, '10': 'price'},
    const {'1': 'time', '3': 3, '4': 1, '5': 18, '10': 'time'},
    const {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
    const {'1': 'exchange', '3': 5, '4': 1, '5': 9, '10': 'exchange'},
    const {'1': 'quoteType', '3': 6, '4': 1, '5': 14, '6': '.yaticker.QuoteType', '10': 'quoteType'},
    const {'1': 'marketHours', '3': 7, '4': 1, '5': 14, '6': '.yaticker.MarketHoursType', '10': 'marketHours'},
    const {'1': 'changePercent', '3': 8, '4': 1, '5': 2, '10': 'changePercent'},
    const {'1': 'dayVolume', '3': 9, '4': 1, '5': 18, '10': 'dayVolume'},
    const {'1': 'dayHigh', '3': 10, '4': 1, '5': 2, '10': 'dayHigh'},
    const {'1': 'dayLow', '3': 11, '4': 1, '5': 2, '10': 'dayLow'},
    const {'1': 'change', '3': 12, '4': 1, '5': 2, '10': 'change'},
    const {'1': 'shortName', '3': 13, '4': 1, '5': 9, '10': 'shortName'},
    const {'1': 'expireDate', '3': 14, '4': 1, '5': 18, '10': 'expireDate'},
    const {'1': 'openPrice', '3': 15, '4': 1, '5': 2, '10': 'openPrice'},
    const {'1': 'previousClose', '3': 16, '4': 1, '5': 2, '10': 'previousClose'},
    const {'1': 'strikePrice', '3': 17, '4': 1, '5': 2, '10': 'strikePrice'},
    const {'1': 'underlyingSymbol', '3': 18, '4': 1, '5': 9, '10': 'underlyingSymbol'},
    const {'1': 'openInterest', '3': 19, '4': 1, '5': 18, '10': 'openInterest'},
    const {'1': 'optionsType', '3': 20, '4': 1, '5': 14, '6': '.yaticker.OptionType', '10': 'optionsType'},
    const {'1': 'miniOption', '3': 21, '4': 1, '5': 18, '10': 'miniOption'},
    const {'1': 'lastSize', '3': 22, '4': 1, '5': 18, '10': 'lastSize'},
    const {'1': 'bid', '3': 23, '4': 1, '5': 2, '10': 'bid'},
    const {'1': 'bidSize', '3': 24, '4': 1, '5': 18, '10': 'bidSize'},
    const {'1': 'ask', '3': 25, '4': 1, '5': 2, '10': 'ask'},
    const {'1': 'askSize', '3': 26, '4': 1, '5': 18, '10': 'askSize'},
    const {'1': 'priceHint', '3': 27, '4': 1, '5': 18, '10': 'priceHint'},
    const {'1': 'vol_24hr', '3': 28, '4': 1, '5': 18, '10': 'vol24hr'},
    const {'1': 'volAllCurrencies', '3': 29, '4': 1, '5': 18, '10': 'volAllCurrencies'},
    const {'1': 'fromcurrency', '3': 30, '4': 1, '5': 9, '10': 'fromcurrency'},
    const {'1': 'lastMarket', '3': 31, '4': 1, '5': 9, '10': 'lastMarket'},
    const {'1': 'circulatingSupply', '3': 32, '4': 1, '5': 1, '10': 'circulatingSupply'},
    const {'1': 'marketcap', '3': 33, '4': 1, '5': 1, '10': 'marketcap'},
  ],
  '4': const [yaticker_QuoteType$json, yaticker_OptionType$json, yaticker_MarketHoursType$json],
};

@$core.Deprecated('Use yatickerDescriptor instead')
const yaticker_QuoteType$json = const {
  '1': 'QuoteType',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'ALTSYMBOL', '2': 5},
    const {'1': 'HEARTBEAT', '2': 7},
    const {'1': 'EQUITY', '2': 8},
    const {'1': 'INDEX', '2': 9},
    const {'1': 'MUTUALFUND', '2': 11},
    const {'1': 'MONEYMARKET', '2': 12},
    const {'1': 'OPTION', '2': 13},
    const {'1': 'CURRENCY', '2': 14},
    const {'1': 'WARRANT', '2': 15},
    const {'1': 'BOND', '2': 17},
    const {'1': 'FUTURE', '2': 18},
    const {'1': 'ETF', '2': 20},
    const {'1': 'COMMODITY', '2': 23},
    const {'1': 'ECNQUOTE', '2': 28},
    const {'1': 'CRYPTOCURRENCY', '2': 41},
    const {'1': 'INDICATOR', '2': 42},
    const {'1': 'INDUSTRY', '2': 1000},
  ],
};

@$core.Deprecated('Use yatickerDescriptor instead')
const yaticker_OptionType$json = const {
  '1': 'OptionType',
  '2': const [
    const {'1': 'CALL', '2': 0},
    const {'1': 'PUT', '2': 1},
  ],
};

@$core.Deprecated('Use yatickerDescriptor instead')
const yaticker_MarketHoursType$json = const {
  '1': 'MarketHoursType',
  '2': const [
    const {'1': 'PRE_MARKET', '2': 0},
    const {'1': 'REGULAR_MARKET', '2': 1},
    const {'1': 'POST_MARKET', '2': 2},
    const {'1': 'EXTENDED_HOURS_MARKET', '2': 3},
  ],
};

/// Descriptor for `yaticker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List yatickerDescriptor = $convert.base64Decode('Cgh5YXRpY2tlchIOCgJpZBgBIAEoCVICaWQSFAoFcHJpY2UYAiABKAJSBXByaWNlEhIKBHRpbWUYAyABKBJSBHRpbWUSGgoIY3VycmVuY3kYBCABKAlSCGN1cnJlbmN5EhoKCGV4Y2hhbmdlGAUgASgJUghleGNoYW5nZRIxCglxdW90ZVR5cGUYBiABKA4yEy55YXRpY2tlci5RdW90ZVR5cGVSCXF1b3RlVHlwZRI7CgttYXJrZXRIb3VycxgHIAEoDjIZLnlhdGlja2VyLk1hcmtldEhvdXJzVHlwZVILbWFya2V0SG91cnMSJAoNY2hhbmdlUGVyY2VudBgIIAEoAlINY2hhbmdlUGVyY2VudBIcCglkYXlWb2x1bWUYCSABKBJSCWRheVZvbHVtZRIYCgdkYXlIaWdoGAogASgCUgdkYXlIaWdoEhYKBmRheUxvdxgLIAEoAlIGZGF5TG93EhYKBmNoYW5nZRgMIAEoAlIGY2hhbmdlEhwKCXNob3J0TmFtZRgNIAEoCVIJc2hvcnROYW1lEh4KCmV4cGlyZURhdGUYDiABKBJSCmV4cGlyZURhdGUSHAoJb3BlblByaWNlGA8gASgCUglvcGVuUHJpY2USJAoNcHJldmlvdXNDbG9zZRgQIAEoAlINcHJldmlvdXNDbG9zZRIgCgtzdHJpa2VQcmljZRgRIAEoAlILc3RyaWtlUHJpY2USKgoQdW5kZXJseWluZ1N5bWJvbBgSIAEoCVIQdW5kZXJseWluZ1N5bWJvbBIiCgxvcGVuSW50ZXJlc3QYEyABKBJSDG9wZW5JbnRlcmVzdBI2CgtvcHRpb25zVHlwZRgUIAEoDjIULnlhdGlja2VyLk9wdGlvblR5cGVSC29wdGlvbnNUeXBlEh4KCm1pbmlPcHRpb24YFSABKBJSCm1pbmlPcHRpb24SGgoIbGFzdFNpemUYFiABKBJSCGxhc3RTaXplEhAKA2JpZBgXIAEoAlIDYmlkEhgKB2JpZFNpemUYGCABKBJSB2JpZFNpemUSEAoDYXNrGBkgASgCUgNhc2sSGAoHYXNrU2l6ZRgaIAEoElIHYXNrU2l6ZRIcCglwcmljZUhpbnQYGyABKBJSCXByaWNlSGludBIZCgh2b2xfMjRochgcIAEoElIHdm9sMjRochIqChB2b2xBbGxDdXJyZW5jaWVzGB0gASgSUhB2b2xBbGxDdXJyZW5jaWVzEiIKDGZyb21jdXJyZW5jeRgeIAEoCVIMZnJvbWN1cnJlbmN5Eh4KCmxhc3RNYXJrZXQYHyABKAlSCmxhc3RNYXJrZXQSLAoRY2lyY3VsYXRpbmdTdXBwbHkYICABKAFSEWNpcmN1bGF0aW5nU3VwcGx5EhwKCW1hcmtldGNhcBghIAEoAVIJbWFya2V0Y2FwIoACCglRdW90ZVR5cGUSCAoETk9ORRAAEg0KCUFMVFNZTUJPTBAFEg0KCUhFQVJUQkVBVBAHEgoKBkVRVUlUWRAIEgkKBUlOREVYEAkSDgoKTVVUVUFMRlVORBALEg8KC01PTkVZTUFSS0VUEAwSCgoGT1BUSU9OEA0SDAoIQ1VSUkVOQ1kQDhILCgdXQVJSQU5UEA8SCAoEQk9ORBAREgoKBkZVVFVSRRASEgcKA0VURhAUEg0KCUNPTU1PRElUWRAXEgwKCEVDTlFVT1RFEBwSEgoOQ1JZUFRPQ1VSUkVOQ1kQKRINCglJTkRJQ0FUT1IQKhINCghJTkRVU1RSWRDoByIfCgpPcHRpb25UeXBlEggKBENBTEwQABIHCgNQVVQQASJhCg9NYXJrZXRIb3Vyc1R5cGUSDgoKUFJFX01BUktFVBAAEhIKDlJFR1VMQVJfTUFSS0VUEAESDwoLUE9TVF9NQVJLRVQQAhIZChVFWFRFTkRFRF9IT1VSU19NQVJLRVQQAw==');
