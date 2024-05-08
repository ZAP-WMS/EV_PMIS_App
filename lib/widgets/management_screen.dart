String managementRole = 'O&M';
List<String> managementScreen = [
  '/daily-report',
  '/monthly-report',
  '/breakdown_screen',
  '/charger_availability_screen',
];
List managementImagedata = [
  'assets/overview_image/daily_progress.png',
  'assets/overview_image/monthly.png',
  'assets/overview_image/safety.png',
  'assets/overview_image/closure_report.png',
];

List<String> managementDescription = [
  'Daily Progress Report',
  'Monthly Project Monitoring',
  'Breakdown Data',
  'Charger Availability Status'
];

List<String> breakdownClnName = [
  'Sr.No.',
  'Location',
  'Depot name',
  'Equipment Name',
  'Chargers affected',
  'Fault Type',
  'Fault',
  'Attribute to',
  'Fault Occurrance',
  'Fault Resolving',
  'Year',
  'Month',
  'AgencyName',
  'Fault Resolve by',
  'Status',
  'Pending',
  'MTTR',
  'Remarks'
];

List<String> chargerAvailabilityClnName = [
  'Sr.No.',
  'Location',
  'Depot name',
  'ChargerNo',
  'ChargerSrNo',
  'ChargerMake',
  'TargetTime',
  'TimeLoss',
  'Availability',
  'Remarks',
];
