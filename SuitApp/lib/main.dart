import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

enum ItemType { asset, file }

class ClothingItem {
  final String imagePath;
  final String itemName;
  final ItemType type;

  ClothingItem({
    required this.imagePath,
    required this.itemName,
    required this.type,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بدلاتي',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      home: const ClothingPage(),
    );
  }
}

class ClothingPage extends StatefulWidget {
  const ClothingPage({super.key});

  @override
  _ClothingPageState createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  final Random _random = Random();

  final List<ClothingItem> _suits = [
    ClothingItem(
        imagePath: 'images/blacksuit.png',
        itemName: 'بدلة سوداء',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/bluesuit.png',
        itemName: 'بدلة زرقاء',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/graysuit.png',
        itemName: 'بدلة رمادية',
        type: ItemType.asset),
  ];

  final List<ClothingItem> _shirts = [
    ClothingItem(
        imagePath: 'images/whiteshirt.png',
        itemName: 'قميص أبيض',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/blueshirt.png',
        itemName: 'قميص أزرق',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/blackshirt.png',
        itemName: 'قميص أسود',
        type: ItemType.asset),
  ];

  final List<ClothingItem> _boots = [
    ClothingItem(
        imagePath: 'images/blackboots.png',
        itemName: 'جزمة سوداء',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/brownboots.png',
        itemName: 'جزمة بنية',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/lightbrownboots.png',
        itemName: 'جزمة سوداء',
        type: ItemType.asset),
  ];

  final List<ClothingItem> _neckties = [
    ClothingItem(
        imagePath: 'images/bluenecktie.png',
        itemName: 'ربطة عنق زرقاء',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/blacknecktie.png',
        itemName: 'ربطة عنق سوداء',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/graynecktie.png',
        itemName: 'ربطة عنق رمادية',
        type: ItemType.asset),
    ClothingItem(
        imagePath: 'images/rednecktie.png',
        itemName: 'ربطة عنق حمراء',
        type: ItemType.asset),
  ];

  late ClothingItem _currentSuit;
  late ClothingItem _currentShirt;
  late ClothingItem _currentBoots;
  late ClothingItem _currentNecktie;

  @override
  void initState() {
    super.initState();
    _updateClothingItems();
  }

  void _updateClothingItems() {
    _currentSuit = _getRandomItem(_suits);
    _currentShirt = _getRandomItem(_shirts);
    _currentBoots = _getRandomItem(_boots);
    _currentNecktie = _getRandomItem(_neckties);
  }

