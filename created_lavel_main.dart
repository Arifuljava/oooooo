import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import '../../app_style.dart';
import '../../ui/dashboard_screen.dart';
import '../../ui/print_page_size.dart';
import '../../ui/splash_screen.dart';
import '../TextEditingContainer.dart';
import '../barcode_editing_container.dart';
import '../custome_slider.dart';
import '../emoji_container.dart';
import '../images_take_container.dart';
import '../qrcode_editing_container.dart';
import '../scanner.dart';
import '../table_editing_container.dart';
import '../variable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../date_time_editing_container.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// text widget
String randomUuid = '';
String labelText = 'Double click here ';
final TextEditingController textEditingController = TextEditingController();
bool isBold = false;
bool isItalic = false;
bool isUnderline = false;
TextAlign textAlignment = TextAlign.left;
double textFontSize = 15.0;
double textValueSize = 15;
double textFieldX = 0.0;
double textFieldY = 0.0;
double textFieldWidth = 200.0;
double textFieldHeight = 50.0;
String currentText = '';
double minTextFieldWidth = 40.0;
int ddd = 0 ;
List<String> undoStack = [];
List<String> redoStack = [];
bool showTextEditingWidget = false;
bool showTextEditingContainerFlag = false;
int textButtonCounter = 0;
List<Widget> containerWidgets = [];

double getLabelWidth = 100;
double getLabelHeight = 100;

int sdkPaperSizeWidth = 10;
int sdkPaperSizeHeight = 10;

// barcode widget
final TextEditingController inputBarcodeData = TextEditingController();
String barcodeData = '1234';
String encodingType = 'Code128';
String errorMessage = "";
bool showBarcodeContainerFlag = false;
bool showBarcodeWidget = false;
//position set barcode
double barContainerX = 0;
double barContainerY = 0;

// qrcode widget
String qrcodeData = '5678';
bool showQrcodeWidget = false;
bool showQrcodeContainerFlag = false;
String currentTime= '';
int flage_init=0;

class CreatedContainerMain extends StatefulWidget {
  static const routeName = '/createLabel';


  String? uid;
  String? operaton;
  String? name_label;
  CreatedContainerMain({super.key, this.uid,this.operaton,this.name_label});

  @override
  CreatedContainerMainState createState() => CreatedContainerMainState();
}

class CreatedContainerMainState extends State<CreatedContainerMain> {
  static const platform =
      MethodChannel('com.github.Arifuljava:GrozziieBlutoothSDk:v1.0.1');
  GlobalKey globalKey = GlobalKey();
  Uint8List? imageData;
  String formatDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  }

  void getCurrentTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now().toString();
      });
    });
  }
  //position set text widget
  double textContainerX = 0;
  double textContainerY = 0;

  //position set barcode
  double qrContainerX = 0;
  double qrContainerY = 0;

  // table widget
  bool showTableWidget = false;
  bool showTableContainerFlag = false;

  //position set barcode
  double tableContainerX = 0;
  double tableContainerY = 0;
  double lineWidthValue = 2;

  // Image widget
  bool showImageWidget = false;
  bool showImageContainerFlag = false;

  //position set barcode
  double imageContainerX = 0;
  double imageContainerY = 0;

  // Image widget
  bool showScanWidget = false;
  double scanContainerX = 0;
  double scanContainerY = 0;

  // Date widget
  bool showDateContainerWidget = false;
  bool showDateContainerFlag = false;

  //position set barcode
  double dateContainerX = 0;
  double dateContainerY = 0;

  // Emoji widget
  bool showEmojiWidget = false;
  bool showEmojiContainerFlag = false;

  //position set barcode
  double emojiContainerX = 0;
  double emojiContainerY = 0;

  bool selectIndex = false;
  String value = "";
  int nowLabelWidth = 0;
  String myuuid = '';
  String label_name= '';
  //for text



  void _getHeightWidth(
      int paperSizeWidth, int paperSizeHeight, double limitationX) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    int screenWidthInt = screenWidth.floor();
    int screenHeightInt = screenHeight.floor();
    sdkPaperSizeWidth = paperSizeWidth;
    sdkPaperSizeHeight = paperSizeHeight;
    nowLabelWidth = screenWidthInt - 10;
    double limitation = limitationX;
    double nowLabelHeight = 100;
    var zoomX = paperSizeWidth / paperSizeHeight;
    nowLabelHeight = nowLabelWidth / zoomX;
    if (nowLabelHeight > limitation * nowLabelWidth) {
      nowLabelHeight = limitation * nowLabelWidth;
      nowLabelWidth = (nowLabelHeight * zoomX).toInt();
    }
    getLabelWidth = (nowLabelWidth).toDouble();
    getLabelHeight = nowLabelHeight;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth;

    _getHeightWidth(widthText, heightText, 1);
    //_getHeightWidth(40, 30, 1);

    double containerHeight = getLabelHeight;
    double containerWidth = getLabelWidth;

    return WillPopScope(
      onWillPop: () async {
        return await showExitbutton(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _createdLabelContainer(containerHeight, containerWidth, context),
            if (showTextEditingContainerFlag)
              Expanded(child: _showTextEditingContainer(screenWidth))
            else if (showBarcodeContainerFlag)
              Expanded(child: _showBarcodeContainer(screenWidth))
            else if (showQrcodeContainerFlag)
              Expanded(child: _showQrcodeContainer(screenWidth))
            else if (showTableContainerFlag)
              Expanded(child: _showTableContainer(screenWidth))
            else if (showImageContainerFlag)
              Expanded(child: _showImageContainer(screenWidth))
            else if (showDateContainerFlag)
              Expanded(child: _showDateContainer(screenWidth))
            else if (showEmojiContainerFlag)
              Expanded(child: _showEmojiContainer(screenWidth))
            else
              Expanded(child: _buildOptionsContainer(context, screenWidth))
          ],
        ),
        bottomNavigationBar: buildBottomAppBarButton(screenWidth),
      ),
    );
  }

  Future<dynamic> showExitbutton(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                leading: Icon(Icons.save,color: Colors.green,),
                title: Text('Save',style: TextStyle(color: Colors.green),),
                onTap: () async{
                  Navigator.pop(context);
                  Navigator.pop(context);

//delete
                  DatabaseHelper_DataList dbHelper = DatabaseHelper_DataList('ElementList');
                  int idToCheck = int.parse(widget.uid.toString());
                  // Replace with the ID you want to check
                  bool exists = await dbHelper.isDataExists(idToCheck);
                  if (exists) {
                    await dbHelper.deleteData(idToCheck);
                    print("Success");
                    final random = Random();
                    final randomNumber = random.nextInt(100000);

                    // Convert the random number to a string
                    final randomString = randomNumber.toString();
                    showUpdateSaveDialouge(context,randomString);


                  } else {
                    print('Data with ID $idToCheck does not exist in the database.');
                  }
                  print(barCodes.length);

                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.save_as,color: Colors.blue,),
                title: Text('Save As',style: TextStyle(color: Colors.blue),),
                onTap: () async{
                  Navigator.pop(context);
                  final random = Random();
                  final randomNumber = random.nextInt(100000);

                  // Convert the random number to a string
                  final randomString = randomNumber.toString();
                  await DatabaseHelper__UUID.instance.insertData("01018106033", ""+randomString);
                  showNameDialouge1(context,""+randomString);


                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.backspace,color: Colors.redAccent,),
                title: Text(' Do not Save',style: TextStyle(color: Colors.redAccent),),
                onTap: () async{
                  Navigator.pop(context);
                  textCodes.clear();
                  textCodeOffsets.clear();
                  updateTextBold.clear();
                  updateTextUnderline.clear();
                  updateTextItalic.clear();
                  updateTextFontSize.clear();
                  updateTextAlignment.clear();
                  textContainerRotations.clear();
                  updateTextWidthSize.clear();
                  barCodes.clear();
                  barCodeOffsets.clear();
                  updateBarcodeHeight.clear();
                  updateBarcodeWidth.clear();
                  barCodesContainerRotations.clear();
                  qrCodes.clear();
                  qrCodeOffsets.clear();
                  qrCodesContainerRotations.clear();
                  updateQrcodeSize.clear();
                  tableCodes.clear();
                  tableOffsets.clear();
                  flage_init = 0;
                  //lineCodes.clear();
                  // lineOffsets.clear();
                  emojiCodes.clear();
                  emojiCodeOffsets.clear();
                  imageCodes.clear();
                  updateEmojiWidth.clear();
                  imageCodeOffsets.clear();
                  setState(() {
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                    // showLineContainerFlag = false;
                  });
                  //Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );


                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.close,color: Colors.red,),
                title: Text('Cancel',style: TextStyle(color: Colors.red),),
                onTap: () async{
                  Navigator.pop(context);

                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
            ],
          ),
        );
      },
    );
  }
  void  listclean(){
    textCodes.clear();
    textCodeOffsets.clear();
    updateTextBold.clear();
    updateTextUnderline.clear();
    updateTextItalic.clear();
    updateTextFontSize.clear();
    updateTextAlignment.clear();
    textContainerRotations.clear();
    updateTextWidthSize.clear();
    barCodes.clear();
    barCodeOffsets.clear();
    qrCodes.clear();
    qrCodeOffsets.clear();
    tableCodes.clear();
    tableOffsets.clear();
    flage_init = 0;
    //lineCodes.clear();
    // lineOffsets.clear();
    emojiCodes.clear();
    emojiCodeOffsets.clear();
    imageCodes.clear();
    imageCodeOffsets.clear();
  }
  Future<dynamic> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text("Confirm Exit",style: bodyMedium,),
          content:  Text("Do you want to save your Template?",style: bodySmall,),
          actions: <Widget>[
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                //Navigator.of(context).popUntil((route) => route.isFirst);
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                });
              },
            ),
            TextButton(
                child: const Text("Don't Save"),
                onPressed: () {
                  textCodes.clear();
                  textCodeOffsets.clear();
                  barCodes.clear();
                  barCodeOffsets.clear();
                  qrCodes.clear();
                  qrCodeOffsets.clear();
                  tableCodes.clear();
                  tableOffsets.clear();
                  flage_init = 0;
                  //lineCodes.clear();
                 // lineOffsets.clear();
                  emojiCodes.clear();
                  emojiCodeOffsets.clear();
                  imageCodes.clear();
                  imageCodeOffsets.clear();
                  setState(() {
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                   // showLineContainerFlag = false;
                  });
                  //Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                }),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and cancel the back action
              },
            ),
          ],
        );
      },
    );
  }
  void showMyToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // Duration of the toast
      gravity: ToastGravity.BOTTOM,    // Position of the toast
      timeInSecForIosWeb: 1,           // Time to show on iOS
      backgroundColor: Colors.grey,    // Background color of the toast
      textColor: Colors.white,         // Text color of the toast
      fontSize: 16.0,                  // Font size of the message
    );
  }
