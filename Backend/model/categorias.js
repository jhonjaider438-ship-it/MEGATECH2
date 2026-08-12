import { supabase } from "../config/supabase.js";

//obtener todas las categorias 
export const  obtenerCategorias = async () => {
    const { data, error } = await supabase
        .from("categorias")
        .select("*");

    return { data, error };
};

// Crear categoría
export const crearCategoria = async (nombre_categoria) => {
    const { data, error } = await supabase
        .from("categorias")
        .insert([{ nombre_categoria }])
        .select();

    return { data, error };
};

// Obtener por id
export const obtenerCategoriaPorId = async (id) => {
    const { data, error } = await supabase
        .from("categorias")
        .select("*")
        .eq("id", id)
        .single();

    return { data, error };
};

// Actualizar categoría
export const actualizarCategoria = async (id, nombre_categoria) => {
    const { data, error } = await supabase
        .from("categorias")
        .update({ nombre_categoria })
        .eq("id", id)
        .select();

    return { data, error };
};

// Eliminar categoría
export const eliminarCategoria = async (id) => {
    const { data, error } = await supabase
        .from("categorias")
        .delete()
        .eq("id", id);

    return { data, error };
};