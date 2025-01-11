
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PreventiveYearlyModel {
  PreventiveYearlyModel({
    required this.srNo,
    required this.equipment,
    required this.frequency,
    required this.installationDate,
    this.maintenanceDates = const [],
  });

  int srNo; // Integer type for srNo
  String equipment; // String for equipment
  String frequency; // String for frequency
  String installationDate; // String for installationDate
  List<String> maintenanceDates; // List of maintenance dates

  // Convert the model data to a Map for storing in Firebase
  Map<String, dynamic> toJson() {
    // Create a map to store all fields
    Map<String, dynamic> data = {
      'srNo': srNo,
      'equipment': equipment,
      'frequency': frequency,
      'installationDate': installationDate,
    };

    // Add maintenance dates dynamically to the map
    for (int i = 0; i < maintenanceDates.length; i++) {
      data['maintenance${i + 1}'] =
          maintenanceDates[i]; // maintenance1, maintenance2, etc.
    }

    return data;
  }

  // Factory method to create an instance of the model from Firebase data
  factory PreventiveYearlyModel.fromJson(Map<String, dynamic> json) {
    List<String> maintenanceList = [];

    // Loop through all keys in the JSON and look for maintenance keys (e.g., maintenance1, maintenance2, ...)
    json.forEach((key, value) {
      if (key.startsWith('Maintenance')) {
        // Look for keys that start with "maintenance"
        maintenanceList.add(value); // Add the maintenance date to the list
      }
    });

    return PreventiveYearlyModel(
      srNo: json['srNo'],
      equipment: json['equipment'],
      frequency: json['frequency'],
      installationDate: json['installationDate'],
      maintenanceDates: maintenanceList,
    );
  }

  DataGridRow dataGridRow() {
    // Initialize cells with the static columns
    List<DataGridCell> cells = [
      DataGridCell<int>(columnName: 'srNo', value: srNo),
      DataGridCell<String>(columnName: 'equipment', value: equipment),
      DataGridCell<String>(columnName: 'frequency', value: frequency),
      DataGridCell<String>(
          columnName: 'installationDate', value: installationDate),
    ];

    // Dynamically add maintenance columns (based on the number of maintenance dates)
    for (int i = 0; i < maintenanceDates.length; i++) {
      cells.add(
        DataGridCell<String>(
          columnName:
              'Maintenance ${i + 1}', // Dynamically generated column names
          value:
              maintenanceDates[i], // Adding the corresponding maintenance date
        ),
      );
    }

    // Return the DataGridRow with all the cells (static + dynamic)
    return DataGridRow(cells: cells);
  }
}
