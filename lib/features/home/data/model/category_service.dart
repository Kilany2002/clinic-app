import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await supabase.from('categories').select();
    return response;
  }
}
