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