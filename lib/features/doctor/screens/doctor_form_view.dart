import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../logic/doctor_form_controller.dart';
import '../widgets/form/basic_info_step.dart';
import '../widgets/form/destination_step.dart';
import '../widgets/form/experience_step.dart';

class DoctorFormScreen extends StatefulWidget {
  const DoctorFormScreen({super.key});
  static const String id = 'DoctorFormScreen';

  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  final DoctorFormController controller = DoctorFormController();

  @override
  void initState() {
    super.initState();
    controller.initialize();
    controller.addListener(_updateState);
  }

  @override
  void dispose() {
    controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ('Doctor Registration')),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                connectorColor: WidgetStateProperty.all(AppColors.color1),
                currentStep: controller.currentStep,
                onStepContinue: controller.canProceedToNextStep
                    ? controller.nextStep
                    : null,
                onStepCancel: controller.previousStep,
                steps: [
                  Step(
                    title: const Text('Basic Information'),
                    content: BasicInfoStep(controller: controller),
                    isActive: controller.currentStep >= 0,
                    state: controller.currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Experience & Pricing'),
                    content: ExperienceStep(
                      controller: controller,
                      onChanged: _updateState,
                    ),
                    isActive: controller.currentStep >= 1,
                    state: controller.currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Availability'),
                    content: DestinationsStep(
                        controller: controller, context: context),
                    isActive: controller.currentStep >= 2,
                    state: StepState.indexed,
                  ),
                ],
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        if (details.currentStep > 0)
                          OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back',
                                style: TextStyle(color: Colors.black)),
                          ),
                        const SizedBox(width: 16),
                        if (details.currentStep < 2)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.canProceedToNextStep
                                  ? AppColors.color1
                                  : Colors.grey,
                            ),
                            onPressed: controller.canProceedToNextStep
                                ? details.onStepContinue
                                : null,
                            child: const Text('Next'),
                          ),
                        if (details.currentStep == 2)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.canProceedToNextStep
                                  ? AppColors.color1
                                  : Colors.grey,
                            ),
                            onPressed: controller.isLoading
                                ? null
                                : () => controller.submitForm(context),
                            child: controller.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Submit'),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
