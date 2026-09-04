import {obtenerProductos,obtenerProductoPorId,crearProducto,actualizarProducto,eliminarProducto, contarProductosBajoStock } from "../model/productos.js";
import { obtenerAdminsYEmpleados } from "../model/usuarios.js";
import { enviarAlertaStock } from '../utils/sendemail.js';
import { cloudinary } from "../config/claudinary.js";

// Helper: sube un buffer a Cloudinary usando upload_stream
const subirImagenCloudinary = (buffer, folder = "productos") => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder },
      (error, result) => {
        if (error) return reject(error);
        resolve(result.secure_url);
      }
    );
    stream.end(buffer);
  });
};

// GET
export const listarProductos = async (req, res) => {
    const { data, error } = await obtenerProductos();

    if (error) {
        return res.status(500).json({ error: error.message });
    }

    res.json(data);
};

// GET por ID
export const obtenerProducto = async (req, res) => {
    const { id } = req.params;

    const { data, error } = await obtenerProductoPorId(id);

    if (error) {
        return res.status(404).json({ error: error.message });
    }

    res.json(data);
};

// POST
export const crear = async (req, res) => {
    try {
        const nuevoProducto = { ...req.body };

        if (req.file) {
            try {
                nuevoProducto.imagen = await subirImagenCloudinary(req.file.buffer);
            } catch (cloudinaryError) {
                console.error("Error subiendo imagen a Cloudinary:", cloudinaryError);
                return res.status(500).json({
                    error: "Error al subir la imagen a Cloudinary.",
                    detalle: cloudinaryError.message || cloudinaryError
                });
            }
        }

        const { data, error } = await crearProducto(nuevoProducto);

        if (error) {
            return res.status(400).json({ error: error.message });
        }

        res.status(201).json(data);
    } catch (error) {
        console.error("ERROR AL CREAR PRODUCTO:", error);
        res.status(500).json({
            error: "Error al crear el producto.",
            detalle: error.message || error
        });
    }
};

// PUT
export const actualizar = async (req, res) => {
    try {
        const { id } = req.params;
        const cambios = { ...req.body };

        if (req.file) {
            try {
                cambios.imagen = await subirImagenCloudinary(req.file.buffer);
            } catch (cloudinaryError) {
                console.error("Error subiendo imagen a Cloudinary:", cloudinaryError);
                return res.status(500).json({
                    error: "Error al subir la imagen a Cloudinary.",
                    detalle: cloudinaryError.message || cloudinaryError
                });
            }
        }

        const { data, error } = await actualizarProducto(id, cambios);

        if (error) {
            return res.status(400).json({ error: error.message });
        }

        // Verificar si el producto quedó con poco stock
        await verificarStock(data);

        res.json(data);
    } catch (error) {
        console.error("ERROR AL ACTUALIZAR PRODUCTO:", error);
        res.status(500).json({
            error: "Error al actualizar el producto.",
            detalle: error.message || error
        });
    }
};

// DELETE
export const eliminar = async (req, res) => {
    const { id } = req.params;

    const { error } = await eliminarProducto(id);

    if (error) {
        return res.status(400).json({ error: error.message });
    }

    res.json({
        mensaje: "Producto eliminado correctamente"
    });
};

export const verificarStock = async (producto) => {

    if (producto.stock <= 5) {

        const { data: usuarios } = await obtenerAdminsYEmpleados();

        for (const usuario of usuarios) {

            await enviarAlertaStock(
                usuario.correo,
                usuario.nombre,
                producto.nombre,
                producto.stock,
                producto.descripcion
            );

        }

    }

};

export const bajoStock = async (req, res) => {
    const { count, error } = await contarProductosBajoStock();

    if (error) {
        return res.status(500).json({ error: error.message });
    }

    res.json({ total: count });
};