import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/upload_article.dart';
import '../bloc/upload_article_bloc.dart';
import '../bloc/upload_article_event.dart';
import '../bloc/upload_article_state.dart';

const kPrimaryColor = Color(0xFF6C63FF);
const kBackgroundColor = Color(0xFFF8F9FA);

class EditArticlePage extends StatefulWidget {
  final UploadArticle article;

  const EditArticlePage({super.key, required this.article});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contentController;
  late final TextEditingController _authorController;
  late final TextEditingController _tagsController;

  late String _selectedCategory;
  late bool _isPublished;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'general',
    'technology',
    'science',
    'health',
    'business',
    'entertainment',
    'sports',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _descriptionController =
        TextEditingController(text: widget.article.description);
    _contentController = TextEditingController(text: widget.article.content);
    _authorController = TextEditingController(text: widget.article.author);
    _tagsController =
        TextEditingController(text: widget.article.tags.join(', '));
    _selectedCategory =
        widget.article.category.isEmpty ? 'general' : widget.article.category;
    _isPublished = widget.article.isPublished;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tags = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final updatedArticle = UploadArticle(
        id: widget.article.id,
        title: _titleController.text,
        description: _descriptionController.text,
        content: _contentController.text,
        author: _authorController.text,
        thumbnailURL: widget.article.thumbnailURL,
        createdAt: widget.article.createdAt,
        category: _selectedCategory,
        isPublished: _isPublished,
        tags: tags,
      );

      context.read<UploadArticleBloc>().add(
            UpdateArticle(
              article: updatedArticle,
              imagePath: _selectedImage?.path,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Article',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _submitForm,
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('Save',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: BlocListener<UploadArticleBloc, UploadArticleState>(
        listener: (context, state) {
          if (state is UploadArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Article updated successfully!'),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
            Navigator.pop(context, true);
          } else if (state is UploadArticleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<UploadArticleBloc, UploadArticleState>(
          builder: (context, state) {
            if (state is UploadArticleLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: kPrimaryColor),
                    const SizedBox(height: 24),
                    Text(
                      'Saving changes...',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Image section
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.white,
                      child: _selectedImage != null
                          ? _buildImageWithOverlay(
                              Image.file(_selectedImage!, fit: BoxFit.cover))
                          : widget.article.thumbnailURL != null &&
                                  widget.article.thumbnailURL!.isNotEmpty
                              ? _buildImageWithOverlay(
                                  Image.network(widget.article.thumbnailURL!,
                                      fit: BoxFit.cover),
                                )
                              : _buildImagePlaceholder(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Form
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          _buildTextField(
                            controller: _titleController,
                            label: 'Title',
                            hint: 'Enter article title',
                            validator: (v) =>
                                v!.isEmpty ? 'Title is required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Author
                          _buildTextField(
                            controller: _authorController,
                            label: 'Author',
                            hint: 'Your name',
                            validator: (v) =>
                                v!.isEmpty ? 'Author is required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Description
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Brief summary of your article',
                            maxLines: 2,
                            validator: (v) =>
                                v!.isEmpty ? 'Description is required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Category dropdown
                          _buildLabel('Category'),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                items: _categories.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat,
                                    child: Text(
                                      cat[0].toUpperCase() + cat.substring(1),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedCategory = v!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tags
                          _buildTextField(
                            controller: _tagsController,
                            label: 'Tags',
                            hint: 'flutter, dart, news (comma separated)',
                          ),
                          const SizedBox(height: 16),

                          // Publish switch
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Published',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      _isPublished
                                          ? 'Article is visible'
                                          : 'Saved as draft',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _isPublished,
                                  onChanged: (v) =>
                                      setState(() => _isPublished = v),
                                  activeColor: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          Divider(color: Colors.grey.shade200),
                          const SizedBox(height: 16),

                          // Content
                          _buildLabel('Content'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _contentController,
                            maxLines: null,
                            minLines: 8,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.6),
                            decoration: InputDecoration(
                              hintText: 'Write your article content here...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: kPrimaryColor),
                              ),
                            ),
                            validator: (v) =>
                                v!.isEmpty ? 'Content is required' : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_rounded),
                SizedBox(width: 8),
                Text('Save Changes',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildImageWithOverlay(Widget image) {
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        Container(color: Colors.black12),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text('Change',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_photo_alternate_rounded,
              size: 32, color: kPrimaryColor),
        ),
        const SizedBox(height: 10),
        const Text(
          'Add cover image',
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Text(
          'Tap to upload',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }
}
