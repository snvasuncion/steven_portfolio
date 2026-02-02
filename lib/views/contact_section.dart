import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utility/delayed_fade_scale.dart';
import '../utility/message_helper.dart';
import '../viewmodels/contact_viewmodel.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final viewModel = ContactViewModel();

  static const Color primaryColor = Colors.deepPurple;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;

  List<Map<String, dynamic>> _storedMessages = [];

  @override
  void initState() {
    super.initState();
    _loadStoredMessages();
  }

  Future<void> _loadStoredMessages() async {
    try {
      final messages = await viewModel.getMessages();
      setState(() {
        _storedMessages = messages;
      });
    } catch (e) {
      // prepping for future error handling
    }
  }

  void _showMessageDialog(
      BuildContext context, String name, String message, DateTime timestamp) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                MessageHelper.formatTimestamp(timestamp),
                style:
                    GoogleFonts.openSans(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: GoogleFonts.openSans(
                    fontSize: 16, height: 1.6, color: Colors.grey[800]),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CLOSE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final currentContext = context;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DelayedFadeScale(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Contact',
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            DelayedFadeScale(
              delay: const Duration(milliseconds: 300),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildContactCard(
                        title: 'Email',
                        subtitle: 'Send me a direct message',
                        details: viewModel.getEmail(),
                        icon: const Icon(Icons.email_outlined,
                            color: primaryColor, size: 28),
                        onTap: () =>
                            _launchUrl('mailto:${viewModel.getEmail()}'),
                        index: 0,
                      ),
                      const SizedBox(height: 16),
                      _buildContactCard(
                        title: 'LinkedIn',
                        subtitle: 'Connect with me professionally',
                        details: viewModel.getLinkedinUrl(),
                        icon: const FaIcon(FontAwesomeIcons.linkedin,
                            color: primaryColor, size: 28),
                        onTap: () => _launchUrl(viewModel.getLinkedinUrl()),
                        index: 1,
                      ),
                      const SizedBox(height: 16),
                      _buildContactCard(
                        title: 'GitHub',
                        subtitle: 'Check out my projects',
                        details: viewModel.getGithubUrl(),
                        icon: const Icon(Icons.code_outlined,
                            color: primaryColor, size: 28),
                        onTap: () => _launchUrl(viewModel.getGithubUrl()),
                        index: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            DelayedFadeScale(
              delay: const Duration(milliseconds: 400),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Send me a message',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'New Opportunities, Commissions, connections? Feel free to reach out!',
                            style:
                                GoogleFonts.openSans(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          DelayedFadeScale(
                            delay: const Duration(milliseconds: 500),
                            child: _buildTextField(
                              controller: _nameController,
                              label: 'Your Name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your name';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          DelayedFadeScale(
                            delay: const Duration(milliseconds: 600),
                            child: _buildTextField(
                              controller: _emailController,
                              label: 'Your Email',
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your email';
                                if (!value.contains('@'))
                                  return 'Please enter a valid email';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          DelayedFadeScale(
                            delay: const Duration(milliseconds: 700),
                            child: _buildTextField(
                              controller: _messageController,
                              label: 'Your Message',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your message';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          DelayedFadeScale(
                            delay: const Duration(milliseconds: 800),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: whiteColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final currentContext = context;
                                  try {
                                    await viewModel.sendMessage(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      message: _messageController.text,
                                    );
                                    if (currentContext.mounted) {
                                      ScaffoldMessenger.of(currentContext)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Message sent successfully!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      _formKey.currentState!.reset();
                                      _nameController.clear();
                                      _emailController.clear();
                                      _messageController.clear();
                                      _loadStoredMessages();
                                    }
                                  } catch (error) {
                                    if (currentContext.mounted) {
                                      ScaffoldMessenger.of(currentContext)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Error sending message: $error'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text(
                                'Send Message',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_storedMessages.isNotEmpty)
              DelayedFadeScale(
                delay: const Duration(milliseconds: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Text(
                          'Message Board',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: _storedMessages.reversed.take(5).map((message) {
                        final timestamp = message['timestamp'] != null
                            ? DateTime.parse(message['timestamp'] as String)
                            : DateTime.now();
                        final timeAgo = MessageHelper.getTime(timestamp);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(38),
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message['name']
                                                        ?.toString()
                                                        .toUpperCase() ??
                                                    'VISITOR',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryColor,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                message['email']?.toString() ??
                                                    'anonymous@email.com',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          timeAgo,
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Divider(height: 1, color: Colors.grey[200]),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  message['message']?.toString() ?? '',
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      MessageHelper.formatTimestamp(timestamp),
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _showMessageDialog(
                                          context,
                                          message['name']?.toString() ??
                                              'Visitor',
                                          message['message']?.toString() ?? '',
                                          timestamp,
                                        );
                                      },
                                      child: Text(
                                        'VIEW FULL',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: Colors.grey[300], thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${_storedMessages.length} messages total',
                              style: GoogleFonts.openSans(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color: Colors.grey[300], thickness: 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required String details,
    required Widget icon,
    required VoidCallback onTap,
    required int index,
  }) {
    return DelayedFadeScale(
      delay: Duration(milliseconds: 500 + (index * 150)),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color.lerp(Colors.transparent, primaryColor, 0.1)!,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: icon,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.openSans(
                            fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        details,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: primaryColor, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      style: GoogleFonts.openSans(),
      validator: validator,
    );
  }
}
