enum Format {
  minified,
  maximized
}
String format(int number, Format option) {
  if(number == null) return "";
  if(option == null) return "";

  String endResult = number.toString();

  if(option == Format.minified) {
    if(number > 1000000) {
      endResult = endResult.substring(0, endResult.length - 6) + "M";
    } else if(number > 1000) {
      endResult = endResult.substring(0, endResult.length - 3) + "K";
    }
  } else if(option == Format.maximized) {
    if(number > 1000) {
      final String lastThreeNumbers = endResult.substring(endResult.length - 3, endResult.length);
      endResult = endResult.substring(0, endResult.length - 3) + "." + lastThreeNumbers;
      if(number > 1000000) {
        final String lastSixNumbers = endResult.substring(endResult.length - 7, endResult.length);
        endResult = endResult.substring(0, endResult.length - 7) + "." + lastSixNumbers;
      }
    }
  }

  return endResult;

}