import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response =
          await supabase.from('categories').select('id, name, image');

      return response.map((category) {
        return {
          "id": category["id"] ?? 0,
          "name": category["name"] ?? "Unknown",
          "image": category["image"] ??
              "https://cdn.pixabay.com/photo/2022/06/09/04/51/robot-7251710_1280.png", // صورة افتراضية
        };
      }).toList();
    } catch (error) {
      print("Error fetching categories: $error");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDoctorsByCategory(
      int categoryId) async {
    final response = await supabase
        .from('doctors')
        .select()
        .eq('category_id', categoryId)
        .order('rating', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
