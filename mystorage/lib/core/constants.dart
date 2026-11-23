class AppConstants {
  static const supabaseUrl = 'http://127.0.0.1:54321';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';

  static const planLimits = {
    'free':     {'storages': 3,  'clothes': 15},
    'ad_free':  {'storages': 3,  'clothes': 15},
    'basic':    {'storages': 20, 'clothes': 70},
    'ai_voice': {'storages': -1, 'clothes': -1},
  };
}
