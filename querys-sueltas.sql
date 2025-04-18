-- TRAER DATOS Y FICHA MEDICA DE UN CONTACTO

SELECT 
    c.idcontacto,
    c.nombre,
    c.apellido,
    c.docum,
    c.tipodoc,
    c.fechanacim,
    c.telocontacto,
    c.telemergencia,
    c.correo,
    c.direccion,
    fm.idficha,
    fm.gruposang,
    fm.cobertura,
    fm.histenfermflia,
    fm.observficha
FROM 
    Contactos c
LEFT JOIN 
    FichaMedica fm ON c.idcontacto = fm.idcontacto
WHERE 
    c.idcontacto = ?;


-- TRAER HISTORIAL DE ATENCION DE UN CONTACTO 

SELECT 
    t.idturno,
    s.nombreservicio,
    t.dia,
    t.observaciones
FROM 
    Turnos t
JOIN 
    Servicios s ON t.idservicio = s.idservicio
WHERE 
    t.atentido = 1 
    AND t.idcontacto = ?
ORDER BY 
    t.idturno DESC
LIMIT 10;
