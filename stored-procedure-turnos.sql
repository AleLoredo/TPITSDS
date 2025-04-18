-- Procedimiento: Turnos disponibles en una fecha determinada
-- ejemplo llamada
-- CALL sp_turnos_disponibles_dia('2025-04-21', 1, 2);
DELIMITER $$

CREATE PROCEDURE sp_turnos_disponibles_dia (
    IN p_fecha DATE,
    IN p_idprofesional INT,
    IN p_idservicio INT
)
BEGIN
  WITH horarios AS (
    SELECT 
      s.duracionturno,
      CASE DAYOFWEEK(p_fecha)
        WHEN 2 THEN apr.lun
        WHEN 3 THEN apr.mar
        WHEN 4 THEN apr.mie
        WHEN 5 THEN apr.jue
        WHEN 6 THEN apr.vie
        WHEN 7 THEN apr.sab
        WHEN 1 THEN apr.dom
      END AS trabaja,
      
      CASE DAYOFWEEK(p_fecha)
        WHEN 2 THEN apr.hora_init_lun
        WHEN 3 THEN apr.hora_init_mar
        WHEN 4 THEN apr.hora_init_mie
        WHEN 5 THEN apr.hora_init_jue
        WHEN 6 THEN apr.hora_init_vie
        WHEN 7 THEN apr.hora_init_sab
        WHEN 1 THEN apr.hora_init_dom
      END AS hora_inicio,

      CASE DAYOFWEEK(p_fecha)
        WHEN 2 THEN apr.hora_fin_lun
        WHEN 3 THEN apr.hora_fin_mar
        WHEN 4 THEN apr.hora_fin_mie
        WHEN 5 THEN apr.hora_fin_jue
        WHEN 6 THEN apr.hora_fin_vie
        WHEN 7 THEN apr.hora_fin_sab
        WHEN 1 THEN apr.hora_fin_dom
      END AS hora_fin
    FROM AgendaProRegular apr
    JOIN Servicios s ON s.idservicio = apr.idservicio
    WHERE apr.idprofesional = p_idprofesional AND apr.idservicio = p_idservicio
  ),
  excepciones AS (
    SELECT 
      hora_inicio AS excep_inicio,
      hora_fin AS excep_fin
    FROM AgendaProfExcep
    WHERE idprofesional = p_idprofesional
      AND idservicio = p_idservicio
      AND p_fecha BETWEEN dia_inicio AND dia_fin
  ),
  secuencia AS (
    SELECT 0 AS n
    UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
    UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16
    UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
  )
  SELECT 
    ADDTIME(h.hora_inicio, SEC_TO_TIME(s.n * h.duracionturno * 60)) AS turno_disponible
  FROM horarios h
  JOIN secuencia s ON ADDTIME(h.hora_inicio, SEC_TO_TIME(s.n * h.duracionturno * 60)) < h.hora_fin
  LEFT JOIN excepciones e 
    ON ADDTIME(h.hora_inicio, SEC_TO_TIME(s.n * h.duracionturno * 60)) BETWEEN e.excep_inicio AND SUBTIME(e.excep_fin, SEC_TO_TIME(h.duracionturno * 60))
  WHERE h.trabaja = TRUE AND e.excep_inicio IS NULL;
END$$

-- Procedimiento: Primer turno disponible más próximo para cada profesional en un servicio
-- ejemplo llamada: CALL sp_primer_turno_disponible_por_profesional(2);

CREATE PROCEDURE sp_primer_turno_disponible_por_profesional (
    IN p_idservicio INT
)
BEGIN
  WITH RECURSIVE dias AS (
    SELECT CURRENT_DATE AS fecha
    UNION ALL
    SELECT fecha + INTERVAL 1 DAY FROM dias WHERE fecha < CURRENT_DATE + INTERVAL 14 DAY
  ),
  turnos_potenciales AS (
    SELECT 
      d.fecha,
      apr.idprofesional,
      s.idservicio,
      s.duracionturno,

      CASE DAYOFWEEK(d.fecha)
        WHEN 2 THEN apr.lun
        WHEN 3 THEN apr.mar
        WHEN 4 THEN apr.mie
        WHEN 5 THEN apr.jue
        WHEN 6 THEN apr.vie
        WHEN 7 THEN apr.sab
        WHEN 1 THEN apr.dom
      END AS trabaja,

      CASE DAYOFWEEK(d.fecha)
        WHEN 2 THEN apr.hora_init_lun
        WHEN 3 THEN apr.hora_init_mar
        WHEN 4 THEN apr.hora_init_mie
        WHEN 5 THEN apr.hora_init_jue
        WHEN 6 THEN apr.hora_init_vie
        WHEN 7 THEN apr.hora_init_sab
        WHEN 1 THEN apr.hora_init_dom
      END AS hora_inicio,

      CASE DAYOFWEEK(d.fecha)
        WHEN 2 THEN apr.hora_fin_lun
        WHEN 3 THEN apr.hora_fin_mar
        WHEN 4 THEN apr.hora_fin_mie
        WHEN 5 THEN apr.hora_fin_jue
        WHEN 6 THEN apr.hora_fin_vie
        WHEN 7 THEN apr.hora_fin_sab
        WHEN 1 THEN apr.hora_fin_dom
      END AS hora_fin
    FROM dias d
    JOIN AgendaProRegular apr ON 1=1
    JOIN Servicios s ON s.idservicio = apr.idservicio
    WHERE s.idservicio = p_idservicio
  ),
  bloques_horarios AS (
    SELECT
      tp.fecha,
      tp.idprofesional,
      tp.idservicio,
      ADDTIME(tp.hora_inicio, SEC_TO_TIME(tp.duracionturno * seq.numero * 60)) AS horario
    FROM turnos_potenciales tp
    JOIN (
      SELECT 0 AS numero
      UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
      UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
      UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16
      UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    ) AS seq
    WHERE tp.trabaja = TRUE
      AND ADDTIME(tp.hora_inicio, SEC_TO_TIME(tp.duracionturno * seq.numero * 60)) < tp.hora_fin
  ),
  turnos_validos AS (
    SELECT
      bh.idprofesional,
      bh.idservicio,
      bh.fecha,
      bh.horario
    FROM bloques_horarios bh
    LEFT JOIN AgendaProfExcep ape ON 
      ape.idprofesional = bh.idprofesional 
      AND ape.idservicio = bh.idservicio
      AND bh.fecha BETWEEN ape.dia_inicio AND ape.dia_fin
      AND bh.horario >= ape.hora_inicio AND bh.horario < ape.hora_fin
    WHERE ape.idprofesional IS NULL
  )
  SELECT
    tv.idprofesional,
    tv.idservicio,
    MIN(CONCAT(tv.fecha, ' ', tv.horario)) AS primer_turno_disponible
  FROM turnos_validos tv
  GROUP BY tv.idprofesional, tv.idservicio
  ORDER BY tv.primer_turno_disponible;
END$$

DELIMITER ;
