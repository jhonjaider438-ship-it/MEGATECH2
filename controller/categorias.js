import { obtenerCategorias, crearCategoria, obtenerCategoriaPorId, actualizarCategoria, eliminarCategoria } from '../model/categorias.js';

// Obtener todas
export const lista = async (req, res) => {
    const { data, error } = await obtenerCategorias();

    if (error) return res.status(500).json(error);

    res.json(data);
};

// Crear
export const crear = async (req, res) => {
    const { nombre_categoria } = req.body;

    const { data, error } = await crearCategoria(nombre_categoria);

    if (error) return res.status(500).json(error);

    res.status(201).json(data);
};

// Obtener por id
export const obtener = async (req, res) => {
    const { id } = req.params;

    const { data, error } = await obtenerCategoriaPorId(id);

    if (error) return res.status(404).json(error);

    res.json(data);
};

// Actualizar
export const actualizar = async (req, res) => {
    const { id } = req.params;
    const { nombre_categoria } = req.body;

    const { data, error } = await actualizarCategoria(
        id,
        nombre_categoria
    );

    if (error) return res.status(500).json(error);

    res.json(data);
};

// Eliminar
export const eliminar = async (req, res) => {
    const { id } = req.params;

    const { data, error } = await eliminarCategoria(id);

    if (error) return res.status(500).json(error);

    res.json({
        mensaje: "Categoría eliminada",
        data,
    });
};