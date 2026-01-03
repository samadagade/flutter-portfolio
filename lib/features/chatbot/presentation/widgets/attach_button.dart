// ─────────────────────────────────────────────────────────────────────────────
// ATTACH BUTTON
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AttachmentAction { upload, gallery, camera, audio, contact, location }

class AttachButton extends StatefulWidget {
  const AttachButton({
    super.key,
    required this.onSelected,
    this.icon = Icons.attach_file,
  });

  final ValueChanged<AttachmentAction> onSelected;
  final IconData icon;

  @override
  State<AttachButton> createState() => _ChatGPTAttachButtonState();
}

class _ChatGPTAttachButtonState extends State<AttachButton> {
  final MenuController _menuController = MenuController();

  void _openMenu() {
    HapticFeedback.heavyImpact();
    _menuController.open();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8),
      style: MenuStyle(
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
        backgroundColor: WidgetStatePropertyAll(scheme.surface),
        elevation: const WidgetStatePropertyAll(8),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        shadowColor: WidgetStatePropertyAll(Colors.black.withOpacity(0.2)),
      ),
      builder: (context, controller, child) {
        return IconButton(
          tooltip: 'Attach',
          icon: Icon(widget.icon),
          onPressed: _openMenu,
        );
      },
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.upload_file_rounded),
          child: const Text('Upload from device'),
          onPressed: () => widget.onSelected(AttachmentAction.upload),
        ),
        const Divider(height: 8),
        MenuItemButton(
          leadingIcon: const Icon(Icons.person_add_alt_1_rounded),
          child: const Text('Contact'),
          onPressed: () => widget.onSelected(AttachmentAction.contact),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.photo_library_rounded),
          child: const Text('Gallery'),
          onPressed: () => widget.onSelected(AttachmentAction.gallery),
        ),
      ],
    );
  }
}
