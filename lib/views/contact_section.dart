import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Get in Touch',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 24),

                        // Email Section
                        ListTile(
                          leading: Icon(Icons.email,
                              color: Theme.of(context).primaryColor),
                          title: const Text('Email'),
                          subtitle: SelectableText(viewModel.getEmail()),
                          onTap: () =>
                              _launchUrl('mailto:${viewModel.getEmail()}'),
                        ),

                        const SizedBox(height: 16),

                        // LinkedIn Section
                        ListTile(
                          leading: Icon(Icons.business,
                              color: Theme.of(context).primaryColor),
                          title: const Text('LinkedIn'),
                          subtitle:
                              const Text('Connect with me professionally'),
                          onTap: () => _launchUrl(viewModel.getLinkedinUrl()),
                        ),

                        const SizedBox(height: 16),

                        // GitHub Section
                        ListTile(
                          leading: Icon(Icons.code,
                              color: Theme.of(context).primaryColor),
                          title: const Text('GitHub'),
                          subtitle: const Text('Check out my code'),
                          onTap: () => _launchUrl(viewModel.getGithubUrl()),
                        ),

                        const SizedBox(height: 32),

                        // Contact Form
                        Text(
                          'Send me a message',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                                        content:
                                            Text('Message sent successfully!')),
                                  );
                                  _formKey.currentState!.reset();
                                  _nameController.clear();
                                  _emailController.clear();
                                  _messageController.clear();
                                }
                              } catch (error) {
                                if (currentContext.mounted) {
                                  ScaffoldMessenger.of(currentContext)
                                      .showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error sending message: $error')),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text('Send Message'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
