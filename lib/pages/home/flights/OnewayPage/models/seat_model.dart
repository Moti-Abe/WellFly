enum SeatType { available, occupied, premium, exit }

class SeatInfo {
  final String label;
  final SeatType type;
  final double extraPrice;

  const SeatInfo({
    required this.label,
    required this.type,
    this.extraPrice = 0,
  });
}
