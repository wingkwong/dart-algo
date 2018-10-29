const strings = StringAlgo();

class StringAlgo {
  const StringAlgo();

  /// The Hamming distance between two strings of equal length is the number of positions at which the corresponding symbols are different.
  int hammingDistance(String a, String b) {
    if (a.length != b.length) {
      throw ('Strings must be of the same length');
    }

    var distance = 0;

    for (var i = 0; i < a.length; i += 1) {
      if (a[i] != b[i]) {
        distance += 1;
      }
    }
    return distance;
  }

  /// The Knuth–Morris–Pratt string-searching algorithm (or KMP algorithm) searches for occurrences of a "word" W within a main "text string" S
  /// by employing the observation that when a mismatch occurs,
  /// the word itself embodies sufficient information to determine where the next match could begin,
  /// thus bypassing re-examination of previously matched characters.
  int knuthMorrisPratt(String text, String word) {
    if (word.length == 0) {
      return 0;
    }

    var textIndex = 0;
    var wordIndex = 0;

    const patternTable = [0];
    var prefixIndex = 0;
    var suffixIndex = 1;

    while (suffixIndex < word.length) {
      if (word[prefixIndex] == word[suffixIndex]) {
        patternTable[suffixIndex] = prefixIndex + 1;
        suffixIndex += 1;
        prefixIndex += 1;
      } else if (prefixIndex == 0) {
        patternTable[suffixIndex] = 0;
        suffixIndex += 1;
      } else {
        prefixIndex = patternTable[prefixIndex - 1];
      }
    }

    while (textIndex < text.length) {
      if (text[textIndex] == word[wordIndex]) {
        if (wordIndex == word.length - 1) {
          return (textIndex - word.length) + 1;
        }
        wordIndex += 1;
        textIndex += 1;
      } else if (wordIndex > 0) {
        wordIndex = patternTable[wordIndex - 1];
      } else {
        wordIndex = 0;
        textIndex += 1;
      }
    }
    return -1;
  }

  /// The Levenshtein distance is a string metric for measuring the difference between two sequences
  int levenshteinDistance(String a, String b) {
    List distanceMatrix = new List.filled(b.length + 1, null);

    for (var i = 0; i <= a.length; i += 1) {
      distanceMatrix[0][i] = i;
    }

    for (var j = 0; j <= b.length; j += 1) {
      distanceMatrix[j][0] = j;
    }

    for (var j = 1; j <= b.length; j += 1) {
      for (var i = 1; i <= a.length; i += 1) {
        var indicator = a[i - 1] == b[j - 1] ? 0 : 1;
        distanceMatrix[j][i] =
            distanceMatrix[j][i - 1] + 1 < distanceMatrix[j - 1][i] + 1 &&
                    distanceMatrix[j][i - 1] + 1 <
                        distanceMatrix[j - 1][i - 1] + indicator
                ? distanceMatrix[j][i - 1] + 1
                : distanceMatrix[j - 1][i] + 1 <
                        distanceMatrix[j - 1][i - 1] + indicator
                    ? distanceMatrix[j - 1][i] + 1
                    : distanceMatrix[j - 1][i - 1] + indicator;
      }
    }
    return distanceMatrix[b.length][a.length];
  }

  /// The longest common substring problem is to find the longest string (or strings) that is a substring (or are substrings) of two or more strings
  String longestCommonSubstring(String string1, String string2) {
    List s1 = []..add(string1);
    List s2 = []..add(string2);

    List substringMatrix = new List.filled(s2.length + 1, null);

    for (var columnIndex = 0; columnIndex <= s1.length; columnIndex += 1) {
      substringMatrix[0][columnIndex] = 0;
    }

    for (var rowIndex = 0; rowIndex <= s2.length; rowIndex += 1) {
      substringMatrix[rowIndex][0] = 0;
    }

    var longestSubstringLength = 0;
    var longestSubstringColumn = 0;
    var longestSubstringRow = 0;

    for (var rowIndex = 1; rowIndex <= s2.length; rowIndex += 1) {
      for (var columnIndex = 1; columnIndex <= s1.length; columnIndex += 1) {
        if (s1[columnIndex - 1] == s2[rowIndex - 1]) {
          substringMatrix[rowIndex][columnIndex] =
              substringMatrix[rowIndex - 1][columnIndex - 1] + 1;
        } else {
          substringMatrix[rowIndex][columnIndex] = 0;
        }

        if (substringMatrix[rowIndex][columnIndex] > longestSubstringLength) {
          longestSubstringLength = substringMatrix[rowIndex][columnIndex];
          longestSubstringColumn = columnIndex;
          longestSubstringRow = rowIndex;
        }
      }
    }

    if (longestSubstringLength == 0) {
      return '';
    }

    var longestSubstring = '';

    while (substringMatrix[longestSubstringRow][longestSubstringColumn] > 0) {
      longestSubstring = s1[longestSubstringColumn - 1] + longestSubstring;
      longestSubstringRow -= 1;
      longestSubstringColumn -= 1;
    }
    return longestSubstring;
  }

  /// Z algorithm is a linear time string matching algorithm which runs in complexity.
  /// It is used to find all occurrence of a pattern in a string , which is common string searching problem.
  List zAlgorithm(String text, String word) {
    const separator = '\$';
    var zString = '${text}${separator}${word}';

    List wordPositions = new List();
    List zArray = new List.filled(zString.length, null);

    var zBoxLeftIndex = 0;
    var zBoxRightIndex = 0;
    var zBoxShift = 0;

    for (var charIndex = 1; charIndex < zString.length; charIndex += 1) {
      if (charIndex > zBoxRightIndex) {
        zBoxLeftIndex = charIndex;
        zBoxRightIndex = charIndex;

        while (zBoxRightIndex < zString.length &&
            zString[zBoxRightIndex - zBoxLeftIndex] ==
                zString[zBoxRightIndex]) {
          zBoxRightIndex += 1;
        }

        zArray[charIndex] = zBoxRightIndex - zBoxLeftIndex;
        zBoxRightIndex -= 1;
      } else {
        zBoxShift = charIndex - zBoxLeftIndex;
        if (zArray[zBoxShift] < (zBoxRightIndex - charIndex) + 1) {
          zArray[charIndex] = zArray[zBoxShift];
        } else {
          zBoxLeftIndex = charIndex;

          while (zBoxRightIndex < zString.length &&
              zString[zBoxRightIndex - zBoxLeftIndex] ==
                  zString[zBoxRightIndex]) {
            zBoxRightIndex += 1;
          }

          zArray[charIndex] = zBoxRightIndex - zBoxLeftIndex;
          zBoxRightIndex -= 1;
        }
      }
    }

    for (var charIndex = 1; charIndex < zArray.length; charIndex++) {
      if (zArray[charIndex] == word.length) {
        var wordPosition = charIndex - word.length - separator.length;
        wordPositions.add(wordPosition);
      }
    }
    return wordPositions;
  }
}
