import { obtenerPedidos,obtenerPedidoPorId,crearPedido,actualizarPedido,eliminarPedido } from "../model/pedidos.js";
import { porid as UserModel } from "../model/usuarios.js";
import {crearDetalle} from "../model/detalle_pedido.js";
import {enviarconfirmacionpedido} from "../utils/sendemail.js";


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


// Crear pedido
export const crear = async (req, res) => {

    const { estado, total, id_cliente, productos } = req.body;

     if (!productos || productos.length === 0) {
        return res.status(400).json({
            mensaje:"Debe enviar productos"
        });
    }

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


    if (error) {
        return res.status(500).json(error);
    }

    // id del pedido creado

    const idPedido = pedido[0].id;

    const detalles = productos.map(producto => ({
        id_pedido: idPedido,
        id_producto: producto.id_producto,
        cantidad: producto.cantidad,
        precio_unitario: producto.precio_unitario,
        subtotal: producto.cantidad * producto.precio_unitario
    }));


    // Obtener información del cliente

    const { data: detalle, error: errorDetalle} = await crearDetalle(detalles);


    if(errorDetalle){

        return res.status(500).json({
            mensaje:"No se pudo crear el detalle del pedido",
            error:errorDetalle
        });

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