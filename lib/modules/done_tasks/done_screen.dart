import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/shared/component/components.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var tasks = AppCubit.get(context).doneTasks;
          return tasksBuilder(tasks);
        });
  }
}
