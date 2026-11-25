import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { clothes, criteria, maxPerBox } = await req.json();

    if (!clothes || clothes.length === 0) {
      return new Response(JSON.stringify({ groups: [] }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const criteriaLabel = (criteria as string[]).join(", ");

    const clothList = (clothes as Array<{
      id: string;
      name: string;
      tags: Array<{ name: string; category: string }>;
    }>)
      .map((c) => {
        const tagStr = c.tags.map((t) => `${t.name}(${t.category})`).join(", ");
        return `- ID: ${c.id} | 이름: ${c.name ?? "이름없음"} | 태그: ${tagStr || "없음"}`;
      })
      .join("\n");

    const prompt = `당신은 옷 정리 전문가입니다. 다음 옷 목록을 분석하여 최적의 보관 상자 배치를 제안해주세요.

분류 기준: ${criteriaLabel}
상자당 최대 의류 수: ${maxPerBox}개

옷 목록:
${clothList}

규칙:
- 각 그룹은 최대 ${maxPerBox}개의 옷만 포함
- 선택한 기준(${criteriaLabel})을 중심으로 분류
- 비슷한 옷들끼리 같은 상자에 배치
- 상자 이름은 한국어로, 내용을 잘 표현하도록 (예: "봄/여름 캐주얼", "겨울 아우터", "블랙 계열 포멀")
- 모든 옷이 반드시 하나의 그룹에만 포함
- 옷이 적으면 상자 수를 줄여도 됨

설명 없이 JSON만 반환:
{
  "groups": [
    {
      "name": "상자 이름",
      "clothIds": ["id1", "id2"],
      "reason": "이 상자에 넣은 이유 (한 줄, 한국어)"
    }
  ]
}`;

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": Deno.env.get("ANTHROPIC_API_KEY")!,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 2000,
        messages: [{ role: "user", content: prompt }],
      }),
    });

    const data = await response.json();
    const text = data.content?.[0]?.text ?? "{}";
    const jsonMatch = text.match(/\{[\s\S]*\}/);
    const result = JSON.parse(jsonMatch ? jsonMatch[0] : text);

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: (error as Error).message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
