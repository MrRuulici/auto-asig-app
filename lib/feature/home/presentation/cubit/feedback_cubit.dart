import 'package:auto_asig/core/data/email_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _serviceId = EmailData.serviceId;
  static const String _templateId = EmailData.templateId;
  static const String _publicKey = EmailData.publicKey;

  Future<void> sendFeedback({
    required String subject,
    required String body,
    required String userEmail,
    required String userId,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      // 1. Save to Firestore first
      await _firestore.collection('feedback').add({
        'subject': subject,
        'body': body,
        'userEmail': userEmail,
        'userId': userId,
        'status': 'unread',
        'createdAt': FieldValue.serverTimestamp(),
        'emailSent': false,
      });

      // 2. Send email via EmailJS
      await _sendEmailViaEmailJS(
        subject: subject,
        body: body,
        userEmail: userEmail,
        userId: userId,
      );

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Feedback trimis cu succes!',
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Eroare Firebase: ${e.message}',
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Eroare la trimiterea feedback-ului: ${error.toString()}',
      ));
    }
  }

  Future<void> _sendEmailViaEmailJS({
    required String subject,
    required String body,
    required String userEmail,
    required String userId,
  }) async {
    try {
      print('📧 Attempting to send email via EmailJS...');
      
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      
      final data = {
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _publicKey,
        'template_params': {
          'subject': subject,
          'message': body,
          'user_email': userEmail,
          'user_id': userId,
          'send_date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        }
      };

      print('Request Data: ${json.encode(data)}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Email sent successfully via EmailJS');
      } else {
        print('❌ EmailJS error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('❌ EmailJS exception: $error');
      // Don't throw - we still saved to Firestore
    }
  }

  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
      hasError: false,
    ));
  }
}