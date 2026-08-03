import {obtenerDetalles,obtenerDetallePorId,obtenerDetallesPorPedido,crearDetalle,actualizarDetalle,eliminarDetalle} from "../model/detalle_pedido.js";


    
// Obtener todos
export const obtener = async (req, res) => {

    const { data, error } = await obtenerDetalles();

    if(error){
        return res.status(500).json(error);
    }

    res.json(data);

};



// Obtener por ID
export const obtenerPorId = async (req,res)=>{

    const { id } = req.params;


    const {data,error} = await obtenerDetallePorId(id);


    if(error){
        return res.status(404).json(error);
    }


    res.json(data);

};



// Obtener detalles de un pedido
export const obtenerPorPedido = async(req,res)=>{

    const { id } = req.params;


    const {data,error} = await obtenerDetallesPorPedido(id);


    if(error){
        return res.status(500).json(error);
    }


    res.json(data);

};



// Crear detalle
export const crear = async(req,res)=>{
    const {
        id_pedido,
        id_producto,
        cantidad,
        precio_unitario,
        subtotal
    } = req.body;
    const {data,error} = await crearDetalle({

        id_pedido,
        id_producto,
        cantidad,
        precio_unitario,
        subtotal

    });



    if(error){
        return res.status(500).json(error);
    }


    res.status(201).json(data);

};




// Actualizar
export const actualizar = async(req,res)=>{


    const {id}=req.params;


    const {data,error}= await actualizarDetalle(
        id,
        req.body
    );


    if(error){
        return res.status(500).json(error);
    }


    res.json(data);

};




// Eliminar
export const eliminar = async(req,res)=>{


    const {id}=req.params;


    const {error}=await eliminarDetalle(id);



    if(error){
        return res.status(500).json(error);
    }


    res.json({
        mensaje:"Detalle eliminado correctamente"
    });

};