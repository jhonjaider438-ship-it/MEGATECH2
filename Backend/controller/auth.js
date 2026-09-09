import bcrypt from "bcryptjs";
import jwt from 'jsonwebtoken';
import { crearuser, obtenercorreo } from "../model/usuarios.js";
import { supabase } from "../config/supabase.js";
import { enviarCodigoVerificacion } from '../utils/emailservices.js';

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
        // VERIFICAR SI EL CORREO YA EXISTE 
        const { data: usuarioExiste } = await obtenercorreo(correo); 
        if (usuarioExiste) 
            { return res.status(400).json({ 
                error: 'el correo ya existe' 
            }); 
        }
       // encriptar la contraseña
        const encriptar = await bcrypt.hash(contraseña, 10);

        // rol por defcto
        const rol = "Cliente";

        // 1. genera codigo de 6 diitos con Math.random() y fecha de expiracion (15 minutos)
        const codigoVerificacion = Math.floor(100000 + Math.random() * 900000).toString();
        const codigoVerificacionExpiracion = new Date(Date.now() + 15 * 60 * 1000); // 15 minutos

        // GUARDAR USUARIO EN SUPABASE 
        const { data, error } = await crearuser( cedula, nombre, apellido, telefono, correo, encriptar, rol, false, codigoVerificacion, codigoVerificacionExpiracion );
        if (error) {
            return res.status(500).json({
                error: 'error al crear el usuario en la base de datos',
                error: error
            });
        }

        // 2. enaviar el correo con el codigo de 6 digitos usando Brevo
        const resultadoEnvio = await enviarCodigoVerificacion(correo, nombre, codigoVerificacion);

        // normalizar el objeto de usuario (soporta formato con o sin .single())
        const usuarioCreado = Array.isArray(data) ? data[0] : data;

        const usuarioRespuesta = {
            id: usuarioCreado.id, 
            cedula: usuarioCreado.cedula, 
            nombre: usuarioCreado.nombre, 
            apellido: usuarioCreado.apellido, 
            telefono: usuarioCreado.telefono, 
            correo: usuarioCreado.correo,
            rol: usuarioCreado.rol
        };

        //3. si Brevo fallo, el usuario ya quedo creado, pero aviamos que el correo no llego
        if (!resultadoEnvio.exito) {
            return res.status(500).json({
                message: 'usuario creado correctamente, pero no se pudo enviar el correo de verificación',
                emailEnviado: false,
                usuario: usuarioRespuesta,
            });
        }
        return res.status(201).json({ 
            message: 'usuario creado correctamente', 
            emailEnviado: true, 
            usuario: usuarioRespuesta 
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
            token,
            usuario: {
                id: usuario.id,
                cedula: usuario.cedula,
                nombre: usuario.nombre,
                apellido: usuario.apellido,
                telefono: usuario.telefono,
                correo: usuario.correo,
                rol: usuario.rol
            }
        });
    } catch (error) {
        console.error('error en el login:', error);
        return res.status(500).json({
            error: error.message
        });
    }
};

// VERIFICAR CUENTA CON CÓDIGO DE 6 DÍGITOS
export const verificarCuenta = async (req, res) => { 
    try { 
        const { correo, codigo } = req.body; 

        // VALIDAR DATOS 
        if (!correo || !codigo) { 
            return res.status(400).json({ 
                error: 'correo y código de verificación son requeridos' 
            }); 
        }
        // BUSCAR USUARIO EN SUPABASE 
        const { data: usuario, error: errorUsuario } = await supabase 
        .from('usuarios') 
        .select( 'id, correo, idVerified, codigoVerificacion, codigoVerificacionExpiracion' ) 
        .eq('correo', correo) 
        .single(); 
        if (errorUsuario || !usuario) { 
            return res.status(404).json({ 
                error: 'usuario no encontrado' 
            }); 
        }
        // REVISAR SI YA ESTÁ VERIFICADA 
        if (usuario.idVerified) { 
            return res.status(400).json({ 
                error: 'la cuenta ya ha sido verificada' 
            }); 
        } 
        // COMPARAR CÓDIGO 
        if ( String(usuario.codigoVerificacion).trim() !== String(codigo).trim() ) { 
            return res.status(400).json({ 
                error: 'código de verificación incorrecto' 
            }); 
        }
        // VALIDAR EXPIRACIÓN DE 15 MINUTOS 
        const ahora = new Date(); 
        const expiracion = new Date(
             usuario.codigoVerificacionExpiracion 
            ); 
            if (ahora > expiracion) {
                 return res.status(400).json({
                     error: 'el código de verificación ha expirado' 
                    }); 
                } 
                // ACTIVAR CUENTA 
                const { error: errorActualizar } = await supabase 
                .from('usuarios') 
                .update({ idVerified: true, codigoVerificacion: null, codigoVerificacionExpiracion: null }) 
                .eq('id', usuario.id); 
                if (errorActualizar) {
                     return res.status(500).json({
                         error: 'error al actualizar el estado de verificación' 
                        }); 
                    } 
                    return res.status(200).json({
                         message: 'cuenta verificada correctamente' 
                        });
                    } catch (error) { 
                        console.error( 
                            'error en la verificación de cuenta:', error );
                             return res.status(500).json({ 
                                error: error.message 
                            }); 
                        } 
 };
