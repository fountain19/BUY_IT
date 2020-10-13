
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/models/product.dart';

import 'package:store_app/services/store.dart';
import 'package:store_app/widgets/text_field.dart';


import '../../constans.dart';


class EditProduct extends StatefulWidget {
  static String id='EditProduct';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  List<File> imageList;
  List<String> imagesUrl = List();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _store=Store();

  @override
  Widget build(BuildContext context) {
    Product products=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(

        backgroundColor: KmainColor,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton.icon(
              onPressed: () {
                pickImage();
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                'Add Image',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: KmainColor,
//      resizeToAvoidBottomPadding: false,

      body:ListView(
        children: <Widget>[
//              SizedBox(
//                  height: MediaQuery
//                      .of(context)
//                      .size
//                      .height * .2
//              ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MultiImagePickerList(
                  imageList: imageList,
                  removeNewImage: (index) {
                    return
                      removeImage(index);
                  }),
              SizedBox(
                height: 10.0,
              ),
              productTextField(
                  textTitle: 'Product Name',
                  textHint: 'Enter Product Name',
                  controller: productNameController),

              SizedBox(
                height: 10.0,
              ),
              productTextField(
                  textTitle: 'Product Price',textType: TextInputType.number,
                  textHint: 'Enter Product Price',
                  controller: productPriceController),
              SizedBox(
                height: 10.0,
              ),

              productTextField(
                  textTitle: 'Product Description',
                  textHint: 'Enter Product Description',
                  controller: productDescriptionController),
              SizedBox(
                height: 10.0,
              ),
              productTextField(
                  textTitle: 'Product Category',
                  textHint: 'Enter Product Category',
                  controller: productCategoryController),
              SizedBox(
                height: 10.0,
              ),
                RaisedButton(onPressed: ()async{
                  // if(_globalKey.currentState.validate()){
                  //   _globalKey.currentState.save();
                  if(imageList==null||imageList.isEmpty){
                    showSnackBar('Product Image can\t be empty', scaffoldKey);
                    return;
                  }
                  if(productNameController.text==''){
                    showSnackBar('Product Title can\'t be empty', scaffoldKey);
                    return;
                  }
                  if(productPriceController.text==''){
                    showSnackBar('product Price can\'t be empty', scaffoldKey);
                    return;
                  }
                  if(productDescriptionController.text==''){
                    showSnackBar('product Description can\'t be empty', scaffoldKey);
                    return;
                  }
                  if(productCategoryController.text=='Select a Category'){
                    showSnackBar('Please Select a category ', scaffoldKey);
                    return;
                  }
                  // displayProgressDialog(context);
                  // Map<String,dynamic> newProduct={
                  //   KProductName:productNameController.text,
                  //   KProductPrice: productPriceController.text,
                  //   KProductDescription:productDescriptionController.text,
                  //   KProductCategory:productCategoryController.text,
                  // };
                  //
                  // String productID= await _store.addNewProduct(newProduct:newProduct );
                  // //now time to upload images to firebase storage
                  // List<String>imageURL=await _store.uploadProductImages(docID: productID,imageList: imageList);
                  //
                  // bool result=await _store.updateProductImages(docID: productID,data: imageURL);
                  // if (result!=null||result==true) {
                  //   closeProgressDialog(context);
                  //   resetEverything();
                  //   showSnackBar(
                  //       'Product has been modified successfully', scaffoldKey);

                    _store.editProduct({
                      // KProductLocation:_imageLocation,
                      KProductImage:  imagesUrl,
                      KProductCategory: productCategoryController.text,
                      KProductDescription: productDescriptionController.text,
                      KProductName: productNameController.text,
                      KProductPrice: productPriceController.text
                    },
                        products.pId);
                    // }
                  // }
                  },
                  child: Text('Add Product'),),

              ],
            ),
          ],
        ),

      );
  }
  void pickImage() async {

    var file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
    List<File> imageFile = List();
    imageFile.add(file);
    if (imageList == null) {
    imageList = List.from(imageFile, growable: true);
    } else {
    for (int s = 0; s < imageFile.length; s++) {
    imageList.add(file);
    }
    }
    setState(() {

    });
    }
    }
  Widget MultiImagePickerList(
      {List<File> imageList, VoidCallback removeNewImage(int position)}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: imageList == null || imageList.length == 0
          ? Container()
          : SizedBox(
        height: 150.0,
        child: ListView.builder(
            itemCount: imageList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 3, right: 3),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(100),
                        borderRadius:
                        BorderRadius.all(Radius.circular(15.0)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(imageList[index])),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: Colors.red[600],
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ), onPressed: () {
                          removeNewImage(index);
                        },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  removeImage(int index) async {
    imageList.removeAt(index);
    setState(() {});
  }
    showSnackBar(String message, final scaffoldKey) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ));
    }
    displayProgressDialog(BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return Material(
          color: Colors.black.withAlpha(200),
          child: Center(child: Container(
            padding: EdgeInsets.all(30),
            child: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 15,),
                  Text('Please Wait',style: TextStyle(color: Colors.white),),
                ],
              )),
            ),
          )),
        );
      }));
    }
    closeProgressDialog(BuildContext context) {
      Navigator.pop(context);
    }
    void resetEverything() {
      imageList.clear();
      productNameController.text ='';
      productPriceController.text='';
      productDescriptionController.text='';
      productCategoryController.text='';
      setState(() {
      });
    }
}
