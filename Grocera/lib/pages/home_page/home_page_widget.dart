import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({
    Key? key,
    this.para,
  }) : super(key: key);

  final String? para;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    _model.searchTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Home Page',
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                      child: Container(
                        width: 379,
                        height: 61,
                        decoration: BoxDecoration(
                          color: Color(0xFF353535),
                          borderRadius: BorderRadius.circular(15),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            width: 0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                              child: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF676E77),
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                                child: Autocomplete<String>(
                                  initialValue: TextEditingValue(),
                                  optionsBuilder: (textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return ['Option 1'].where((option) {
                                      final lowercaseOption =
                                      option.toLowerCase();
                                      return lowercaseOption.contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return AutocompleteOptionsList(
                                      textFieldKey: _model.searchTextKey,
                                      textController:
                                      _model.searchTextController!,
                                      options: options.toList(),
                                      onSelected: onSelected,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textHighlightStyle: TextStyle(),
                                      elevation: 4,
                                      optionBackgroundColor:
                                      FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      optionHighlightColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      maxHeight: 200,
                                    );
                                  },
                                  onSelected: (String selection) {
                                    setState(() => _model
                                        .searchTextSelectedOption = selection);
                                    FocusScope.of(context).unfocus();
                                  },
                                  fieldViewBuilder: (
                                      context,
                                      textEditingController,
                                      focusNode,
                                      onEditingComplete,
                                      ) {
                                    _model.searchTextFocusNode = focusNode;

                                    _model.searchTextController =
                                        textEditingController;
                                    return TextFormField(
                                      key: _model.searchTextKey,
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      onFieldSubmitted: (_) async {
                                        context.pushNamed(
                                          'searchResult',
                                          queryParameters: {
                                            'para': serializeParam(
                                              _model.searchTextController.text,
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Color(0xFFDDDDDD),
                                        ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                      validator: _model
                                          .searchTextControllerValidator
                                          .asValidator(context),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                  child: Text(
                    'Groceries',
                    style: FlutterFlowTheme.of(context).labelMedium,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: FutureBuilder<List<GroceriesRow>>(
                    future: GroceriesTable().queryRows(
                      queryFn: (q) => q,
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<GroceriesRow> listViewGroceriesRowList =
                      snapshot.data!;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewGroceriesRowList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewGroceriesRow =
                          listViewGroceriesRowList[listViewIndex];
                          return Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                            child: Container(
                              width: 283,
                              height: 283,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x520E151B),
                                    offset: Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 12, 12, 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 290,
                                      height: 200,
                                      decoration: BoxDecoration(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          listViewGroceriesRow.groceryImage!,
                                          width: 300,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          alignment: Alignment(0.00, 0.00),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 290,
                                      height: 52,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0, 12, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  listViewGroceriesRow.name,
                                                  style: FlutterFlowTheme.of(
                                                      context)
                                                      .bodyLarge,
                                                ),
                                                Text(
                                                  listViewGroceriesRow.address,
                                                  style: FlutterFlowTheme.of(
                                                      context)
                                                      .headlineSmall
                                                      .override(
                                                    fontFamily: 'Outfit',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(
                                                -1.00, 1.00),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 15, 0, 0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  listViewGroceriesRow.category,
                                                  'grocery',
                                                ),
                                                style:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
