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
    const body = await req.json();
    let base64Image: string;
    let contentType: string = body.contentType ?? "image/jpeg";

    if (body.imageUrl) {
      const imageResponse = await fetch(body.imageUrl);
      const imageBuffer = await imageResponse.arrayBuffer();
      base64Image = btoa(String.fromCharCode(...new Uint8Array(imageBuffer)));
      contentType = imageResponse.headers.get("content-type") ?? contentType;
    } else {
      base64Image = body.base64Image;
    }

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": Deno.env.get("ANTHROPIC_API_KEY")!,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 300,
        messages: [
          {
            role: "user",
            content: [
              {
                type: "image",
                source: {
                  type: "base64",
                  media_type: contentType,
                  data: base64Image,
                },
              },
              {
                type: "text",
                text: `이 옷 사진을 분석해서 JSON으로만 반환하세요. 설명 없이 JSON만.

형식:
{
  "name": "옷의 대표 이름 (예: 베이지 오버핏 울 코트, 흰색 린넨 셔츠)",
  "tags": [
    {"name": "태그명", "category": "카테고리"}
  ]
}

카테고리별 분석 기준:
- color: 주요 색상 1~2개 (베이지/아이보리/크림/화이트/블랙/네이비/카키/브라운/그레이/블루/레드 등 구체적으로)
- type: 옷 종류 1개 (티셔츠/롱슬리브/셔츠/블라우스/니트/스웨터/후드/맨투맨/재킷/코트/트렌치코트/패딩/조끼/청바지/슬랙스/트라우저/숏팬츠/스커트/원피스/점프수트 등)
- material: 소재 1~2개 (면/린넨/울/캐시미어/실크/폴리에스터/데님/코듀로이/니트/레더/스웨이드/혼방 등, 보이지 않으면 생략)
- season: 착용 계절 (봄여름/가을겨울/사계절 중 하나)
- style: 스타일 1개 (캐주얼/포멀/스포티/빈티지/미니멀/스트리트/오피스/아웃도어 등)
- condition: 옷 상태 1개 (새것/상태좋음/보통/사용감있음 — 사진 상태 기준)
- brand: 로고나 태그가 보일 때만

총 태그 7~10개. 최대한 구체적으로.`,
              },
            ],
          },
        ],
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