//input dialouge
  TextEditingController saveascontroller=new  TextEditingController();
  void showNameDialouge1(BuildContext context,String myyyyy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a FocusNode and request focus on it
        FocusNode inputFocusNode = FocusNode();
        FocusScope.of(context).requestFocus(inputFocusNode);
        return Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: REdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: REdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    focusNode: inputFocusNode,
                    controller: saveascontroller,

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {

                      });
                    },

                  ),
                ),
                TextButton(
                  onPressed: () async{
                    final inputBarcodeText = saveascontroller.text;
                    print(inputBarcodeText);
                    Navigator.pop(context);
                    //print
                    if(inputBarcodeText.toString().toString()==null)
                    {
                      print("null");
                    }
                    else
                    {
                      print("lolololo$inputBarcodeText");

                      checkIfNameExists(inputBarcodeText.toString(),myyyyy);

                      /*

                       */



                    }


                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //input dialouge
TextEditingController conttroller11=new  TextEditingController();

  void showNameDialouge(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a FocusNode and request focus on it
        FocusNode inputFocusNode = FocusNode();
        FocusScope.of(context).requestFocus(inputFocusNode);
        return Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: REdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: REdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    focusNode: inputFocusNode,
                    controller: conttroller11,

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {

                      });
                    },

                  ),
                ),
                TextButton(
                  onPressed: () async{
                    final inputBarcodeText = conttroller11.text;
                  print(inputBarcodeText);
                    Navigator.pop(context);
                    //print
                    if(inputBarcodeText.toString().toString()==null)
                      {
                        print("null");
                      }
                    else
                      {
                        print("lolololo");



                        if(showBarcodeWidget)
                        {

                          /*
                          if(!barcodeList.isEmpty)
                          {
                            for (String barcode in barcodeList) {
                              // Do something with the barcode value
                              //print("Barcode: $barcode");
                              print('bar code : $barcode');
                              String myuid11 = nameList[0];
                              for(int i = 0 ; i<barCodes.length;i++)
                              {
                                addDatatosqllite3(barcode,myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,50,50,barCodes.length,i,myuid11);


                              }

                            }
                          }
                          else
                          {
                            print("Autom");
                          }
                           */




                          String? image = await convertWidgetToImage1();
                          for(int i = 0 ; i<barCodes.length;i++)
                          {
                            double get_id1 = double.parse(updateBarcodeHeight[i].toString());
                            double get_id2 = double.parse(updateBarcodeWidth[i].toString());
                            String stringValue = get_id1.toString();
                            int  ssss = get_id1.toInt();
                            int  ssss11 = get_id2.toInt();
                            double barcodeee = double.parse(barCodesContainerRotations[i].toString());
                            if(i==0)
                            {

                              String myuid11 = nameList[0];
                              addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                              addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee);
                            }
                            else
                            {
                              double get_id1 = double.parse(updateBarcodeHeight[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              String myuid11 = nameList[0];
                              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
                              addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee);
                            }
                            int  secondlenght  =  int.parse(barCodes.length.toString())-1;

                            if(i==secondlenght)
                            {
                              barCodes.clear();
                              barCodeOffsets.clear();

                            }

                          }
                        }
                        //qr code
                        if(showQrcodeWidget)
                        {


                          String? image = await convertWidgetToImage1();
                          for(int i = 0 ; i<qrCodes.length;i++)
                          {
                            double get_id1 = double.parse(updateQrcodeSize[i].toString());
                            double get_id2 = double.parse(updateQrcodeSize[i].toString());
                            String stringValue = get_id1.toString();
                            int  ssss = get_id1.toInt();
                            int  ssss11 = get_id2.toInt();
                            double barcodeee = double.parse(qrCodesContainerRotations[i].toString());
                            if(i==0)
                            {
                              String myuid11 = nameList[0];
                              double get_id1 = double.parse(updateQrcodeSize[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              // void addelemento(String databasename, String element, String date1, String  size1, String uuid1)
                              addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);

                              addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);
                            }
                            else
                            {
                              double get_id1 = double.parse(updateQrcodeSize[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              String myuid11 = nameList[0];

                              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
                              addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);
                            }
                            int  secondlenght  =  int.parse(qrCodes.length.toString())-1;

                            if(i==secondlenght)
                            {
                              qrCodes.clear();
                              qrCodeOffsets.clear();

                            }

                          }


                        }

                        //emoji container
                        if(showEmojiWidget)
                        {
                          String? image = await convertWidgetToImage1();
                          // print("Emoji$emojiCodes.lenght");
                          for(int i = 0 ; i<emojiCodes.length;i++)
                          {
                            double getRationm = double.parse(emojiCodesContainerRotations[i].toString());
                            if(i==0)
                            {

                              //

                              double get_id1 = double.parse(updateEmojiWidth[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              //
                              String myuid11 = nameList[0];
                              addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                              addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);
                            }
                            else
                            {
                              //
                              double get_id1 = double.parse(updateEmojiWidth[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              //
                              String myuid11 = nameList[0];
                              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
                              addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);
                            }
                            int  secondlenght  =  int.parse(emojiCodes.length.toString())-1;

                            if(i==secondlenght)
                            {
                              emojiCodes.clear();
                              emojiCodeOffsets.clear();

                            }

                          }


                        }
                        //text
                        if(showTextEditingWidget||showDateContainerWidget)
                        {
                          String? image = await convertWidgetToImage1();
                          print(image);



                          for(int i = 0 ; i<textCodes.length;i++)
                          {
                           bool is_bold = bool.parse(updateTextBold[i].toString());
                        bool is_underline = bool.parse(updateTextUnderline[i].toString());
                           bool is_italic = bool.parse(updateTextItalic[i].toString());
                           double is_fontsize = double.parse(updateTextFontSize[i].toString());
                           double is_rotee = double.parse(textContainerRotations[i].toString());
                           double is_size = double.parse(updateTextWidthSize[i].toString());
                            TextAlign alignment = updateTextAlignment[i];
                           int  sizeee = is_size.toInt();

                            if(i==0)
                            {

                              print(image);
                              String myuid11 = nameList[0];
                              addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                              addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
                                  is_bold,is_underline,is_italic,is_fontsize,is_rotee);
                            }
                            else
                            {
                              String myuid11 = nameList[0];
                              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
                              addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
                                  is_bold,is_underline,is_italic,is_fontsize,is_rotee);
                            }
                            int  secondlenght  =  int.parse(textCodes.length.toString())-1;

                            if(i==secondlenght)
                            {
                              textCodes.clear();
                              textCodeOffsets.clear();

                            }


                          }


                        }
                        //image
                        if(showImageWidget)
                        {
                          String? image = await convertWidgetToImage1();
                          for(int i = 0 ; i<imageCodes.length;i++)
                          {

                            double getRationm = double.parse(imageCodesContainerRotations[i].toString());
                            if(i==0)
                            {
                              double get_id1 = double.parse(updateImageSize[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              String myuid11 = nameList[0];
                              addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                              addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);
                            }
                            else
                            {
                              //
                              double get_id1 = double.parse(updateImageSize[i].toString());
                              String stringValue = get_id1.toString();
                              int  ssss = get_id1.toInt();
                              //
                              String myuid11 = nameList[0];
                              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
                              addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);
                            }
                            int  secondlenght  =  int.parse(imageCodes.length.toString())-1;

                            if(i==secondlenght)
                            {
                              imageCodes.clear();
                              myImageOffset.clear();

                            }

                          }

                        }
                        //table
                        if(showTableWidget)
                        {
                          String? image = await convertWidgetToImage1();
                          for(int i = 0 ; i<tableCodes.length;i++)
                          {

                            int  row = updateTableRow[i];
                            int column = updateTableColumn[i];
                            double get_id1 = double.parse(updateTableWidth[i].toString());
                            double get_id2 = double.parse(updateTableHeight[i].toString());
                            String stringValue = get_id1.toString();
                            int  ssss22 = get_id2.toInt();
                            int  ssss = get_id1.toInt();
                            if(i==0)
                            {

                              String myuid11 = nameList[0];
                              addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                              addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);
                            }
                            else
                            {

                              String myuid11 = nameList[0];
                              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
                              addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);
                            }
                            int  secondlenght  =  int.parse(tableCodes.length.toString())-1;

                            if(i==secondlenght)
                            {
                              tableCodes.clear();
                              tableOffsets.clear();

                            }

                          }


                        }
                        //table



                        delayedHandler();

                      }


                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //
  void showUpdateSaveDialouge(BuildContext context,String myyyyyy) async{



    if(showBarcodeWidget)
    {

      /*
                          if(!barcodeList.isEmpty)
                          {
                            for (String barcode in barcodeList) {
                              // Do something with the barcode value
                              //print("Barcode: $barcode");
                              print('bar code : $barcode');
                              String myuid11 = nameList[0];
                              for(int i = 0 ; i<barCodes.length;i++)
                              {
                                addDatatosqllite3(barcode,myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,50,50,barCodes.length,i,myuid11);


                              }

                            }
                          }
                          else
                          {
                            print("Autom");
                          }
                           */




      String? image = await convertWidgetToImage1();
      for(int i = 0 ; i<barCodes.length;i++)
      {
        double get_id1 = double.parse(updateBarcodeHeight[i].toString());
        double get_id2 = double.parse(updateBarcodeWidth[i].toString());
        String stringValue = get_id1.toString();
        int  ssss = get_id1.toInt();
        int  ssss11 = get_id2.toInt();
        double barcodeee = double.parse(barCodesContainerRotations[i].toString());
        if(i==0)
        {

          String myuid11 = myyyyyy;
          addelemento("ElementList", label_name,formattedDate1,"30*40",""+myuid11,image);
          addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee);
        }
        else
        {
          double get_id1 = double.parse(updateBarcodeHeight[i].toString());
          String stringValue = get_id1.toString();
          int  ssss = get_id1.toInt();
          String myuid11 = myyyyyy;
          //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
          addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee);
        }
        int  secondlenght  =  int.parse(barCodes.length.toString())-1;

        if(i==secondlenght)
        {
          barCodes.clear();
          barCodeOffsets.clear();

        }

      }
    }
    //qr code
    if(showQrcodeWidget)
    {


      String? image = await convertWidgetToImage1();
      for(int i = 0 ; i<qrCodes.length;i++)
      {
        double get_id1 = double.parse(updateQrcodeSize[i].toString());
        double get_id2 = double.parse(updateQrcodeSize[i].toString());
        String stringValue = get_id1.toString();
        int  ssss = get_id1.toInt();
        int  ssss11 = get_id2.toInt();
        double barcodeee = double.parse(qrCodesContainerRotations[i].toString());
        if(i==0)
        {
          double get_id1 = double.parse(updateQrcodeSize[i].toString());
          int  ssss = get_id1.toInt();
          String myuid11 =myyyyyy;
          // void addelemento(String databasename, String element, String date1, String  size1, String uuid1)
          addelemento("ElementList", label_name,formattedDate1,"30*40",""+myuid11,image);
          addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);
        }
        else
        {
          double get_id1 = double.parse(updateQrcodeSize[i].toString());
          int  ssss = get_id1.toInt();
          String myuid11 =myyyyyy;
          //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
          addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);
        }
        int  secondlenght  =  int.parse(qrCodes.length.toString())-1;

        if(i==secondlenght)
        {
          qrCodes.clear();
          qrCodeOffsets.clear();

        }

      }


    }

    //emoji container
    if(showEmojiWidget)
    {
      String? image = await convertWidgetToImage1();
      // print("Emoji$emojiCodes.lenght");
      for(int i = 0 ; i<emojiCodes.length;i++)
      {
        double getRationm = double.parse(emojiCodesContainerRotations[i].toString());
        if(i==0)
        {
          double get_id1 = double.parse(updateEmojiWidth[i].toString());
          int  ssss = get_id1.toInt();
          String myuid11 = myyyyyy;
          addelemento("ElementList", label_name,formattedDate1,"30*40",""+myuid11,image);
          addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);
        }
        else
        {
          double get_id1 = double.parse(updateEmojiWidth[i].toString());
          int  ssss = get_id1.toInt();
          String myuid11 = myyyyyy;
          //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
          addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);
        }
        int  secondlenght  =  int.parse(emojiCodes.length.toString())-1;

        if(i==secondlenght)
        {
          emojiCodes.clear();
          emojiCodeOffsets.clear();

        }

      }


    }
    //text
    if(showTextEditingWidget||showDateContainerWidget)
    {
      String? image = await convertWidgetToImage1();
      print(image);



      for(int i = 0 ; i<textCodes.length;i++)
      {

        bool is_bold = bool.parse(updateTextBold[i].toString());
        bool is_underline = bool.parse(updateTextUnderline[i].toString());
        bool is_italic = bool.parse(updateTextItalic[i].toString());
        double is_fontsize = double.parse(updateTextFontSize[i].toString());
        double is_rotee = double.parse(textContainerRotations[i].toString());
        double is_size = double.parse(updateTextWidthSize[i].toString());
        int  sizeee = is_size.toInt();
        if(i==0)
        {
          print(image);
          String myuid11 = myyyyyy;
          addelemento("ElementList", label_name,formattedDate1,"30*40",""+myuid11,image);
          addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
              is_bold,is_underline,is_italic,is_fontsize,is_rotee);
        }
        else
        {
          String myuid11 = myyyyyy;
          //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
          addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
              is_bold,is_underline,is_italic,is_fontsize,is_rotee);
        }
        int  secondlenght  =  int.parse(textCodes.length.toString())-1;

        if(i==secondlenght)
        {
          textCodes.clear();
          textCodeOffsets.clear();

        }


      }


    }
    //image
    if(showImageWidget)
    {
      String? image = await convertWidgetToImage1();
      for(int i = 0 ; i<imageCodes.length;i++)
      {
        double getRationm = double.parse(imageCodesContainerRotations[i].toString());
        if(i==0)
        {
          double get_id1 = double.parse(updateImageSize[i].toString());
          int  ssss = get_id1.toInt();
          String myuid11 = myyyyyy;
          addelemento("ElementList", label_name,formattedDate1,"30*40",""+myuid11,image);
          addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);
        }
        else
        {
          double get_id1 = double.parse(updateImageSize[i].toString());
          int  ssss = get_id1.toInt();
          String myuid11 = myyyyyy;
          //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
          addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);
        }
        int  secondlenght  =  int.parse(imageCodes.length.toString())-1;

        if(i==secondlenght)
        {
          imageCodes.clear();
          myImageOffset.clear();

        }

      }

    }
    //table
    if(showTableWidget)
    {
      String? image = await convertWidgetToImage1();
      for(int i = 0 ; i<tableCodes.length;i++)
      {

        int  row = updateTableRow[i];
        int column = updateTableColumn[i];
        double get_id1 = double.parse(updateTableWidth[i].toString());
        double get_id2 = double.parse(updateTableHeight[i].toString());
        String stringValue = get_id1.toString();
        int  ssss22 = get_id2.toInt();
        int  ssss = get_id1.toInt();
        if(i==0)
        {

          String myuid11 = myyyyyy;
          addelemento("ElementList", label_name,formattedDate1,"30*40",""+myuid11,image);
          addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);
        }
        else
        {

          String myuid11 = myyyyyy;
          //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
          addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);
        }
        int  secondlenght  =  int.parse(tableCodes.length.toString())-1;

        if(i==secondlenght)
        {
          tableCodes.clear();
          tableOffsets.clear();

        }

      }


    }
    delayedHandler();
  }
  //
  void checkIfNameExists(String name,String myyyyy) async {
    DatabaseHelper_DataList dbHelper = DatabaseHelper_DataList("ElementList");

    bool nameExists = await dbHelper.isNameExists(name.toString());

    if (nameExists) {
      showMyToast("Name exists in the database.");
      print("Name exists in the database.");
    } else {



      if(showBarcodeWidget)
      {
        String? image = await convertWidgetToImage1();
        for(int i = 0 ; i<barCodes.length;i++)
        {
          double get_id1 = double.parse(updateBarcodeHeight[i].toString());
          double get_id2 = double.parse(updateBarcodeWidth[i].toString());
          String stringValue = get_id1.toString();
          int  ssss = get_id1.toInt();
          int  ssss11 = get_id2.toInt();
          double barcodeee = double.parse(barCodesContainerRotations[i].toString());

          if(i==0)
          {

            String myuid11 = myyyyy;
            addelemento("ElementList", name,formattedDate1,"30*40",""+myuid11,image);
            addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee);
          }
          else
          {double get_id1 = double.parse(updateBarcodeHeight[i].toString());
          String stringValue = get_id1.toString();
          int  ssss = get_id1.toInt();

            String myuid11 = myyyyy;
            //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
            addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee);
          }
          int  secondlenght  =  int.parse(barCodes.length.toString())-1;

          if(i==secondlenght)
          {
            barCodes.clear();
            barCodeOffsets.clear();

          }

        }
      }
      //qr code
      if(showQrcodeWidget)
      {


        String? image = await convertWidgetToImage1();
        for(int i = 0 ; i<qrCodes.length;i++)
        {
          double get_id1 = double.parse(updateQrcodeSize[i].toString());
          double get_id2 = double.parse(updateQrcodeSize[i].toString());
          String stringValue = get_id1.toString();
          int  ssss = get_id1.toInt();
          int  ssss11 = get_id2.toInt();
          double barcodeee = double.parse(qrCodesContainerRotations[i].toString());
          if(i==0)
          {
            double get_id1 = double.parse(updateQrcodeSize[i].toString());
            String stringValue = get_id1.toString();
            int  ssss = get_id1.toInt();
            String myuid11 = myyyyy;
            // void addelemento(String databasename, String element, String date1, String  size1, String uuid1)
            addelemento("ElementList", name,formattedDate1,"30*40",""+myuid11,image);
            addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);
          }
          else
          {
            double get_id1 = double.parse(updateQrcodeSize[i].toString());
            String stringValue = get_id1.toString();
            int  ssss = get_id1.toInt();
            String myuid11 = myyyyy;
            //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
            addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);
          }
          int  secondlenght  =  int.parse(qrCodes.length.toString())-1;

          if(i==secondlenght)
          {
            qrCodes.clear();
            qrCodeOffsets.clear();

          }

        }


      }

      //emoji container
      if(showEmojiWidget)
      {
        String? image = await convertWidgetToImage1();
        // print("Emoji$emojiCodes.lenght");
        for(int i = 0 ; i<emojiCodes.length;i++)
        {
          double getRationm = double.parse(emojiCodesContainerRotations[i].toString());
          if(i==0)
          {
            double get_id1 = double.parse(updateEmojiWidth[i].toString());
            String stringValue = get_id1.toString();
            int  ssss = get_id1.toInt();
            String myuid11 = myyyyy;
            addelemento("ElementList", name,formattedDate1,"30*40",""+myuid11,image);
            addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);
          }
          else
          { double get_id1 = double.parse(updateEmojiWidth[i].toString());
          String stringValue = get_id1.toString();
          int  ssss = get_id1.toInt();

            String myuid11 = myyyyy;
            //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
            addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);
          }
          int  secondlenght  =  int.parse(emojiCodes.length.toString())-1;

          if(i==secondlenght)
          {
            emojiCodes.clear();
            emojiCodeOffsets.clear();

          }

        }


      }
      //text
      if(showTextEditingWidget||showDateContainerWidget)
      {
        String? image = await convertWidgetToImage1();
        print(image);



        for(int i = 0 ; i<textCodes.length;i++)
        {

          bool is_bold = bool.parse(updateTextBold[i].toString());
          bool is_underline = bool.parse(updateTextUnderline[i].toString());
          bool is_italic = bool.parse(updateTextItalic[i].toString());
          double is_fontsize = double.parse(updateTextFontSize[i].toString());
          double is_rotee = double.parse(textContainerRotations[i].toString());
          double is_size = double.parse(updateTextWidthSize[i].toString());
          int  sizeee = is_size.toInt();

          if(i==0)
          {

            print(image);
            String myuid11 = myyyyy;
            addelemento("ElementList", name,formattedDate1,"30*40",""+myuid11,image);
            addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
                is_bold,is_underline,is_italic,is_fontsize,is_rotee);
          }
          else
          {
            String myuid11 = myyyyy;
            //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
            addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
                is_bold,is_underline,is_italic,is_fontsize,is_rotee);
          }
          int  secondlenght  =  int.parse(textCodes.length.toString())-1;

          if(i==secondlenght)
          {
            textCodes.clear();
            textCodeOffsets.clear();

          }


        }


      }
      //image
      if(showImageWidget)
      {
        String? image = await convertWidgetToImage1();
        for(int i = 0 ; i<imageCodes.length;i++)
        {
          double getRationm = double.parse(imageCodesContainerRotations[i].toString());
          if(i==0)
          {
            double get_id1 = double.parse(updateImageSize[i].toString());
            String stringValue = get_id1.toString();
            int  ssss = get_id1.toInt();
            String myuid11 = myyyyy;
            addelemento("ElementList", name,formattedDate1,"30*40",""+myuid11,image);
            addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);
          }
          else
          {
            double get_id1 = double.parse(updateImageSize[i].toString());
            String stringValue = get_id1.toString();
            int  ssss = get_id1.toInt();
            String myuid11 = myyyyy;
            //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
            addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);
          }
          int  secondlenght  =  int.parse(imageCodes.length.toString())-1;

          if(i==secondlenght)
          {
            imageCodes.clear();
            myImageOffset.clear();

          }

        }

      }
      if(showTableWidget)
        {
          String? image = await convertWidgetToImage1();
          for(int i = 0 ; i<tableCodes.length;i++)
          {

            int  row = updateTableRow[i];
            int column = updateTableColumn[i];
            double get_id1 = double.parse(updateTableWidth[i].toString());
            double get_id2 = double.parse(updateTableHeight[i].toString());
            String stringValue = get_id1.toString();
            int  ssss22 = get_id2.toInt();
            int  ssss = get_id1.toInt();
            if(i==0)
            {

              String myuid11 = myyyyy;
              addelemento("ElementList", name,formattedDate1,"30*40",""+myuid11,image);
              addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);
            }
            else
            {

              String myuid11 = myyyyy;
              //addelemento("ElementList", "text",'text',"30*40",""+myuid11);
              addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);
            }
            int  secondlenght  =  int.parse(tableCodes.length.toString())-1;

            if(i==secondlenght)
            {
              tableCodes.clear();
              tableOffsets.clear();

            }

          }


        }
      delayedHandler();
    }
  }

  //
  bool isLoading = false;
  Future<void> delayedHandler() async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Label Saving...');
    completed: Completed(); // To use with default values
    completed: Completed(completedMsg: "Saved !", completedImage: AssetImage("image path"), completionDelay: 2500);
    // Delay for 2 seconds (adjust the duration as needed)
    setState(() {
      isLoading = true;
    });
    const Duration delayDuration = Duration(seconds: 5);

    await Future.delayed(delayDuration);
    setState(() {
      isLoading = false;

    });


    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));

    // Your code here, this will execute after the delay
    print('Delayed handler executed after 2 seconds.');
  }
  //save and save as
  void showSaveandSaveAsDialouge(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                leading: Icon(Icons.save,color: Colors.green,),
                title: Text('Save',style: TextStyle(color: Colors.green),),
                onTap: () async{
                  Navigator.pop(context);

//delete
                  DatabaseHelper_DataList dbHelper = DatabaseHelper_DataList('ElementList');
                  int idToCheck = int.parse(widget.uid.toString());
                  // Replace with the ID you want to check
                  bool exists = await dbHelper.isDataExists(idToCheck);
                  if (exists) {
                    await dbHelper.deleteData(idToCheck);
                    print("Success");
                    final random = Random();
                    final randomNumber = random.nextInt(100000);

                    // Convert the random number to a string
                    final randomString = randomNumber.toString();
                    showUpdateSaveDialouge(context,randomString);


                  } else {
                    print('Data with ID $idToCheck does not exist in the database.');
                  }
                  print(barCodes.length);
                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.save_as,color: Colors.blue,),
                title: Text('Save As',style: TextStyle(color: Colors.blue),),
                onTap: () async{
                  Navigator.pop(context);
                  final random = Random();
                  final randomNumber = random.nextInt(100000);

                  // Convert the random number to a string
                  final randomString = randomNumber.toString();
                  await DatabaseHelper__UUID.instance.insertData("01018106033", ""+randomString);
                  showNameDialouge1(context,""+randomString);


                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.close,color: Colors.red,),
                title: Text('Cancel',style: TextStyle(color: Colors.red),),
                onTap: () async{
                  Navigator.pop(context);

                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
            ],
          ),
        );
      },
    );
  }
  //save and cancel
  void showsaveandcancel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                leading: Icon(Icons.save,color: Colors.green,),
                title: Text('Save',style: TextStyle(color: Colors.green),),
                onTap: () {
                  Navigator.pop(context);
           showNameDialouge(context);

    // print(tableCodes.length);

        /*
        for(int i = 0 ; i<tableCodes.length;i++)
        {
          try {
            int  get_id1 = int.parse(updateTableRow[i].toString());
            int  get_id2 = int.parse(updateTableColumn[i].toString());
            //bool get_id1 = bool.parse(updateTextBold[i].toString());
            //bool get_id1 = bool.parse(updateTextUnderline[i].toString());
           // double get_id1 = double.parse(updateTextWidthSize[i].toString());
           // String stringValue = get_id1.toString();

            print(get_id1);
            print(get_id2);

          } catch (e) {
            print("Error parsing size for QR Code ${qrCodes[i]}: $e");
          }
        }
         */



                  //print(updateQrcodeSize);

                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.online_prediction,color: Colors.green,),
                title: Text('Save in Server',style: TextStyle(color: Colors.green),),
                onTap: () async{
                  Navigator.pop(context);
                  give_subcategoryName(context);

                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
              ListTile(
                leading: Icon(Icons.close,color: Colors.red,),
                title: Text('Cancel',style: TextStyle(color: Colors.red),),
                onTap: () async{
                  Navigator.pop(context);

                },
              ),
              Divider( // Add a divider
                color: Colors.grey,
                height: 4, // Adjust the height of the line
              ),
            ],
          ),
        );
      },
    );
  }
  void give_subcategoryName(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a FocusNode and request focus on it
        FocusNode inputFocusNode = FocusNode();
        FocusScope.of(context).requestFocus(inputFocusNode);
        return Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: REdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: REdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    focusNode: inputFocusNode,
                    controller: conttroller11,

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {

                      });
                    },

                  ),
                ),
                TextButton(
                  onPressed: () async{
                    final inputBarcodeText = conttroller11.text;
                    print(inputBarcodeText);
                    Navigator.pop(context);
                    //print
                    if(inputBarcodeText.toString().toString()==null)
                    {
                      print("null");
                    }
                    else
                    {
                      print("lolololo");



                     /*
                      if(showBarcodeWidget)
                      {

                        String? image = await convertWidgetToImage1();
                        for(int i = 0 ; i<barCodes.length;i++)
                        {
                          double get_id1 = double.parse(updateBarcodeHeight[i].toString());
                          double get_id2 = double.parse(updateBarcodeWidth[i].toString());
                          String stringValue = get_id1.toString();
                          int  ssss = get_id1.toInt();
                          int  ssss11 = get_id2.toInt();
                          double barcodeee = double.parse(barCodesContainerRotations[i].toString());


                            String myuid11 = nameList[0];

                            addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee,
                    "ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);


                          int  secondlenght  =  int.parse(barCodes.length.toString())-1;

                          if(i==secondlenght)
                          {
                            barCodes.clear();
                            barCodeOffsets.clear();

                          }

                        }
                      }
                      //qr code
                      if(showQrcodeWidget)
                      {


                        String? image = await convertWidgetToImage1();
                        for(int i = 0 ; i<qrCodes.length;i++)
                        {
                          double get_id1 = double.parse(updateQrcodeSize[i].toString());
                          double get_id2 = double.parse(updateQrcodeSize[i].toString());
                          String stringValue = get_id1.toString();
                          int  ssss = get_id1.toInt();
                          int  ssss11 = get_id2.toInt();
                          double barcodeee = double.parse(qrCodesContainerRotations[i].toString());

                            String myuid11 = nameList[0];

                            // void addelemento(String databasename, String element, String date1, String  size1, String uuid1)
                            addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);

                            addDatatosqllite2("qrcode",myuid11,qrCodes[i],qrCodeOffsets[i].dx,qrCodeOffsets[i].dy,ssss,ssss,qrCodes.length,i,myuid11,barcodeee);


                          int  secondlenght  =  int.parse(qrCodes.length.toString())-1;

                          if(i==secondlenght)
                          {
                            qrCodes.clear();
                            qrCodeOffsets.clear();

                          }

                        }


                      }

                      //emoji container
                      if(showEmojiWidget)
                      {
                        String? image = await convertWidgetToImage1();
                        // print("Emoji$emojiCodes.lenght");
                        for(int i = 0 ; i<emojiCodes.length;i++)
                        {
                          double getRationm = double.parse(emojiCodesContainerRotations[i].toString());


                            //

                            double get_id1 = double.parse(updateEmojiWidth[i].toString());
                            String stringValue = get_id1.toString();
                            int  ssss = get_id1.toInt();
                            //
                            String myuid11 = nameList[0];
                            addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                            addDatatosqllite4("emoji__22",myuid11,emojiCodes[i],emojiCodeOffsets[i].dx,emojiCodeOffsets[i].dy,ssss,ssss,emojiCodes.length,i,myuid11,getRationm);


                          int  secondlenght  =  int.parse(emojiCodes.length.toString())-1;

                          if(i==secondlenght)
                          {
                            emojiCodes.clear();
                            emojiCodeOffsets.clear();

                          }

                        }


                      }
                      */
                      //text
                      if(showTextEditingWidget||showDateContainerWidget)
                      {
                        String? image__2 = await convertWidgetToImage1();
                        print(image__2);



                        for(int i = 0 ; i<textCodes.length;i++)
                        {
                          bool is_bold = bool.parse(updateTextBold[i].toString());
                          bool is_underline = bool.parse(updateTextUnderline[i].toString());
                          bool is_italic = bool.parse(updateTextItalic[i].toString());
                          double is_fontsize = double.parse(updateTextFontSize[i].toString());
                          double is_rotee = double.parse(textContainerRotations[i].toString());
                          double is_size = double.parse(updateTextWidthSize[i].toString());
                          TextAlign alignment = updateTextAlignment[i];
                          int  sizeee = is_size.toInt();

/*
void add_elemtToOnline(String tablename, String uuid, String contextdataa,
double positionx, double postiony, int height, int weight,
int index, int length, String myuid112,double barcodeee,bool is_bold, bool is_underline, bool is_italic,double is_fontsize,
    String viewDataList, String viewName,
    String view_date,String view_size,
    String view_uuid, String view_image)
 */


                            String myuid11 = nameList[0];

                            add_elemtToOnline("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,"1",is_rotee,
                                is_bold,is_underline,is_italic,is_fontsize,"ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image__2);


                          int  secondlenght  =  int.parse(textCodes.length.toString())-1;

                          if(i==secondlenght)
                          {
                            textCodes.clear();
                            textCodeOffsets.clear();

                          }


                        }


                      }
                      //image
                     /*
                      if(showImageWidget)
                      {
                        String? image = await convertWidgetToImage1();
                        for(int i = 0 ; i<imageCodes.length;i++)
                        {

                          double getRationm = double.parse(imageCodesContainerRotations[i].toString());

                            double get_id1 = double.parse(updateImageSize[i].toString());
                            String stringValue = get_id1.toString();
                            int  ssss = get_id1.toInt();
                            String myuid11 = nameList[0];
                            addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                            addDatatosqllite5("picture__1",myuid11,imageCodes[i],myImageOffset[i].dx,myImageOffset[i].dy,ssss,ssss,imageCodes.length,i,myuid11,getRationm);

                          int  secondlenght  =  int.parse(imageCodes.length.toString())-1;

                          if(i==secondlenght)
                          {
                            imageCodes.clear();
                            myImageOffset.clear();

                          }

                        }

                      }
                      //table
                      if(showTableWidget)
                      {
                        String? image = await convertWidgetToImage1();
                        for(int i = 0 ; i<tableCodes.length;i++)
                        {

                          int  row = updateTableRow[i];
                          int column = updateTableColumn[i];
                          double get_id1 = double.parse(updateTableWidth[i].toString());
                          double get_id2 = double.parse(updateTableHeight[i].toString());
                          String stringValue = get_id1.toString();
                          int  ssss22 = get_id2.toInt();
                          int  ssss = get_id1.toInt();



                            String myuid11 = nameList[0];
                            addelemento("ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
                            addDatatosqllite6("table_1",myuid11,tableCodes[i],tableOffsets[i].dx,tableOffsets[i].dy,ssss,ssss22,row,column,myuid11,get_id1);

                          int  secondlenght  =  int.parse(tableCodes.length.toString())-1;

                          if(i==secondlenght)
                          {
                            tableCodes.clear();
                            tableOffsets.clear();

                          }

                        }


                      }
                      */
                      //table



                     delayedHandler();

                    }


                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  BottomAppBar buildBottomAppBarButton(double screenWidth) {
    return BottomAppBar(
      child: Container(
        width: screenWidth,
        height: 60.h,
        color: const Color(0xff5DBCFF).withOpacity(0.13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async{
                if(widget.operaton=="1")
                  {
                    showSaveandSaveAsDialouge(context);
                  }
                else
                  {
                    showsaveandcancel(context);

                  }




              },
              style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  padding: REdgeInsets.symmetric(vertical: 11, horizontal: 50),
                  primary: const Color(0xff004368),
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold)),
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  textBorderWidget = false;
                  barcodeBorderWidget = false;
                  qrcodeBorderWidget = false;
                  imageBorderWidget = false;
                  emojiIconBorderWidget = false;
                  timeBorderWidget = false;
                  tableBorderWidget = false;
                });
                await Future.delayed(const Duration(milliseconds: 50));
                await printContent();

              },
              style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  padding: REdgeInsets.symmetric(vertical: 11, horizontal: 50),
                  primary: const Color(0xff004368),
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold)),
              child: const Text(
                'Print',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xffFFFFFF),
      leading: IconButton(
        onPressed: () async{
         // Navigator.pop(context);
          //Navigator.popUntil(context, (route) => route.isFirst);
           await showExitbutton(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.grey,
      ),
      title: Center(
        child: Text(
          '$widthText * $heightText mm' ,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16.sp,
              ),
          textAlign: TextAlign.center,
        ),
      ),

      actions: [
        /*IconButton(
          onPressed: () {},
          icon: Image.asset('assets/icons/undo.png'),
          color: Colors.grey,
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset('assets/icons/info.png'),
          color: Colors.grey,
        ),*/
        SizedBox(width: 60.w)
      ],
    );
  }

  Widget _createdLabelContainer(
      double containerHeight, double containerWidth, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          textBorderWidget = false;
          barcodeBorderWidget = false;
          qrcodeBorderWidget = false;
          timeBorderWidget = false;
          imageBorderWidget = false;
          emojiIconBorderWidget = false;
          timeBorderWidget = false;
        });
      },
      child: Container(
        child: RepaintBoundary(
          key: globalKey,
          child: Container(
            height: containerHeight,
            width: containerWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              border:Border.all(color: Colors.grey.shade400),
            ),
            child: Stack(
              children: [

                if (showTextEditingWidget || showDateContainerWidget)
                  for (var j = 0; j < textCodes.length; j++)
                    Positioned(
                      left: textContainerX + textCodeOffsets[j].dx,
                      top: textContainerY + textCodeOffsets[j].dy,
                      child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              textCodeOffsets[j] = Offset(
                                textCodeOffsets[j].dx + details.delta.dx,
                                textCodeOffsets[j].dy + details.delta.dy,
                              );
                            });
                          },
                          onTapDown: (details) {
                            //text click
                            setState(() {
                              textBorderWidget = true;
                              barcodeBorderWidget = false;
                              qrcodeBorderWidget = false;
                              imageBorderWidget = false;
                              emojiIconBorderWidget = false;
                              timeBorderWidget = false;
                              tableBorderWidget =false;
                              selectedTextCodeIndex = j;
                              selectedTimeCodeIndex = j;
                              if (SelectTime_Text_Scan_Int[j + 1] == 1) {
                                showTextEditingContainerFlag = true;
                                showQrcodeContainerFlag = false;
                                showBarcodeContainerFlag = false;
                                showTableContainerFlag = false;
                                showImageContainerFlag = false;
                                showDateContainerFlag = false;
                                showEmojiContainerFlag = false;
                                showDateContainerFlag = false;
                              } else if (SelectTime_Text_Scan_Int[j + 1] == 2) {
                                showTextEditingContainerFlag = true;
                                showDateContainerFlag = false;
                              } else if (SelectTime_Text_Scan_Int[j + 1] == 3) {
                                showDateContainerFlag = true;
                                showTextEditingContainerFlag = false;
                                showQrcodeContainerFlag = false;
                                showBarcodeContainerFlag = false;
                                showTableContainerFlag = false;
                                showImageContainerFlag = false;
                                showEmojiContainerFlag = false;
                              }
                            });
                          },
                          child: InkWell(
                            onDoubleTap: () {
                              if (SelectTime_Text_Scan_Int[j + 1] == 1) {
                                _showTextInputDialog(
                                    selectedTextCodeIndex, context);
                              } else if (SelectTime_Text_Scan_Int[j + 1] == 2) {
                                _showTextInputDialog(
                                    selectedTextCodeIndex, context);
                              }
                            },
                            child: Transform.rotate(
                              angle: -textContainerRotations[j],
                              child: TextEditingContainer(
                                labelText: textCodes[j],
                                textIndex: j,
                                isBold: updateTextBold[j],
                                isItalic: updateTextItalic[j],
                                isUnderline: updateTextUnderline[j],
                                textAlignment: updateTextAlignment[j],
                                textFontSize: updateTextFontSize[j],
                              ),
                            ),
                          )),
                    ),
                if (showBarcodeWidget)
                  for (var i = 0; i < barCodes.length; i++)
                    Positioned(
                      left: barContainerX + barCodeOffsets[i].dx,
                      top: barContainerY + barCodeOffsets[i].dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            barCodeOffsets[i] = Offset(
                              barCodeOffsets[i].dx + details.delta.dx,
                              barCodeOffsets[i].dy + details.delta.dy,
                            );
                          });
                        },
                        child: GestureDetector(
                          onTapDown: (details) {
                            setState(() {
                              barcodeBorderWidget = true;
                              showBarcodeContainerFlag = true;
                              showQrcodeContainerFlag = false;
                              showTextEditingContainerFlag = false;
                              showTableContainerFlag = false;
                              showImageContainerFlag = false;
                              showDateContainerFlag = false;
                              showEmojiContainerFlag = false;
                              textBorderWidget = false;
                              qrcodeBorderWidget = false;
                              imageBorderWidget = false;
                              emojiIconBorderWidget = false;
                              timeBorderWidget = false;
                              tableBorderWidget =false;
                              selectedBarCodeIndex = i;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _showBarcodeInputDialog(
                                  selectedBarCodeIndex, context);
                            });
                          },
                          child: Transform.rotate(
                            angle: -barCodesContainerRotations[i],
                            child:BarcodeContainer(
                              barcodeData: barCodes[i],encodingType: encodingType, brIndex: i,)
                          ),
                        ),
                      ),
                    ),
                if (showQrcodeWidget)
                  for (var i = 0; i < qrCodes.length; i++)
                    Positioned(
                      left: qrContainerX + qrCodeOffsets[i].dx,
                      top: qrContainerY + qrCodeOffsets[i].dy,
                      child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              qrCodeOffsets[i] = Offset(
                                qrCodeOffsets[i].dx + details.delta.dx,
                                qrCodeOffsets[i].dy + details.delta.dy,
                              );
                            });
                          },
                          onTapDown: (details) {
                            setState(() {
                              qrcodeBorderWidget = true;
                              showQrcodeContainerFlag = true;
                              showTextEditingContainerFlag = false;
                              showBarcodeContainerFlag = false;
                              showTableContainerFlag = false;
                              showImageContainerFlag = false;
                              showDateContainerFlag = false;
                              showEmojiContainerFlag = false;
                              textBorderWidget = false;
                              barcodeBorderWidget = false;
                              imageBorderWidget = false;
                              emojiIconBorderWidget = false;
                              timeBorderWidget = false;
                              tableBorderWidget =false;
                              selectedQRCodeIndex = i;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _showQrcodeInputDialog(
                                  selectedQRCodeIndex, context);
                            });
                          },
                          child: Transform.rotate(
                          angle: -qrCodesContainerRotations[i],
                            child: QrcodeContainer(
                              qrcodeData: qrCodes[i],
                              qrIndex: i,

                            ),
                          )),
                    ),
                if (showTableWidget)
                  for (var i = 0; i < tableCodes.length; i++)
                    Positioned(
                      left: tableContainerX + tableOffsets[i].dx,
                      top: tableContainerY + tableOffsets[i].dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            tableOffsets[i] = Offset(
                              tableOffsets[i].dx + details.delta.dx,
                              tableOffsets[i].dy + details.delta.dy,
                            );
                          });
                        },
                        child: InkWell(
                          onTapDown: (details) {
                            setState(() {
                              showTableContainerFlag = true;
                              showTableWidget = true;
                              showEmojiContainerFlag = false;
                              showTextEditingContainerFlag = false;
                              showBarcodeContainerFlag = false;
                              showQrcodeContainerFlag = false;
                              showImageContainerFlag = false;
                              showDateContainerFlag = false;
                              tableBorderWidget = true;
                              textBorderWidget = false;
                              barcodeBorderWidget = false;
                              qrcodeBorderWidget = false;
                              imageBorderWidget = false;
                              timeBorderWidget = false;
                              selectedTableCodeIndex = i;
                            });
                          },
                          child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              width: updateTableWidth[i],
                              height: updateTableHeight[i],
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: tableBorderWidget ? Border.all(color: selectedTableCodeIndex == i ? Colors.blue : Colors.transparent,
                              ): null),
                              child: Table(
                                defaultColumnWidth: const IntrinsicColumnWidth(),
                                border: TableBorder.all(
                                    width: 2, color: Colors.black),
                                children: [
                                  for (var rowIndex = 0; rowIndex <
                                      updateTableRow[i]; rowIndex++)
                                    TableRow(
                                      children: [
                                        for (var colIndex = 0; colIndex <
                                            updateTableColumn[i]; colIndex++)
                                          TableCell(
                                            child: SizedBox(
                                              height: updateTableHeight[i] / updateTableRow[i],
                                              width: updateTableWidth[i]/updateTableColumn[i],
                                              child: InkWell(
                                                onTap: () {
                                                  // if (selectedTableCodeIndex == i) {
                                                  //   //_showInputDialog(context, rowIndex, colIndex);
                                                  // }

                                                },
                                                child: const Text(
                                                  '',
                                                    //controllers[rowIndex][colIndex].text, // Display data from the controller
                                                  style: TextStyle(color: Colors.black),  // Set text color
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                         Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onPanUpdate: (details){
                              _handleResizeGesture(details, i);
                            },
                            child: Visibility(
                              visible: selectedTableCodeIndex == i
                                  ? tableBorderWidget
                                  : false,
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/icons/zoom_icon.png'),
                              ),
                            ),
                          ),
                        ),
                          ],
                        ),
                        ), // Include the TableContainer widget here
                      ),
                    ),
                if (showImageWidget)
                  for (var i = 0; i < imageCodes.length; i++)
                    if (imageCodes[i] != 'demoImage')

                    Positioned(
                      left: myImageOffset[i].dx,
                      top: myImageOffset[i].dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          Offset newPosition = Offset(
                            myImageOffset[i].dx + details.delta.dx,
                            myImageOffset[i].dy + details.delta.dy,
                          );
                          updateMyImageOffset(i, newPosition);
                        },
                        child: InkWell(
                            onTapDown: (details) {
                              setState(() {
                                showImageContainerFlag = true;
                                imageBorderWidget = true;
                                showEmojiContainerFlag = false;
                                showTextEditingContainerFlag = false;
                                showBarcodeContainerFlag = false;
                                showQrcodeContainerFlag = false;
                                showTableContainerFlag = false;
                                showDateContainerFlag = false;
                                textBorderWidget = false;
                                barcodeBorderWidget = false;
                                qrcodeBorderWidget = false;
                                emojiIconBorderWidget = false;
                                timeBorderWidget = false;
                                tableBorderWidget =false;
                                selectedImageCodeIndex = i;
                              });
                            },
                            child: Transform.rotate(
                              angle: -imageCodesContainerRotations[i],
                              child: ImagesTakeContainer(
                                  imageIndex: i,
                                  imageDate: Image.file(
                                    File(imageCodes[i]),
                                    fit: BoxFit.cover,
                                  )),
                            )),
                      ), // Include the TableContainer widget here
                    ),
                if (showScanWidget ||
                    showQrcodeWidget ||
                    showBarcodeWidget ||
                    showTextEditingWidget)
                  for (var i = 0; i < scanCodes.length; i++)
                    Positioned(
                      left: scanCodeOffsets[i].dx,
                      top: scanCodeOffsets[i].dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          Offset newPosition = Offset(
                            scanCodeOffsets[i].dx + details.delta.dx,
                            scanCodeOffsets[i].dy + details.delta.dy,
                          );
                          updateScanCodeOffset(i, newPosition);
                        },
                        child: InkWell(
                            onTapDown: (details) {
                              qrcodeBorderWidget = true;
                              barcodeBorderWidget = true;
                              textBorderWidget = false;
                              imageBorderWidget = false;
                              emojiIconBorderWidget = false;
                              timeBorderWidget = false;
                              selectedScanCodeIndex = i;
                            },
                            child: ScannerContainer(
                              scanIndex: i,
                            )),
                      ),
                    ),
                if (showEmojiWidget)
                  for (var i = 1; i < emojiCodes.length; i++)
                    Positioned(
                      left: emojiContainerX + emojiCodeOffsets[i].dx,
                      top: emojiContainerY + emojiCodeOffsets[i].dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          Offset newPosition = Offset(
                            emojiCodeOffsets[i].dx + details.delta.dx,
                            emojiCodeOffsets[i].dy + details.delta.dy,
                          );
                          updateEmojiOffsets(i, newPosition);
                        },
                        onTapDown: (details) {
                          setState(() {
                            emojiIconBorderWidget = true;
                            showEmojiContainerFlag = true;
                            showTextEditingContainerFlag = false;
                            showBarcodeContainerFlag = false;
                            showQrcodeContainerFlag = false;
                            showTableContainerFlag = false;
                            showImageContainerFlag = false;
                            showDateContainerFlag = false;
                            textBorderWidget = false;
                            barcodeBorderWidget = false;
                            qrcodeBorderWidget = false;
                            imageBorderWidget = false;
                            timeBorderWidget = false;
                            tableBorderWidget =false;
                            selectedEmojiCodeIndex = i;
                          });
                        },
                        child: Transform.rotate(
                          angle: -emojiCodesContainerRotations[i],
                          child: EmojiContainer(
                              emojiIndex: i,
                              emojiData: Image.file(File(emojiCodes[i]))),
                        ),
                      ),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsContainer(BuildContext context, double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 10.h),
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showTextEditingContainerFlag = false;
                  });
                }),
                const SizedBox(width: 260,)
                /*Image.asset('assets/images/line_c.png'),
                SizedBox(width: 100,)*/
                /*_buildIconButton('assets/icons/empty.png', 'Empty', () {}),
                _buildIconButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildIconButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildIconButton('assets/icons/redo.png', 'Redo', () {}),*/
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: _buildOptions(context, screenWidth),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildOptions(context, screenWidth) {
    return Container(
      height: 232.h,
      width: screenWidth,
      color: Colors.white,
      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          _buildOptionRow(
            [
              _buildIconButton('assets/icons/text.png', 'Text', () {
                setState(() {
                  showTextEditingWidget = true;
                  showTextEditingContainerFlag = true;
                  generateTextCode('Double Click here', 1);
                });
              }),
              _buildIconButton('assets/icons/barcode.png', 'Barcode', () {
                setState(() {
                  showBarcodeContainerFlag = true;
                  showBarcodeWidget = true;
                  generateBarCode('1234', 1);
                });
              }),
              _buildIconButton('assets/icons/qrcode.png', 'QR Code', () {
                setState(() {
                  showQrcodeWidget = true;
                  showQrcodeContainerFlag = true;
                  generateQRCode("5678", 1);
                });
              }),
              _buildIconButton('assets/icons/table.png', 'Table', () {
                setState(() {
                  showTableContainerFlag = true;
                  showTableWidget = true;
                  generateTableCode();
                });
              }),
            ],
          ),
          SizedBox(height: 15.h),
          _buildOptionRow(
            [
              _buildIconButton('assets/icons/images.png', 'Image', () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Select Image'),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            createMyImage(1);
                          },
                          child: const Text('Select Image from Gallery'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            createMyImage(0);
                          },
                          child: const Text('Take Picture'),
                        ),
                      ],
                    );
                  },
                );
                setState(() {
                  showImageContainerFlag = true;
                  showImageWidget = true;
                });
              }),
              _buildIconButton('assets/icons/scan.png', 'Scan', () {
                setState(() {
                  scanBarcode(context);
                });
              }),
              _buildIconButton('assets/icons/time.png', 'Time', () {
                setState(() {
                  showDateContainerWidget = true;
                  showDateContainerFlag = true;
                  generateTextCode(getFormattedDateTime(), 3);
                });
              }),
              _buildIconButton('assets/icons/emoji_icon.png', 'Emoji', () {
                setState(() {
                  showEmojiWidget = true;
                  showEmojiContainerFlag = true;
                });
              }),

            ],
          ),
          SizedBox(height: 15.h),
          /*_buildOptionRow(
            [
              _buildIconButton(
                  'assets/icons/serial_number.png', 'Serial Number', () {}),
              _buildIconButton(
                  'assets/icons/insert_excel.png', 'Insert Excel', () {}),
              _buildIconButton('assets/icons/shape.png', 'Shape', () {}),
              _buildIconButton('assets/icons/line.png', 'Line', () {}),

            ]),*/
        ],
      ),
    );
  }

  Widget _buildOptionRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  Widget _buildIconButton(
      String imagePath, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 60.w,
        child: Column(
          children: [
            IconButton(
              onPressed: onPressed,
              icon: Image.asset(
                imagePath,
                width: 24.w,
                height: 24.h,
              ),
              color: Colors.grey,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: Colors.black45,
                fontFamily: 'Poppins-Regular',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // show text editing container
  Widget _showTextEditingContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 15.h),
        height: double.infinity,
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildOptionRow(
                [
                  _buildIconButton('assets/icons/template.png', 'Template', () {
                    setState(() {
                      showTextEditingWidget = true;
                      showTextEditingContainerFlag = false;
                      showBarcodeContainerFlag = false;
                      showQrcodeContainerFlag = false;
                      showTableContainerFlag = false;
                      showImageContainerFlag = false;
                      showDateContainerFlag = false;
                      showEmojiContainerFlag = false;
                    });
                  }),
                  Image.asset('assets/images/line_c.png'),
                  _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                      () {
                    setState(() {
                      showTextEditingContainerFlag = false;
                      print('Text Container $showTextEditingContainerFlag');
                      deleteTextCode(selectedTextCodeIndex);
                    });
                  }),
                  /*_buildTextIonButton(
                      'assets/icons/multiple.png', 'Multiple', () {}),
                  _buildTextIonButton(
                      'assets/icons/mirroring_icon.png', 'Mirroring', () {}),
                  _buildTextIonButton(
                      'assets/icons/lock_icon.png', 'Lock', () {}),*/
                  _buildTextIonButton(
                    'assets/icons/rotated_icon.png', 'Rotate', () {
                    setState(() {
                      if (textContainerRotations[selectedTextCodeIndex] == 0.0) {
                        // Rotate to vertical
                        textContainerRotations[selectedTextCodeIndex] = -90 * pi / 180;
                      } else if (textContainerRotations[selectedTextCodeIndex] == -90 * pi / 180) {
                        // Rotate to horizontal
                        textContainerRotations[selectedTextCodeIndex] = pi; // 180 degrees
                      } else if (textContainerRotations[selectedTextCodeIndex] == pi) {
                        // Rotate back to vertical
                        textContainerRotations[selectedTextCodeIndex] = 90 * pi / 180;
                      } else if (textContainerRotations[selectedTextCodeIndex] == 90 * pi / 180) {
                        // Rotate to horizontal
                        textContainerRotations[selectedTextCodeIndex] = 0.0;
                      }
                    });
                  }),
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                  height: 180.h,
                  child: SingleChildScrollView(
                      child: _textEditingOptions(context, screenWidth))),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildTextIonButton(
      String imagePath, String label, VoidCallback onPressed) {
    return SizedBox(
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Image.asset(
              imagePath,
              width: 24.w,
              height: 24.h,
            ),
            color: Colors.grey,
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.black45,
              fontFamily: 'Poppins-Regular',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  String alignment_Flag = '0';

  Widget _textEditingOptions(context, screenWidth) {
    return Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 60),
          _textEditingOptionRow([
            IconButton(
              onPressed: _toggleBold,
              icon: Icon(
                updateTextBold[selectedTextCodeIndex]
                    ? Icons.format_bold
                    : Icons.format_bold,
                color: updateTextBold[selectedTextCodeIndex]
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: _toggleUnderline,
              icon: Icon(
                updateTextUnderline[selectedTextCodeIndex]
                    ? Icons.format_underline
                    : Icons.format_underline,
                color: updateTextUnderline[selectedTextCodeIndex]
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            IconButton(
                onPressed: _toggleItalic,
                icon: Icon(
                  updateTextItalic[selectedTextCodeIndex]
                      ? Icons.format_italic
                      : Icons.format_italic,
                  color: updateTextItalic[selectedTextCodeIndex]
                      ? Colors.black
                      : Colors.grey,
                )),
            SizedBox(width: 60.w),
            IconButton(
              onPressed: () {
                alignment_Flag = "2";
                _changeAlignment(TextAlign.left);
                updateTextAlignment[selectedTextCodeIndex] = TextAlign.left;
              },
              icon: Icon(
                selectedTextCodeIndex >= 0 &&
                        selectedTextCodeIndex < updateTextAlignment.length
                    ? Icons.format_align_left
                    : Icons.error,
                color:
                    updateTextAlignment[selectedTextCodeIndex] == TextAlign.left
                        ? Colors.black
                        : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                alignment_Flag = "3";
                _changeAlignment(TextAlign.center);
                updateTextAlignment[selectedTextCodeIndex] = TextAlign.center;
              },
              icon: Icon(
                selectedTextCodeIndex >= 0 &&
                        selectedTextCodeIndex < updateTextAlignment.length
                    ? Icons.format_align_center
                    : Icons.error,
                color: TextAlign.center ==
                        updateTextAlignment[selectedTextCodeIndex]
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                alignment_Flag = "4";
                _changeAlignment(TextAlign.right);
                updateTextAlignment[selectedTextCodeIndex] = TextAlign.right;
              },
              icon: Icon(
                selectedTextCodeIndex >= 0 &&
                        selectedTextCodeIndex < updateTextAlignment.length
                    ? Icons.format_align_right
                    : Icons.error,
                color: TextAlign.right ==
                        updateTextAlignment[selectedTextCodeIndex]
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ]),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Text font size',
                    style: bodySmall.copyWith(fontFamily: pMedium)),
                Slider(
                  min: 15,
                  max: 30,
                  value: updateTextFontSize[selectedTextCodeIndex],
                  onChanged: (value) {
                    _changeFontSize(value);
                    setState(() {
                      textValueSize = value;
                    });
                  },
                ),
                Container(
                  height: 20,
                  width: 32,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey)),
                  child: Center(
                    child: Text(
                      updateTextFontSize[selectedTextCodeIndex].toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 65),
          /*Padding(
            padding: REdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Character arrangement',
                    style: bodySmall.copyWith(fontFamily: pMedium)),
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icons/horizontal_icon.png',
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/icons/vertical_icon.png')),
                IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/icons/curved_icon.png')),
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wrap by word', style: bodySmall),
                GestureDetector(
                  onTap: warpByWordSwitch,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: _wrapByWord ? Colors.green : Colors.grey,
                    ),
                    child: Row(
                      mainAxisAlignment: _wrapByWord
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reverse Type', style: bodySmall),
                GestureDetector(
                  onTap: reverseTypeSwitch,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: _reverseType ? Colors.green : Colors.grey,
                    ),
                    child: Row(
                      mainAxisAlignment: _reverseType
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _textEditingOptionRow(List<Widget> children) {
    return Row(
      children: children,
    );
  }

  bool _wrapByWord = false;
  bool _reverseType = false;

  void warpByWordSwitch() {
    setState(() {
      _wrapByWord = !_wrapByWord;
    });
  }

  void reverseTypeSwitch() {
    setState(() {
      _reverseType = !_reverseType;
    });
  }

  // text functionality
  void _toggleBold() {
    setState(() {
      final previousText = textEditingController.text;
      isBold = !isBold;
      if (isBold) {
        updateTextBold[selectedTextCodeIndex] = true;
      } else {
        updateTextBold[selectedTextCodeIndex] = false;
      }
      undoStack.add(previousText);
      _applyChanges();
    });
  }

  void _toggleUnderline() {
    setState(() {
      final previousText = textEditingController.text;
      isUnderline = !isUnderline;
      if (isUnderline) {
        updateTextUnderline[selectedTextCodeIndex] = true;
      } else {
        updateTextUnderline[selectedTextCodeIndex] = false;
      }
      undoStack.add(previousText);
      _applyChanges();
    });
  }

  void _toggleItalic() {
    setState(() {
      final previousText = textEditingController.text;
      isItalic = !isItalic;
      if (isItalic) {
        updateTextItalic[selectedTextCodeIndex] = true;
      } else {
        updateTextItalic[selectedTextCodeIndex] = false;
      }
      undoStack.add(previousText);
      _applyChanges();
    });
  }

  void _changeAlignment(TextAlign alignment) {
    setState(() {
      final previousText = textEditingController.text;
      textAlignment = alignment;
      updateTextAlignment[selectedTextCodeIndex] = alignment;
      undoStack.add(previousText);
      _applyChanges();
    });
  }

  void _changeFontSize(double fontSize) {
    setState(() {
      final previousText = textEditingController.text;
      textFontSize = fontSize;
      if (fontSize == textFontSize) {
        updateTextFontSize[selectedTextCodeIndex] = fontSize;
      } else {
        updateTextFontSize[selectedTextCodeIndex] = 15;
      }
      undoStack.add(previousText);
      _applyChanges();
    });
  }

  void _applyChanges() {
    textEditingController.value = TextEditingValue(
      text: currentText,
      selection: TextSelection.collapsed(offset: currentText.length),
    );
  }


  //show text input dialog
  //Show input data Dialog Box
  bool isTextCleared = true;
  bool isBarcodeTextCleared = true;
  bool isQrCodesTextCleared = true;
  Map<int, TextEditingController> textControllers = {};
  Map<int, TextEditingController> barCodesControllers = {};
  Map<int, TextEditingController> qrCodesControllers = {};
  FocusNode inputFocusNode = FocusNode();

  void _showTextInputDialog(int selectIndex, BuildContext context) {
    if (!textControllers.containsKey(selectIndex)) {
      textControllers[selectIndex] = TextEditingController(text: "");
    }
    final TextEditingController? inputTextEditingController =
    textControllers[selectIndex];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        FocusScope.of(context).requestFocus(inputFocusNode);
        return WillPopScope(
          onWillPop: () async {
            inputFocusNode.unfocus();
            Navigator.of(context).pop();
            return false;
          },
          child: Dialog(
            alignment: Alignment.bottomCenter,
            insetPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      focusNode: inputFocusNode,
                      controller: inputTextEditingController,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Text here",
                      ),
                      onChanged: (value) {
                        setState(() {
                          textCodes[selectIndex] = value;
                          isTextCleared = value.isEmpty;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final inputTextCode = inputTextEditingController?.text;
                      if (inputTextCode!.isNotEmpty) {
                        setState(() {
                          labelText = inputTextCode;
                        });
                      } else {
                        setState(() {
                          labelText = "Double click here";
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // This code executes when the dialog is closed
      if (isTextCleared) {
        setState(() {
          textCodes[selectIndex] = "Double click here";
        });
        isTextCleared = false;
      }
    });
  }

  //show barcode container
  _checkDataLength(String encodingType) {
    switch (encodingType) {
      case 'Code128':
        isSupportedType = true;
        return Barcode.code128();
      case 'UPC-A':
        isSupportedType = true;
        return barcodeData.length == 12;
      case 'EAN-8':
        isSupportedType = true;
        return barcodeData.length == 7;
      case 'EAN-13':
        isSupportedType = true;
        return barcodeData.length == 13;
      case 'Code93':
        isSupportedType = true;
        return Barcode.code93();
      case 'Code39':
        isSupportedType = true;
        return Barcode.code39();
      case 'CodeBar':
        isSupportedType = true;
        return Barcode.codabar();
      default:
        isSupportedType = false;
        return Barcode.code128();
    }
  }

  //show barcode container
  Widget _showBarcodeContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 15.h),
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showBarcodeWidget = true;
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                  });
                }),
                Image.asset('assets/images/line_c.png'),
                _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                    () {
                  setState(() {
                    if (selectedBarCodeIndex == null) {
                    } else {
                      deleteBarCode(selectedBarCodeIndex);
                      showBarcodeContainerFlag = false;
                    }
                  });
                }),
                /*_buildTextIonButton('assets/icons/empty.png', 'Empty', () {}),
                _buildTextIonButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildTextIonButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildTextIonButton('assets/icons/redo.png', 'Redo', () {}),*/
                _buildTextIonButton(
                    'assets/icons/rotated_icon.png', 'Rotate', () {
                  setState(() {
                    if (barCodesContainerRotations[selectedBarCodeIndex] == 0.0) {
                      barCodesContainerRotations[selectedBarCodeIndex] = -90 * pi / 180;
                    } else if (barCodesContainerRotations[selectedBarCodeIndex] == -90 * pi / 180) {
                      barCodesContainerRotations[selectedBarCodeIndex] = pi; // 180 degrees
                    } else if (barCodesContainerRotations[selectedBarCodeIndex] == pi) {
                      barCodesContainerRotations[selectedBarCodeIndex] = 90 * pi / 180;
                    } else if (barCodesContainerRotations[selectedBarCodeIndex] == 90 * pi / 180) {
                      barCodesContainerRotations[selectedBarCodeIndex] = 0.0;
                    }
                  });
                }),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 170.h,
                  width: screenWidth,
                  color: Colors.white,
                  padding: REdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Text(
                            'Content',
                            style: bodySmall,
                          ),
                          SizedBox(width: 30.w),
                          InkWell(
                            onTap: () {
                              _showBarcodeInputDialog(
                                  selectedBarCodeIndex, context);
                            },
                            child: Container(
                              height: 35.h,
                              width: 230.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r))),
                              child: Center(
                                child: Text(
                                  barCodes.isNotEmpty
                                      ? barCodes[selectedBarCodeIndex]
                                      : barcodeData,
                                  style: bodySmall,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Text(
                            'Encoding\n type',
                            style: bodySmall,
                          ),
                          SizedBox(width: 30.w),
                          Container(
                            height: 35.h,
                            width: 230.w,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r))),
                            child: EncodingTypePicker(
                              selectedType: encodingType,
                              supportedTypes: supportedEncodingTypes,
                              onTypeChanged: (value) {
                                setState(() {
                                  encodingType = value;
                                  errorMessage =
                                      ""; // Reset error message when the encoding type changes
                                });
                              },
                              onConfirm: (value) {
                                setState(() {
                                  encodingType = value;
                                  if (!_checkDataLength(value)) {
                                    errorMessage =
                                        'Invalid data length for $value';
                                  } else {
                                    errorMessage = "";
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  // show barcode input data dialog
  //final FocusNode inputFocusNode = FocusNode();

  void _showBarcodeInputDialog(int selectIndex, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a FocusNode and request focus on it
        FocusNode inputFocusNode = FocusNode();
        FocusScope.of(context).requestFocus(inputFocusNode);
        return Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: REdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: REdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    focusNode: inputFocusNode,
                    controller: inputBarcodeData,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (barCodes.isNotEmpty) {
                          barCodes[selectIndex] = inputBarcodeData.text;
                        }
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final inputBarcodeText = inputBarcodeData.text;
                    if (barCodes.isNotEmpty) {
                      setState(() {
                        barCodes[selectIndex] = inputBarcodeText;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  List<UUID_Model> dataList1 = [];
  List<MyDataModel> dataList23 = [];
//fetch data from fire
  List<String> nameList=[];
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
  Future<void> fetchDataList2(String myuid) async {


    List<UUID_Model> fetchedData = await DatabaseHelper__UUID.instance.getAllData();
    setState(() {
      dataList1 = fetchedData;
    });

   nameList = dataList1.map((data) => data.name).toList();
   // print(dataList1);

  }
  List<UUID_Model_22> dataList233 = [];
  List<String> current_list22=[];
  Future<void> fetchCurrentEmoji(String myuid) async {


    List<UUID_Model_22> fetchedData = await DatabaseHelper__UUID222.instance.getAllData();
    setState(() {
      dataList233 = fetchedData;
    });

    current_list22 = dataList233.map((data) => data.name).toList();
    // print(dataList1);

  }
  //get
  List<MyDataModel> dataList2 = [];

  Future<void> fetchDataListqrcode(String myuid) async {
    print("MyUUID");
    print(myuid);
    final dbHelper3 = DatabaseHelper_Element2("qrcode","qrcode");
    dbHelper3.initDatabase();
    await dbHelper3.initDatabase();
    String desiredBarcodeType = myuid;
    List<MyDataModel> filteredData = await dbHelper3.getAllDataByBarcodeType(desiredBarcodeType);
    int flag = 0;
    print(filteredData);

    for (MyDataModel data in filteredData) {
      if(flag==0)
        {
          showQrcodeWidget = true;
          flag++;
        }
      if (mounted) {
        setState(() {
          dataList555 = filteredData;
          String barcodeType = data.barcodeType;

          qrCodes.add('${data.contentData}');

          qrCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          String roate_get = data.address;
          double roteValue = double.parse(roate_get);
          qrCodesContainerRotations.add(roteValue);
          updateQrcodeSize.add(data.widgetHeight);
          selectedQRCodeIndex = 0;
          qrcodeBorderWidget = true;



          //qrCodes.add('${data.contentData}');

          //qrCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
         // qrCodesContainerRotations.add(0);
          //updateQrcodeSize.add(data.widgetWidth);
        //  print(data.widgetWidth);
          // Update any other relevant state variables here.
        });
      }


    }
  }
  //barcode
  List<String> barcodeList = [];
  Future<void> fetchDataListbarcode(String myuid) async {


    final dbHelper3 = DatabaseHelper_Element3("barcode","barcode");
    dbHelper3.initDatabase();
    await dbHelper3.initDatabase();
    String desiredBarcodeType = myuid;
    List<MyDataModel> filteredData = await dbHelper3.getAllDataByBarcodeType(desiredBarcodeType);
    int flag = 0;
    print(filteredData);
    for (MyDataModel data in filteredData) {
      if(flag==0)
      {
        showBarcodeWidget = true;
        flag++;
      }
      if (mounted) {
        setState(() {
          dataList555 = filteredData;
          String barcodeType = data.barcodeType;
          barCodes.add(data.contentData);
          barCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          String roate_get = data.address;
          double roteValue = double.parse(roate_get);
          barCodesContainerRotations.add(roteValue);
          selectedBarCodeIndex = 0;
          barcodeBorderWidget = true;
          updateBarcodeWidth.add(data.widgetWidth);
          updateBarcodeHeight.add(data.widgetHeight);
          /*
          barCodes.add(data.contentData);
          barCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          barCodesContainerRotations.add(0);
          updateBarcodeWidth.add(data.widgetWidth);
          updateBarcodeHeight.add(data.widgetHeight);
           */
          // Update any other relevant state variables here.
        });
      }



    }
  }
  List<MyDataModel> dataList555 = [];
  List<int> idList555 = [];
  //text
  Future<void> fetchDataListtext(String myuid) async {


    final dbHelper3 = DatabaseHelper_Element("text","text");
    dbHelper3.initDatabase();
    await dbHelper3.initDatabase();
    String desiredBarcodeType = myuid;
    List<MyDataModel> filteredData = await dbHelper3.getAllDataByBarcodeType(desiredBarcodeType);
    int flag = 0;
    print(filteredData);
    for (MyDataModel data in filteredData) {
      if(flag==0)
      {
        showTextEditingWidget = true;
        flag++;
      }
      if (mounted) {
        setState(() {
          dataList555 = filteredData;
          print(dataList555);
          textCodes.add(data.contentData);
          selectedTextCodeIndex = 0;
          textBorderWidget = true;
          textCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          updateTextBold.add(data.bold);
          String italic_string = data.fromWhere;

          bool italic_bool = bool.fromEnvironment(italic_string);
          updateTextItalic.add(italic_bool);
          updateTextUnderline.add(data.underline);
          updateTextAlignment.add(TextAlign.left);
          updateTextFontSize.add(data.textSize);
          SelectTime_Text_Scan_Int.add(1);
          String roate_get = data.address;
          double roteValue = double.parse(roate_get);
          textContainerRotations.add(roteValue);
          updateTextWidthSize.add(data.widgetHeight);
          //textCodes.add(data.contentData);
          //textCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
         // print(data.bold);
          // updateTextBold.add(false);
          // updateTextItalic.add(false);
          // updateTextUnderline.add(false);
          // updateTextAlignment.add(TextAlign.left);
          // updateTextFontSize.add(15.0);
          // SelectTime_Text_Scan_Int.add(1);
          // textContainerRotations.add(0.0);
          // Update any other relevant state variables here.
        });
      }
      else{
        print("Not mount");
      }



    }
  }
  //emoji
  Future<void> fetchDataListemoji(String myuid) async {
    final dbHelper3 = DatabaseHelper_Element5("emoji__22","emoji__22");
    dbHelper3.initDatabase();
    await dbHelper3.initDatabase();
    String desiredBarcodeType = myuid;
    List<MyDataModel> filteredData = await dbHelper3.getAllDataByBarcodeType(desiredBarcodeType);
    int flag = 0;
    for (MyDataModel data in filteredData) {
      if(flag==0)
      {
        showEmojiWidget = true;
        flag++;
      }
      if (mounted) {
        setState(() {
          dataList555 = filteredData;
          //emojiCodes.add(data.contentData);
         // emojiCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          // Update any other relevant state variables here.
         // updateEmojiWidth.add(data.widgetWidth);

          emojiCodes.add(data.contentData);

          emojiCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          String roate_get = data.address;
          double roteValue = double.parse(roate_get);
          emojiCodesContainerRotations.add(roteValue);

          updateEmojiWidth.add(data.widgetWidth);
          selectedEmojiCodeIndex = 0;
          emojiIconBorderWidget = true;
        });
      }



    }
  }
  //image
  Future<void> fetchDataListimage(String myuid) async {
    final dbHelper3 = DatabaseHelper_Element4("picture__1","picture__1");
    dbHelper3.initDatabase();
    await dbHelper3.initDatabase();
    String desiredBarcodeType = myuid;
    List<MyDataModel>? filteredData = await dbHelper3.getAllDataByBarcodeType(desiredBarcodeType);
    int flag = 0;
    for (MyDataModel data in filteredData!) {
      if(flag==0)
      {
        showImageWidget = true;
        flag++;
      }
      if (mounted) {
        setState(() {
          dataList555 = filteredData;
          imageCodes.add(data.contentData);
          myImageOffset.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          String roate_get = data.address;
          double roteValue = double.parse(roate_get);
          imageCodesContainerRotations.add(roteValue);
          emojiCodeOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));
          updateImageSize.add(data.widgetWidth);

          // Update any other relevant state variables here.
        });
      }



    }
  }
//table
  Future<void> fetchDataListTable(String myuid) async {
    final dbHelper3 = DatabaseHelper_Element6("table_1","table_1");
    dbHelper3.initDatabase();
    await dbHelper3.initDatabase();
    String desiredBarcodeType = myuid;
    List<MyDataModel>? filteredData = await dbHelper3.getAllDataByBarcodeType(desiredBarcodeType);
    int flag = 0;
    for (MyDataModel data in filteredData!) {
      if(flag==0)
      {
        showTableWidget = true;
        flag++;
      }
      if (mounted) {
        setState(() {
          dataList555 = filteredData;
          tableCodes.add(data.contentData);
          tableOffsets.add(Offset(double.parse(data.positionX.toString()), double.parse(data.positionY.toString())));

          updateTableRow.add(data.index);
          updateTableColumn.add(data.length);
          updateTableWidth.add(data.widgetWidth);
          updateTableHeight.add(data.widgetHeight);
          //controllers.add(newControllers);
          selectedTableCodeIndex = 0;
          tableBorderWidget = true;

          // Update any other relevant state variables here.
        });
      }



    }
  }



  Timer? _timer;
  int _counter = 0;
  int randomInt = 0 ;
  @override
  void initState() {
    super.initState();
    print("Op");

    fetchDataList2(widget.uid.toString());
    print(widget.operaton);
    label_name= widget.name_label.toString();
    if(flage_init==0)
      {
        print("donlon++++1111");
        flage_init=1;
        var uuid = Uuid();
        String  randomUuigd = uuid.v4();
        int min = 1;
        int max = 100;
         randomInt = min + Random().nextInt(max - min);
        // print(randomInt);


       if(widget.operaton=="1")
         {
           print("ggg");

        fetchDataListqrcode(widget.uid.toString());
    fetchDataListtext(widget.uid.toString());
     fetchDataListbarcode(widget.uid.toString());
       fetchDataListimage(widget.uid.toString());
    fetchDataListemoji(widget.uid.toString());
           fetchDataListTable(widget.uid.toString());
           getCurrentTime();
         }
       else if(flagg=="2"){

       }

      }
    var uuid = Uuid();

// Generate a random UUID
    String randomUuid = uuid.v4();
    if(widget.uid.toString()==null)
      {


      }
    print(widget.uid);

    DateTime now = DateTime.now();
    formattedDate1 = formatDate(now);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        fetchCurrentEmoji("010181060331");

        for (var i = 0; i < imageCodes.length; i++)
          {
            print(imageCodes[i]);
          }
        _counter++;
        initializeFirebase();
        if (myui == 5) {
          generateEmojiCode();
        }
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the keyboard programmatically
      inputFocusNode.requestFocus();
      imagePicker = ImagePicker();
    });
    selectTime = TimeOfDay.now();
    selectFormat = TimeOfDayFormatD.h_colon_mm_space_a;
    selectDate = DateTime.now();
    selectedFormatDate = DateFormat.yMMMMd();
  }
  late Future<List<MyDataModel>> fetchDataFuture;
  @override
  void dispose()  {
    inputFocusNode.dispose();
    _timer?.cancel();
    flage_init = 0;

     // fetchDataListtext(widget.uid.toString()).cancel();
    super.dispose();
  }

  //show qrcode container
  Widget _showQrcodeContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 15.h),
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showQrcodeWidget = true;
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                  });
                }),
                Image.asset('assets/images/line_c.png'),
                _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                    () {
                  setState(() {
                    if (selectedQRCodeIndex == null) {
                    } else {
                      deleteQRCode(selectedQRCodeIndex);
                      showQrcodeContainerFlag = false;
                    }
                  });
                }),
                /*_buildTextIonButton('assets/icons/empty.png', 'Empty', () {}),
                _buildTextIonButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildTextIonButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildTextIonButton('assets/icons/redo.png', 'Redo', () {}),*/
                _buildTextIonButton(
                    'assets/icons/rotated_icon.png', 'Rotate', () {
                  setState(() {
                    if (qrCodesContainerRotations[selectedQRCodeIndex] == 0.0) {
                      qrCodesContainerRotations[selectedQRCodeIndex] = -90 * pi / 180;
                    } else if (qrCodesContainerRotations[selectedQRCodeIndex] == -90 * pi / 180) {
                      qrCodesContainerRotations[selectedQRCodeIndex] = pi; // 180 degrees
                    } else if (qrCodesContainerRotations[selectedQRCodeIndex] == pi) {
                      qrCodesContainerRotations[selectedQRCodeIndex] = 90 * pi / 180;
                    } else if (qrCodesContainerRotations[selectedQRCodeIndex] == 90 * pi / 180) {
                      qrCodesContainerRotations[selectedQRCodeIndex] = 0.0;
                    }
                  });
                }),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 170.h,
                  width: screenWidth,
                  color: Colors.white,
                  padding: REdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Text(
                            'Content',
                            style: bodySmall,
                          ),
                          SizedBox(width: 30.w),
                          InkWell(
                            onTap: () {
                              _showQrcodeInputDialog(
                                  selectedQRCodeIndex, context);
                            },
                            child: Container(
                              height: 35.h,
                              width: 230.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r))),
                              child: Center(
                                child: Text(
                                  qrCodes.isNotEmpty
                                      ? qrCodes[selectedQRCodeIndex]
                                      : qrcodeData,
                                  //qrCodes[selectedQRCodeIndex!],
                                  style: bodySmall,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Text(
                            'Encoding\n type',
                            style: bodySmall,
                          ),
                          SizedBox(width: 30.w),
                          Container(
                            height: 35.h,
                            width: 230.w,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r))),
                            child: Center(
                              child: Text('QR_CODE', style: bodySmall),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  // show qrcode input data dialog
  final TextEditingController _inputQrcodeData = TextEditingController();

  void _showQrcodeInputDialog(int selectedQRCodeIndex, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        FocusNode inputFocusNode = FocusNode();
        FocusScope.of(context).requestFocus(inputFocusNode);
        return Dialog(
          alignment: Alignment.bottomCenter,
          insetPadding: REdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: REdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    focusNode: inputFocusNode,
                    controller: _inputQrcodeData,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (qrCodes.length > 0) {
                          qrCodes[selectedQRCodeIndex] = _inputQrcodeData.text;
                        }
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final inputQrcodeText = _inputQrcodeData.text;
                    if (inputQrcodeText.isNotEmpty) {
                      setState(() {
                        if (qrCodes.length > 0) {
                          qrCodes[selectedQRCodeIndex] = inputQrcodeText;
                        }
                      });
                      Navigator.pop(context);
                    } else {
                      if (qrCodes.length > 0) {
                        qrCodes[selectedQRCodeIndex] = inputQrcodeText;
                      }
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // show table container
  Widget _showTableContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 15.h),
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showTableWidget = true;
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                  });
                }),
                Image.asset('assets/images/line_c.png'),
                _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                    () {
                  setState(() {
                    showTableContainerFlag = false;
                    deleteTableCode();
                  });
                }),

                /*_buildTextIonButton('assets/icons/empty.png', 'Empty', () {}),
                _buildTextIonButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildTextIonButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildTextIonButton('assets/icons/redo.png', 'Redo', () {}),*/
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 215.h,
                  width: screenWidth,
                  color: Colors.white,
                  padding: REdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              addColumn();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/icons/inset_colum_icon.png'),
                                SizedBox(
                                  height: 14.h,
                                  child: const Text('Insert colum'),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              addRow();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/icons/insert_row_icon.png'),
                                SizedBox(
                                  height: 14.h,
                                  child: const Text('Insert Row'),
                                ),

                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              removeColumn();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/icons/delete_colum_icon.png'),
                                SizedBox(
                                  height: 14.h,
                                  child: const Text('Delete colum'),
                                ),

                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              removeRow();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/icons/delete_row_icon.png'),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 14.h,
                                  child: const Text('Delete Row'),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            'Line width',
                            style: bodySmall,
                          ),
                          SizedBox(width: 15.w),
                          CustomSlider(
                            initialValue: lineWidthValue,
                            minValue: 2.0,
                            maxValue: 30.0,
                            onChanged: (value) {
                              lineWidthValue = value;
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Row height',
                            style: bodySmall,
                          ),
                          SizedBox(width: 9.w),
                          CustomSlider(
                            initialValue: lineWidthValue,
                            minValue: 2.0,
                            maxValue: 30.0,
                            onChanged: (value) {
                              lineWidthValue = value;
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Colum width',
                            style: bodySmall,
                          ),
                          SizedBox(width: 1.w),
                          CustomSlider(
                            initialValue: lineWidthValue,
                            minValue: 2.0,
                            maxValue: 30.0,
                            onChanged: (value) {
                              lineWidthValue = value;
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  // show Image container
  Widget _showImageContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 15.h),
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showImageWidget = true;
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                  });
                }),
                Image.asset('assets/images/line_c.png'),
                _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                    () {
                  setState(() {
                    showImageContainerFlag = false; // Hide additional container
                    //showImageWidget = false;
                    deleteImageCode(selectedImageCodeIndex);
                  });
                }),
                /*_buildTextIonButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildTextIonButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildTextIonButton('assets/icons/redo.png', 'Redo', () {}),*/
                _buildTextIonButton(
                    'assets/icons/rotated_icon.png', 'Rotate', () {
                  setState(() {
                    if (imageCodesContainerRotations[selectedImageCodeIndex] == 0.0) {
                      imageCodesContainerRotations[selectedImageCodeIndex] = -90 * pi / 180;
                    } else if (imageCodesContainerRotations[selectedImageCodeIndex] == -90 * pi / 180) {
                      imageCodesContainerRotations[selectedImageCodeIndex] = pi; // 180 degrees
                    } else if (imageCodesContainerRotations[selectedImageCodeIndex] == pi) {
                      imageCodesContainerRotations[selectedImageCodeIndex] = 90 * pi / 180;
                    } else if (imageCodesContainerRotations[selectedImageCodeIndex] == 90 * pi / 180) {
                      imageCodesContainerRotations[selectedImageCodeIndex] = 0.0;
                    }
                  });
                }),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 210.h,
                  width: screenWidth,
                  color: Colors.white,
                  padding: REdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Threshold ',
                            style: bodySmall,
                          ),
                          SizedBox(width: 10.w),
                          CustomSlider(
                            initialValue: lineWidthValue,
                            minValue: 2.0,
                            maxValue: 30.0,
                            onChanged: (value) {
                              lineWidthValue = value;
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Proportional stretch',
                            style: bodySmall,
                          ),
                          GestureDetector(
                            onTap: warpByWordSwitch,
                            child: Container(
                              width: 50.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _wrapByWord ? Colors.green : Colors.grey,
                              ),
                              child: Row(
                                mainAxisAlignment: _wrapByWord
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.h,
                                    margin:
                                        REdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  // show scan popup dialog
  Future<void> scanBarcode(BuildContext context) async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );
    } catch (e) {
      scanResult = 'Failed to get the barcode or QR code: $e';
    }

    setState(() {
      barcodeScanRes = scanResult;
      showTextResult = false;
      showBarcode = false;
      showQRCode = false;
    });

    if (barcodeScanRes != '-1') {
      bool isButtonClick = true;
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      'Scanning Result',
                      style: bodyMedium,
                    ),
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: REdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Choose insertion type',
                          style: bodySmall,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 150.h,
                      width: 260.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11.r)),
                      ),
                      child: Center(
                          child: ScannerContainerState().buildResultWidget()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showTextResult = true;
                              showBarcode = false;
                              showQRCode = false;
                            });
                          },
                          child: Text(
                            'Text',
                            style: (showTextResult == true ||
                                    isButtonClick == true)
                                ? TextStyle(color: Colors.blue)
                                : bodySmall,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isButtonClick = false;
                              showBarcode = true;
                              showQRCode = false;
                              showTextResult = false;
                            });
                          },
                          child: Text(
                            'Bar Code',
                            style: showBarcode
                                ? TextStyle(color: Colors.blue)
                                : bodySmall,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isButtonClick = false;
                              showQRCode = true;
                              showBarcode = false;
                              showTextResult = false;
                            });
                          },
                          child: Text(
                            'QR Code',
                            style: showQRCode
                                ? TextStyle(color: Colors.blue)
                                : bodySmall,
                          ),
                        ),
                      ],
                    ),
                    ReusableButton(
                      text: 'Confirm',
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          if (showBarcode || showQRCode || showTextResult) {
                            if (showQRCode) {
                              showQrcodeWidget = true;
                              showQrcodeContainerFlag = true;
                              generateQRCode(barcodeScanRes, 2);
                            } else if (showBarcode) {
                              showBarcodeWidget = true;
                              showBarcodeContainerFlag = true;
                              generateBarCode(barcodeScanRes, 2);
                            } else if (showTextResult) {
                              showTextEditingWidget = true;
                              showTextEditingContainerFlag = true;
                              generateTextCode(barcodeScanRes, 2);
                            }
                          } else {
                            showTextResult = true;
                            showTextEditingWidget = true;
                            showTextEditingContainerFlag = true;
                            generateTextCode(barcodeScanRes, 2);
                          }
                        });
                      },
                      width: 170.w,
                      height: 45.h,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ).then((_) {
        setState(() {
          // Update the main Container widget after closing the modal
          resultWidget = ScannerContainerState().buildResultWidget();
        });
      });
    }
  }

  // show DatePicker container
  bool showStyleContainer = false;

  Widget _showDateContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        margin: REdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        margin: REdgeInsets.only(top: 15.h),
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                  });
                }),
                Image.asset('assets/images/line_c.png'),
                _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                    () {
                  setState(() {
                    showDateContainerFlag = false;
                    deleteTextCode(selectedTextCodeIndex);
                  });
                }),
                /*_buildTextIonButton('assets/icons/empty.png', 'Empty', () {}),
                _buildTextIonButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildTextIonButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildTextIonButton('assets/icons/redo.png', 'Redo', () {}),*/
                _buildTextIonButton(
                    'assets/icons/rotated_icon.png', 'Rotate', () {
                  setState(() {
                    if (textContainerRotations[selectedTextCodeIndex] == 0.0) {
                      // Rotate to vertical
                      textContainerRotations[selectedTextCodeIndex] = -90 * pi / 180;
                    } else if (textContainerRotations[selectedTextCodeIndex] == -90 * pi / 180) {
                      // Rotate to horizontal
                      textContainerRotations[selectedTextCodeIndex] = pi; // 180 degrees
                    } else if (textContainerRotations[selectedTextCodeIndex] == pi) {
                      // Rotate back to vertical
                      textContainerRotations[selectedTextCodeIndex] = 90 * pi / 180;
                    } else if (textContainerRotations[selectedTextCodeIndex] == 90 * pi / 180) {
                      // Rotate to horizontal
                      textContainerRotations[selectedTextCodeIndex] = 0.0;
                    }
                  });
                }),
              ],
            ),
            SizedBox(height: 20.h),
            if (showStyleContainer)
              Expanded(
                  child: SingleChildScrollView(
                      child: _textEditingOptions(context, screenWidth)))
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 150.h,
                    width: screenWidth,
                    color: Colors.white,
                    padding:
                        REdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Date & Format:',
                              style: bodySmall,
                            ),
                            SizedBox(width: 10.w),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey),
                                onPressed: () {
                                  showDatePickerDialog(context);
                                },
                                child: const Text('Select Date & Format')),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Text(
                              'Time & Format :',
                              style: bodySmall,
                            ),
                            SizedBox(width: 10.w),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey),
                                onPressed: () {
                                  showTimeDatePickerDialog(
                                      context, selectedTimeCodeIndex);
                                },
                                child: const Text('Select Time & Format')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Container(
              padding: REdgeInsets.symmetric(horizontal: 15),
              height: 50,
              width: screenWidth,
              color: Colors.grey.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          showStyleContainer = false;
                        });
                      },
                      child: Text(
                        'Format',
                        style: showStyleContainer
                            ? bodySmall
                            : bodySmall.copyWith(color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          showStyleContainer = !showStyleContainer;
                        });
                      },
                      child: Text(
                        'Style',
                        style: showStyleContainer
                            ? bodySmall.copyWith(color: Colors.blue)
                            : bodySmall,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  // show Emoji container
  Widget _showEmojiContainer(double screenWidth) {
    return Stack(children: [
      Container(
        padding: REdgeInsets.only(bottom: 30.h),
        alignment: Alignment.topCenter,
        child: Image.asset('assets/icons/rectangle.png'),
      ),
      Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xff5DBCFF).withOpacity(0.13),
          borderRadius: BorderRadius.all(Radius.circular(13.w)),
        ),
        child: Column(
          children: [
            _buildOptionRow(
              [
                _buildIconButton('assets/icons/template.png', 'Template', () {
                  setState(() {
                    showEmojiWidget = true;
                    showTextEditingContainerFlag = false;
                    showBarcodeContainerFlag = false;
                    showQrcodeContainerFlag = false;
                    showTableContainerFlag = false;
                    showImageContainerFlag = false;
                    showDateContainerFlag = false;
                    showEmojiContainerFlag = false;
                  });
                }),
                Image.asset('assets/images/line_c.png'),
                _buildTextIonButton('assets/icons/delete_icon.png', 'Delete',
                    () {
                  setState(() {
                    showEmojiContainerFlag = false;
                    deleteEmojiCode();
                  });
                }),
                /*_buildTextIonButton(
                    'assets/icons/multiple.png', 'Multiple', () {}),
                _buildTextIonButton('assets/icons/undo (2).png', 'Undo', () {}),
                _buildTextIonButton('assets/icons/redo.png', 'Redo', () {}),*/
                _buildTextIonButton(
                    'assets/icons/rotated_icon.png', 'Rotate', () {
                  setState(() {
                    if (emojiCodesContainerRotations[selectedEmojiCodeIndex] == 0.0) {
                      // Rotate to vertical
                      emojiCodesContainerRotations[selectedEmojiCodeIndex] = -90 * pi / 180;
                    } else if (emojiCodesContainerRotations[selectedEmojiCodeIndex] == -90 * pi / 180) {
                      // Rotate to horizontal
                      emojiCodesContainerRotations[selectedEmojiCodeIndex] = pi; // 180 degrees
                    } else if (emojiCodesContainerRotations[selectedEmojiCodeIndex] == pi) {
                      // Rotate back to vertical
                      emojiCodesContainerRotations[selectedEmojiCodeIndex] = 90 * pi / 180;
                    } else if (emojiCodesContainerRotations[selectedEmojiCodeIndex] == 90 * pi / 180) {
                      // Rotate to horizontal
                      emojiCodesContainerRotations[selectedEmojiCodeIndex] = 0.0;
                    }
                  });
                }),
              ],
            ),

            Container(
              padding: REdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListViewItem(
                          email: categories[index],
                          selected: selectedCategory == categories[index],
                          onPressed: () {
                            setState(() {
                              selectedCategory = categories[index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                  if (selectedCategory.isNotEmpty)
                    Container(
                      height: 150.h,
                      width: double.infinity,
                      color: Colors.white,
                      child: FirebaseListView(
                        data2: selectedCategory,
                        emails: emails,
                        imageUrls: imageUrls,
                      ),
                    ),
                  if(selectedCategory.isEmpty)
                    Container(
                      height: 150.h,
                      width: double.infinity,
                      color: Colors.white,
                      child: FirebaseListView(
                        data2: 'Animals',
                        emails: emails,
                        imageUrls: imageUrls,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }


  // Print function
  printContent() async {
    final image = await convertWidgetToImage();
    if (image != null) {
      final imageData = await convertImageToData(image);
      if (imageData != null) {
        setState(() {
          this.imageData = imageData;
        });
        await sendBitmapToJava(image,imageData);
      }
    }
  }

  Future<ui.Image?> convertWidgetToImage() async {
    try {
      double imageZoomeIn = sdkPaperSizeWidth * 8 / getLabelWidth;
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: imageZoomeIn);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? uint8list = byteData?.buffer.asUint8List();
      print(uint8list);
      return image;
    } catch (e) {
      print('Error capturing container convert to bitmap: $e');
      return null;
    }
  }
 /*
  Future<String> convertWidgetToImage1() async {
    try {
      double imageZoomIn = sdkPaperSizeWidth * 8 / getLabelWidth;
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: imageZoomIn);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? uint8list = byteData?.buffer.asUint8List();
      Directory appDir = await getApplicationDocumentsDirectory();

      int minRange = 1;
      int maxRange = 50000;

      // Generate a random number within the range
      int randomNumber = Random().nextInt(maxRange - minRange + 1) + minRange;

      // Convert the random number to a string
      String randomString = randomNumber.toString();

      String fileName = "captured_image" + randomString + ".png";
      String filePath = '${appDir.path}/$fileName';

      print(filePath);

      return filePath; // Return the filePath here

    } catch (e) {
      print('Error capturing container convert to bitmap: $e');
      return ''; // Return an empty string or an appropriate error message
    }
  }
  */

  Future<String> convertWidgetToImage1() async {
    try {
      double imageZoomIn = sdkPaperSizeWidth * 8 / getLabelWidth;
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: imageZoomIn);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? uint8list = byteData?.buffer.asUint8List();

      Directory appDir = await getApplicationDocumentsDirectory();

      int minRange = 1;
      int maxRange = 50000;

      // Generate a random number within the range
      int randomNumber = Random().nextInt(maxRange - minRange + 1) + minRange;

      // Convert the random number to a string
      String randomString = randomNumber.toString();

      String fileName = "captured_image" + randomString + ".png";
      String filePath = '${appDir.path}/$fileName';

      // Write the image data to the file
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(uint8list!);

      // Now you can retrieve the length of the file
      int fileLength = await imageFile.length();

      print('File path: $filePath');
      print('File length: $fileLength bytes');

      return filePath;

    } catch (e) {
      print('Error capturing container convert to bitmap: $e');
      return ''; // Return an empty string or an appropriate error message
    }
  }




  Future<Uint8List?> convertImageToData(ui.Image image) async {
    try {
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error converting image to data: $e');
      return null;
    }
  }


  Future<void> launchAndroidActivity() async {
    try {
      final MethodChannel _channel = MethodChannel('com.example.Grozziie/MainActivity');
      await _channel.invokeMethod('launchActivity');
    } on PlatformException catch (e) {
      print('Error launching Android activity: ${e.message}');
    }
  }

  Future<void> sendBitmapToJava(ui.Image bitmapDataD,Uint8List bitmapData) async {
    try {
      final byteBuffer = bitmapData.buffer;
      final byteList = byteBuffer.asUint8List();
      int height=bitmapDataD.height;
      int width= bitmapDataD.width;
      String printercategory=category;
      //await launchAndroidActivity();

      await platform.invokeMethod('receiveBitmap', {
        'bitmapData': byteList,
        'height': height,
        'width': width,
        'printercategory': printercategory,
      });
      print('Bitmap data sent to Java');
    } catch (e) {
      print('Error sending bitmap data to Java: $e');
    }
  }



// Multiple Text Container function
  void generateTextCode(String textValue, int textCodeFlag) {
    setState(() {
      if (textCodeFlag == 1) {
        textCodes.add('Double Click here');
        selectedTextCodeIndex = textCodes.length - 1;
        textBorderWidget = true;
        textCodeOffsets.add(Offset(0, (textCodes.length * 5).toDouble()));
        updateTextBold.add(false);
        updateTextItalic.add(false);
        updateTextUnderline.add(false);
        updateTextAlignment.add(TextAlign.left);
        updateTextFontSize.add(15.0);
        SelectTime_Text_Scan_Int.add(1);
        textContainerRotations.add(0.0);
        updateTextWidthSize.add(130);
      } else if (textCodeFlag == 2) {
        textCodes.add(textValue);
        selectedTextCodeIndex = textCodes.length - 1;
        textBorderWidget = true;
        textCodeOffsets.add(Offset(0, (textCodes.length * 5).toDouble()));
        updateTextBold.add(false);
        updateTextItalic.add(false);
        updateTextUnderline.add(false);
        updateTextAlignment.add(TextAlign.left);
        updateTextFontSize.add(15.0);
        SelectTime_Text_Scan_Int.add(2);
        textContainerRotations.add(0.0);
        updateTextWidthSize.add(130);
      } else if (textCodeFlag == 3) {
        DateTime currentTime = DateTime.now();
        String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);
        String completeTextValue = formattedDateTime;
        textCodes.add(completeTextValue);
        selectedTextCodeIndex = textCodes.length - 1;
        textBorderWidget = true;
        textCodeOffsets.add(Offset(0, (textCodes.length * 5).toDouble()));
        updateTextBold.add(false);
        updateTextItalic.add(false);
        updateTextUnderline.add(false);
        updateTextAlignment.add(TextAlign.left);
        updateTextFontSize.add(15.0);
        SelectTime_Text_Scan_Int.add(3);
        textContainerRotations.add(0.0);
        updateTextWidthSize.add(200);
      }/* else if (textCodeFlag == 4) {
        textCodes.add('01');
        selectedTextCodeIndex = textCodes.length - 1;
        textBorderWidget = true;
        textCodeOffsets.add(Offset(0, (textCodes.length * 5).toDouble()));
        updateTextBold.add(false);
        updateTextItalic.add(false);
        updateTextUnderline.add(false);
        updateTextAlignment.add(TextAlign.center);
        updateTextFontSize.add(25);
        SelectTime_Text_Scan_Int.add(4);
        textContainerRotations.add(0.0);
        updateTextWidthSize.add(50);
        prefixNumber.add('');
        suffixNumber.add('');
        incrementNumber.add(1);

      }*/
    });
  }

  void deleteTextCode(int textIndex) {
    if (textIndex >= 0 &&
        textIndex < textCodes.length) {
      textCodes.removeAt(textIndex);
      textControllers.remove(textIndex);
      textBorderWidget = false;
      if (textIndex < textCodeOffsets.length) {
        textCodeOffsets.removeAt(textIndex);
      }
      if (textIndex < updateTextBold.length) {
        updateTextBold.removeAt(textIndex);
      }
      if (textIndex < updateTextUnderline.length) {
        updateTextUnderline.removeAt(textIndex);
      }
      if (textIndex < updateTextItalic.length) {
        updateTextItalic.removeAt(textIndex);
      }
      if (textIndex < updateTextFontSize.length) {
        updateTextFontSize.removeAt(textIndex);
      }
      if (textIndex < updateTextAlignment.length) {
        updateTextAlignment.removeAt(textIndex);
      }
      if (textIndex < SelectTime_Text_Scan_Int.length) {
        SelectTime_Text_Scan_Int.removeAt(textIndex + 1);
      }
      if (textIndex < textContainerRotations.length) {
        textContainerRotations.removeAt(textIndex);
      }
      if (textIndex < updateTextWidthSize.length) {
        updateTextWidthSize.removeAt(textIndex);
      }
    }
  }

  // Multiple BarCode Container function
  void generateBarCode(String barcodeValue, int barCodeFlag) {
    setState(() {
      if (barCodeFlag == 1) {
        barCodes.add('1234');
        barCodeOffsets.add(Offset(0, (barCodes.length * 5).toDouble()));
        barCodesContainerRotations.add(0);
        selectedBarCodeIndex = barCodes.length - 1;
        barcodeBorderWidget = true;
        updateBarcodeWidth.add(100);
        updateBarcodeHeight.add(80);
      } else if (barCodeFlag == 2) {
        barCodes.add('$barcodeValue ${barCodes.length + 1}');
        barCodeOffsets.add(Offset(0, (barCodes.length * 5).toDouble()));
        barCodesContainerRotations.add(0);
        selectedBarCodeIndex = barCodes.length - 1;
        barcodeBorderWidget = true;
        updateBarcodeWidth.add(100);
        updateBarcodeHeight.add(80);
      }
    });
  }

  void deleteBarCode(int barcodeIndex) {
    if (barcodeIndex >= 0 && barcodeIndex < barCodes.length) {
      barCodes.removeAt(barcodeIndex);
      barCodeOffsets.removeAt(barcodeIndex);

      if (barcodeIndex < updateBarcodeWidth.length) {
        updateBarcodeWidth.removeAt(barcodeIndex);
      }
      if (barcodeIndex < updateBarcodeHeight.length) {
        updateBarcodeHeight.removeAt(barcodeIndex);
      }
      if (barcodeIndex < barCodesContainerRotations.length) {
        barCodesContainerRotations.removeAt(barcodeIndex);
      }
      barcodeBorderWidget = false;
    }
  }

  // Multiple Qr container Function
  void generateQRCode(String qrCodeValue, int qrFlag) {
    setState(() {
      if (qrFlag == 1) {
        qrCodes.add('5678 ${qrCodes.length + 1}');
        qrCodeOffsets.add(Offset(0, (qrCodes.length * 5).toDouble()));
        qrCodesContainerRotations.add(0);
        updateQrcodeSize.add(100);
        selectedQRCodeIndex = qrCodes.length - 1;
        qrcodeBorderWidget = true;
      } else if (qrFlag == 2) {
        qrCodes.add(qrCodeValue);
        qrCodeOffsets.add(Offset(0, (qrCodes.length * 5).toDouble()));
        qrCodesContainerRotations.add(0);
        updateQrcodeSize.add(100);
        selectedQRCodeIndex = qrCodes.length - 1;
        qrcodeBorderWidget = true;
      }
    });
  }

  void deleteQRCode(int qrCodeIndex) {
    if (qrCodeIndex >= 0 && qrCodeIndex < qrCodes.length) {
      qrCodes.removeAt(qrCodeIndex);
      qrCodeOffsets.removeAt(qrCodeIndex);

      if (qrCodeIndex < updateQrcodeSize.length) {
        updateQrcodeSize.removeAt(qrCodeIndex);
      }
      if (qrCodeIndex < qrCodesContainerRotations.length) {
        qrCodesContainerRotations.removeAt(qrCodeIndex);
      }
      qrcodeBorderWidget = false;
    }
  }



  // Multiple Table container Function
  void generateTableCode() {
    setState(() {
      tableCodes.add('Table ${tableCodes.length + 1}');
      tableOffsets.add(Offset(0, (tableCodes.length * 5).toDouble()));
      updateTableRow.add(1);
      updateTableColumn.add(1);
      updateTableWidth.add(120);
      updateTableHeight.add(80);
      //controllers.add(newControllers);
    });
  }

  void deleteTableCode() {
    if (selectedTableCodeIndex != null) {
      setState(() {
        tableCodes.removeAt(selectedTableCodeIndex);
        tableOffsets.removeAt(selectedTableCodeIndex);
        selectedTableCodeIndex = 0;
      });
    }
    if (selectedTableCodeIndex < updateTableWidth.length) {
      updateTableWidth.removeAt(selectedTableCodeIndex);
    }
    if (selectedTableCodeIndex < updateTableHeight.length) {
      updateTableHeight.removeAt(selectedTableCodeIndex);
    }
    if (selectedTableCodeIndex < updateTableRow.length) {
      updateTableRow.removeAt(selectedTableCodeIndex);
    }
    if (selectedTableCodeIndex < updateTableColumn.length) {
      updateTableColumn.removeAt(selectedTableCodeIndex);
    }
  }


  // For table Function
  void addRow() {
    setState(() {
      updateTableRow[selectedTableCodeIndex]++;
    });
  }

  void removeRow() {
    setState(() {
      if (selectedTableCodeIndex >= 0) {
        if (updateTableRow[selectedTableCodeIndex] > 1) {
          updateTableRow[selectedTableCodeIndex]--;
        }
      }
    });
  }

  void addColumn() {
    setState(() {
      updateTableColumn[selectedTableCodeIndex]++;
    });
  }

  void removeColumn() {
    setState(() {
      if(selectedTableCodeIndex>=0)
      {
        if(updateTableColumn[selectedTableCodeIndex]>1){
          updateTableColumn[selectedTableCodeIndex]--;
        }
      }
    });
  }

  void _handleResizeGesture(DragUpdateDetails details, int tableIndex) {
    if (selectedTableCodeIndex == tableIndex){
      setState(() {
        final newWidth = updateTableWidth[selectedTableCodeIndex] + details.delta.dx;
        final newHeight = updateTableHeight[selectedTableCodeIndex] + details.delta.dy;
        updateTableWidth[selectedTableCodeIndex] = newWidth >= minTableWidth ? newWidth : minTableWidth;
        updateTableHeight[selectedTableCodeIndex] = newHeight >= minTableHeight ? newHeight : minTableHeight;
      });
    }

  }


  // for image Function
  void createMyImage(int detector) {
    setState(() {
      myImage.add('Image code ${myImage.length + 1}');
      myImageOffset.add(Offset(0, (myImage.length * 5).toDouble()));
      XFile demoImage = XFile("demo_image_path.png");
      imageCodes.add("demoImage");
      imageCodesContainerRotations.add(0);

      updateImageSize.add(100);
      selectedImageCodeIndex = myImage.length - 1;
      imageBorderWidget = true;

      if (detector == 0) {
        takePicture(myImage.length);
      } else {
        selectImage(myImage.length);
      }
    });
  }

  void deleteImageCode(int imageIndex) {

    if (imageIndex >= 0 && imageIndex < imageCodes.length) {
      imageCodes.removeAt(imageIndex);
      myImage.removeAt(imageIndex);
      myImageOffset.removeAt(imageIndex);

      if (imageIndex < updateImageSize.length) {
        imageCodesContainerRotations.removeAt(imageIndex);
      }
      if (imageIndex < updateImageSize.length) {
        updateImageSize.removeAt(imageIndex);
      }
      imageBorderWidget = false;
    }
  }

  void updateImageOffset(int index, Offset offset) {
    setState(() {
      imageCodeOffsets[index] = offset;
    });
  }

  late ImagePicker imagePicker;

  Future<void> selectImage(int myIndex) async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      cropImage(File(pickedFile.path), myIndex);
    }
  }

  //Crop Image
  Future<void> cropImage(File imageFile, int myIndex) async {
    final imageCropper = ImageCropper(); // Create an instance of ImageCropper
    final croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        // Allow user to set custom aspect ratio
        showCropGrid: true, // Show grid in the crop overlay
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = XFile(croppedFile.path);
        print("Cropfile");
        int mmm = myIndex - 1;
        imageCodes[mmm] = croppedFile.path;
        print(croppedFile.path);
        print(imageCodes);
      });
    }
  }

  void updateMyImageOffset(int index, Offset offset) {
    setState(() {
      myImageOffset[index] = offset;
    });
  }

  Future<void> takePicture(int myIndex) async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      cropImage(File(pickedFile.path), myIndex);
    }
  }

  // for Scan
  void updateScanCodeOffset(int index, Offset newPosition) {
    setState(() {
      scanCodeOffsets[index] = newPosition;
    });
  }

  // multiple Emoji Section
  void generateEmojiCode() {
    setState(() {
      if (emojiCodes.length == 0) {
        emojiCodes.add('5678 ${emojiCodes.length + 1}');
        emojiCodeOffsets.add(Offset(0, (emojiCodes.length * 5).toDouble()));
        emojiCodes[0] = current_list22[0];
        flag2 = 2;
        emojiCodesContainerRotations.add(0);
        emojiCodesContainerRotations.add(0);
        updateEmojiWidth.add(50);
        selectedEmojiCodeIndex = emojiCodes.length - 1;
        emojiIconBorderWidget = true;
      } else {
        emojiCodes.add('5678 ${emojiCodes.length + 1}');
        int position = emojiCodes.length - 1;
        print("NOT$position$onethree");
        emojiCodeOffsets.add(Offset(0, (emojiCodes.length * 5).toDouble()));

        emojiCodes[position] = current_list22[0];
        emojiCodesContainerRotations.add(0);
        flg = 2;
        myui = 1;
        emojiCodesContainerRotations.add(0);
        updateEmojiWidth.add(50);
        selectedEmojiCodeIndex = emojiCodes.length - 1;
        emojiIconBorderWidget = true;
        if (flg == 2) {
        } else {
          emojiCodes.add('5678 ${emojiCodes.length + 1}');
          int position = emojiCodes.length - 1;
          print("NOT$position$onethree");
          emojiCodeOffsets.add(Offset(0, (emojiCodes.length * 5).toDouble()));
          emojiCodes[position] = current_list22[0];
          emojiCodesContainerRotations.add(0);
          print(emojiCodes);
          flg = 2;
          myui = 1;
          emojiCodesContainerRotations.add(0);
          updateEmojiWidth.add(50);
          selectedEmojiCodeIndex = emojiCodes.length - 1;
          emojiIconBorderWidget = true;
        }
      }
    });
  }

  void updateEmojiOffsets(int index, Offset offset) {
    setState(() {
      emojiCodeOffsets[index] = offset;
    });
  }

  void deleteEmojiCode() {
    if (selectedEmojiCodeIndex != null) {
      setState(() {
        emojiCodes.removeAt(selectedEmojiCodeIndex);
        emojiCodeOffsets.removeAt(selectedEmojiCodeIndex);
        selectedEmojiCodeIndex = 0;
      });
      if (selectedEmojiCodeIndex < emojiCodesContainerRotations.length) {
        emojiCodesContainerRotations.removeAt(selectedEmojiCodeIndex);
      }
    }
  }

  // Time function
  DateFormat? selectedFormatDate;

  void showTimeDatePickerDialog(BuildContext context, int selectIndex) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 300,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: REdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, size: 20),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                timeFormat = false;
                              });
                            },
                            child: Text('Time',
                                style: !timeFormat
                                    ? const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)
                                    : bodySmall)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              timeFormat = !timeFormat;
                            });
                          },
                          child: Text('Format',
                              style: timeFormat
                                  ? const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)
                                  : bodySmall),
                        ),
                        IconButton(
                            onPressed: () {
                              textCodes[selectedTextCodeIndex] =
                                  getFormattedDateTime();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.done, size: 20)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: timeFormat
                        ? timeFormatSelectionDialog()
                        : timePickerDialog(selectIndex),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget timePickerDialog(int selectIndex) {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectTime.hour,
        selectTime.minute,
      ),
      onDateTimeChanged: (DateTime newDateTime) {
        // Update the selected time but do not call setState here.
        selectTime = TimeOfDay.fromDateTime(newDateTime);
      },
    );
  }

  Widget timeFormatSelectionDialog() {
    return SizedBox(
      height: 200.0,
      child: CupertinoPicker(
        itemExtent: 50,
        onSelectedItemChanged: (int index) {
          // Update the selected format but do not call setState here.
          switch (index) {
            case 0:
              selectFormat = TimeOfDayFormatD.h_colon_mm_space_a;
              break;
            case 1:
              selectFormat = TimeOfDayFormatD.h_colon_mm_colon_ss_space_a;
              break;
            case 2:
              selectFormat = TimeOfDayFormatD.H_colon_mm;
              break;
            case 3:
              selectFormat = TimeOfDayFormatD.H_colon_mm_colon_ss;
              break;
            case 4:
              selectFormat = TimeOfDayFormatD.None;
              break;
          }
        },
        children: const [
          Text('h:mm a'),
          Text('h:mm:ss a'),
          Text('HH:mm'),
          Text('HH:mm:ss'),
          Text('No'),
        ],
      ),
    );
  }

  void showDatePickerDialog(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 300,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: REdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, size: 20),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                dateFormat = false;
                              });
                            },
                            child: Text('Date',
                                style: !dateFormat
                                    ? const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)
                                    : bodySmall)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              dateFormat = !dateFormat;
                            });
                          },
                          child: Text('Format',
                              style: dateFormat
                                  ? const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)
                                  : bodySmall),
                        ),
                        IconButton(
                            onPressed: () {
                              textCodes[selectedTextCodeIndex] =
                                  getFormattedDateTime();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.done, size: 20)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: dateFormat
                        ? dateFormatSelectionWidget()
                        : showDatePickerWidget(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget showDatePickerWidget() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: selectDate ?? DateTime.now(),
      minimumYear: 1900,
      maximumYear: 2100,
      onDateTimeChanged: (DateTime newDateTime) {
        selectDate = newDateTime;
      },
    );
  }

  Widget dateFormatSelectionWidget() {
    return SizedBox(
      height: 200.0,
      child: CupertinoPicker(
        itemExtent: 50.0,
        onSelectedItemChanged: (int index) {
          switch (index) {
            case 0:
              selectedFormatDate = DateFormat('MMMM d, yyyy');
              break;
            case 1:
              selectedFormatDate = DateFormat('yyyy-MM-dd');
              break;
            case 2:
              selectedFormatDate = DateFormat('dd/MM/yyyy');
              break;
            case 3:
              selectedFormatDate = null;
              break;
          }
        },
        children: const [
          Text('yyyy-MM-dd'),
          Text('dd/MM/yyyy'),
          Text('MMMM d, yyyy'),
          Text('No'),
        ],
      ),
    );
  }


  String getFormattedDate() {
    if (selectDate == null || selectedFormatDate == null) {
      return '';
    }
    return selectedFormatDate!.format(selectDate!);
  }

  String getFormattedTime() {
    if (selectFormat == TimeOfDayFormatD.None) {
      return '';
    }

    final dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      selectTime.hour,
      selectTime.minute,
    );

    switch (selectFormat) {
      case TimeOfDayFormatD.h_colon_mm_space_a:
        return DateFormat('h:mm a').format(dateTime);
      case TimeOfDayFormatD.h_colon_mm_colon_ss_space_a:
        return DateFormat('h:mm:ss a').format(dateTime);
      case TimeOfDayFormatD.H_colon_mm:
        return DateFormat('HH:mm').format(dateTime);
      case TimeOfDayFormatD.H_colon_mm_colon_ss:
        return DateFormat('HH:mm:ss').format(dateTime);
      default:
        return 'Invalid TimeOfDayFormat'; // Return a default message for invalid format
    }
  }

  String getFormattedDateTime() {
    String formattedDate = getFormattedDate();
    String formattedTime = getFormattedTime();

    if (formattedTime.isNotEmpty) {
      formattedDate += ' $formattedTime';
    }


    return formattedDate;
  }
