String calculateDaysDifference(String commentDate) {
  DateTime currentDate = DateTime.now();
  DateTime commentDateTime = DateTime.parse(commentDate);

  int differenceInDays = currentDate.difference(commentDateTime).inDays;
  if (differenceInDays == 0) {
    int differenceInHours = currentDate.difference(commentDateTime).inHours;
    if (differenceInHours > 0) {
      return '$differenceInHours hrs ago';
    } else {
      int differentInMinutes =
          currentDate.difference(commentDateTime).inMinutes;
      if (differentInMinutes > 0) {
        return '$differentInMinutes min ago';
      } else {
        return '${currentDate.difference(commentDateTime).inSeconds} sec ago';
      }
    }
  } else if (differenceInDays <= 31) {
    return '$differenceInDays days ago';
  } else if (differenceInDays <= 365) {
    int differenceInMonths = (differenceInDays / 30).floor();
    return '$differenceInMonths months ago';
  } else {
    int differenceInYears = (differenceInDays / 365).floor();
    return '$differenceInYears years ago';
  }
}
