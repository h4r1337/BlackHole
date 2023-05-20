/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2022, Ankit Sangwan
 */

import 'package:logging/logging.dart';

bool matchSongs({
  required String title,
  required String artist,
  required String title2,
  required String artist2,
}) {
  Logger.root.info('Matching $title by $artist with $title2 by $artist2');
  final title1 = title.toLowerCase();
  final title3 = title2.toLowerCase();
  final names1 = artist.toLowerCase().split(',');
  final names2 = artist2.toLowerCase().split(',');
  bool artistMatched = false;
  bool titleMatched = false;

  // Check if at least one artist name matches
  for (final String name1 in names1) {
    for (final String name2 in names2) {
      if (flexibleMatch(
        string1: name1,
        string2: name2,
        flexibility: 0,
      )) {
        artistMatched = true;
        break;
      }
    }
    if (artistMatched) {
      break;
    }
  }

  titleMatched = flexibleMatch(
    string1: title1,
    string2: title3,
    wordMatch: true,
  );

  Logger.root.info('TitleMatched: $titleMatched');
  Logger.root.info('ArtistMatched: $artistMatched');

  return artistMatched && titleMatched;
}

bool flexibleMatch({
  required String string1,
  required String string2,
  double flexibility = 0.7,
  bool wordMatch = false,
}) {
  final text1 = string1.toLowerCase().trim();
  final text2 = string2.toLowerCase().trim();
  if (text1 == text2) {
    return true;
  } else if (text1.contains(text2) || text2.contains(text1)) {
    return true;
  } else if (flexibility > 0) {
    final bool matched = flexibilityCheck(
      text1: text1,
      text2: text2,
      wordMatch: wordMatch,
      flexibility: flexibility,
    );
    if (matched) {
      return true;
    } else if (text1.contains('(') || text2.contains('(')) {
      return flexibilityCheck(
        text1: text1.split('(')[0].trim(),
        text2: text2.split('(')[0].trim(),
        wordMatch: wordMatch,
        flexibility: flexibility,
      );
    }
  }

  return false;
}

bool flexibilityCheck({
  required String text1,
  required String text2,
  required bool wordMatch,
  required double flexibility,
}) {
  int count = 0;
  final list1 = wordMatch ? text1.split(' ') : text1.split('');
  final list2 = wordMatch ? text2.split(' ') : text2.split('');
  final minLength = list1.length > list2.length ? list1.length : list2.length;

  for (int i = 0; i < minLength; i++) {
    if (list1[i] == list2[i]) {
      count++;
    } else {
      break;
    }
  }
  final percentage = count / minLength;
  if ((1 - percentage) <= flexibility) {
    return true;
  }
  return false;
}
