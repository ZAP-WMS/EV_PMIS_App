import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/view_AllFiles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../style.dart';
import '../action__screen/uplad_doc.dart';
import '../o&m_model/preventive_model.dart';

class PreventiveYearlyDatasource extends DataGridSource {
  BuildContext mainContext;
  int tabIndex;
  String cityName;
  String depoName;
  String userId;
  List data = [];

  PreventiveYearlyDatasource(this._preventiveMaintenance, this.mainContext,
      this.tabIndex, this.cityName, this.depoName, this.userId) {
    buildDataGridRows();
    fetchDataFromFirebase();
    // initializePdfList();
  }

  void buildDataGridRows() {
    dataGridRows = _preventiveMaintenance
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  // Method to initialize pdfList based on the number of rows
  void initializePdfList() {
    // Assuming _preventiveMaintenance.length gives you the row count
    List<List<String?>> pdfList = List.generate(
      10, // Number of rows (you can adjust this to your needs)
      (i) => List.filled(dataGridRows.length,
          null), // Each row has dataGridRows.length columns, initialized to null
    );
  }

  @override
  List<PreventiveYearlyModel> _preventiveMaintenance = [];
  double totalMttrForConclusion = 0.0;
  List<DataGridRow> dataGridRows = [];
  bool isTotalMttrConcluded = true;

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<dynamic> tableData = [];
  List<GridColumn> columns = [];

  String? maintenancePart;
  String? numberPart;
  String? servicedDate = '';
  List<String> selectedPdfName = [];
  List<Map<String, dynamic>> rowsData = []; // Store data for each row
  Map<int, String?> pdfUrls =
      {}; // Map to store pdfUrl for each row by row index
  List<String?> pdfList = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> yearOption = ['Yearly', 'Half Yearly', 'Quarterly', 'Monthly'];

  String submissionDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  void addMaintenanceColumn(int columnIndex, String columnName, String value) {
    // Check if the column with the given name already exists
    bool columnExists =
        columns.any((column) => column.columnName == columnName);

    if (columnExists) {
      // If the column exists, update its values for each row
      for (var row in dataGridRows) {
        // Find the index of the column to update
        int cellIndex =
            row.getCells().indexWhere((cell) => cell.columnName == columnName);
        if (cellIndex != -1) {
          row.getCells()[cellIndex] =
              DataGridCell<String>(columnName: columnName, value: value);
        }
      }
    } else {
      // If the column doesn't exist, add it as a new column at the next index
      int nextIndex = columnIndex + 1;

      // Add a new column at the next index
      columns.insert(
        nextIndex,
        GridColumn(
            width: 180,
            columnName: columnName,
            label: Container(
              alignment: Alignment.center, // Center the label within the cell
              child: Text(
                columnName,
                textAlign:
                    TextAlign.center, // Center the text inside the container
              ),
            )),
      );

      // Add the new data (column value) to each row
      for (var row in dataGridRows) {
        row.getCells().insert(
              nextIndex,
              DataGridCell<String>(columnName: columnName, value: value),
            );
      }
    }

    // Notify listeners to update the grid
    notifyListeners();
  }

  void _pickPdfForRow(int rowIndex, int columnIndex) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    // Get the current date
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    if (result != null) {
      // Get the file from the result and store it locally
      File selectedFile = File(result.files.single.path!);
      servicedDate = formattedDate;
      // Update the pdfList at the correct row index with the selected file's name
      if (rowIndex >= 0 && rowIndex < pdfList.length) {
        pdfList[rowIndex] = result.files.first.name;
      } else {
        print("Invalid row index: $rowIndex");
      }

      notifyListeners();

      // Now upload the selected file for the row
      await _uploadPdfToFirebase(
          selectedFile, pdfList[rowIndex].toString(), rowIndex);
      notifyListeners();
    } else {
      print('No file selected');
    }
  }

