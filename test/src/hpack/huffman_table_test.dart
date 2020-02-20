// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show ascii;

import 'package:test/test.dart';
import 'package:http2/src/hpack/huffman.dart';
import 'package:http2/src/hpack/huffman_table.dart';

main() {
  group('hpack', () {
    group('huffman', () {
      final decode = http2HuffmanCodec.decode;
      final encode = http2HuffmanCodec.encode;

      Map<String, List<int>> hpackSpecTestCases = {
        'www.example.com': [
          0xf1,
          0xe3,
          0xc2,
          0xe5,
          0xf2,
          0x3a,
          0x6b,
          0xa0,
          0xab,
          0x90,
          0xf4,
          0xff
        ],
        'no-cache': [0xa8, 0xeb, 0x10, 0x64, 0x9c, 0xbf],
        'custom-key': [0x25, 0xa8, 0x49, 0xe9, 0x5b, 0xa9, 0x7d, 0x7f],
        'custom-value': [0x25, 0xa8, 0x49, 0xe9, 0x5b, 0xb8, 0xe8, 0xb4, 0xbf],
      };

      test('hpack-spec-testcases', () {
        hpackSpecTestCases.forEach((String value, List<int> encoding) {
          expect(decode(encoding), ascii.encode(value));
          expect(encode(ascii.encode(value)), encoding);
        });
      });

      test('more-than-7-bit-padding', () {
        var data = [
          // Just more-than-7-bitpadding
          [0xff],
          [0xff, 0xff],
          [0xff, 0xff, 0xff],
          [0xff, 0xff, 0xff, 0xff],

          // 0xf8 = '&' + more-than-7-bitpadding
          [0xf8, 0xff],
          [0xf8, 0xff, 0xff],
          [0xf8, 0xff, 0xff, 0xff],
          [0xf8, 0xff, 0xff, 0xff, 0xff],

          // ')' + entire EOS
          [0xfe, 0xff, 0xff, 0xff, 0xff],
        ];

        for (var test in data) {
          expect(() => decode(test), throwsA(isHuffmanDecodingException));
        }
      });

      test('incomplete-encoding', () {
        var data = [
          // Incomplete encoding
          [0xfe],

          // 0xf8 = '&' + Incomplete encoding
          [0xf8, 0xfe],
        ];

        for (var test in data) {
          expect(() => decode(test), throwsA(isHuffmanDecodingException));
        }
      });

      test('fuzzy-test', () {
        var data = [
          [0xb8, 0xa4, 0x4e, 0xe3, 0xb1, 0x4d, 0x3d, 0x63, 0x16, 0x5b, 0x6a],
          [0x71, 0x5f, 0xb3, 0xb1, 0x4b, 0x94, 0xe8, 0x2f, 0x4c, 0x3d, 0x04],
          [0x95, 0x6d, 0x89, 0xfb, 0x91, 0x6a, 0x6c, 0x52, 0x64, 0x9a, 0xd1],
          [0x64, 0x59, 0x79, 0x38, 0xd2, 0x09, 0xea, 0x94, 0x92, 0xda, 0x24],
          [0xb0, 0x35, 0xfe, 0xa9, 0x96, 0xb5, 0xe1, 0xde, 0x0a, 0x82, 0x18],
          [0x39, 0xe5, 0xdd, 0xba, 0x50, 0xd4, 0x33, 0xa7, 0xb9, 0x63, 0x21],
          [0x26, 0x52, 0x7a, 0xaa, 0x52, 0x4d, 0x27, 0x81, 0xe4, 0xef, 0xcd],
          [0x17, 0x9e, 0x09, 0xcc, 0xd0, 0x0f, 0x5e, 0x03, 0x45, 0xc9, 0xba],
          [0x84, 0xfc, 0x75, 0xeb, 0xcc, 0x9e, 0xb6, 0x50, 0x3f, 0xf8, 0x00],
          [0xb9, 0x24, 0x95, 0x13, 0x6d, 0x89, 0xb2, 0x89, 0x86, 0x02, 0xca],
          [0xb7, 0xd5, 0x78, 0xfa, 0xa3, 0xa9, 0x90, 0x1b, 0x35, 0xb4, 0x72],
          [0x62, 0x9a, 0x31, 0x0c, 0x32, 0x1c, 0x25, 0x2e, 0x1b, 0x56, 0x55],
          [0xa9, 0x5d, 0xa8, 0xa4, 0xed, 0x91, 0xeb, 0xba, 0xa0, 0xf9, 0x82],
          [0x59, 0x9c, 0xc3, 0x6f, 0x66, 0xec, 0x65, 0xe0, 0x95, 0x6e, 0x34],
          [0x3d, 0xc7, 0x0d, 0x6c, 0x01, 0x7d, 0xf2, 0x03, 0x9b, 0xe3, 0xc1],
          [0x1d, 0xc6, 0xa4, 0xd1, 0x59, 0x52, 0xce, 0x42, 0x3d, 0xf6, 0xe5],
          [0x2d, 0xbd, 0xb6, 0x5c, 0xfb, 0x52, 0x65, 0x2e, 0x7f, 0x03, 0x61],
          [0x22, 0x24, 0x50, 0x48, 0x65, 0x5a, 0xe0, 0x0d, 0xf9, 0x78, 0x8d],
          [0x72, 0xeb, 0x1d, 0x31, 0xb7, 0xe3, 0xa8, 0x15, 0x1f, 0xf1, 0x43],
          [0x45, 0xa4, 0x40, 0x5a, 0x9c, 0x98, 0xa8, 0x6e, 0xac, 0xba, 0x83],
          [0x27, 0x55, 0x33, 0xa7, 0x79, 0x08, 0x29, 0x42, 0x6d, 0x89, 0xfc],
          [0x3b, 0x65, 0x21, 0x7a, 0x24, 0x58, 0x58, 0x6a, 0x97, 0x6e, 0x7c],
          [0x56, 0x41, 0xff, 0x08, 0xaf, 0x9d, 0x33, 0x12, 0xcd, 0xb5, 0x99],
          [0x35, 0x48, 0x38, 0x46, 0x3f, 0xee, 0x15, 0x16, 0x8d, 0xf5, 0x16],
          [0xcc, 0xc0, 0x1b, 0x1e, 0xf1, 0xae, 0xf7, 0x40, 0xca, 0xc7, 0x9d],
          [0x93, 0xae, 0x93, 0xcf, 0x97, 0xdf, 0xba, 0xd6, 0xb2, 0xac, 0x2f],
          [0x45, 0xe4, 0x5b, 0x73, 0x54, 0x4c, 0x6c, 0x95, 0xa9, 0xab, 0x7f],
          [0x71, 0xac, 0xbf, 0xdf, 0xa4, 0x29, 0xe3, 0x17, 0x3f, 0x24, 0x2f],
          [0x5e, 0xc0, 0xf2, 0xbf, 0x5d, 0xc0, 0x31, 0x2d, 0x97, 0x24, 0x1d],
          [0x6d, 0x0b, 0x7c, 0x15, 0x68, 0x7c, 0xe1, 0x15, 0xbf, 0x4f, 0x85],
          [0x0a, 0x59, 0xf2, 0x3e, 0x48, 0x1d, 0xac, 0xc8, 0x22, 0xb0, 0x37],
          [0x3a, 0xe2, 0x9e, 0xec, 0xf9, 0x1e, 0x88, 0xfa, 0xbe, 0x00, 0xee],
          [0xc7, 0x5a, 0x1f, 0xc8, 0x48, 0x23, 0x3b, 0x1a, 0x0f, 0xf3, 0x7c],
          [0x43, 0x0d, 0x10, 0x03, 0xb2, 0xc6, 0xbd, 0xed, 0x03, 0x19, 0x49],
          [0xc9, 0xc4, 0x0e, 0xf3, 0xc6, 0xf4, 0xc1, 0x71, 0xee, 0x96, 0xeb],
          [0x18, 0x51, 0x07, 0x36, 0x1a, 0x13, 0x83, 0x69, 0x2b, 0x1b, 0x09],
          [0xac, 0x23, 0xb7, 0x47, 0x2d, 0xeb, 0x39, 0xdc, 0x3e, 0xdb, 0x74],
          [0x44, 0x60, 0x06, 0x28, 0x5e, 0x8f, 0xef, 0xfc, 0x70, 0x7b, 0x73],
          [0xda, 0x38, 0x25, 0x76, 0xa9, 0x1a, 0x99, 0x9a, 0x52, 0xdf, 0x8c],
          [0xd4, 0xc4, 0x99, 0x2b, 0x54, 0x88, 0xc9, 0x34, 0x80, 0x43, 0x15],
          [0x11, 0xa1, 0xed, 0xe3, 0xb4, 0x88, 0xd5, 0x1d, 0x4a, 0x1b, 0x9f],
          [0xfd, 0x2c, 0xb4, 0x6e, 0x65, 0xfb, 0x27, 0x9b, 0x65, 0x55, 0x19],
          [0xb6, 0xa4, 0x67, 0x16, 0x8a, 0x59, 0xf5, 0xfc, 0x0f, 0x7e, 0x24],
          [0x40, 0x8e, 0x5d, 0x84, 0x90, 0x76, 0x50, 0xdb, 0x72, 0x2a, 0x3b],
          [0x7d, 0x1e, 0x9d, 0x2f, 0xad, 0xce, 0x60, 0x00, 0xf8, 0xbc, 0xfa],
          [0xc1, 0x2d, 0x32, 0xbd, 0xa2, 0xe7, 0xed, 0x17, 0x48, 0xca, 0xb0],
          [0xe6, 0x91, 0x6c, 0xa7, 0xdc, 0x83, 0x58, 0x19, 0x05, 0xb1, 0xa6],
          [0xec, 0xb2, 0x16, 0xa3, 0x89, 0x7a, 0xcd, 0x44, 0xe9, 0x3a, 0x98],
          [0xcf, 0xef, 0x78, 0x5b, 0x7a, 0xec, 0xa8, 0xfa, 0x6c, 0x78, 0x23],
          [0x8b, 0x53, 0x89, 0x82, 0x21, 0x3e, 0xfc, 0xed, 0xe4, 0x6b, 0xa0],
          [0xff, 0x28, 0x10, 0xb2, 0x24, 0xf9, 0xb5, 0x3e, 0x08, 0xb2, 0x50],
          [0x5e, 0x57, 0x11, 0xff, 0x06, 0x1b, 0xc7, 0x0b, 0x28, 0x5b, 0x34],
          [0x00, 0x4a, 0xcc, 0x4e, 0x8e, 0x07, 0xea, 0x93, 0x10, 0x1c, 0x87],
          [0xab, 0xc7, 0x7e, 0x10, 0x64, 0x7f, 0xa4, 0x6c, 0xca, 0x93, 0x73],
          [0xcf, 0x57, 0xc5, 0x15, 0xbc, 0x47, 0xed, 0x5b, 0x1e, 0xb5, 0x9b],
          [0x8e, 0xa5, 0xf3, 0x07, 0xa0, 0x68, 0x1e, 0x9e, 0xea, 0x57, 0x3f],
          [0xfe, 0xa7, 0x7f, 0x91, 0xc7, 0xa4, 0x15, 0x7c, 0xa2, 0x00, 0x4c],
          [0xb9, 0x62, 0x28, 0xa5, 0x9b, 0x04, 0x98, 0xf9, 0xdd, 0x37, 0x42],
          [0xfa, 0x40, 0x1c, 0xce, 0xa0, 0x75, 0x9d, 0xaf, 0xd2, 0x09, 0xae],
          [0xa7, 0x8e, 0xdb, 0x1e, 0x8b, 0x94, 0x24, 0x47, 0xd8, 0x04, 0xd7],
          [0x69, 0x95, 0x8a, 0x29, 0xbe, 0x9f, 0xfb, 0x71, 0x91, 0x9a, 0x40],
          [0x82, 0xed, 0x1e, 0xf5, 0xac, 0x34, 0x17, 0xfe, 0x5f, 0xfd, 0xd3],
          [0x81, 0xe6, 0xaa, 0x7b, 0x12, 0xf0, 0xb2, 0xb9, 0x47, 0x02, 0x3c],
          [0x05, 0xc3, 0x6d, 0xd5, 0xf1, 0xa4, 0x93, 0xe2, 0x8b, 0x7c, 0xed],
        ];
        for (var test in data) {
          expect(decode(encode(test)), equals(test));
        }
      });
    });
  });
}

/// A matcher for HuffmanDecodingExceptions.
const Matcher isHuffmanDecodingException =
    TypeMatcher<HuffmanDecodingException>();
