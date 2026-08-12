import { crearComprobante, obtenerComprobantes, obtenerComprobantePorPedidoo, obtenerPedidoPorId } from "../model/conprobante.js";

// Registrar comprobante
export const registrarComprobante = async (req, res) => {
    try {

        const { id_pedido, foto } = req.body;

        if (!id_pedido || !foto) {
            return res.status(400).json({
                error: "Faltan datos para registrar el comprobante."
            });
        }

        // Buscar el pedido
        const { data: pedido, error: errorPedido } =
            await obtenerPedidoPorId(id_pedido);

        if (errorPedido || !pedido) {
            return res.status(404).json({
                error: "El pedido no existe."
            });
        }

        // Obtener automáticamente el cliente del pedido
        const id_cliente = pedido.id_cliente;

        // Crear comprobante
        const { data, error } = await crearComprobante({
            id_pedido,
            id_cliente,
            foto
        });

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        res.status(201).json({
            mensaje: "Comprobante registrado correctamente.",
            comprobante: data
        });

    } catch (error) {

        res.status(500).json({
            error: error.message
        });

    }
};


// Ver todos los comprobantes
export const listarComprobantes = async (req, res) => {
    try {

        const { data, error } = await obtenerComprobantes();

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        res.status(200).json({
            comprobantes: data
        });

    } catch (error) {

        res.status(500).json({
            error: error.message
        });

    }
};


// Ver comprobante de un pedido
export const comprobantePorPedido = async (req, res) => {
    try {

        const { id_pedido } = req.params;

        const { data, error } =
            await obtenerComprobantePorPedidoo(id_pedido);

        if (error || !data) {
            return res.status(404).json({
                error: "No se encontró el comprobante de este pedido."
            });
        }

        res.status(200).json(data);

    } catch (error) {

        res.status(500).json({
            error: error.message
        });

    }
};