  // Function to upload PDF to Firebase Storage and store the URL
  Future<void> _uploadPdfToFirebase(
      File selectedFile, String selectedPdfName, int rowIndex) async {
    try {
      String filePath =
          'preventive maintenance/${yearOption[tabIndex]}/$rowIndex/$selectedPdfName';
      Reference storageRef = _storage.ref().child(filePath);

      UploadTask uploadTask = storageRef.putFile(selectedFile);

      showDialog(
        context: mainContext,
        barrierDismissible:
            false, // Prevent dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Uploading..."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(), // Show the progress indicator
                SizedBox(height: 10),
                Text("Please wait while we are setting your pdf..."),
              ],
            ),
          );
        },
      );

      await uploadTask.whenComplete(() async {
        String pdfUrl = await storageRef.getDownloadURL();

        pdfUrls[rowIndex] = pdfUrl;

        // rowsData[rowIndex]['pdfUrl'] = pdfUrl;
        Navigator.of(mainContext).pop();

        notifyListeners();
      });
    } catch (e) {
      print("Error uploading file: $e");
    }
  }

  void updateColumns(List<String> maintenanceDates) {
    Map<String, dynamic> tableData = {};

    for (var i in dataGridRows) {
      for (var data in i.getCells()) {
        tableData[data.columnName] = data.value;
      }
      columns.clear();
      // You might want to ensure the column is added only once for each unique column name
      for (var data in i.getCells()) {
        if (!columns.any((col) => col.columnName == data.columnName)) {
          columns.add(
            GridColumn(
              columnName: data.columnName,
              visible: true,
              allowEditing: false,
              width: data.columnName == 'srNo'
                  ? MediaQuery.of(mainContext).size.width * 0.13
                  : data.columnName.contains('Maintenance')
                      ? MediaQuery.of(mainContext).size.width * 0.5
                      : MediaQuery.of(mainContext).size.width * 0.35,
              label: createColumnLabel(data.columnName),
            ),
          );
        }
      }
      print(columns.length);
      // Add the maintenance columns dynamically, ensuring they do not already exist
      for (int i = 0; i < maintenanceDates.length; i++) {
        String columnName = 'Maintenance ${i + 1}';

        // Only add the maintenance column if it doesn't already exist
        if (!columns.any((col) => col.columnName == columnName)) {
          columns.add(
            GridColumn(
              columnName: columnName,
              visible: true,
              allowEditing: false,
              width: MediaQuery.of(mainContext).size.width *
                  0.5, // Adjust width as needed
              label: createColumnLabel(columnName),
            ),
          );
        }
      }

      tableData = {}; // Reset after each row
    }
  }

  List<DataGridRow> previousDataGridRows = []; // To store previous row data
  bool _isUpdating =
      false; // Flag to ensure update isn't triggered multiple times

  void updateRows(List<PreventiveYearlyModel> updatedData, int columnIndex) {
    // Prevent the update from running if it's already in progress
    if (_isUpdating) return;

    // Set the flag to true to indicate that the update is in progress
    _isUpdating = true;

    if (updatedData == null || updatedData.isEmpty) {
      dataGridRows = [];
      notifyListeners();
      _isUpdating = false;
      return;
    }

    // Map the updated data to data grid rows
    dataGridRows = updatedData.map((data) {
      List<DataGridCell> cells = [
        DataGridCell<int>(columnName: 'srNo', value: data.srNo),
        DataGridCell<String>(columnName: 'equipment', value: data.equipment),
        DataGridCell<String>(columnName: 'frequency', value: data.frequency),
        DataGridCell<String>(
            columnName: 'installationDate', value: data.installationDate),
      ];

      // Dynamically add maintenance columns based on the number of maintenance dates
      for (int i = 0; i < data.maintenanceDates.length; i++) {
        String columnName = 'Maintenance ${i + 1}';
        String docColumnName = '${columnName} Doc';

        // Add columns if they don't already exist
        if (!cells.any((cell) => cell.columnName == columnName)) {
          cells.add(DataGridCell<String>(
              columnName: columnName, value: data.maintenanceDates[i]));
          cells.add(DataGridCell<String>(
              columnName: docColumnName, value: data.maintenanceDates[i]));
        }
      }

      // Update or add maintenance based on columnIndex
      if (columnIndex == 3) {
        int cellIndex =
            cells.indexWhere((cell) => cell.columnName == 'Maintenance 1');
        int cellsDoc = cellIndex + 1;

        if (cellIndex != -1) {
          // If the cell exists, update its value by replacing it
          cells[cellIndex] = DataGridCell<String>(
            columnName: 'Maintenance 1',
            value: data.maintenanceDates.isNotEmpty
                ? data.maintenanceDates[0]
                : '',
          );
          cells[cellsDoc] = DataGridCell<String>(
            columnName: 'Maintenance 1 Doc',
            value: data.maintenanceDates.isNotEmpty
                ? data.maintenanceDates[0]
                : '',
          );
        } else {
          // If no cell with 'Maintenance 1' exists, add a new one
          cells.add(DataGridCell<String>(
            columnName: 'Maintenance 1',
            value: data.maintenanceDates.isNotEmpty
                ? data.maintenanceDates[0]
                : '',
          ));
          cells.add(DataGridCell<String>(
            columnName: 'Maintenance 1 Doc',
            value: data.maintenanceDates.isNotEmpty
                ? data.maintenanceDates[0]
                : '',
          ));
        }
      }

      return DataGridRow(cells: cells);
    }).toList();

    // Check if row data has changed
    if (_hasRowDataChanged(previousDataGridRows, dataGridRows)) {
      // If rows have changed, do something, e.g., adding new rows, logging, etc.
      print("Row data has changed!");
    }

    // Store the current row data for the next update
    previousDataGridRows = List.from(dataGridRows);

    // Notify listeners and reset the flag
    notifyListeners();
    _isUpdating = false; // Reset the flag after the update
  }

