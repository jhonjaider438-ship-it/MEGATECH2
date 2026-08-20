import { supabase } from "../config/supabase.js";


// Obtener todos los pedidos
export const obtenerPedidos = async () => {
    return await supabase
        .from("pedidos")
        .select("*");
};

// Obtener un pedido por ID
export const obtenerPedidoPorId = async (id) => {
    return await supabase
        .from("pedidos")
        .select("*")
        .eq("id", id)
        .single();
};

// Crear pedido
export const crearPedido = async (pedido) => {
    return await supabase
        .from("pedidos")
        .insert([pedido])
        .select();
};

// Actualizar pedido
export const actualizarPedido = async (id, pedido) => {
    return await supabase
        .from("pedidos")
        .update(pedido)
        .eq("id", id)
        .select();
};

// Eliminar pedido
export const eliminarPedido = async (id) => {
    return await supabase
        .from("pedidos")
        .delete()
        .eq("id", id);
};

// Obtener pedidos por cédula del cliente
export const obtenerPedidosPorCedula = async (cedula) => {

    // Primero buscamos el usuario por cédula
    const { data: usuario, error: errorUsuario } = await supabase
        .from("usuarios")
        .select("id")
        .eq("cedula", cedula)
        .single();

    if (errorUsuario) {
        return {
            data: null,
            error: errorUsuario
        };
    }

    // Después buscamos los pedidos usando el id del cliente
    const { data, error } = await supabase
        .from("pedidos")
        .select("*")
        .eq("id_cliente", usuario.id);

    return { data, error };
};