//addDatatosqllite("text",myuid11,textCodes[i],textCodeOffsets[i].dx,textCodeOffsets[i].dy,sizeee,sizeee,textCodes.length,i,myuid11,
//                                   is_bold,is_underline,is_italic,is_fontsize,is_rotee);
  void addDatatosqllite(String tablename, String uuid, String contextdataa,
      double positionx, double postiony, int height, int weight,
      int index, int length, String myuid112,bool is_bold, bool is_underline, bool is_italic,double is_fontsize, double is_rotee ) async{
    final dbHelper = DatabaseHelper_Element(tablename,tablename);
    await dbHelper.initDatabase();
    print("init");
    String strNumber = uuid;
    int number11 = int.parse(strNumber);
    String rotee= is_rotee.toString();
    String is_myUnderline = is_italic.toString();
    final data = MyDataModel(

      contentData: contextdataa,
      positionX: positionx,
      positionY: postiony,
      widgetWidth: weight.toDouble(),
      widgetHeight: height.toDouble(),
      index: index,
      length: length,
      barcodeType: uuid,
      textSize: is_fontsize,
      bold: is_bold,
      underline: is_underline,
      fromWhere: is_myUnderline,
      type: alignment_Flag,
      address: rotee,

    );
    flage_init=0;
    await dbHelper.insertData(data);
  }
}
//2
void addDatatosqllite2(String tablename, String uuid, String contextdataa,
    double positionx, double postiony, int height, int weight,
    int index, int length, String myuid112, double barcodeee) async{
  final dbHelper = DatabaseHelper_Element2(tablename,tablename);
  await dbHelper.initDatabase();
  print("init");
  String strNumber = uuid;
  String rotee= barcodeee.toString();
  int number11 = int.parse(strNumber);
  final data = MyDataModel(

    contentData: contextdataa,
    positionX: positionx,
    positionY: postiony,
    widgetWidth: weight.toDouble(),
    widgetHeight: height.toDouble(),
    index: index,
    length: length,
    barcodeType: uuid,
    textSize: 20,
    bold: true,
    underline: true,
    fromWhere: '20',
    type: '20',
    address: rotee,

  );
  flage_init=0;
  await dbHelper.insertData(data);

}
//element 3
void addDatatosqllite3(String tablename, String uuid, String contextdataa,
    double positionx, double postiony, int height, int weight,
    int index, int length, String myuid112, double barcodeee) async{
  final dbHelper = DatabaseHelper_Element3(tablename,tablename);
  await dbHelper.initDatabase();
  print("init");
  String strNumber = uuid;
  int number11 = int.parse(strNumber);
  String rotee= barcodeee.toString();
  final data = MyDataModel(

    contentData: contextdataa,
    positionX: positionx,
    positionY: postiony,
    widgetWidth: weight.toDouble(),
    widgetHeight: height.toDouble(),
    index: index,
    length: length,
    barcodeType: uuid,
    textSize: 20,
    bold: true,
    underline: true,
    fromWhere: '20',
    type: '20',
    address: rotee,

  );
  flage_init=0;
  await dbHelper.insertData(data);

}
//element 4
void addDatatosqllite4(String tablename, String uuid, String contextdataa,
    double positionx, double postiony, int height, int weight,
    int index, int length, String myuid112,double barcodeee) async{
  final dbHelper = DatabaseHelper_Element4(tablename,tablename);
  await dbHelper.initDatabase();
  print("init");
  String strNumber = uuid;
  int number11 = int.parse(strNumber);
  String rotee= barcodeee.toString();
  final data = MyDataModel(

    contentData: contextdataa,
    positionX: positionx,
    positionY: postiony,
    widgetWidth: weight.toDouble(),
    widgetHeight: height.toDouble(),
    index: index,
    length: length,
    barcodeType: uuid,
    textSize: 20,
    bold: true,
    underline: true,
    fromWhere: '20',
    type: '20',
    address: rotee,

  );
  flage_init=0;
  await dbHelper.insertData(data);

}
//element 4
void addDatatosqllite5(String tablename, String uuid, String contextdataa,
    double positionx, double postiony, int height, int weight,
    int index, int length, String myuid112,double barcodeee) async{
  final dbHelper = DatabaseHelper_Element5(tablename,tablename);
  await dbHelper.initDatabase();
  print("init");
  String strNumber = uuid;
  int number11 = int.parse(strNumber);
  String rotee= barcodeee.toString();
  final data = MyDataModel(

    contentData: contextdataa,
    positionX: positionx,
    positionY: postiony,
    widgetWidth: weight.toDouble(),
    widgetHeight: height.toDouble(),
    index: index,
    length: length,
    barcodeType: uuid,
    textSize: 20,
    bold: true,
    underline: true,
    fromWhere: '20',
    type: '20',
    address: rotee,

  );
  flage_init=0;
  await dbHelper.insertData(data);

}
//table
void addDatatosqllite6(String tablename, String uuid, String contextdataa,
    double positionx, double postiony, int height, int weight,
    int index, int length, String myuid112,double barcodeee) async{
  final dbHelper = DatabaseHelper_Element6(tablename,tablename);
  await dbHelper.initDatabase();
  print("init");
  String strNumber = uuid;
  int number11 = int.parse(strNumber);
  String rotee= barcodeee.toString();
  final data = MyDataModel(

    contentData: contextdataa,
    positionX: positionx,
    positionY: postiony,
    widgetWidth: weight.toDouble(),
    widgetHeight: height.toDouble(),
    index: index,
    length: length,
    barcodeType: uuid,
    textSize: 20,
    bold: true,
    underline: true,
    fromWhere: '20',
    type: '20',
    address: rotee,

  );
  flage_init=0;
  await dbHelper.insertData(data);

}
//add online
/*
 addDatatosqllite3("barcode",myuid11,barCodes[i],barCodeOffsets[i].dx,barCodeOffsets[i].dy,ssss11,ssss,barCodes.length,i,myuid11,barcodeee,
                    "ElementList", inputBarcodeText,formattedDate1,"30*40",""+myuid11,image);
 */
