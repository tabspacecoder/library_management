import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfViewer extends StatefulWidget {
  String link;
  String name;
   PdfViewer( {required this.name,required this.link});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: Container(
          child: SfPdfViewer.network(widget.link,canShowScrollHead: true,canShowScrollStatus: true,pageLayoutMode: PdfPageLayoutMode.single,scrollDirection: PdfScrollDirection.vertical)),
    );
  }
}