  ClothingItem _getRandomItem(List<ClothingItem> itemList) {
    return itemList[_random.nextInt(itemList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.home), // Home icon
            SizedBox(width: 8), // Spacer
            Text(
              'بدلاتي', // Welcome message
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                  'assets/appicon.png'), // Replace with your image path
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Clothing item widgets
                  ClothingItemWidget(
                    clothingItem: _currentSuit,
                    itemList: _suits,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      ClothingItemWidget(
                        clothingItem: _currentShirt,
                        itemList: _shirts,
                      ),
                      const SizedBox(width: 10),
                      ClothingItemWidget(
                        clothingItem: _currentNecktie,
                        itemList: _neckties,
                      ),
                    ],
                  ),
                  ClothingItemWidget(
                    clothingItem: _currentBoots,
                    itemList: _boots,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _updateClothingItems();
                });
              },
              label: const Text(
                'اضغط هنا',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClothingItemWidget extends StatelessWidget {
  final ClothingItem clothingItem;
  final List<ClothingItem> itemList;

  const ClothingItemWidget({
    super.key,
    required this.clothingItem,
    required this.itemList, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClothingListPage(itemList: itemList),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            if (clothingItem.type == ItemType.asset)
              Image.asset(
                clothingItem.imagePath,
                width: 150,
                height: 150,
              )
            else if (clothingItem.type == ItemType.file)
              Image.file(
                File(clothingItem.imagePath),
                width: 150,
                height: 150,
              ),
            const SizedBox(height: 10),
            Text(
              clothingItem.itemName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class ClothingListPage extends StatefulWidget {
  final List<ClothingItem> itemList;

  const ClothingListPage({super.key, required this.itemList});

  @override
  _ClothingListPageState createState() => _ClothingListPageState();
}

class _ClothingListPageState extends State<ClothingListPage> {
  void _deleteItem(BuildContext context, ClothingItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor:
                  Colors.white, // Set the background color here
            ),
            child: AlertDialog(
              title: const Text('حذف العنصر'),
              content: const Text('هل أنت متأكد أنك تريد حذف هذا العنصر؟'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Remove the item from the list
                      widget.itemList.remove(item);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('حذف'),
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الملابس'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30), // Add space from the AppBar
        child: ListView.separated(
          itemCount: widget.itemList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 30); // Space between items
          },
          itemBuilder: (context, index) {
            final item = widget.itemList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 100, // Adjusted width
                  height: 100, // Adjusted height
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: item.type == ItemType.asset
                        ? Image.asset(
                            item.imagePath,
                          )
                        : Image.file(
                            File(item.imagePath),
                          ),
                  ),
                ),
                title: Text(
                  item.itemName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Apply bold font weight
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClothingDetailsPage(clothingItem: item),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(context, item),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust padding here
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddClothingPage(itemList: widget.itemList),
              ),
            ).then((updatedList) {
              if (updatedList != null) {
                setState(() {
                  widget.itemList.clear();
                  widget.itemList.addAll(
                      updatedList); // Update the list with the returned one
                });
              }
            });
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ClothingDetailsPage extends StatelessWidget {
  final ClothingItem clothingItem;

  const ClothingDetailsPage({super.key, required this.clothingItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الملابس'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            clothingItem.type == ItemType.asset
                ? Image.asset(
                    clothingItem.imagePath,
                    width: 200,
                    height: 200,
                  )
                : Image.file(
                    File(clothingItem.imagePath),
                    width: 200,
                    height: 200,
                  ),
            const SizedBox(height: 20),
            Text(
              clothingItem.itemName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'رجوع',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddClothingPage extends StatefulWidget {
  final List<ClothingItem> itemList;

  const AddClothingPage({super.key, required this.itemList});

  @override
  _AddClothingPageState createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  late TextEditingController _itemNameController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  Future<void> _takePicture(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final String? itemName = await _showItemNameDialog(context);
      if (itemName != null && itemName.isNotEmpty) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String imagePath = '${appDir.path}/$itemName.jpg';

        // Copy the image to the desired directory
        final File newImage = File(pickedImage.path);
        await newImage.copy(imagePath);

        setState(() {
          // Add the image path to the appropriate item list
          widget.itemList.add(ClothingItem(
              imagePath: imagePath, itemName: itemName, type: ItemType.file));
        });
        // Update the state of the previous page to reflect the changes
        Navigator.pop(context, widget.itemList.toList());
      }
    }
  }

  Future<void> _uploadPicture(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final String? itemName = await _showItemNameDialog(context);
      if (itemName != null && itemName.isNotEmpty) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String imagePath = '${appDir.path}/$itemName.jpg';

        // Save the image to the directory
        final File newImage = await File(pickedImage.path).copy(imagePath);

        setState(() {
          // Add the image path to the appropriate item list
          widget.itemList.add(ClothingItem(
              imagePath: imagePath, itemName: itemName, type: ItemType.file));
        });
        // Update the state of the previous page to reflect the changes
        Navigator.pop(context, widget.itemList.toList());
      }
    }
  }

  Future<String?> _showItemNameDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                Colors.white, // Set the background color here
          ),
          child: AlertDialog(
            title: const Text('ادخل اسم القطعة'),
            content: TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(hintText: 'ادخل اسم القطعة'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, _itemNameController.text);
                },
                child: const Text('موافق'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('إلغاء'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ملابس'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 140,
              child: GestureDetector(
                onTap: () => _takePicture(context),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40, color: Colors.black),
                      SizedBox(height: 10),
                      Text(
                        'التقاط صورة',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _uploadPicture(context),
              child: SizedBox(
                height: 140,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.file_upload, size: 40, color: Colors.black),
                      SizedBox(height: 10),
                      Text(
                        'تحميل صورة',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
