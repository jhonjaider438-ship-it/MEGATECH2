import { supabase } from "../config/supabase.js";


// Obtener todos los detalles
export const obtenerDetalles = async () => {

    return await supabase
        .from("detalle_pedido")
        .select("*");

};


// Obtener detalle por ID
export const obtenerDetallePorId = async (id) => {

    return await supabase
        .from("detalle_pedido")
        .select("*")
        .eq("id", id)
        .single();

};


// Obtener detalles de un pedido
export const obtenerDetallesPorPedido = async (id_pedido) => {

    return await supabase
        .from("detalle_pedido")
        .select("*")
        .eq("id_pedido", id_pedido);

};



// Crear detalle
export const crearDetalle = async (detalles) => {

    return await supabase
        .from("detalle_pedido")
        .insert(detalles)
        .select();

};



// Actualizar detalle
export const actualizarDetalle = async (id, detalle) => {

    return await supabase
        .from("detalle_pedido")
        .update(detalle)
        .eq("id", id)
        .select();

};



// Eliminar detalle
export const eliminarDetalle = async (id) => {

    return await supabase
        .from("detalle_pedido")
        .delete()
        .eq("id", id);

};
