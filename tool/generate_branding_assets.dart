// Generator aset placeholder branding Afterglow.
//
// Fakta tertunda #2 (docs/grilling/bagian-01-fondasi.md): logo final dari user
// belum ada. Skrip ini membuat placeholder otomatis yang mudah diganti — cukup
// ganti file PNG di assets/branding dan jalankan ulang flutter_launcher_icons.
//
// Jalankan: dart run tool/generate_branding_assets.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const size = 1024;

// Warna diambil dari palet placeholder (core/theme/app_theme.dart).
const purple = [0x7C, 0x4D, 0xFF]; // AppPalette.seed
const warm = [0xFF, 0x8A, 0x50]; // warm amber di dekat horizon
const sun = [0xFF, 0xD6, 0x6B]; // piringan matahari
const glow = [0xFF, 0xB0, 0x5C]; // pendar sekitar matahari
const ground = [0x2A, 0x15, 0x54]; // siluet tanah (ungu gelap)

void main() {
  final icon = _drawScene();

  Directory('assets/branding').createSync(recursive: true);

  // 1. Ikon utama full-bleed — dipakai mipmap legacy & sumber launcher icon.
  File('assets/branding/app_icon_placeholder.png')
      .writeAsBytesSync(img.encodePng(icon));

  // 2. Foreground adaptif: senada diperkecil ke safe zone (~66%) di atas
  //    canvas transparan; background adaptif diisi warna ungu dari palet.
  final scaled = img.copyResize(
    icon,
    width: (size * 0.66).round(),
    height: (size * 0.66).round(),
    interpolation: img.Interpolation.cubic,
  );
  final foreground = img.Image(width: size, height: size);
  img.compositeImage(foreground, scaled,
      dstX: (size - scaled.width) ~/ 2,
      dstY: (size - scaled.height) ~/ 2);
  File('assets/branding/app_icon_foreground_placeholder.png')
      .writeAsBytesSync(img.encodePng(foreground));

  stdout.writeln('Placeholder icon dibuat di assets/branding/');
}

img.Image _drawScene() {
  final image = img.Image(width: size, height: size);

  const horizonY = size * 0.62;
  const sunX = size * 0.5;
  const sunY = horizonY;
  const sunR = size * 0.085;
  const glowR = size * 0.38;

  for (final pixel in image) {
    final y = pixel.y.toDouble();

    if (y > horizonY) {
      // Tanah: siluet rata ungu gelap.
      image.setPixelRgb(pixel.x, pixel.y, ground[0], ground[1], ground[2]);
      continue;
    }

    // Langit: gradien ungu (atas) → warm (horizon).
    final t = (y / horizonY).clamp(0.0, 1.0);
    var r = _lerp(purple[0], warm[0], t);
    var g = _lerp(purple[1], warm[1], t);
    var b = _lerp(purple[2], warm[2], t);

    // Pendar matahari.
    final dx = pixel.x - sunX;
    final dy = pixel.y - sunY;
    final d = math.sqrt(dx * dx + dy * dy);
    if (d <= sunR) {
      // Piringan matahari (setengah terbenam karena dibatasi horizon).
      r = sun[0].toDouble();
      g = sun[1].toDouble();
      b = sun[2].toDouble();
    } else {
      final fade = (1 - (d - sunR) / (glowR - sunR)).clamp(0.0, 1.0);
      final k = fade * 0.45;
      r = _lerp(r, glow[0].toDouble(), k);
      g = _lerp(g, glow[1].toDouble(), k);
      b = _lerp(b, glow[2].toDouble(), k);
    }

    image.setPixelRgb(pixel.x, pixel.y, r.round(), g.round(), b.round());
  }
  return image;
}

double _lerp(num a, num b, double t) => a + (b - a) * t;
