import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/diary_entry.dart';
import '../services/diary_storage.dart';

class PhotoDiaryScreen extends StatefulWidget {
  const PhotoDiaryScreen({super.key});

  @override
  State<PhotoDiaryScreen> createState() => _PhotoDiaryScreenState();
}

class _PhotoDiaryScreenState extends State<PhotoDiaryScreen> {
  final ImagePicker _picker = ImagePicker();
  final DiaryStorage _storage = DiaryStorage();
  final TextEditingController _captionController = TextEditingController();

  String? _photoPath;
  Position? _position;
  bool _isGettingLocation = false;
  bool _isSaving = false;
  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final entries = await _storage.loadEntries();
    if (!mounted) return;
    setState(() => _entries = entries);
  }

  Future<void> _takePhoto() async {
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      if (permission.isPermanentlyDenied) {
        _showMessage('Camera permission is permanently denied. Enable it in app settings.');
        await openAppSettings();
      } else {
        _showMessage('Camera permission was denied.');
      }
      return;
    }
    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    // The native photo picker handles access to the selected image.
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1080,
      );
      if (image == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/diary_photos');
      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      final extension = image.path.contains('.')
          ? image.path.substring(image.path.lastIndexOf('.'))
          : '.jpg';
      final savedPath =
          '${photoDir.path}/photo_${DateTime.now().microsecondsSinceEpoch}$extension';
      final savedFile = await File(image.path).copy(savedPath);

      if (!mounted) return;
      setState(() {
        _photoPath = savedFile.path;
        _position = null;
      });

      await _fetchLocation();
    } catch (error) {
      _showMessage('Could not select photo: $error');
    }
  }

  Future<void> _fetchLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          await showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Location services are disabled'),
              content: const Text('Please enable GPS/location services to attach coordinates to your photo.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text('Open settings'),
                ),
              ],
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage('Location permission denied. You can grant it in settings.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage('Location permission permanently denied. Open app settings to enable it.');
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;
      setState(() => _position = position);
    } catch (error) {
      _showMessage('Could not get GPS location: $error');
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _saveEntry() async {
    final path = _photoPath;
    final position = _position;
    final caption = _captionController.text.trim();

    if (path == null) {
      _showMessage('Please take a photo or choose one from the gallery.');
      return;
    }
    if (position == null) {
      _showMessage('Please fetch your GPS location before saving.');
      return;
    }
    if (caption.isEmpty) {
      _showMessage('Please enter a caption.');
      return;
    }

    setState(() => _isSaving = true);
    final entry = DiaryEntry(
      imagePath: path,
      caption: caption,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: DateTime.now(),
    );

    final updated = [entry, ..._entries];
    await _storage.saveEntries(updated);

    if (!mounted) return;
    setState(() {
      _entries = updated;
      _photoPath = null;
      _position = null;
      _captionController.clear();
      _isSaving = false;
    });
    _showMessage('Entry saved to your offline diary.');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)} '
        '${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 19, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 9),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value, textAlign: TextAlign.end),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Narxoz Photo Journal'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              clipBehavior: Clip.antiAlias,
              child: _photoPath != null && File(_photoPath!).existsSync()
                  ? Image.file(File(_photoPath!), fit: BoxFit.cover)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 58, color: Colors.blueGrey),
                        SizedBox(height: 10),
                        Text('Your captured photo will appear here'),
                      ],
                    ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _infoRow(Icons.location_on, 'Latitude', _position == null ? 'Not available' : _position!.latitude.toStringAsFixed(6)),
                    _infoRow(Icons.location_on, 'Longitude', _position == null ? 'Not available' : _position!.longitude.toStringAsFixed(6)),
                    _infoRow(Icons.gps_fixed, 'Accuracy', _position == null ? '—' : '± ${_position!.accuracy.toStringAsFixed(1)} m'),
                    _infoRow(Icons.terrain, 'Altitude', _position == null ? '—' : '${_position!.altitude.toStringAsFixed(1)} m'),
                    _infoRow(Icons.access_time, 'Timestamp', _position == null ? 'Not captured' : _formatDate(DateTime.now())),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isGettingLocation ? null : _fetchLocation,
                icon: _isGettingLocation
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: Text(_isGettingLocation ? 'Fetching GPS...' : 'Fetch Current GPS Location'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Caption',
                hintText: 'e.g. Campus Quad at Narxoz',
                prefixIcon: Icon(Icons.edit_note),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveEntry,
                icon: const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'SAVE ENTRY TO DIARY'),
              ),
            ),
            const SizedBox(height: 24),
            Text('📜 Diary Entries (${_entries.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_entries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No diary entries yet. Capture your first moment!')),
              )
            else
              ..._entries.map(
                (entry) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: File(entry.imagePath).existsSync()
                          ? Image.file(File(entry.imagePath), width: 76, height: 76, fit: BoxFit.cover)
                          : const SizedBox(
                              width: 76,
                              height: 76,
                              child: Icon(Icons.broken_image_outlined),
                            ),
                    ),
                    title: Text(entry.caption, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${entry.latitude.toStringAsFixed(4)}° N, ${entry.longitude.toStringAsFixed(4)}° E\n'
                      '${_formatDate(entry.timestamp)}\n'
                      'Accuracy: ± ${entry.accuracy.toStringAsFixed(1)} m',
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
