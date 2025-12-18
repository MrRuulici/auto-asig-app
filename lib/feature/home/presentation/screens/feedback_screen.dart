import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/home/presentation/cubit/feedback_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/feedback_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _subjectController =
      TextEditingController(text: 'Ce putem îmbunătăți?');
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = context.read<UserDataCubit>().state.member.email;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            showSuccessSnackbar(context, state.successMessage!);
            
            // Clear the form
            _bodyController.clear();
            _subjectController.text = 'Ce putem îmbunătăți?';

            // Clear messages after showing
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.read<FeedbackCubit>().clearMessages();
              }
            });
          } else if (state.hasError && state.errorMessage != null) {
            showErrorSnackbar(context, state.errorMessage!);

            // Clear messages after showing
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.read<FeedbackCubit>().clearMessages();
              }
            });
          }
        },
        child: BlocBuilder<FeedbackCubit, FeedbackState>(
          builder: (context, state) {
            final isLoading = state.isLoading;
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title
                          const Text(
                            'Părerea ta contează!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: logoBlue,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ajută-ne să îmbunătățim aplicația',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Subject field
                          Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: TextField(
                              controller: _subjectController,
                              decoration: const InputDecoration(
                                labelText: 'Subiect',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              enabled: !isLoading,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Body field
                          Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: TextField(
                              controller: _bodyController,
                              maxLines: 8,
                              minLines: 8,
                              decoration: const InputDecoration(
                                labelText: 'Mesajul Tău',
                                hintText: 'Spune-ne ce crezi...',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                              ),
                              enabled: !isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Send button at the bottom
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: AutoAsigButton(
                    onPressed: () => _sendFeedback(context, userEmail),
                    text: 'Trimite Feedback',
                    isActive: !isLoading,
                    preTextIcon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    activeBackgroundColor: logoBlue,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _sendFeedback(BuildContext context, String? userEmail) {
    final subject = _subjectController.text.trim();
    final body = _bodyController.text.trim();

    if (body.isEmpty) {
      showErrorSnackbar(context, 'Te rugăm să introduci feedback-ul tău');
      return;
    }

    final userId = context.read<UserDataCubit>().state.member.id;

    context.read<FeedbackCubit>().sendFeedback(
          subject: subject.isEmpty ? 'Feedback Aplicație' : subject,
          body: body,
          userEmail: userEmail ?? 'unknown@email.com',
          userId: userId,
        );
  }
}