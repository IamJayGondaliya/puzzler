import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzler/image_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ImageController mutable = Provider.of<ImageController>(context);
    ImageController immutable =
        Provider.of<ImageController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mutable.image != null
                  ? Stack(
                      children: [
                        Image.file(
                          mutable.image!,
                          height: 300,
                          width: 300,
                        ),
                        Container(
                          height: 300,
                          width: 300,
                          color: Colors.white.withOpacity(0.6),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) => DragTarget(
                              onAcceptWithDetails: (details) {
                                log("${details.data}");
                                immutable.acceptImage(index);
                              },
                              onWillAcceptWithDetails: (details) {
                                log("DATA: ${details.data}");
                                return index == details.data;
                              },
                              builder: (context, _, __) =>
                                  mutable.dataList[index],
                            ),
                          ),
                        ),
                      ],
                    )
                  : mutable.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("No Image Yet !!"),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: mutable.images
                      .map(
                        (e) => LongPressDraggable(
                          data: mutable.images.indexOf(e),
                          feedback: Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.all(10),
                            child: e,
                          ),
                          child: Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.all(10),
                            child: e,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              immutable.splitImage();
            },
            child: const Icon(Icons.splitscreen),
          ),
          const SizedBox(
            width: 15,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              immutable.setImage();
            },
            icon: const Icon(Icons.image),
            label: const Text("Select Image"),
          ),
        ],
      ),
    );
  }
}