// Helper method to compare previous and current row data
  bool _hasRowDataChanged(
      List<DataGridRow> previousRows, List<DataGridRow> currentRows) {
    if (previousRows.length != currentRows.length) return true;

    for (int i = 0; i < previousRows.length; i++) {
      var previousRow = previousRows[i];
      var currentRow = currentRows[i];

      // Compare row data (you can customize this to compare specific cells or all cells)
      if (!ListEquality()
          .equals(previousRow.getCells(), currentRow.getCells())) {
        return true; // Return true if there is any difference
      }
    }

    return false; // No changes
  }

  // void addMaintenanceDate(
  //     int dataRowIndex, int dataColumnIndex, DateTime date) {
  //   PreventiveYearlyModel model = _preventiveMaintenance[dataRowIndex];
  //   model.maintenanceDates = List<String>.from(model.maintenanceDates);

  //   // model.maintenanceDates.add(DateFormat('dd-MM-yyyy').format(date));

  //   if (dataColumnIndex >= 0 && model.maintenanceDates.isNotEmpty) {
  //     int dataIndex = (dataColumnIndex - 2) ~/ 2;
  //     // Check if the dataIndex is within the bounds of the list
  //     if (dataIndex >= 0 && dataIndex < model.maintenanceDates.length) {
  //       // Replace the existing value at dataIndex
  //       model.maintenanceDates[dataIndex] =
  //           DateFormat('dd-MM-yyyy').format(date);
  //     } else if (dataIndex == model.maintenanceDates.length) {
  //       model.maintenanceDates.add(DateFormat('dd-MM-yyyy').format(date));
  //     } else if (dataIndex > model.maintenanceDates.length) {
  //       while (model.maintenanceDates.length < dataIndex) {
  //         model.maintenanceDates
  //             .add(''); // Adding empty strings to extend the list
  //       }
  //       model.maintenanceDates.add(DateFormat('dd-MM-yyyy')
  //           .format(date)); // Insert the new value at dataIndex
  //     }
  //   } else {
  //     // If the columnIndex is out of bounds, you can choose to add it at the end
  //     model.maintenanceDates.add(DateFormat('dd-MM-yyyy').format(date));
  //   }
  //   print('maintenance Date ${model.maintenanceDates.length}');
  //   updateColumns(dataColumnIndex); // Update columns based on new data
  //   updateRows(_preventiveMaintenance, dataColumnIndex);
  // }

  void separateMaintenance(String input) {
    RegExp regExp = RegExp(r'([a-zA-Z\s]+)(\d+)');
    var match = regExp.firstMatch(input);

    if (match != null) {
      maintenancePart = match.group(1)!;
      numberPart = match.group(2)!;
    } else {
      print("The input doesn't match the expected pattern.");
    }
  }

  int separateMaintenance1(String input) {
    RegExp regExp = RegExp(r'([a-zA-Z\s]+)(\d+)');
    var match = regExp.firstMatch(input);

    if (match != null) {
      maintenancePart = match.group(1)!;
      numberPart = match.group(2)!;
    } else {
      print("The input doesn't match the expected pattern.");
    }
    return int.parse(numberPart ?? '0');
  }

  void preventiveMaintenanceStore(
      BuildContext context, String userId, String depoName) {
    Map<String, dynamic> tableData = Map();
    List<dynamic> tabledata = [];
    String dueDate = '';

    if (dataGridRows != null && dataGridRows.isNotEmpty) {
      for (int rowIndex = 0; rowIndex < dataGridRows.length; rowIndex++) {
        var i = dataGridRows[rowIndex]; // Current row
        for (var data in i.getCells()) {
          tableData[data.columnName] = data.value;
        }

        tabledata.add(tableData);

        tableData = {};
      }
    }

    FirebaseFirestore.instance
        .collection('PrevntiveMaintenance')
        .doc(depoName)
        .collection(yearOption[tabIndex])
        .doc(userId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        // Document exists, update it
        docSnapshot.reference.update({
          'data': tabledata,
        }).whenComplete(() {
          tabledata.clear();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Data are updated'),
            backgroundColor: blue,
          ));
        });
      } else {
        // Document doesn't exist, create it
        docSnapshot.reference.set({
          'data': tabledata,
        }).whenComplete(() {
          tabledata.clear();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Data are added'),
            backgroundColor: blue,
          ));
        });
      }
    });
    // FirebaseFirestore.instance
    //     .collection('PrevntiveMaintenance')
    //     .doc(depoName)
    //     .collection(yearOption[tabIndex])
    //     .doc(userId)
    //     .update({
    //   'data': tabledata,
    // }).whenComplete(() {
    //   tabledata.clear();
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: const Text('Data are synced'),
    //     backgroundColor: blue,
    //   ));
    // });
  }

  String getDueDate(String installationDate, int index) {
    // Check if the installation date is empty or null
    if (installationDate.isEmpty || installationDate == null) {
      print('Error: installationDate is empty or null');
      return 'Invalid Date'; // Return a default value or handle the error gracefully
    }

    try {
      // Define the expected format
      DateFormat format = DateFormat("dd-MM-yyyy");
      print('installation Date: $installationDate');

      // Try parsing the date
      DateTime now = format.parse(installationDate);

      DateTime dueDate;

      switch (index) {
        case 0:
          dueDate = now.add(const Duration(days: 365)); // 1 year from now
          break;
        case 1:
          dueDate = now.add(
              const Duration(days: 183)); // 6 months from now (approximately)
          break;
        case 2:
          dueDate = now
              .add(const Duration(days: 90)); // 3 months (quarterly) from now
          break;
        case 3:
          dueDate = now.add(const Duration(days: 30)); // 1 month from now
          break;
        default:
          dueDate = now;
          break;
      }

      // Format the due date and return it
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      return 'Due Date: ${dateFormat.format(dueDate)}';
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid Date'; // Return a fallback message in case of an error
    }
  }

  Map<String, dynamic> submissionData = {}; // Global variable to hold the data
  Map<String, dynamic> dataList = {};
  late List<Map<String, dynamic>> submissionDataList = []; // Store fetched data

