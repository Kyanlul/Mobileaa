import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http')) {
      if (endsWith('.svg')) {
        return ImageType.networkSvg;
      } else if (endsWith('.png')) {
        return ImageType.networkPng;
      } else if (endsWith('.jpg') || endsWith('.jpeg')) {
        return ImageType.networkJpg;
      }
      return ImageType.networkUnknown;
    }

    if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (endsWith('.png')) {
      return ImageType.png;
    } else if (endsWith('.jpg') || endsWith('.jpeg')) {
      return ImageType.jpg;
    } else {
      return ImageType.unknown;
    }
  }
}

enum ImageType {
  svg,
  png,
  jpg,
  unknown,
  networkSvg,
  networkPng,
  networkJpg,
  networkUnknown
}

class CustomImageView extends StatefulWidget {
  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
    this.loadingIndicator,
    this.errorWidget
  });

  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final Widget? loadingIndicator;
  final Widget? errorWidget;

  @override
  _CustomImageViewState createState() => _CustomImageViewState();
}

class _CustomImageViewState extends State<CustomImageView> {
  Uint8List? _networkImageBytes;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadNetworkImage();
  }

  @override
  void didUpdateWidget(CustomImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imagePath != oldWidget.imagePath) {
      _loadNetworkImage();
    }
  }

  Future<void> _loadNetworkImage() async {
    if (widget.imagePath == null) return;

    final imageType = widget.imagePath!.imageType;
    if (imageType == ImageType.networkSvg ||
        imageType == ImageType.networkPng ||
        imageType == ImageType.networkJpg) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      try {
        final response = await http.get(Uri.parse(widget.imagePath!));
        if (response.statusCode == 200) {
          setState(() {
            _networkImageBytes = response.bodyBytes;
            _isLoading = false;
          });
        } else {
          _handleImageLoadError();
        }
      } catch (e) {
        _handleImageLoadError();
      }
    }
  }

  void _handleImageLoadError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
      _networkImageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
      alignment: widget.alignment!,
      child: _buildWidget(),
    )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  Widget _buildCircleImage() {
    if (widget.radius != null) {
      return ClipRRect(
        borderRadius: widget.radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  Widget _buildImageWithBorder() {
    if (widget.border != null) {
      return Container(
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (widget.imagePath != null) {
      switch (widget.imagePath!.imageType) {
        case ImageType.svg:
          return SvgPicture.asset(
            widget.imagePath!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.contain,
            color: widget.color,
          );
        case ImageType.networkSvg:
          return _isLoading
              ? (widget.loadingIndicator ?? const CircularProgressIndicator())
              : _hasError
              ? (widget.errorWidget ?? Image.asset(widget.placeHolder))
              : SvgPicture.memory(
            _networkImageBytes!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.contain,
            color: widget.color,
          );
        case ImageType.jpg:
        case ImageType.png:
          return Image.asset(
            widget.imagePath!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            color: widget.color,
          );
        case ImageType.networkPng:
        case ImageType.networkJpg:
          return _isLoading
              ? (widget.loadingIndicator ?? const CircularProgressIndicator())
              : _hasError
              ? (widget.errorWidget ?? Image.asset(widget.placeHolder))
              : Image.memory(
            _networkImageBytes!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            color: widget.color,
          );
        default:
          return Image.asset(
            widget.placeHolder,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
          );
      }
    }
    return const SizedBox();
  }
}