void add_elemtToOnline(String tablename, String uuid, String contextdataa,
double positionx, double postiony, int height, int weight,
int index, int length, String myuid112,double barcodeee,bool is_bold, bool is_underline, bool is_italic,double is_fontsize,
    String viewDataList, String viewName,
    String view_date,String view_size,
    String view_uuid, String view_image) async
{
  String offsetX = positionx.toString();
  String offsetY = postiony.toString();
  String widget_width = weight.toString();
  String widget_height = height.toString();

  String widget_index = index.toString();
  String widget_length = length.toString();
  String how_muchrote = barcodeee.toString();
  String widget_bold = is_bold.toString();
  String widget_underline = is_underline.toString();
  String widget_italic= is_italic.toString();
  String widget_fontsize= is_fontsize.toString();

  String widget_viewDataList= viewDataList.toString();
  String widget_viewName= viewName.toString();
  String widget_view_date= view_date.toString();
  String widget_view_size= view_size.toString();
  String widget_view_uuid= view_uuid.toString();
  String widget_view_image= view_image.toString();




 await addLabelData22442(tablename,uuid,contextdataa,offsetX,offsetY,widget_width,widget_height,
      widget_index, widget_length,myuid112,how_muchrote,widget_bold,widget_underline,widget_italic,widget_fontsize,
      widget_viewDataList,widget_viewName,widget_view_date,widget_view_size,widget_view_uuid,widget_view_image);


print(tablename);

 //addLabelData33(tablename,contextdataa,offsetX,offsetY,widget_width,widget_height,uuid,widget_fontsize,widget_bold,widget_underline,widget_italic,"text",how_muchrote,
//uuid,uuid,"23333","name","40*30","fhjkfhgj");

}
Future<void> addLabelData22442(String tablename, String uuid, String contextdataa,
    String  positionx, String postiony, String height, String weight,
    String index, String length, String myuid112,String barcodeee,String is_bold, String is_underline, String is_italic,String is_fontsize,
    String viewDataList, String viewName,
    String view_date,String view_size,
    String view_uuid, String view_image) async {
  final url = 'https://grozziie.zjweiting.com:8033/tht/allLabelData/add';
  final headers = {'Content-Type': 'application/json'};

  final data = {
    "subCategoryName": viewName.toString(),
    "labelDataList": {
      "contentData": contextdataa.toString(),
      "positionX":positionx.toString(),
      "positionY": postiony.toString(),
      "widgetWidh": weight.toString(),
      "widgetHeight": height.toString(),
      "index": "32",
      "length": "342",
      "barcodeType": uuid.toString(),
      "textSize": is_fontsize.toString(),
      "bold": is_bold.toString(),
      "underline": is_underline.toString(),
      "fromWhere": is_italic.toString(),
      "type": is_italic.toString(),
      "address": barcodeee.toString()
    },
    "LabelDataView": {
      "id": viewName.toString(),
      "myid": view_uuid.toString(),
      "date": view_date.toString(),
      "size": view_size.toString(),
      "name": viewName.toString(),
      "imagebitmap": view_image.toString()
    }
  };
print(json.encode(data));
  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));

  if (response.statusCode == 200) {
    print("LabelData added successfully");
  } else {
    print("Failed to add LabelData. Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
  }
}

