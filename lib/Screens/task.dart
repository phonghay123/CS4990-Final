import 'package:flutter/material.dart';
class Job{
  String? id;
  bool complete;
  String? text;
  DateTime date;

  Job({
    required this.id,
    required this.text,
    required this.date,
    this.complete = false,
  });

  static List<Job> jobList(){
    return[
      Job(id: '1', text: 'Example', complete: false,date: DateTime.now()),
      Job(id: '2', text: 'more Example', complete: false, date: DateTime.now()),
    ];
  }
}
class TaskItem extends StatelessWidget{
  final Job job;
  final taskClick;
  final deleteTask;
  final sendNoti;
  const TaskItem({Key? key, required this.job, required this.taskClick, required this.deleteTask, required this.sendNoti}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      //color: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration( color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
      onTap: () {
        taskClick(job);
        if(job.complete == false)
          {
            sendNoti(job);
          }

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
    ),
      tileColor: Colors.white ,
        leading: Icon(job.complete? Icons.check : null,color: Colors.pinkAccent) ,
        title: Text(job.text!, style: TextStyle(fontSize: 20,color: Colors.black,decoration: job.complete? TextDecoration.lineThrough : null)),
        subtitle: Text('Due on: ' + job.date.year.toString() + '-' + job.date.month.toString() + '-' + job.date.day.toString()
        + '   ' + job.date.hour.toString() + ':' + job.date.minute.toString(),textAlign: TextAlign.start ,),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 15),
          height: 30,
          width: 30,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
          child: IconButton(color: Colors.white, iconSize: 14,icon: Icon(Icons.delete),
            onPressed: () {
            deleteTask(job.id);
            },),
        ),
    ),
    );
  }
}