import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utility/message_helper.dart';
import '../viewmodels/contact_viewmodel.dart';

// ⚠️  Change this to your desired admin password before deploying.
const _kAdminPassword = 'snv@admin2026';

// ---------------------------------------------------------------------------
// Entry point — call this to trigger the auth → panel flow
// ---------------------------------------------------------------------------

void showAdminAuthDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _AdminAuthDialog(),
  );
}

// ---------------------------------------------------------------------------
// Password dialog
// ---------------------------------------------------------------------------

class _AdminAuthDialog extends StatefulWidget {
  const _AdminAuthDialog();

  @override
  State<_AdminAuthDialog> createState() => _AdminAuthDialogState();
}

class _AdminAuthDialogState extends State<_AdminAuthDialog> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _error = false;

  void _submit() {
    if (_controller.text.trim() == _kAdminPassword) {
      Navigator.pop(context);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AdminPanel(),
      );
    } else {
      setState(() => _error = true);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor:
          isDark ? const Color(0xFF1A1F2E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primary,
                    primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: const Icon(Icons.admin_panel_settings_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(height: 20),
            Text(
              'Admin Access',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFF2E6FF) : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Enter your password to access the moderation panel.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              obscureText: _obscure,
              autofocus: true,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    GoogleFonts.poppins(color: _error ? Colors.red : primary),
                errorText: _error ? 'Incorrect password' : null,
                filled: true,
                fillColor:
                    isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primary, width: 2),
                ),
                prefixIcon: Icon(Icons.lock_outline, color: primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              style: GoogleFonts.openSans(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey[300]!),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            color: isDark ? Colors.white60 : Colors.grey[700])),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Enter',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Admin Panel — full-screen moderation panel
