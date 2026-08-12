import { obtenerPedidos,obtenerPedidoPorId,crearPedido,actualizarPedido,eliminarPedido, obtenerPedidosPorCedula } from "../model/pedidos.js";
import { porid as UserModel } from "../model/usuarios.js";
import {crearDetalle} from "../model/detalle_pedido.js";
import { actualizarStock } from "../model/productos.js";
import {enviarconfirmacionpedido} from "../utils/sendemail.js";
import { supabase } from "../config/supabase.js";


// Obtener todos
export const obtener = async (req, res) => {

    const { data, error } = await obtenerPedidos();

    if (error) {
        return res.status(500).json(error);
    }

    res.json(data);
};


// Obtener por ID
export const obtenerPorId = async (req, res) => {

    const { id } = req.params;

    const { data, error } = await obtenerPedidoPorId(id);

    if (error) {
        return res.status(404).json(error);
    }

    res.json(data);
};


export const crear = async (req, res) => {

    const { estado, total, id_cliente, productos } = req.body;


    if (!productos || productos.length === 0) {
        return res.status(400).json({
            mensaje:"Debe enviar productos"
        });
    }


    // Validar stock antes de crear pedido

    for (const producto of productos) {


        const { data: productoActual, error } = await supabase
            .from("productos")
            .select("stock")
            .eq("id", producto.id_producto)
            .single();



        if(error){
            return res.status(500).json(error);
        }



        // Verificar si hay suficiente stock

        if(productoActual.stock < producto.cantidad){

            return res.status(400).json({
                mensaje:`No hay suficiente stock para el producto ${producto.id_producto}`
            });

        }

    }



    // Calcular total

    const totalCalculado = productos.reduce(
        (total, producto) => 
            total + (producto.cantidad * producto.precio_unitario),
        0
    );



    // Crear pedido

    const { data: pedido, error } = await crearPedido({

        fecha: new Date(),

        estado,

        total: totalCalculado,

        id_cliente

    });



    if(error){
        return res.status(500).json(error);
    }



    const idPedido = pedido[0].id;



    // Crear detalle pedido

    const detalles = productos.map(producto => ({

        id_pedido:idPedido,

        id_producto:producto.id_producto,

        cantidad:producto.cantidad,

        precio_unitario:producto.precio_unitario,

        subtotal:producto.cantidad * producto.precio_unitario

    }));



    const { data: detalle, error:errorDetalle } = await crearDetalle(detalles);



    if(errorDetalle){

        return res.status(500).json({
            mensaje:"No se pudo crear el detalle del pedido",
            error:errorDetalle
        });

    }



    // Descontar stock

    for (const producto of productos) {


        const { data: productoActual } = await supabase
            .from("productos")
            .select("stock")
            .eq("id", producto.id_producto)
            .single();



        const nuevoStock = productoActual.stock - producto.cantidad;



        await actualizarStock(
            producto.id_producto,
            nuevoStock
        );

    }



    res.status(201).json({

        mensaje:"Pedido y detalle creados correctamente",

        pedido,

        detalle

    });

};


// Actualizar
export const actualizar = async (req, res) => {

    const { id } = req.params;

    const { data, error } = await actualizarPedido(
        id,
        req.body
    );


    if (error) {
        return res.status(500).json(error);
    }

    res.json(data);
};



// Eliminar
export const eliminar = async (req, res) => {

    const { id } = req.params;

    const { error } = await eliminarPedido(id);


    if (error) {
        return res.status(500).json(error);
    }


    res.json({
        mensaje: "Pedido eliminado correctamente"
    });
};

export const pedidosPorCedula = async (req, res) => {

    try {

        const { cedula } = req.params;

        const pedidos = await obtenerPedidosPorCedula(cedula);

        res.status(200).json(pedidos);

    } catch (error) {

        res.status(500).json({
            error: error.message
        });

    }

};