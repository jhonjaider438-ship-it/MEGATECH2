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
            id,
            id_pedido,
            id_cliente,
            fecha,
            foto,

            usuarios (
                id,
                cedula,
                nombre,
                apellido,
                telefono,
                correo
            ),

            pedidos (
                id,
                fecha,
                estado,
                total,
                id_cliente,

                detalle_pedido (
                    id,
                    id_pedido,
                    id_producto,
                    cantidad,
                    precio_unitario,
                    subtotal,

                    productos (
                        id,
                        nombre,
                        descripcion,
                        precio,
                        stock,
                        foto,
                        id_subcategoria,

                        subcategorias (
                            id,
                            nombre,
                            id_categoria,

                            categorias (
                                id,
                                nombre_categoria
                            )
                        )
                    )
                )
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