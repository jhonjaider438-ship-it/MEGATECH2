import { crearComprobante, obtenerComprobantes, obtenerComprobantePorPedidoo, obtenerPedidoPorId } from "../model/conprobante.js";

// Registrar comprobante vía REST API (Unsigned)
export const registrarComprobante = async (req, res) => {
  try {
    const { id_pedido } = req.body;

    if (!id_pedido || !req.file) {
      return res.status(400).json({
        error: "Faltan datos para registrar el comprobante. Envía id_pedido y la imagen."
      });
    }

    // 1. Validar el pedido en la base de datos
    const { data: pedido, error: errorPedido } = await obtenerPedidoPorId(id_pedido);

    if (errorPedido || !pedido) {
      return res.status(404).json({
        error: "El pedido no existe."
      });
    }

    // 2. Preparar el envío multipart/form-data para Cloudinary
    const formData = new FormData();
    
    // Crear el Blob desde el buffer de multer
    const blob = new Blob([req.file.buffer], { type: req.file.mimetype });
    formData.append("file", blob, req.file.originalname);
    
    // Configurar preset y carpeta
    formData.append("upload_preset", "ml_default"); // Usa el preset que pusiste como 'No firmado'
    formData.append("folder", "comprobantes");

    // 3. Petición HTTP POST directa a la API REST de Cloudinary
    const cloudName = process.env.CLOUDINARY_CLOUD_NAME || "f5akv7vt";
    const response = await fetch(`https://api.cloudinary.com/v1_1/${cloudName}/image/upload`, {
      method: "POST",
      body: formData
    });

    const resultado = await response.json();

    if (!response.ok) {
      console.error("Error respuesta Cloudinary:", resultado);
      return res.status(response.status).json({
        error: "Error de autenticación o configuración en Cloudinary.",
        detalle: resultado
      });
    }

    const foto = resultado.secure_url;
    const id_cliente = pedido.id_cliente;

    // 4. Guardar en Supabase
    const { data, error } = await crearComprobante({
      id_pedido,
      id_cliente,
      foto
    });

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    res.status(201).json({
      mensaje: "Comprobante registrado correctamente.",
      comprobante: data
    });

  } catch (error) {
    console.error("ERROR COMPLETO COMPROBANTE:", error);

    res.status(500).json({
      error: "Error al procesar el comprobante.",
      detalle: error.message || error
    });
  }
};

// Ver todos los comprobantes
export const listarComprobantes = async (req, res) => {
  try {
    const { data, error } = await obtenerComprobantes();

    if (error) return res.status(500).json({ error: error.message });

    res.status(200).json({ comprobantes: data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Ver comprobante de un pedido
export const comprobantePorPedido = async (req, res) => {
  try {
    const { id_pedido } = req.params;
    const { data, error } = await obtenerComprobantePorPedidoo(id_pedido);

    if (error || !data) {
      return res.status(404).json({ error: "No se encontró el comprobante." });
    }

    res.status(200).json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};