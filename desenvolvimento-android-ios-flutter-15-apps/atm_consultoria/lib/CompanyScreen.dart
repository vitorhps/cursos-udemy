import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Empresa"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset("images/detalhe_empresa.png"),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Sobre a empresa",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepOrange,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur aliquet interdum luctus. Nam ac metus sed eros ultricies efficitur ac id justo. Suspendisse congue lacinia nulla id imperdiet. Integer quis leo quis lectus ornare iaculis. Pellentesque aliquet, nibh lobortis commodo facilisis, arcu dui bibendum nisl, nec placerat dui risus eget velit. Sed consequat dui vitae imperdiet aliquam. Curabitur a eleifend turpis. Suspendisse maximus metus mi, ut rutrum nunc dapibus ac."
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur aliquet interdum luctus. Nam ac metus sed eros ultricies efficitur ac id justo. Suspendisse congue lacinia nulla id imperdiet. Integer quis leo quis lectus ornare iaculis. Pellentesque aliquet, nibh lobortis commodo facilisis, arcu dui bibendum nisl, nec placerat dui risus eget velit. Sed consequat dui vitae imperdiet aliquam. Curabitur a eleifend turpis. Suspendisse maximus metus mi, ut rutrum nunc dapibus ac."
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur aliquet interdum luctus. Nam ac metus sed eros ultricies efficitur ac id justo. Suspendisse congue lacinia nulla id imperdiet. Integer quis leo quis lectus ornare iaculis. Pellentesque aliquet, nibh lobortis commodo facilisis, arcu dui bibendum nisl, nec placerat dui risus eget velit. Sed consequat dui vitae imperdiet aliquam. Curabitur a eleifend turpis. Suspendisse maximus metus mi, ut rutrum nunc dapibus ac.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
