CREATE VIEW RH
  AS
   SELECT U.NOME_USER, U.STATUS, MAX(LG.DT_LOGIN), 
      LISTAGG(M.DESCRICAO_MODULO, ' - ' )WITHIN
  GROUP(ORDER BY M.DESCRICAO_MODULO) AS MODULO
     FROM S01USUARIO U,
          S02PERFIL P,
          S05REL_PERFIL_MODULO REL,
          S03DEPARTAMENTO DEP,
          S04MODULO M,
          LOG_USER  LG
    WHERE U.ID_PERFIL = P.ID_PERFIL
      AND P.ID_PERFIL = REL.ID_PERFIL
      AND REL.ID_MODULO = M.ID_MODULO
      AND LG.ID_USUARIO = U.ID_USUARIO
      AND DEP.ID_DEPTO = U.ID_DEPTO
      GROUP BY U.NOME_USER, U.STATUS, LG.DT_LOGIN
      ORDER BY U.NOME_USER;
