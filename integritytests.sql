-- ¿Todos los usuarios tienen su contacto correspondiente?
SELECT s.idusuario
FROM SystemUsers s
LEFT JOIN Contactos c ON s.idcontacto = c.idcontacto
WHERE c.idcontacto IS NULL;

-- ¿Todos los profesionales están activos y tienen al menos un servicio?
SELECT p.idprofesional
FROM Profesionales p
LEFT JOIN ProfServicios ps ON p.idprofesional = ps.idprofesional
WHERE ps.idservicio IS NULL OR p.activo = 0;
