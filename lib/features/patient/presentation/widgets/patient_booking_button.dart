import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/features/patient/data/model/doctor_category_list.dart';
import 'package:clinicc/features/patient/data/model/patient_appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class PatientBookingButton extends StatelessWidget {
  const PatientBookingButton({
    super.key,
    required this.doctor,
    required this.patientName,
    required this.patientAge,
    required this.visitType,
    required this.selectedDate,
    required this.patientFCMToken,
    required this.doctorFCMToken,
    this.onBookingSuccess,
  });

  final Doctor doctor;
  final String patientName;
  final int patientAge;
  final String visitType;
  final DateTime selectedDate;
  final String? patientFCMToken;
  final String? doctorFCMToken;
  final VoidCallback? onBookingSuccess;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.color1,
        ),
        onPressed: () {
          PaymentData.initialize(
            apiKey:
                "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RnMU56azNMQ0p1WVcxbElqb2lNVGN5TkRFNE56ZzFOaTQxT1RBeU56TWlmUS44Z0RXdTAxNnk5MGt0QkZ2Z2tfNzFGRVpTQktWeFVBZUpZZUs3WU9MRXNQcmRDRWVLbTFVUEluRk93Um90QlVpdlFycEFHcFkzTFEzY3liNC0yaE9ZUQ==",
            integrationCardId: "4612972",
            integrationMobileWalletId: "4612975",
            iframeId: "856699",
            style: Style(
              primaryColor: AppColors.color1,
              scaffoldColor: Colors.white,
              appBarBackgroundColor: AppColors.color1,
              appBarForegroundColor: Colors.white,
              textStyle: TextStyle(),
              buttonStyle: ElevatedButton.styleFrom(),
              circleProgressColor: AppColors.color1,
              unselectedColor: Colors.grey,
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentView(
                onPaymentSuccess: () async {
                  // Call the booking function after successful payment
                  final success =
                      await PatientAppointmentService.bookAppointment(
                    name: patientName,
                    age: patientAge,
                    visitType: visitType,
                    date: selectedDate,
                    doctorId: doctor.id,
                    isPaid: true,
                    context: context,
                    doctor: doctor,
                    patientFCMToken: patientFCMToken,
                    doctorFCMToken: doctor.fcmToken,
                  );

                  if (success && onBookingSuccess != null) {
                    onBookingSuccess!();
                  }
                },
                onPaymentError: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Payment failed. Please try again.")),
                  );
                },
                price: double.parse(doctor.price),
              ),
            ),
          );
        },
        child: const Text("Book Now"),
      ),
    );
  }
}
