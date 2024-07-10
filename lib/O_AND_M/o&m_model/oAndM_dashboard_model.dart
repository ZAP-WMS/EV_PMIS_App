import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OAndMDashboardModel {
  OAndMDashboardModel({
    required this.srNo,
    required this.location,
    required this.depotName,
    required this.noOfChargers,
    required this.noOfBuses,
    required this.chargerAvailability,
    required this.noOfFaultOccured,
    required this.totalFaultsResolved,
    required this.totalFaultsPending,
    required this.chargersMttr,
    required this.electricalMttr,
  });

  int srNo;
  String location;
  String depotName;
  int noOfChargers;
  int noOfBuses;
  String chargerAvailability;
  int noOfFaultOccured;
  int totalFaultsResolved;
  int totalFaultsPending;
  double chargersMttr;
  double electricalMttr;

  factory OAndMDashboardModel.fromJson(Map<String, dynamic> json) {
    return OAndMDashboardModel(
      srNo: json["SrNo"],
      location: json["Location"],
      depotName: json["Depotname"],
      noOfChargers: json["chargers"],
      noOfBuses: json["buses"],
      chargerAvailability: json["ChargerAvailability"],
      noOfFaultOccured: json["NoOfFaultOccured"],
      totalFaultsResolved: json["TotalFaultsResolved"],
      totalFaultsPending: json["TotalFaultsPending"],
      chargersMttr: json["MTTR"],
      electricalMttr : json["ElectricalMTTR"] ?? ''
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'Sr.No.', value: srNo),
      DataGridCell(columnName: 'Location', value: location),
      DataGridCell(columnName: 'Depotname', value: depotName),
      DataGridCell(columnName: 'chargers', value: noOfChargers),
      DataGridCell(columnName: 'buses', value: noOfBuses),
      DataGridCell(
          columnName: 'chargerAvailability', value: chargerAvailability),
      DataGridCell(columnName: 'faultOccured', value: noOfFaultOccured),
      DataGridCell(
          columnName: 'totalFaultsResolved', value: totalFaultsResolved),
      DataGridCell(columnName: 'totalFaultsPending', value: totalFaultsPending),
      DataGridCell(columnName: 'chargerMttr', value: chargersMttr),
      DataGridCell(columnName: 'electricalMttr', value: electricalMttr),
    ]);
  }
}
