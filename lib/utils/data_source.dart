import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({
    required List<Map<String, dynamic>> tableData,
  }) {
    _employeeData = tableData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'timestamp', value: e['timestamp'] ?? ""),
              DataGridCell<String>(
                  columnName: 'latitude', value: e['latitude']),
              DataGridCell<String>(
                  columnName: 'longitude', value: e['longitude']),
              DataGridCell<String>(
                  columnName: 'accuracy', value: e['accuracy']),
              DataGridCell<String>(
                  columnName: 'distance', value: e['distance'].toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    if (kDebugMode) {
      print("row--> ${_employeeData.length}");
    }
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
