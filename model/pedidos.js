import { supabase } from "../config/supabase.js";
import { buscarPorCedula } from '../model/usuarios.js'


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

export const obtenerPedidosPorCedula = async (cedula) => {

    // Buscar el usuario
    const usuario = await buscarPorCedula(cedula);

    if (!usuario) {
        throw new Error("Usuario no encontrado");
    }

    // Buscar sus pedidos
    const { data, error } = await supabase
        .from("pedidos")
        .select("*")
        .eq("id_cliente", usuario.id);

    if (error) throw error;

    return data;
};