// ---------------------------------------------------------------------------

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _viewModel = ContactViewModel();
  List<Map<String, dynamic>> _pending = [];
  final Set<String> _selectedIds = {};
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  Future<void> _loadPending() async {
    setState(() => _isLoading = true);
    try {
      final messages = await _viewModel.getPendingMessages();
      if (mounted) {
        setState(() {
          _pending = messages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnack('Failed to load pending messages', isError: true);
      }
    }
  }

  Future<void> _approve() async {
    final toApprove =
        _pending.where((m) => _selectedIds.contains(m['id'])).toList();
    if (toApprove.isEmpty) return;
    setState(() => _isProcessing = true);
    try {
      await _viewModel.approveMessages(toApprove);
      if (mounted) {
        setState(() {
          _pending.removeWhere((m) => _selectedIds.contains(m['id']));
          _selectedIds.clear();
          _isProcessing = false;
        });
        _showSnack('${toApprove.length} message(s) approved & published ✓');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showSnack('Failed to approve: $e', isError: true);
      }
    }
  }

  Future<void> _reject() async {
    final ids = _selectedIds.toList();
    if (ids.isEmpty) return;
    setState(() => _isProcessing = true);
    try {
      await _viewModel.rejectMessages(ids);
      if (mounted) {
        setState(() {
          _pending.removeWhere((m) => _selectedIds.contains(m['id']));
          _selectedIds.clear();
          _isProcessing = false;
        });
        _showSnack('${ids.length} message(s) rejected & removed');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showSnack('Failed to reject: $e', isError: true);
      }
    }
  }

  void _toggleAll() {
    setState(() {
      if (_selectedIds.length == _pending.length) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(_pending.map((m) => m['id'] as String));
      }
    });
  }

  void _toggleItem(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.openSans()),
      backgroundColor: isError ? Colors.redAccent : Colors.green[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _previewMessage(Map<String, dynamic> msg) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final timestamp = msg['timestamp'] != null
        ? DateTime.parse(msg['timestamp'] as String)
        : DateTime.now();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg['name']?.toString().toUpperCase() ?? 'VISITOR',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary),
              ),
              const SizedBox(height: 4),
              Text(
                MessageHelper.formatTimestamp(timestamp),
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.grey[500]),
              ),
              const SizedBox(height: 16),
              Divider(
                  color: isDark ? Colors.white12 : Colors.grey[200],
                  height: 1),
              const SizedBox(height: 16),
              Text(
                msg['message']?.toString() ?? '',
                style: GoogleFonts.openSans(
                    fontSize: 15,
                    height: 1.6,
                    color: isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CLOSE',
                      style: GoogleFonts.poppins(
                          color: primary, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final allSelected =
        _pending.isNotEmpty && _selectedIds.length == _pending.length;

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F5FF),
        body: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isDark
                      ? [primary, primary.withValues(alpha: 0.8), const Color(0xFF111827)]
                      : [primary, const Color(0xFF7E57C2), const Color(0xFF9575CD)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Close',
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Message Moderation',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '${_pending.length} message${_pending.length == 1 ? '' : 's'} pending review',
                              style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.75)),
                            ),
                          ],
                        ),
                      ),
                      // Refresh
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.white),
                        onPressed: _isProcessing ? null : _loadPending,
                        tooltip: 'Refresh',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Select-all bar (shows only when list is non-empty) ──────────
            if (!_isLoading && _pending.isNotEmpty)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                color: isDark
                    ? primary.withValues(alpha: 0.12)
                    : primary.withValues(alpha: 0.07),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Checkbox(
                      value: allSelected,
                      tristate: !allSelected && _selectedIds.isNotEmpty,
                      onChanged: (_) => _toggleAll(),
                      activeColor: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _selectedIds.isEmpty
                          ? 'Select all'
                          : '${_selectedIds.length} of ${_pending.length} selected',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFF2E6FF)
                            : primary,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: primary),
                    )
                  : _pending.isEmpty
                      ? _buildEmptyState(isDark, primary)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                          itemCount: _pending.length,
                          itemBuilder: (_, i) =>
                              _buildMessageCard(_pending[i], isDark, primary),
                        ),
            ),
          ],
        ),

        // ── Sticky action bar ────────────────────────────────────────────────
        bottomNavigationBar: _selectedIds.isEmpty
            ? null
            : _buildActionBar(isDark, primary),
      ),
    );
  }

  Widget _buildMessageCard(
      Map<String, dynamic> msg, bool isDark, Color primary) {
    final id = msg['id'] as String? ?? '';
    final isSelected = _selectedIds.contains(id);
    final timestamp = msg['timestamp'] != null
        ? DateTime.parse(msg['timestamp'] as String)
        : DateTime.now();
    final timeAgo = MessageHelper.getTime(timestamp);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isSelected
            ? primary.withValues(alpha: isDark ? 0.18 : 0.08)
            : (isDark ? const Color(0xFF1A1F2E) : Colors.white),
        border: Border.all(
          color: isSelected
              ? primary.withValues(alpha: 0.6)
              : (isDark ? Colors.white12 : Colors.grey.shade200),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _toggleItem(id),
        onLongPress: () => _previewMessage(msg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                        isSelected ? primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? primary
                          : (isDark ? Colors.white38 : Colors.grey.shade400),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            msg['name']?.toString().toUpperCase() ?? 'VISITOR',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? primary
                                  : (isDark
                                      ? const Color(0xFFF2E6FF)
                                      : Colors.black87),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      msg['message']?.toString() ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark ? Colors.white60 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.touch_app_rounded,
                            size: 12,
                            color: isDark ? Colors.white24 : Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          'Long press to preview full message',
                          style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: isDark ? Colors.white24 : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color primary) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.mark_email_read_outlined,
                size: 40, color: primary.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 20),
          Text(
            'All clear!',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No messages are waiting for review.',
            style: GoogleFonts.openSans(
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(bool isDark, Color primary) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isProcessing ? null : _reject,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.redAccent),
                      )
                    : const Icon(Icons.delete_outline_rounded,
                        color: Colors.redAccent),
                label: Text(
                  'Reject (${_selectedIds.length})',
                  style: GoogleFonts.poppins(
                      color: Colors.redAccent, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _approve,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_outline_rounded,
                        color: Colors.white),
                label: Text(
                  'Approve (${_selectedIds.length})',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
