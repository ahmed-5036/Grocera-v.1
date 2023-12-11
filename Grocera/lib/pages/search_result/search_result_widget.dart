import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'search_result_model.dart';
export 'search_result_model.dart';

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget({
    Key? key,
    this.para,
  }) : super(key: key);

  final String? para;

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  late SearchResultModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchResultModel());
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
          leading: FlutterFlowIconButton(
            borderColor: Color(0x004B39EF),
            borderRadius: 17,
            borderWidth: 0,
            buttonSize: 15,
            fillColor: Color(0x004B39EF),
            icon: Icon(
              Icons.arrow_back_sharp,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 25,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Search Result',
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                        child: Text(
                          'Results:',
                          style: FlutterFlowTheme.of(context).labelMedium,
                        ),
                      ),
                      FutureBuilder<ApiCallResponse>(
                        future: SearchGroceryCall.call(
                          search: widget.para,
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
                          final stackSearchGroceryResponse = snapshot.data!;
                          return Container(
                            width: 380,
                            height: 900,
                            child: Stack(
                              children: [
                                Wrap(
                                  spacing: 0,
                                  runSpacing: 0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Builder(
                                        builder: (context) {
                                          final itemm =
                                          stackSearchGroceryResponse
                                              .jsonBody
                                              .toList();
                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: itemm.length,
                                            itemBuilder: (context, itemmIndex) {
                                              final itemmItem =
                                              itemm[itemmIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(16, 0, 16, 8),
                                                child: Container(
                                                  width: 283,
                                                  height: 283,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF980C0C),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4,
                                                        color:
                                                        Color(0x520E151B),
                                                        offset: Offset(0, 2),
                                                      )
                                                    ],
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        12, 12, 12, 12),
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(
                                                          width: 290,
                                                          height: 200,
                                                          decoration:
                                                          BoxDecoration(),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                12),
                                                            child:
                                                            Image.network(
                                                              getJsonField(
                                                                itemmItem,
                                                                r'''$.grocery_image''',
                                                              ),
                                                              width: double
                                                                  .infinity,
                                                              height: 200,
                                                              fit: BoxFit.cover,
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
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0,
                                                                    12,
                                                                    0,
                                                                    0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      getJsonField(
                                                                        itemmItem,
                                                                        r'''$.name''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                          context)
                                                                          .bodyLarge,
                                                                    ),
                                                                    Text(
                                                                      getJsonField(
                                                                        itemmItem,
                                                                        r'''$.address''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                          context)
                                                                          .headlineSmall
                                                                          .override(
                                                                        fontFamily:
                                                                        'Outfit',
                                                                        fontSize:
                                                                        18,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                AlignmentDirectional(
                                                                    -1.00,
                                                                    1.00),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                                  child: Text(
                                                                    getJsonField(
                                                                      itemmItem,
                                                                      r'''$.category''',
                                                                    ).toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                        context)
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
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
