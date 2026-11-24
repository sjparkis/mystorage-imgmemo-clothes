class AppConstants {
  static const supabaseUrl = 'https://zwxgkgljuwodgslrdodg.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3eGdrZ2xqdXdvZGdzbHJkb2RnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTU0MjMyMzYsImV4cCI6MjExMDk5OTIzNn0.Ue0XHJ-_kFWm9Iv6GHofluaY-xItIqDwAeNOCzxXeSw';

  static const planLimits = {
    'free':     {'storages': 3,  'clothes': 15},
    'ad_free':  {'storages': 3,  'clothes': 15},
    'basic':    {'storages': 20, 'clothes': 70},
    'ai_voice': {'storages': -1, 'clothes': -1},
  };
}
