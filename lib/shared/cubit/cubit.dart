import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/archived_tasks/archived_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/tasks_screen.dart';

import 'package:udemy_flutter/shared/cubit/states.dart';

//هنا كل كا يخص الداتا بيز من create و insert و update
//هو دا بقا البلوك بما يخصه**
class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        //id integer
        // title string
        // date string
        //time string
        // status string
        print('create database');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print(' database opened');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserted New Record ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate(
      'UPDATE tasks  SET status = ? WHERE id = ?',
      //'UPDATE Test SET name = ?, value = ? WHERE name = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database!.rawUpdate('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}
