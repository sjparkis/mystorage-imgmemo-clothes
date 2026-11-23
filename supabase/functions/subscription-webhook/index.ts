import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { crypto } from "https://deno.land/std@0.168.0/crypto/mod.ts";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

serve(async (req) => {
  let payload: Record<string, unknown>;
  try {
    payload = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const webhookSecret = Deno.env.get("REVENUECAT_WEBHOOK_SECRET");
  if (webhookSecret) {
    const signature = req.headers.get("X-RevenueCat-Signature") ?? "";
    const encoder = new TextEncoder();
    const keyData = encoder.encode(webhookSecret);
    const msgData = encoder.encode(JSON.stringify(payload));
    const key = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]
    );
    const signatureBytes = await crypto.subtle.sign("HMAC", key, msgData);
    const expectedSig = Array.from(new Uint8Array(signatureBytes))
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("");
    if (signature !== expectedSig) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { "Content-Type": "application/json" },
      });
    }
  }

  const userId = payload.app_user_id as string | undefined;
  if (!userId) {
    return new Response(JSON.stringify({ error: "Missing app_user_id" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const entitlements =
    (payload.subscriber as Record<string, unknown>)?.entitlements as Record<string, { is_active: boolean }> ?? {};

  let plan = "free";
  if (entitlements["ai_voice"]?.is_active) plan = "ai_voice";
  else if (entitlements["basic"]?.is_active) plan = "basic";
  else if (entitlements["ad_free"]?.is_active) plan = "ad_free";

  const { error } = await supabase.from("subscriptions").upsert({
    user_id: userId,
    plan,
    status: plan === "free" ? "expired" : "active",
    revenuecat_id: (payload.subscriber as Record<string, unknown>)?.original_app_user_id,
    updated_at: new Date().toISOString(),
  }, { onConflict: "user_id" });

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response("ok");
});
