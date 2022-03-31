import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import '/constants.dart';
import 'Components/add_items.dart';
import 'Components/edit_dialogue.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ITEMS',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: kLightBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: kBlue.withOpacity(0.9),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          snapshot.data!.docs[index].get('title'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(snapshot.data!.docs[index].get('des')),
                        leading: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          height: 80,
                          width: 80,
                          child: snapshot.data!.docs[index].get('imgUrl') ==
                                  'no'
                              ? const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: kBlue,
                                )
                              : Ink.image(
                                  image: NetworkImage(
                                      snapshot.data!.docs[index].get('imgUrl')),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: kLightBlue,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: kBlue,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return EditDialogue(
                                        title: snapshot.data!.docs[index]
                                            .get('title'),
                                        des: snapshot.data!.docs[index]
                                            .get('des'),
                                        imgUrl: snapshot.data!.docs[index]
                                            .get('imgUrl'),
                                        id: snapshot.data!.docs[index].id);
                                  },
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)));
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ],
            color: Color.fromRGBO(255, 216, 228, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
        child: IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AddItem();
                },
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ));
          },
          icon: const Icon(Icons.add),
          color: kBlue,
        ),
      ),
    );
  }
}
