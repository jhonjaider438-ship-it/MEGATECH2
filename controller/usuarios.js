import { json } from "express";
import { UserModel, porid, actualizar, eliminar } from "../model/usuarios.js";
import bcrypt from "bcryptjs";

// obtenertodos los usuarios
export const obteneruser = async (req, res) => {
    try {
        const {data, error} = await UserModel.obtenertodos();
        if (error) {
            return res.status(500),json({
                error: error.message
            });
        }
    } catch (error) {
        console.error('Error al obtener usuarios', error);
        return res.status(500).json({
            error: error.message
        });
    }
};

// obtener usuario por id
export const buscarporid = async (req, res) => {
    try {
        const {id} = req.params;
        const {data,error} = await porid(id);
        if (error || !data) {
            return res.status(404).json({error: error.message});
        }
        return res.status(200).json({
            usuarios: data
        });
    } catch (error) {
        console.error('error al obtener usuario', error);
        return res.status(500).json({error: error.message});
    }
};

// actualizar usuarios
export const actualizaruser = async (req, res) => {
    try {
        const {id} = req.params;
        const campos = req.body
        // encriptar la contraseña
        if (campos.contraseña) {
            campos.contraseña = await bcrypt.hash(campos.contraseña, 10);
        }
        const {data,error} = await actualizar(id, campos);

        if (error || !data) {
            return res.status(404).json({
                error: error?.message || 'usuario no entontrado'
            });
        }
        return res.status(200).json({
            mensaje: 'usuario actualizado correctamente',
            usuario: data
        });

    } catch (error) {
        console.error('error al actualizar usuario', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// eliminar usuario
export const eliminaruser = async (req, res) => {
    try {
        const {id} = req.params;
        const {data, error} = await eliminar(id);
        if (error || !data) {
            return res.status(404).json({
                error: error?.message || 'usuario no entontrado'
            });
        }
        return res.status(200).json({
            mensaje: 'usuario eliminado correctamente',
            usuario: data
        });

    } catch (error) {
        console.error('error al eliminar usario', errror);
        return res.status(500).json({
            error: error.message
        });
    }
}