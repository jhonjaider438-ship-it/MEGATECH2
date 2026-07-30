import { supabase } from "../config/supabase.js";

// Obtener todos los productos
export const obtenerProductos = async () => {
    return await supabase
        .from("productos")
        .select(`
            *,
            subcategorias(nombre)
        `);
};

// Obtener un producto por id
export const obtenerProductoPorId = async (id) => {
    return await supabase
        .from("productos")
        .select(`
            *,
            subcategorias(nombre)
        `)
        .eq("id", id)
        .single();
};

// Crear producto
export const crearProducto = async (producto) => {
    return await supabase
        .from("productos")
        .insert([producto])
        .select()
        .single();
};

// Actualizar producto
export const actualizarProducto = async (id, producto) => {
    return await supabase
        .from("productos")
        .update(producto)
        .eq("id", id)
        .select()
        .single();
};

// Eliminar producto
export const eliminarProducto = async (id) => {
    return await supabase
        .from("productos")
        .delete()
        .eq("id", id);
};