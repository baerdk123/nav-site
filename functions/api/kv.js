// Cloudflare Pages Function — KV 同步代理（解决 CORS）
// Token 从 Pages 环境变量 KV_TOKEN（Secret）自动读取，无需前端传参
const CF_API = 'https://api.cloudflare.com/client/v4';
const ACCOUNT = '53f8bc314242b1fefda3e51f0d284ebf';
const KV_NS = 'bd780c429b664300a3ae5c32b62a084d';
const KV_KEY = 'nav_bookmarks';

export async function onRequest(context) {
  const { request, env } = context;
  const url = new URL(request.url);
  if (url.pathname !== '/api/kv') return new Response('Not Found', { status: 404 });

  const token = env.KV_TOKEN || '';
  if (!token) {
    return new Response(JSON.stringify({ success: false, error: 'KV_TOKEN not configured' }), {
      status: 500, headers: { 'Content-Type': 'application/json' }
    });
  }

  const cfUrl = CF_API + '/accounts/' + ACCOUNT + '/storage/kv/namespaces/' + KV_NS + '/values/' + KV_KEY;
  try {
    if (request.method === 'GET') {
      const resp = await fetch(cfUrl, { headers: { 'Authorization': 'Bearer ' + token } });
      const text = await resp.text();
      let result = text;
      try { result = JSON.parse(text); } catch(e) {}
      return new Response(JSON.stringify({ success: true, result }), {
        headers: { 'Content-Type': 'application/json' }
      });
    }
    if (request.method === 'PUT') {
      const body = await request.text();
      const resp = await fetch(cfUrl, {
        method: 'PUT',
        headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
        body
      });
      const result = await resp.json();
      return new Response(JSON.stringify(result), {
        headers: { 'Content-Type': 'application/json' }
      });
    }
    return new Response('Method Not Allowed', { status: 405 });
  } catch(e) {
    return new Response(JSON.stringify({ success: false, error: e.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' }
    });
  }
}
