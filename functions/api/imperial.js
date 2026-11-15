// Adaptador Cloudflare Pages para o backend original do Brummês Imperial.
// Exige compatibilidade Node.js e variáveis de ambiente no painel da Cloudflare.
import { handler } from '../_lib/imperial.mjs';

export async function onRequest({ request }) {
  const url = new URL(request.url);
  const event = {
    httpMethod: request.method,
    headers: { cookie: request.headers.get('cookie') || '' },
    body: request.method === 'GET' ? null : await request.text(),
    path: url.pathname,
  };
  try {
    const result = await handler(event);
    return new Response(result.body, {
      status: result.statusCode,
      headers: result.headers || {},
    });
  } catch (error) {
    console.error('Erro no adaptador imperial:', error?.name || 'Unknown');
    return Response.json({error:'Erro interno no servidor.'},{status:500});
  }
}
