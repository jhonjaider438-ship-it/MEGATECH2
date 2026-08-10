import { supabase } from "../config/supabase.js";

// crear una venta 
export const crearVenta = async (venta) => {
    return await supabase
        .from("ventas")
        .insert([venta])
        .select()
        .single();
};

// Crear detalle de venta
export const crearDetalleVenta = async (detalles) => {
    return await supabase
        .from("detalle_venta")
        .insert(detalles)
        .select();
};

// Obtener producto por id
export const obtenerProducto = async (id) => {
    return await supabase
        .from("productos")
        .select("*")
        .eq("id", id)
        .single();
};

// Actualizar stock
export const actualizarStock = async (id, stock) => {
    return await supabase
        .from("productos")
        .update({ stock })
        .eq("id", id)
        .select();
};

// Buscar usuario
export const obtenerUsuarioporid = async (id) => {
    return await supabase
        .from("usuarios")
        .select("*")
        .eq("id", id)
        .single();
};

// Obtener compras de un cliente por ID
export const obtenerComprasPorCliente = async (id_cliente) => {
    return await supabase
        .from("ventas")
        .select(`
            *,
            detalle_venta (
                *,
                productos (
                    nombre,
                    precio,
                    foto
                )
            )
        `)
        .eq("id_cliente", id_cliente)
        .order("fecha", { ascending: false });
};

// Buscar usuario por cédula
export const obtenerUsuarioPorCedula = async (cedula) => {
    return await supabase
        .from("usuarios")
        .select("*")
        .eq("cedula", cedula)
        .single();
};

// Obtener todas las ventas
export const obtenerVentas = async () => {
    return await supabase
        .from("ventas")
        .select(`
            *,
            detalle_venta (
                *,
                productos (
                    nombre,
                    precio,
                    foto
                )
            )
        `)
        .order("fecha", { ascending: false });
};


// Obtener ventas realizadas por un vendedor
export const obtenerVentasPorVendedor = async (id_vendedor) => {
    return await supabase
        .from("ventas")
        .select(`
            *,
            detalle_venta (
                *,
                productos (
                    nombre,
                    precio,
                    foto
                )
            )
        `)
        .eq("id_vendedor", id_vendedor)
        .order("fecha", { ascending: false });
};


// Obtener una venta por ID
export const obtenerVentaPorId = async (id) => {
    return await supabase
        .from("ventas")
        .select(`
            *,
            detalle_venta (
                *,
                productos (
                    nombre,
                    precio,
                    foto
                )
            )
        `)
        .eq("id", id)
        .single();
};

// Obtener detalles de una venta
export const obtenerDetallesVenta = async (id_venta) => {
    return await supabase
        .from("detalle_venta")
        .select("*")
        .eq("id_venta", id_venta);
};

// Eliminar detalles de una venta
export const eliminarDetallesVenta = async (id_venta) => {
    return await supabase
        .from("detalle_venta")
        .delete()
        .eq("id_venta", id_venta);
};

// Eliminar una venta
export const eliminarVenta = async (id) => {
    return await supabase
        .from("ventas")
        .delete()
        .eq("id", id);
};

// Obtener reporte de ventas
export const obtenerReporteVentas = async (fechaInicio, fechaFin) => {
    return await supabase
        .from("ventas")
        .select(`
            id,
            fecha,
            total,
            id_cliente,
            id_vendedor,

            usuarios!ventas_id_vendedor_fkey (
                id,
                cedula,
                nombre,
                apellido,
                rol
            ),

            detalle_venta (
                id,
                cantidad,
                precio_unitario,
                subtotal,
                id_producto,

                productos (
                    id,
                    nombre,
                    precio,
                    stock,
                    id_subcategoria,

                    subcategorias (
                        id,
                        nombre,

                        categorias (
                            id,
                            nombre_categoria
                        )
                    )
                )
            )
        `)
        .gte("fecha", fechaInicio)
        .lte("fecha", fechaFin)
        .order("fecha", { ascending: false });
};
