import 'package:flutter/material.dart';
import 'date_card.dart';

class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime displayMonth;
  final ValueChanged<DateTime> onDateSelected;
  final ScrollController scrollController;
  final VoidCallback onFullCalendarPressed;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.displayMonth,
    required this.onDateSelected,
    required this.scrollController,
    required this.onFullCalendarPressed,
  });

  /// Generate dates for the selected month with proper day alignment
  List<DateTime> _generateCalendarDates() {
    final year = displayMonth.year;
    final month = displayMonth.month;
    
    // First day of the selected month
    final firstDay = DateTime(year, month, 1);
    // Last day of the selected month
    final lastDay = DateTime(year, month + 1, 0);
    
    List<DateTime> dates = [];
    
    // Add dates from the current month only
    for (int i = 1; i <= lastDay.day; i++) {
      dates.add(DateTime(year, month, i));
    }
    
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _generateCalendarDates()
                  .map((date) => DateCard(
                        date: date,
                        isSelected: date.year == selectedDate.year &&
                            date.month == selectedDate.month &&
                            date.day == selectedDate.day,
                        onTap: () => onDateSelected(date),
                      ))
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.calendar_month, color: Color(0xff003a78)),
              onPressed: onFullCalendarPressed,
              tooltip: 'Full View',
            ),
          ),
        ],
      ),
    );
  }
}