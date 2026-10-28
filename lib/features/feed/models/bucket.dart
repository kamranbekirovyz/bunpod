enum Bucket {
  today('Today'),
  yesterday('Yesterday'),
  thisWeek('This Week'),
  thisMonth('This Month'),
  earlier('Earlier');

  const Bucket(this.label);

  final String label;
}
