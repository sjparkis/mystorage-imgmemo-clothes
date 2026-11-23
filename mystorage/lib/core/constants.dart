class AppConstants {
  static const supabaseUrl = 'https://zwxgkgljuwodgslrdodg.supabase.co';
  static const supabaseAnonKey = 'sb_publishable_meyFQGEFQMkMU_8yE6knog_GQKnG6Cp';

  static const planLimits = {
    'free':     {'storages': 3,  'clothes': 15},
    'ad_free':  {'storages': 3,  'clothes': 15},
    'basic':    {'storages': 20, 'clothes': 70},
    'ai_voice': {'storages': -1, 'clothes': -1},
  };
}
