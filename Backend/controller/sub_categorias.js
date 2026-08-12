import { obtenerSubcategorias, crearSubcategoria, obtenerSubcategoriaPorId, actualizarSubcategoria, eliminarSubcategoria } from "../model/sub_categorias.js";
  

// Listar
export const lista = async (req, res) => {
    const { data, error } = await obtenerSubcategorias();

    if (error) return res.status(500).json(error);

    res.json(data);
};

// Crear
export const crear = async (req, res) => {
    const { nombre, id_categoria } = req.body;

    const { data, error } = await crearSubcategoria(
        nombre,
        id_categoria
    );

    if (error) return res.status(500).json(error);

    res.status(201).json(data);
};

// Obtener
export const obtener = async (req, res) => {
    const { id } = req.params;

    const { data, error } = await obtenerSubcategoriaPorId(id);

    if (error) return res.status(404).json(error);

    res.json(data);
};

// Actualizar
export const actualizar = async (req, res) => {
    const { id } = req.params;
    const { nombre, id_categoria } = req.body;

    const { data, error } = await actualizarSubcategoria(
        id,
        nombre,
        id_categoria
    );

    if (error) return res.status(500).json(error);

    res.json(data);
};

// Eliminar
export const eliminar = async (req, res) => {
    const { id } = req.params;

    const { data, error } = await eliminarSubcategoria(id);

    if (error) return res.status(500).json(error);

    res.json({
        mensaje: "Subcategoría eliminada",
        data
    });
};