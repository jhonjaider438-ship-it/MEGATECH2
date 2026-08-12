import { supabase } from "../config/supabase.js";

// Obtener todas
export const obtenerSubcategorias = async () => {
    const { data, error } = await supabase
        .from("subcategorias")
        .select("*");

    return { data, error };
};

// Crear
export const crearSubcategoria = async (nombre, id_categoria) => {
    const { data, error } = await supabase
        .from("subcategorias")
        .insert([
            {
                nombre,
                id_categoria
            }
        ])
        .select();

    return { data, error };
};

// Obtener por id
export const obtenerSubcategoriaPorId = async (id) => {
    const { data, error } = await supabase
        .from("subcategorias")
        .select("*")
        .eq("id", id)
        .single();

    return { data, error };
};

// Actualizar
export const actualizarSubcategoria = async (id, nombre, id_categoria) => {
    const { data, error } = await supabase
        .from("subcategorias")
        .update({
            nombre,
            id_categoria
        })
        .eq("id", id)
        .select();

    return { data, error };
};

// Eliminar
export const eliminarSubcategoria = async (id) => {
    const { data, error } = await supabase
        .from("subcategorias")
        .delete()
        .eq("id", id);

    return { data, error };
};