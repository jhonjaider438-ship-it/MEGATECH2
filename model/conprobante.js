import { supabase } from "../config/supabase.js";

// Registrar comprobante
export const crearComprobante = async (comprobante) => {
    return await supabase
        .from("comprobantes")
        .insert([comprobante])
        .select()
        .single();
};

// Obtener todos los comprobantes
export const obtenerComprobantes = async () => {
    return await supabase
        .from("comprobantes")
        .select(`
            *,
            usuarios (
                id,
                cedula,
                nombre,
                apellido
            ),
            pedidos (
                id,
                estado,
                total
            )
        `)
        .order("fecha", { ascending: false });
};

// Obtener comprobante por pedido
export const obtenerComprobantePorPedido = async (id_pedido) => {
    return await supabase
        .from("comprobantes")
        .select(`
            *,
            usuarios (
                id,
                cedula,
                nombre,
                apellido
            ),
            pedidos (
                id,
                estado,
                total
            )
        `)
        .eq("id_pedido", id_pedido)
        .single();
};

export const obtenerPedidoPorId = async (id) => {
    return await supabase
        .from("pedidos")
        .select("id, id_cliente, estado, total")
        .eq("id", id)
        .single();
};