import 'package:html/dom.dart' as dom;

import '../../features/threads/domain/thread_models.dart';

ThreadPagination parseThreadPagination(
  dom.Document doc, {
  required int fallbackPage,
}) {
  var currentPage = fallbackPage;
  int? totalPages;
  String? nextPageUrl;
  String? previousPageUrl;

  final pageNav = doc.querySelector('.pageNav');
  if (pageNav != null) {
    final currentElement = pageNav.querySelector('.pageNav-page--current');
    final parsedCurrent = _extractInt(currentElement?.text);
    if (parsedCurrent != null) {
      currentPage = parsedCurrent;
    }

    final pageNumbers = <int>[];
    for (final element in pageNav.querySelectorAll('.pageNav-page')) {
      final number = _extractInt(element.text);
      if (number != null) {
        pageNumbers.add(number);
      }
    }
    if (pageNumbers.isNotEmpty) {
      totalPages = pageNumbers.reduce((value, element) => value > element ? value : element);
    }

    nextPageUrl = pageNav.querySelector('.pageNav-jump--next')?.attributes['href'];
    previousPageUrl = pageNav.querySelector('.pageNav-jump--prev')?.attributes['href'];
  }

  if (totalPages == null) {
    final simpleNavCurrent = doc.querySelector('.pageNavSimple-el--current');
    if (simpleNavCurrent != null) {
      final text = simpleNavCurrent.text.trim();
      final currentMatch = RegExp(r'^(\d+)').firstMatch(text);
      final totalMatch = RegExp(r'of\s+(\d+)').firstMatch(text);
      final parsedCurrent = currentMatch != null ? int.tryParse(currentMatch.group(1) ?? '') : null;
      final parsedTotal = totalMatch != null ? int.tryParse(totalMatch.group(1) ?? '') : null;
      if (parsedCurrent != null) {
        currentPage = parsedCurrent;
      }
      if (parsedTotal != null) {
        totalPages = parsedTotal;
      }
    }

    nextPageUrl ??= doc.querySelector('.pageNavSimple-el--next')?.attributes['href'];
    previousPageUrl ??= doc.querySelector('.pageNavSimple-el--prev')?.attributes['href'];
  }

  totalPages ??= currentPage;

  return ThreadPagination(
    currentPage: currentPage,
    totalPages: totalPages,
    nextPageUrl: nextPageUrl,
    previousPageUrl: previousPageUrl,
  );
}

int? _extractInt(String? value) {
  if (value == null) {
    return null;
  }
  final match = RegExp(r'(-?\d+)').firstMatch(value.replaceAll(',', ''));
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(1) ?? '');
}
