import bcrypt from "bcryptjs";
import jwt from 'jsonwebtoken';
import { crearuser, obtenercorreo } from "../model/usuarios.js";

// registro 
export const registro = async (req, res) => {
    try {
        const {cedula,nombre,apellido,telefono,correo,contraseña} = req.body
        // validar datos
        if (!cedula || !nombre || !apellido || !telefono || !correo || !contraseña) {
            return res.status(400).json({
                error: 'faltan datos'
            });
        }

        // encriptar la contraseña
        const encriptar = await bcrypt.hash(contraseña, 10);
        // rol por defecto
        const rol  = 'Cliente'
        // guardar en la base de datos
        const {data,error} = await crearuser(
            cedula,
            nombre,
            apellido,
            telefono,
            correo,
            encriptar,
            rol
        )
        if (error) {
            return res.status(500).json({
                error: 'error al crear el usuario',
                error
            });
        }

        return res.status(201).json({
            mensagge: 'usuario creado correctamente',
            usuario: {
                id: data[0].id,
                cedula: data[0].cedula,
                nombre: data[0].nombre,
                apellido: data[0].apellido,
                telefono: data[0].telefono,
                correo: data[0].correo,
                rol: data[0].rol,
            }
        });

    } catch (error) {
        console.error('error en el registro:', error);
        return res.status(500).json({
            error: error.mensagge
        });
    }
};

// creamos el login
export const login = async (req, res) => {
    try {
        const {correo,contraseña} = req.body;
        // validar datos
        if (!correo || !contraseña) {
             return res.status(400).json({
                error: 'todos los datos son requeridos'
             });
        }

        // validamos si el email existe
        const  {data: usuario} = await obtenercorreo(correo);
        if (!usuario) {
            return res.status(400).json({
                error: 'email no registrado'
            });  
        }

        // verificar la contraseña
        const pasworvalida = await bcrypt.compare(contraseña, usuario.contraseña);
        if (!pasworvalida) {
            return res.status(400).json({
                error: 'contraeña incorrecta'
            });
        }

        // genera un token
        const token = jwt.sign(
            {
                id: usuario.id,
                correo: usuario.correo,
                rol: usuario.rol
            },
            process.env.JWT_SECRET,
            {expiresIn: '1h'}
        );
        return res.status(200).json({
            mesaggen: 'login exitoso',
            token
        });
    } catch (error) {
        console.error('error en el login:', error);
        return res.status(500).json({
            error: error.message
        });
    }
}