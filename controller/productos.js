import {obtenerProductos,obtenerProductoPorId,crearProducto,actualizarProducto,eliminarProducto } from "../model/productos.js";
import { obtenerAdminsYEmpleados } from "../model/usuarios.js";
import { enviarAlertaStock } from '../utils/sendemail.js';

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
    const { data, error } = await crearProducto(req.body);

    if (error) {
        return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
};

// PUT
export const actualizar = async (req, res) => {
    const { id } = req.params;

    const { data, error } = await actualizarProducto(id, req.body);

    if (error) {
        return res.status(400).json({ error: error.message });
    }

    // Verificar si el producto quedó con poco stock
    await verificarStock(data);

    res.json(data);
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

}