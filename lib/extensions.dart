extension E1 on String {
  /// return text between [startWord] and [endWord]
  String? extract(String startWord, [String? endWord]) {
    String? result;
    int startIndex = indexOf(startWord);

    if (startIndex > 0) {
      int endIndex;
      endWord == null
          ? endIndex = length
          : endIndex = indexOf(endWord, startIndex + startWord.length);
      if (endIndex > 0) {
        result = substring(startIndex + startWord.length, endIndex);
      }
    }
    return result;
  }

  /// extract text between [startWord2] and [startWord1]
  String? extractWith2StartWords(
      String startWord1, String startWord2, String endWord) {
    String? result;
    int startIndex1 = indexOf(startWord1);
    if (startIndex1 < 0) {
      return result;
    }
    int startIndex2 = indexOf(startWord2, startIndex1 + startWord1.length);
    if (startIndex2 < 0) {
      return result;
    }
    int endIndex = indexOf(endWord, startIndex2 + startWord2.length);
    if (endIndex < 0) {
      return result;
    }
    result = substring(startIndex2 + startWord2.length, endIndex);
    return result;
  }

  /// convert string to SQL string with special character like '
  String? toSql() {
    return "'${replaceAll("'", "''").replaceAll("\\", "\\\\")}'";
  }

  double? toDouble() {
    String sTmp = trim();
    sTmp = sTmp.replaceAll(",", ".");
    return double.parse(sTmp);
  }

  int? toInt() {
    String sTmp = trim();
    return int.parse(sTmp);
  }

  /// return right string
  String right(int len) {
    if (len >= length) {
      return this;
    } else {
      return substring(length - len);
    }
  }

  String left(int len) {
    if (len >= length) {
      return this;
    } else {
      return substring(0, len);
    }
  }

  ///conditionnal concat is this is not empty
  String concat(String append) {
    if (this != "") return this + append;
    return this;
  }

  String capitalizeFirstLetter() {
    if (trim().isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeWords() {
    String sResult = "";
    bool bNextIsUpper = true;
    for (var rune in runes) {
      var s = String.fromCharCode(rune);
      if (bNextIsUpper) {
        sResult += s.toUpperCase();
        bNextIsUpper = false;
      } else {
        sResult += s.toLowerCase();
      }
      if (s == ' ' || s == '-') bNextIsUpper = true;
    }
    return sResult;

    // presque mais ce n'est pas bon
    /*return split(RegExp(r'[.-\s]'))
        .map((word) => word.capitalizeFirstLetter())
        .join(' ');*/
  }
}

extension E2 on int {
  int binarySet(int bits) {
    assert(bits != 0);
    return this | bits;
  }

  int binaryUnset(int bits) {
    assert(bits != 0);
    return this & (~bits);
  }

  bool binaryIsSet(int bits) {
    assert(bits != 0);
    if (this & bits == bits) {
      return true;
    } else {
      return false;
    }
  }

  bool binaryIsNotSet(int bits) => !binaryIsSet(bits);
}