void addelemento(String databasename, String element, String date1, String  size1, String uuid1,String image_data) async {
  //addelemento("ElementList", "text",'text',textCodes.length,""+myuid11);
  final dbHelper3 = DatabaseHelper_DataList(databasename);
  dbHelper3.initDatabase();
  await dbHelper3.initDatabase();
  print("INi2");
  final String uuid = uuid1;
  final date = date1;
  final size = size1;
  final name = element;
  final imageBitmap = image_data;
  String strNumber = uuid1;
  int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;

  // Convert milliseconds to seconds
  int currentTimeInSeconds = currentTimeInMillis ~/ 1000;
  int number = int.parse(strNumber);
  final data = Model22(
    id: number,
    myid: currentTimeInSeconds.toString(),
    date: date,
    size: size,
    name: name,
    imagebitmap: imageBitmap,

  );
  flage_init=0;
  await dbHelper3.insertData(data);
}

//Multiple Image  function variable
XFile? _imageFile;
List<String> imageCodes = [];
List<Offset> imageCodeOffsets = [];
List<String> myImage = [];
List<Offset> myImageOffset = [];
List<double> imageCodesContainerRotations =[] ;
List<double> updateImageSize = [];
int selectedImageCodeIndex = 0;

// multiple Table function variable
double minTableWidth = 80.0;
double minTableHeight = 50.0;

