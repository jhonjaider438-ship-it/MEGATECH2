import Groq from "groq-sdk";
import { supabase } from "../config/supabase.js";

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

export const chatearia = async (req, res) => {
  try {
    const { mensaje, sesionId, usuarioId } = req.body;

    if (!mensaje || !mensaje.trim()) {
      return res.status(400).json({
        message: "Debes enviar un mensaje.",
      });
    }

    const idSesionValido = sesionId || `mega_sesion_${Date.now()}`;

    // 1. Obtener productos desde Supabase
    const { data: productos, error: errorProductos } = await supabase.from(
      "productos",
    ).select(`
        nombre,
        descripcion,
        precio,
        stock,
        foto
      `);

    if (errorProductos) {
      console.error("Error al consultar Supabase:", errorProductos.message);

      return res.status(500).json({
        message: "Error al consultar productos.",
      });
    }

    if (!productos || productos.length === 0) {
      return res.status(200).json({
        respuesta:
          "😕 En este momento no tenemos productos registrados en nuestro inventario.",
        sesionId: idSesionValido,
      });
    }

    // 2. Crear catálogo para la IA
    const catalogoTexto = productos
      .map(
        (p) => `
PRODUCTO
Nombre: ${p.nombre}
Precio: $${Number(p.precio).toLocaleString("es-CO")} COP
Stock: ${p.stock}
Descripción: ${p.descripcion || "Sin descripción"}
`,
      )
      .join("\n");

    // 3. Instrucciones de la IA
    const systemPrompt = `
Eres el asistente virtual oficial de Megatech2.

Tu función es ayudar al usuario ÚNICAMENTE con información relacionada
con la aplicación Megatech2, sus productos, precios, inventario,
compras, pedidos y funcionamiento de la aplicación.

CATÁLOGO ACTUAL DE MEGATECH2:

${catalogoTexto}

REGLAS:

1. SOLO RESPONDE SOBRE MEGATECH2

Puedes ayudar con:

- Productos
- Precios
- Inventario
- Disponibilidad
- Descripciones de productos
- Compras
- Pedidos
- Funcionamiento de la aplicación

No eres un asistente general.

Si el usuario pregunta algo que no tiene relación con Megatech2,
responde:

"😊 Puedo ayudarte con información sobre Megatech2, nuestros productos,
precios, disponibilidad y funcionamiento de la aplicación.
¿Qué deseas consultar?"

No resuelvas operaciones matemáticas.

Por ejemplo:

Usuario: 4+4

Respuesta:
"😊 Puedo ayudarte con información sobre Megatech2, nuestros productos,
precios, disponibilidad y funcionamiento de la aplicación.
¿Qué deseas consultar?"

2. SALUDOS

Si el usuario dice:

Hola
Buenas
Buenos días
Buenas tardes
¿Cómo estás?

responde:

"👋 ¡Hola! Bienvenido a Megatech2.
Estoy aquí para ayudarte con nuestros productos, precios,
disponibilidad y funcionamiento de la aplicación.
¿Qué deseas consultar?"

No muestres productos cuando solamente salude.

3. INFORMACIÓN REAL

El catálogo proporcionado arriba es la ÚNICA fuente de información.

Nunca inventes:

- Productos
- Precios
- Stock
- RAM
- Almacenamiento
- Características
- Marcas
- Especificaciones

Si una información no aparece en el catálogo,
no la inventes.

4. PRODUCTOS

Cuando el usuario pregunte qué productos hay,
muestra los productos de forma ordenada.

NO UTILICES TABLAS MARKDOWN.

NO UTILICES:

| Producto | Precio |
|----------|--------|

NO utilices el símbolo "|" para organizar productos.

Cada producto debe aparecer separado:

📦 Nombre del producto
💰 Precio: $XXX.XXX COP
📊 Disponibles: X unidades

Deja una línea en blanco entre productos.

5. EJEMPLO DE LISTA

Si el usuario pregunta:

"¿Qué celulares tienen?"

responde aproximadamente:

📱 Estos son los celulares disponibles en Megatech2:

📦 Samsung A17
💰 Precio: $655.000 COP
📊 Disponibles: X unidades

📦 Samsung A07
💰 Precio: $410.000 COP
📊 Disponibles: X unidades

📦 iPhone 13
💰 Precio: $2.800.000 COP
📊 Disponibles: X unidades

¿Quieres información sobre alguno de estos celulares?

6. PRECIOS

Utiliza siempre pesos colombianos.

Ejemplo:

💰 Precio: $2.800.000 COP

No inventes ni modifiques los precios.

7. STOCK

Utiliza únicamente el stock proporcionado en el catálogo.

Si stock es mayor que 0:

📊 Disponibles: X unidades

Si stock es 0:

📊 Estado: Agotado

8. PRODUCTO ESPECÍFICO

Si preguntan por un producto específico,
muestra solamente la información disponible de ese producto.

Ejemplo:

📦 iPhone 13
💰 Precio: $2.800.000 COP
📊 Disponibles: X unidades

9. PRODUCTO NO ENCONTRADO

Si el producto no aparece en el catálogo:

"😕 No encuentro ese producto en nuestro catálogo actual de Megatech2.

Si quieres, puedo mostrarte los productos que tenemos disponibles."

10. FOTOS

No muestres URLs de imágenes.

La aplicación se encargará de mostrar las imágenes.

11. DESCRIPCIONES

Si el usuario pregunta por la descripción,
utiliza únicamente la descripción almacenada en el catálogo.

12. FORMATO

Las respuestas deben ser:

- Claras
- Ordenadas
- Cortas
- Profesionales
- Fáciles de leer

No utilices tablas.
No utilices bloques de código.
No utilices listas horizontales.
No utilices "|" para separar información.
No inventes información.

13. INFORMACIÓN DE LA APLICACIÓN

Megatech2 permite:

- Consultar productos.
- Consultar precios.
- Consultar disponibilidad.
- Realizar compras.
- Consultar pedidos.
- Consultar información relacionada con la tienda.

Si el usuario pregunta qué puede hacer en Megatech2,
puedes explicar estas funciones.

Tu objetivo es proporcionar información clara,
ordenada y basada únicamente en los datos reales de Megatech2.
`;

    // 4. Consultar Groq
    const completion = await groq.chat.completions.create({
      model: "openai/gpt-oss-20b",

      messages: [
        {
          role: "system",
          content: systemPrompt,
        },
        {
          role: "user",
          content: mensaje.trim(),
        },
      ],

      temperature: 0.3,

      // Importante para evitar que el razonamiento
      // consuma todo el límite antes de generar la respuesta.
      max_tokens: 1200,

      reasoning_effort: "low",
    });

    let respuestaTexto = completion.choices[0]?.message?.content?.trim();

    // 5. Verificar respuesta de Groq
    if (!respuestaTexto) {
      console.warn("Respuesta vacía de Groq.");

      console.warn("Finish reason:", completion.choices[0]?.finish_reason);

      console.warn("Mensaje:", completion.choices[0]?.message);

      respuestaTexto =
        "😕 No pude generar una respuesta en este momento. Intenta nuevamente.";
    }

    // 6. Guardar conversación
    const registrosAInsertar = [
      {
        sesion_id: idSesionValido,
        usuario_id: usuarioId || null,
        emisor: "user",
        mensaje: mensaje.trim(),
      },
      {
        sesion_id: idSesionValido,
        usuario_id: usuarioId || null,
        emisor: "bot",
        mensaje: respuestaTexto,
      },
    ];

    const { error: errorInsert } = await supabase
      .from("mensajes_chat")
      .insert(registrosAInsertar);

    if (errorInsert) {
      console.error(
        "Error guardando el historial en Supabase:",
        errorInsert.message,
      );
    }

    // 7. Respuesta al frontend
    return res.status(200).json({
      respuesta: respuestaTexto,
      sesionId: idSesionValido,
    });
  } catch (error) {
    console.error("========== ERROR CHAT ==========");

    console.error("Error:", error);

    console.error("Mensaje:", error.message);

    console.error("Respuesta:", error.response?.data);

    console.error("================================");

    return res.status(500).json({
      message: "Error al procesar la respuesta",
      error: error.message,
    });
  }
};

// Obtener historial
export const obtenerHistorialMega = async (req, res) => {
  try {
    const { sesionId } = req.params;

    const { data: historial, error } = await supabase
      .from("mensajes_chat")
      .select("emisor, mensaje, created_at")
      .eq("sesion_id", sesionId)
      .order("created_at", {
        ascending: true,
      });

    if (error) {
      return res.status(500).json({
        message: "Error al consultar historial",
        error: error.message,
      });
    }

    return res.status(200).json({
      historial: historial || [],
    });
  } catch (error) {
    return res.status(500).json({
      message: "Error interno",
      error: error.message,
    });
  }
};
