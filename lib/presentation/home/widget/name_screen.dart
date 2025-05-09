import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/presentation/home_provider/wish_item_provider.dart';
import '../../../core/ui/styles.dart';
import '../../../core/widgets/text_form_field.dart';
import '../../../domain/models/wishlist_item.dart';

class NameScreen extends ConsumerWidget {
  NameScreen({
    super.key,
    required this.onPressed,
    // required this.nameController,
  });

  final VoidCallback onPressed;

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemProvider = ref.read(wishItemProvider.notifier);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 10,
                ),
                const Text('WHAT DO YOU WISH?',
                    style: AppStyles.textStyleSoFoSans),
                const Spacer(
                  flex: 7,
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.cancel_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 700),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: AppStyles.paddingMain,
                    children: [
                      IwishTextFormFieldWidget(
                        controller: nameController,
                        labelText: 'name',
                      ),
                      const IwishTextFormFieldWidget(labelText: 'link'),
                      const IwishTextFormFieldWidget(labelText: 'price'),
                      const IwishTextFormFieldWidget(labelText: 'photo'),
                      const IwishTextFormFieldWidget(labelText: 'comments'),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.yellow,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await itemProvider.createItem(
                            WishlistItem(
                              title: nameController.text,
                            ),
                          );
                          onPressed();
                        },
                        child: const Text(
                          'I wish',
                          style: AppStyles.textStyleSoFoSans,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
