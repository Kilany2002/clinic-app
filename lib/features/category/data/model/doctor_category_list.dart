class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final int experience;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.experience,
  });
}

class DoctorRepository {
  static List<Doctor> fetchDoctors() {
    return [
      Doctor(
          name: "Dr. Osama Ali",
          specialty: "Speech",
          rating: 4.9,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 10),
      Doctor(
          name: "Dr. Sara Selem",
          specialty: "Speech",
          rating: 4.8,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 8),
      Doctor(
          name: "Dr. May Morad",
          specialty: "Speech",
          rating: 4.5,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 6),
      Doctor(
          name: "Dr. Alaa Mohamed",
          specialty: "Autism",
          rating: 3.7,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 5),
    ];
  }

  static List<Doctor> fetchPopularDoctors() {
    return [
      Doctor(
          name: "Dr. Mohamed Saad",
          specialty: "General",
          rating: 5.0,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 15),
      Doctor(
          name: "Dr. Adel Mohamed",
          specialty: "Cardiology",
          rating: 4.7,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 12),
      Doctor(
          name: "Dr. Fatema Amir",
          specialty: "Pediatrics",
          rating: 4.6,
          imageUrl:
              "https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?t=st=1739711747~exp=1739715347~hmac=bb8658eddf170eedce0a1427867eed8e5259384d83824f7569f2e4e25a6fe426&w=900",
          experience: 8),
    ];
  }
}
