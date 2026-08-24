import { obtenerPedidos,obtenerPedidoPorId,crearPedido,actualizarPedido,eliminarPedido, obtenerPedidosPorCedula } from "../model/pedidos.js";
import { porid as UserModel } from "../model/usuarios.js";
import {crearDetalle} from "../model/detalle_pedido.js";
import { actualizarStock } from "../model/productos.js";
import {enviarconfirmacionpedido} from "../utils/sendemail.js";
import { supabase } from "../config/supabase.js";

// Formatear fecha y hora de Bogotá
const formatearFechaBogota = (fecha) => {

    return new Date(`${fecha}Z`).toLocaleString("es-CO", {
        timeZone: "America/Bogota",
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        hour12: true
    });

};

export const obtener = async (req, res) => {

    const { data, error } = await obtenerPedidos();

    if (error) {
        return res.status(500).json(error);
    }

    const pedidosFormateados = data.map(pedido => ({
        ...pedido,
        fecha_formateada: formatearFechaBogota(pedido.fecha)
    }));

    res.json(pedidosFormateados);
};


export const obtenerPorId = async (req, res) => {

    const { id } = req.params;

    const { data, error } = await obtenerPedidoPorId(id);

    if (error) {
        return res.status(404).json(error);
    }

    const pedidoFormateado = {
        ...data,
        fecha_formateada: formatearFechaBogota(data.fecha)
    };

    res.json(pedidoFormateado);
};


export const crear = async (req, res) => {

    const {  id_cliente, productos } = req.body;

      // VALIDAR QUE EL CLIENTE EXISTA

    if (!id_cliente) {
        return res.status(400).json({
            mensaje: "Debe enviar el id del cliente"
        });
    }


    const { data: cliente, error: errorCliente } = await supabase
        .from("usuarios")
        .select("*")
        .eq("id", id_cliente)
        .single();


    if (errorCliente || !cliente) {
        return res.status(404).json({
            mensaje: "El cliente no existe"
        });
    }

         // VALIDAR PRODUCTOS

    if (!productos || productos.length === 0) {
        return res.status(400).json({
            mensaje:"Debe enviar productos"
        });
    }   



    // Validar stock antes de crear pedido

   for (const producto of productos) {

    const { data: productoActual, error } = await supabase
        .from("productos")
        .select("*")
        .eq("id", producto.id_producto)
        .single();


    // 1. VALIDAR QUE EL PRODUCTO EXISTA

    if (error || !productoActual) {

        return res.status(404).json({
            mensaje: `El producto ${producto.id_producto} no existe`
        });

    }


    // 2. VALIDAR CANTIDAD

    if (producto.cantidad <= 0) {

        return res.status(400).json({
            mensaje: `La cantidad del producto ${producto.id_producto} debe ser mayor que 0`
        });

    }


    // 3. VALIDAR PRECIO

    if (producto.precio_unitario <= 0) {

        return res.status(400).json({
            mensaje: `El precio del producto ${producto.id_producto} debe ser mayor que 0`
        });

    }


    // 4. VALIDAR STOCK

    if (productoActual.stock < producto.cantidad) {

        return res.status(400).json({
            mensaje: `No hay suficiente stock para el producto ${producto.id_producto}`,
            stockDisponible: productoActual.stock,
            cantidadSolicitada: producto.cantidad
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

        estado: 'Por pagar',

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

    const fechaFormateada = new Date(pedido[0].fecha).toLocaleString("es-CO", {
    timeZone: "America/Bogota",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: true
});

    const pedidoFormateado = {
    ...pedido[0],
    fecha_formateada: formatearFechaBogota(pedido[0].fecha)
    };
    res.status(201).json({

    mensaje: "Pedido y detalle creados correctamente",

    pedido: pedidoFormateado,

    detalle

});

};


// Actualizar
export const actualizar = async (req, res) => {

    try {

        const { id } = req.params;
        const { estado } = req.body;


        // ==========================================
        // VALIDAR ESTADO
        // ==========================================

        const estadosValidos = [
            "Por pagar",
            "Por entregar",
            "Entregado"
        ];


        if (!estado) {

            return res.status(400).json({
                mensaje: "Debe enviar el estado"
            });

        }


        if (!estadosValidos.includes(estado)) {

            return res.status(400).json({
                mensaje: "Estado no válido",
                estadosPermitidos: estadosValidos
            });

        }


        // ==========================================
        // BUSCAR EL PEDIDO
        // ==========================================

        const {
            data: pedidoActual,
            error: errorPedido
        } = await obtenerPedidoPorId(id);


        if (errorPedido || !pedidoActual) {

            return res.status(404).json({
                mensaje: "El pedido no existe"
            });

        }
         // ESTADO ACTUAL

        const estadoActual = pedidoActual.estado;


        // ==========================================
        // VALIDAR FLUJO
        // ==========================================

        if (
            estadoActual === "Por pagar" &&
            estado !== "Por entregar"
        ) {

            return res.status(400).json({
                mensaje:
                    "Un pedido Por pagar solamente puede pasar a Por entregar"
            });

        }


        if (
            estadoActual === "Por entregar" &&
            estado !== "Entregado"
        ) {

            return res.status(400).json({
                mensaje:
                    "Un pedido Por entregar solamente puede pasar a Entregado"
            });

        }


        if (estadoActual === "Entregado") {

            return res.status(400).json({
                mensaje:
                    "Un pedido Entregado no puede cambiar de estado"
            });

        }


        // ==========================================
        // ACTUALIZAR ESTADO
        // ==========================================

        const {data,error} = await actualizarPedido(
            id,
            {estado: estado});


        if (error) {

            return res.status(500).json({
                mensaje: "Error al actualizar el pedido",
                error
            });

        }


        // ==========================================
        // ENVIAR CORREO
        // ==========================================

        if (estado === "Por entregar") {

            const idCliente = pedidoActual.id_cliente;


            // Buscar cliente

            const {
                data: cliente,
                error: errorCliente
            } = await UserModel(idCliente);


            if (errorCliente || !cliente) {

                return res.status(404).json({
                    mensaje: "El pedido se actualizó, pero no se encontró el cliente"
                });

            }


            // Enviar correo

            const resultadoCorreo =
                await enviarconfirmacionpedido(
                    cliente.correo,
                    cliente.nombre,
                    id,
                    pedidoActual.total
                );


            if (!resultadoCorreo.success) {

                return res.status(500).json({
                    mensaje: "El pedido se actualizó, pero no se pudo enviar el correo",
                    error: resultadoCorreo.error
                });

            }

        }


        // ==========================================
        // RESPUESTA
        // ==========================================

        return res.status(200).json({

            mensaje: "Pedido actualizado correctamente",

            pedido: data

        });


    } catch (error) {

        return res.status(500).json({

            mensaje: "Error interno del servidor",

            error: error.message

        });

    }

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

        if (!cedula) {
            return res.status(400).json({
                mensaje: "Debe enviar la cédula"
            });
        }

        const { data, error } = await obtenerPedidosPorCedula(cedula);

        if (error) {
            return res.status(404).json({
                mensaje: "No se encontraron pedidos para esta cédula",
                error: error.message
            });
        }

        return res.status(200).json(data);

    } catch (error) {

        return res.status(500).json({
            mensaje: "Error interno del servidor",
            error: error.message
        });

    }

};