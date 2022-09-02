import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';



Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField(
        {required TextEditingController controller,
        required TextInputType type,
        Function(String)? onSubmit,
        Function(String)? onChange,
        required String? Function(String?)? validate,
        required String label,
        required IconData prefix,
        IconData? suffix,
        bool isObscure = false,
        void Function()? onPress,
        void Function()? onTap,
        bool isClickable = true}) =>
    TextFormField(
      controller: controller,
      enabled: isClickable,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      obscureText: isObscure,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: onPress,
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model,context) {
  return Dismissible(
    key:Key(model['id'].toString()) ,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(
                status: 'done',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(
                status: 'archived',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
    onDismissed: (direction){
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}
Widget tasksBuilder(List<Map<dynamic, dynamic>> tasks) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) {
        // print('task status ${tasks[index]['status']}');
        return buildTaskItem(tasks[index], context);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        );
      },
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 80,
          ),
          Text(
            'No Tasks Yet , Please Add Some Tasks',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18,

            ),
          ),
        ],
      ),
    ),
  );
}