double tableContainerX = 0;
double tableContainerY = 0;
List<double> updateTableWidth = [];
List<double> updateTableHeight = [];
List<String> tableCodes = [];
List<Offset> tableOffsets = [Offset.zero, const Offset(0, 100)];
List<int> updateTableRow=[];
List<int> updateTableColumn=[];
/*List<TextEditingController> newControllers = List.generate(
  controllers[selectedTableCodeIndex].length,
      (index) => TextEditingController(),
);*/


//store  function

Future<Uint8List?> convertImageToData1(ui.Image image,String timeeuuid) async {
  try {
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    print( byteData?.buffer.asUint8List());
    await uploadBitmapToFirebaseStorage(byteData!.buffer.asUint8List(),timeeuuid);
    return byteData?.buffer.asUint8List();
  } catch (e) {
    print('Error converting image to data: $e');
    return null;
  }
}
String formattedDate= '';



//
Future<void> uploadBitmapToFirebaseStorage(Uint8List bytes,String timeeuuid) async {
  try {
    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child('images').child('image.png');

    await storageReference.putData(bytes);
    FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;

    String imageUrl = await storageReference.getDownloadURL();
    firebaseFirestore.collection("Allhis").doc(""+timeeuuid).update({
      "imagebitmap":""+imageUrl


    });

   if(ddd == 0)
     {
       ddd = 1;
       Fluttertoast.showToast(
         msg: "Data saved successfully!",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         backgroundColor: primaryBlue,
         textColor: Colors.white,
       );

     }
    print('Image URL: $imageUrl');
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
  }
}
String formattedDate1= '';
//get uuid
