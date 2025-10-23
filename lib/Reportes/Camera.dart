import 'dart:async';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// List<CameraDescription> _allcameras = <CameraDescription>[];

/// Camera example home widget.
class CameraHome extends StatefulWidget {
  final List<CameraDescription> allcameras;
  String proyecto;
  /// Default Constructor
  CameraHome({
    required this.allcameras,
    required this.proyecto,
  });

  @override
  State<CameraHome> createState() {
    return _CameraHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _CameraHomeState extends State<CameraHome>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  late List<CameraDescription> _allcameras;
  late String proyecto;
  double? _screenWidth;
  double? _screenHeight;
  int _selectedIndex = 0;
  late Future<void> _initializeControllerFuture;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    super.initState();
    _allcameras = widget.allcameras;
    proyecto = widget.proyecto;
    WidgetsBinding.instance.addObserver(this);
    _initializeControllerFuture = _initializeCameraController(_allcameras[0]);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    videoController?.dispose();
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    _focusModeControlRowAnimationController.dispose();
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // App is backgrounded → release camera
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // App returned → re-initialize camera
      _initializeCameraController(cameraController.description);
    }
  }
  // #enddocregion AppLifecycle

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Scaffold(
              backgroundColor: Colors.grey[900],
              extendBody: false,
              extendBodyBehindAppBar: false,
              appBar: AppBar(
                toolbarHeight: 40,
                title: Text('',
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.red[900],
                // backgroundColor: Colors.red[900]?.withOpacity(0.5),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.grey[400],
                  onPressed: () {
                    controller?.dispose();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Container(
                constraints: BoxConstraints.expand(height: 700),
                alignment: Alignment.center,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (controller != null) {
                      return _cameraPreviewWidget();
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              floatingActionButton: _flashModeControlRowWidget(),
              bottomNavigationBar: BottomAppBar(
                height: 70,
                color: Colors.red[900],
                // color: Colors.red[900]?.withOpacity(0.5),
                child: _cameraBottomWidget(),
              ),
            );
          }
          else {
            return Scaffold(
              backgroundColor: Colors.grey[900],
              extendBody: false,
              extendBodyBehindAppBar: false,
              body: Row(
                children: [
                  NavigationRail(
                    useIndicator: true,
                    indicatorColor: Colors.green,
                    selectedIndex: null,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      switch (index) {
                        case 0: return Navigator.of(context).pop();
                        case 1: return;
                      }
                    },
                    minWidth: 40,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.red[900],
                    selectedLabelTextStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 20,
                      letterSpacing: 0.8,
                      // decoration: TextDecoration.underline,
                      decorationThickness: 2.0,
                    ),
                    unselectedLabelTextStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 20,
                      letterSpacing: 0,
                      // decoration: TextDecoration.underline,
                      decorationThickness: 2.0,
                    ),
                    // leading: IconButton(
                    //   icon: Icon(Icons.arrow_back_ios, color: Colors.grey[400]),
                    //   onPressed: () => Navigator.of(context).pop(),
                    // ),
                    destinations: const <NavigationRailDestination>
                    [
                      // navigation destinations
                      NavigationRailDestination(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white54,),
                        // onPressed: () => Navigator.of(context).pop(),
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical:8),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(''),
                          ),
                        ),
                        disabled: false,
                      ),
                      NavigationRailDestination(
                        icon: SizedBox.shrink(),
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical:8),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(''),
                          ),
                        ),
                        disabled: true,
                      ),
                    ],
                    selectedIconTheme: IconThemeData(color: Colors.red[900], opacity: 1),
                    unselectedIconTheme: IconThemeData(color: Colors.white54),
                    // selectedLabelTextStyle: TextStyle(color: Colors.white),
                  ),
                  Container(
                    constraints: BoxConstraints.expand(width: 700),
                    alignment: Alignment.center,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (controller != null) {
                          return _cameraPreviewWidget();
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: _cameraRightWidget(),
                  ),
                ],
              ),
              floatingActionButton: _flashModeControlRowWidget(),
              // bottomNavigationBar: BottomAppBar(
              //   height: 70,
              //   color: Colors.red[900],
              //   // color: Colors.red[900]?.withOpacity(0.5),
              //   child: _cameraBottomWidget(),
              // ),
            );
          }
        }
    );
  }


  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'Cargando...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onTapDown: (TapDownDetails details) =>
                      onViewFinderTap(details, constraints),
                );
              }
          ),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    if (localVideoController == null && imageFile == null) {
      return Container();
    }
    else {
      return SizedBox(
        width: 64.0,
        height: 64.0,
        child: (localVideoController == null)
            ? (
            // The captured image on the web contains a network-accessible URL
            // pointing to a location within the browser. It may be displayed
            // either with Image.network or Image.memory after loading the image
            // bytes to memory.
            kIsWeb
                ? Image.network(imageFile!.path)
                : Image.file(File(imageFile!.path)))
            : Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.pink)),
          child: Center(
            child: AspectRatio(
                aspectRatio:
                localVideoController.value.aspectRatio,
                child: VideoPlayer(localVideoController)),
          ),
        ),
      );
    }
  }

  /// Sets flashmode for image
  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.grey[400],
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.grey[400],
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: controller?.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.grey[400],
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.grey[400],
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _cameraBottomWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.cameraswitch),
          color: Colors.grey[400],
          iconSize: 40,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              !cameraController.value.isRecordingVideo
              ? TurnCam
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.flash_on),
          color: Colors.grey[400],
          iconSize: 40,
          onPressed: controller != null ? onFlashModeButtonPressed : null,
        ),
        IconButton(
          icon: Icon(controller?.value.isCaptureOrientationLocked ?? false
              ? Icons.screen_lock_rotation
              : Icons.screen_rotation),
          color: Colors.grey[400],
          iconSize: 40,
          onPressed: controller != null
              ? onCaptureOrientationLockButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.grey[400],
          iconSize: 40,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              !cameraController.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        _thumbnailWidget(),
      ],
    );
  }

  Widget _cameraRightWidget() {
    final CameraController? cameraController = controller;
    return Container(
      width: 70,
      color: Colors.red[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            color: Colors.grey[400],
            iconSize: 40,
            onPressed: cameraController != null &&
                cameraController.value.isInitialized &&
                !cameraController.value.isRecordingVideo
                ? TurnCam
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            color: Colors.grey[400],
            iconSize: 40,
            onPressed: controller != null ? onFlashModeButtonPressed : null,
          ),
          IconButton(
            icon: Icon(controller?.value.isCaptureOrientationLocked ?? false
                ? Icons.screen_lock_rotation
                : Icons.screen_rotation),
            color: Colors.grey[400],
            iconSize: 40,
            onPressed: controller != null
                ? onCaptureOrientationLockButtonPressed
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.grey[400],
            iconSize: 40,
            onPressed: cameraController != null &&
                cameraController.value.isInitialized &&
                !cameraController.value.isRecordingVideo
                ? onTakePictureButtonPressed
                : null,
          ),
          _thumbnailWidget(),
        ],
      ),
    );
  }


  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.max,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                  (double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value)
        ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
        // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
        // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() async {
    final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
    final FinalPath = await '$output/Lonchi-Ing/$proyecto/Fotos';
    if (await Directory(FinalPath).exists()){
      print ('Ya existe $FinalPath');
    } else{
      print ('NO existe $FinalPath');
      await new Directory(FinalPath).create(recursive: true);
    }
    await takePicture().then((XFile? file) {
      DateTime now = DateTime.now();
      String nowtext = DateFormat('yyyy-MM-dd-(kk.mm.ss)').format(now);
      final path = (FinalPath + "/$nowtext.jpeg");
      file?.saveTo(path);
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) {
          showInSnackBar('Foto salvada en ${path}');
        }
      }
      Navigator.pop(context, path);
    });
  }

  void TurnCam() {
    var selectedcam;
    print(controller!.description.name);
    if (controller!.value.isInitialized) {
      if (controller!.description.name == "Camera 0"){
        selectedcam = _allcameras[1];
        ChangeCam(selectedcam);
      }
      else {
        selectedcam = _allcameras[0];
        ChangeCam(selectedcam);
      }
      return;
    }
    else{
      ChangeCam(_allcameras[0]);
    }
  }

  Future<void> ChangeCam(CameraDescription cameraDescription) async {
    // Dispose the current controller first
    await controller?.dispose();
    await _initializeCameraController(cameraDescription);
  }


  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }


  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Orientación libre');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Orientación fija ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      // showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}