// Function to fetch data from Firebase
  Future<Map<String, dynamic>> fetchDataFromFirebase() async {
    try {
      // Fetch the document snapshot
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('PrevntiveMaintenance')
          .doc(depoName) // Ensure this is your document ID
          .collection(yearOption[tabIndex]) // Sub-collection based on year
          .doc(userId) // Sub-collection based on user ID
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Store the fetched data into the global submissionData variable
        submissionData = docSnapshot.data()
            as Map<String, dynamic>; // Cast it to Map<String, dynamic>
        // Check if 'submission Date' exists and is of the expected type (List<Map<String, dynamic>>)
        if (submissionData.containsKey('submission Date') &&
            submissionData['submission Date'] is List) {
          // Cast 'submission Date' to List<Map<String, dynamic>> if it exists
          submissionDataList = List<Map<String, dynamic>>.from(
              submissionData['submission Date']);
        } else {
          // If 'submission Date' doesn't exist or is not a List, set an empty list
          submissionDataList = [];
        }

        notifyListeners();
        return submissionData;
      } else {
        return {}; // Return an empty map if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {}; // Return an empty map if there's an error
    }
  }

  int getColumnIndex(DataGridRow row, String columnName) {
    // Loop through the cells of the row
    for (int i = 0; i < row.getCells().length; i++) {
      if (row.getCells()[i].columnName == columnName) {
        return i; // Return the index if columnName matches
      }
    }
    return -1; // Return -1 if the column was not found
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    DateTime? date;

    String getPreviousColumnSubDate(String previousColumnName) {
      // Here, you should have logic to get the previous column's subDate
      // This could be from your submissionDataList or other data sources
      // Example:
      for (var data in submissionDataList) {
        if (data.containsKey(previousColumnName)) {
          return data[previousColumnName] ?? ''; // return the subDate if found
        }
      }
      return ''; // return empty string if not found
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      String due = '';
      final int dataRowIndex = dataGridRows.indexOf(row);

      // Accessing the specific cell value from DataGridRow
      DataGridCell installationDateCell =
          dataGridRows[dataRowIndex].getCells()[3];
      String installationDate = installationDateCell.value.toString();

      String dueDateText = getDueDate(installationDate, tabIndex);
      int maintIndex = 0;

      if (dataGridCell.columnName.contains('Maintenance')) {
        maintIndex = separateMaintenance1(dataGridCell.columnName) - 1;
      }
      if (dataGridCell.columnName.contains('Maintenance') &&
          !dataGridCell.columnName.contains('Maintenance 1')) {
        // Get the index of the current column (maintenance)
        int currentColumnIndex = getColumnIndex(row, dataGridCell.columnName);

        // Determine the previous column name
        String previousColumnName = 'Maintenance ${currentColumnIndex - 4}';

        // Now retrieve the subDate for the previous column
        String previousColumnSubDate =
            getPreviousColumnSubDate(previousColumnName);

        // Now use the subDate for further processing
        due = getDueDate(previousColumnSubDate, tabIndex);
      }

      return (dataGridCell.columnName == 'installationDate')
          ? Row(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: mainContext,
                        builder: (mainContext) => AlertDialog(
                              insetPadding: const EdgeInsets.all(8),
                              buttonPadding: const EdgeInsets.all(15),
                              title: const Text(
                                'All Date',
                                style: TextStyle(fontSize: 18),
                              ),
                              content: SizedBox(
                                  height:
                                      MediaQuery.of(mainContext).size.height *
                                          0.6,
                                  width: MediaQuery.of(mainContext).size.width *
                                      0.6,
                                  child: SfDateRangePicker(
                                    selectionShape:
                                        DateRangePickerSelectionShape.rectangle,
                                    viewSpacing: 5,
                                    headerHeight: 12,
                                    view: DateRangePickerView.month,
                                    showTodayButton: false,
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      if (args.value is PickerDateRange) {}
                                    },
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    showActionButtons: true,
                                    onCancel: () {
                                      Navigator.pop(mainContext);
                                    },
                                    onSubmit: ((value) {
                                      date = DateTime.parse(value.toString());

                                      final int dataRowIndex =
                                          dataGridRows.indexOf(row);
                                      if (dataRowIndex != null) {
                                        final int dataRowIndex =
                                            dataGridRows.indexOf(row);
                                        dataGridRows[dataRowIndex]
                                                .getCells()[3] =
                                            DataGridCell<String>(
                                                columnName: 'installationDate',
                                                value: DateFormat('dd-MM-yyyy')
                                                    .format(date!));
                                        _preventiveMaintenance[dataRowIndex]
                                                .installationDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(date!);

                                        notifyListeners();

                                        Navigator.pop(mainContext);
                                        String columnName = 'installationDate';

                                        for (var i in dataGridRows) {
                                          // Iterate over each row
                                          for (int columnIndex = 0;
                                              columnIndex < i.getCells().length;
                                              columnIndex++) {
                                            // Iterate over each cell in the row
                                            var data = i.getCells()[
                                                columnIndex]; // Get the current cell

                                            if (data.columnName == columnName) {
                                              // Assuming the installationDate is in the format "DD-MM-YYYY"
                                              String installationDateString =
                                                  _preventiveMaintenance[
                                                          dataRowIndex]
                                                      .installationDate;

                                              List<String> dateParts =
                                                  installationDateString
                                                      .split('-');
                                              int day = int.parse(dateParts[0]);
                                              int month =
                                                  int.parse(dateParts[1]);
                                              int year =
                                                  int.parse(dateParts[2]);

                                              DateTime installationDate =
                                                  DateTime(year, month, day);

                                              DateTime oneYearLater = DateTime(
                                                  installationDate.year + 1,
                                                  installationDate.month,
                                                  installationDate.day - 1);

                                              // addMaintenanceColumn(
                                              //     columnIndex,
                                              //     'Maintenance 1 Doc',
                                              //     currentDate);
                                              addMaintenanceColumn(columnIndex,
                                                  'Maintenance 1', currentDate);

                                              break;
                                            }
                                          }
                                        }
                                      }
                                    }),
                                  )),
                            ));
                  },
                  icon: const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                ),
                Text(
                  dataGridCell.value.toString(),
                  style: appTextStyle,
                ),
              ],
            )
          : (dataGridCell.columnName.contains('Maintenance 1'))
              ? Column(
                  children: [
                    Center(child: Text(dueDateText)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                final int columnIndex = getColumnIndex(
                                    row, dataGridCell.columnName);

                                Navigator.push(
                                    mainContext,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UploadPreventiveList(
                                              // cityName: cityName,
                                              colunmName:
                                                  dataGridCell.columnName,
                                              yearOption: yearOption[tabIndex],
                                              depoName: depoName,
                                              userId: userId,
                                              fldrName:
                                                  '${yearOption[tabIndex]}/$columnIndex'),
                                    ));
                              },
                              child: const Text('Upload')),
                          const SizedBox(width: 3),
                          ElevatedButton(
                              onPressed: () {
                                final int columnIndex = getColumnIndex(
                                    row, dataGridCell.columnName);
                                Navigator.push(mainContext, MaterialPageRoute(
                                  builder: (context) {
                                    return ViewAllPdf(
                                      title: 'Preventive Maintenance',
                                      cityName: cityName,
                                      depoName: depoName,
                                      userId: userId,
                                      docId:
                                          '${yearOption[tabIndex]}/$columnIndex',
                                    );
                                  },
                                ));
                              },
                              child: const Text('View'))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (submissionDataList.isNotEmpty &&
                            maintIndex >= 0 &&
                            maintIndex < submissionDataList.length)
                          Center(
                            child: Text(
                              'sub Date: ${submissionDataList[maintIndex][dataGridCell.columnName] ?? ''}',
                            ),
                          ),
                        if (submissionDataList.length == maintIndex + 1)
                          IconButton(
                            onPressed: () {
                              separateMaintenance(dataGridCell.columnName);
                              // Name of the column to add
                              String name = maintenancePart!;
                              int number = int.parse(numberPart!);
                              number++;

                              String newColumnName = '$name$number';
                              String value = currentDate;
                              int columnIndex = columns.length - 1;
                              addMaintenanceColumn(
                                  columnIndex, newColumnName, value);
                            },
                            icon: CircleAvatar(
                              backgroundColor: blue,
                              child: Icon(Icons.add, color: white),
                            ),
                          )
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Center(
                    //         child: Text(
                    //             'sub Date:${submissionDataList.isNotEmpty ? submissionDataList[dataRowIndex][dataGridCell.columnName] : ''}')),
                    //     IconButton(
                    //       onPressed: () {
                    //         separateMaintenance(dataGridCell.columnName);
                    //         // Name of the column to add
                    //         String name = maintenancePart!;
                    //         int number = int.parse(numberPart!);
                    //         number++;

                    //         String newColumnName = '$name$number';
                    //         String value = currentDate;
                    //         int columnIndex = columns.length - 1;
                    //         addMaintenanceColumn(
                    //             columnIndex, newColumnName, value);
                    //       },
                    //       icon: CircleAvatar(
                    //           backgroundColor: blue,
                    //           child: Icon(
                    //             Icons.add,
                    //             color: white,
                    //           )),
                    //     ),
                    //   ],
                    // ),
                  ],
                )
              : (dataGridCell.columnName.contains('Maintenance'))
                  ? Column(
                      children: [
                        Center(child: Text(due)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    final int columnIndex = getColumnIndex(
                                        row, dataGridCell.columnName);

                                    Navigator.push(
                                        mainContext,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UploadPreventiveList(
                                                  // cityName: cityName,
                                                  colunmName:
                                                      dataGridCell.columnName,
                                                  yearOption:
                                                      yearOption[tabIndex],
                                                  depoName: depoName,
                                                  userId: userId,
                                                  fldrName:
                                                      '${yearOption[tabIndex]}/$columnIndex'),
                                        ));
                                  },
                                  child: const Text('Upload')),
                              const SizedBox(width: 3),
                              ElevatedButton(
                                  onPressed: () {
                                    final int columnIndex = getColumnIndex(
                                        row, dataGridCell.columnName);
                                    Navigator.push(mainContext,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return ViewAllPdf(
                                          title: 'Preventive Maintenance',
                                          cityName: cityName,
                                          depoName: depoName,
                                          userId: userId,
                                          docId:
                                              '${yearOption[tabIndex]}/$columnIndex',
                                        );
                                      },
                                    ));
                                  },
                                  child: const Text('View'))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if (submissionDataList.isNotEmpty &&
                                maintIndex >= 0 &&
                                maintIndex < submissionDataList.length)
                              Center(
                                child: Text(
                                  'sub Date: ${submissionDataList[maintIndex][dataGridCell.columnName] ?? ''}',
                                ),
                              ),
                            if (submissionDataList.length == maintIndex + 1)
                              IconButton(
                                onPressed: () {
                                  separateMaintenance(dataGridCell.columnName);
                                  // Name of the column to add
                                  String name = maintenancePart!;
                                  int number = int.parse(numberPart!);
                                  number++;

                                  String newColumnName = '$name$number';
                                  String value = currentDate;
                                  int columnIndex = columns.length - 1;
                                  addMaintenanceColumn(
                                      columnIndex, newColumnName, value);
                                },
                                icon: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(Icons.add, color: white),
                                ),
                              )
                          ],
                        ),

                        // Row(
                        //   children: [
                        //     Center(
                        //         child: Text(
                        //             'sub Date:${submissionDataList.isNotEmpty ? submissionDataList[dataRowIndex][dataGridCell.columnName] : ''}')),
                        //     IconButton(
                        //       onPressed: () {
                        //         separateMaintenance(dataGridCell.columnName);
                        //         // Name of the column to add
                        //         String name = maintenancePart!;
                        //         int number = int.parse(numberPart!);
                        //         number++;

                        //         String newColumnName = '$name$number';
                        //         String value = currentDate;
                        //         int columnIndex = columns.length - 1;
                        //         addMaintenanceColumn(
                        //             columnIndex, newColumnName, value);
                        //       },
                        //       icon: CircleAvatar(
                        //           backgroundColor: blue,
                        //           child: Icon(
                        //             Icons.add,
                        //             color: white,
                        //           )),
                        //     ),
                        //   ],
                        // ),
                      ],
                    )
                  : Center(
                      child: Text(
                        dataGridCell.value.toString(),
                        textAlign: TextAlign.center,
                        style: tablefonttext,
                      ),
                    );
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'srNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'srNo', value: newCellValue);
      _preventiveMaintenance[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'equipment') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'equipment', value: newCellValue);
      _preventiveMaintenance[dataRowIndex].equipment = newCellValue;
    } else if (column.columnName == 'frequency') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'frequency', value: newCellValue);
      _preventiveMaintenance[dataRowIndex].frequency = newCellValue;
    } else if (column.columnName == 'installationDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'installationDate', value: newCellValue);
      _preventiveMaintenance[dataRowIndex].installationDate = newCellValue;
    } else {
      // Handle dynamic maintenance columns (e.g., maintenance1, maintenance2, etc.)
      for (int i = 1;
          i < _preventiveMaintenance[dataRowIndex].maintenanceDates.length;
          i++) {
        if (column.columnName == 'Maintenance${i + 1}') {
          // Update the maintenance date cell and the model
          dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
              DataGridCell<String>(
                  columnName: 'Maintenance ${i + 1}', value: newCellValue);
          _preventiveMaintenance[dataRowIndex].maintenanceDates[i] =
              newCellValue;
          break; // Once you find the matching column, break out of the loop
        }
      }
    }
    notifyListeners(); // Notify listeners to refresh the DataGrid
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = '';

    final bool isNumericType = column.columnName == 'sfuNo';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        style: tablefonttext,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 5,
            right: 5,
          ),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericType
            ? TextInputType.number
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  RegExp _getRegExp(
      bool isNumericKeyBoard, bool isDateTimeBoard, String columnName) {
    return isNumericKeyBoard
        ? RegExp('[0-9]')
        : isDateTimeBoard
            ? RegExp('[0-9/]')
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }

  Widget createColumnLabel(String labelText) {
    return Container(
      alignment: Alignment.center,
      child: Text(labelText,
          overflow: TextOverflow.values.first,
          textAlign: TextAlign.center,
          style: tableheader),
    );
  }
}
