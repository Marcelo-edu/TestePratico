DECLARE

  NOME_USUARIO VARCHAR2(30);
  PERFIL       NUMBER(2);
  ID_DEPTO     NUMBER(2);
  CPF          NUMBER(11);
  ACAO         CHAR;
  RETORNO      VARCHAR2(100);
  ID_USUARIO   NUMBER(3);

  /*========================================================
                  CADASTRA OU ALTERA USUARIO
  
  PARA ESSA ACAO, CONSIDERA-SE: A - ATIVO
                                I - INATIVO
                                E - EXCLUIR
  ========================================================*/

  FUNCTION CADASTRA_USUARIO(v_NOME      IN CHAR,
                            V_ID_PERFIL IN NUMBER,
                            V_ID_DEPTO  IN NUMBER,
                            V_CPF       IN INTEGER,
                            V_ACAO      IN CHAR,
                            V_RETORNO   IN OUT VARCHAR2) --IS
  
   RETURN BOOLEAN AS
  
    pCPF S01USUARIO.CPF%TYPE;
  
  BEGIN
  
    IF V_ACAO = 'A' THEN
    
      BEGIN
        SELECT 1 INTO pCPF FROM S01USUARIO WHERE CPF = V_CPF;
      
        IF pCPF = 1 THEN
          DBMS_OUTPUT.PUT_LINE('O USUARIO JA ESTA CADASTRADO');
        END IF;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        
          INSERT INTO S01USUARIO
          VALUES
            (ID_USER.NEXTVAL, v_NOME, V_ID_DEPTO, V_ID_PERFIL, 'A', V_CPF);
        
          V_RETORNO := 'USUARIO CADASTRADO!';
          RETURN TRUE;
        
      END;
    
    ELSIF V_ACAO = 'I' THEN
    
      BEGIN
        SELECT 1
          INTO pCPF
          FROM S01USUARIO
         WHERE CPF = V_CPF
           AND STATUS = 'A';
      
        IF pCPF = 1 THEN
        
          UPDATE S01USUARIO
             SET STATUS = 'I'
           WHERE CPF = V_CPF
             AND STATUS = 'A';
        
          V_RETORNO := 'USUARIO FOI ALTERADO PARA INATIVO!';
          RETURN TRUE;
        
        END IF;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('USUARIO NAO ENCONTRADO OU NAO ESTA ATIVO!!!');
      END;
    
    ELSE
    
      BEGIN
      
        SELECT 1
          INTO pCPF
          FROM S01USUARIO
         WHERE CPF = V_CPF
           AND STATUS IN ('A', 'I');
      
        IF pCPF = 1 THEN
          DELETE FROM S01USUARIO WHERE CPF = V_CPF;
          V_RETORNO := 'USUARIO EXCLUIDO!';
        
          RETURN TRUE;
        END IF;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('USUARIO A SER EXCLUIDO NAO ENCONTRADO!');
        
      END;
    
    END IF;
  
  END;

  /*========================================================
                  LOG USUARIO
  ========================================================*/

  FUNCTION LOGIN(ID_USER NUMBER)
  
   RETURN BOOLEAN AS
  
    V_ID_USER NUMBER;
    V_NOME    VARCHAR2(30);
  
  BEGIN
  
    SELECT ID_USUARIO, NOME_USER
      INTO V_ID_USER, V_NOME
      FROM S01USUARIO
     WHERE ID_USUARIO = ID_USER;
  
    INSERT INTO LOG_USER VALUES (V_ID_USER, V_NOME, SYSDATE);
  
    RETURN TRUE;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('ACESSO NEGADO, USUARIO NAO ENCONTRADO');
      RETURN FALSE;
    
  END LOGIN;

  /*========================================================
                  BLOCO PRINCIPAL
  ========================================================*/

BEGIN

  ID_USUARIO := &ID_USER;

  IF LOGIN(ID_USUARIO) THEN
  
    NOME_USUARIO := 'THEO';
    PERFIL       := 2;
    CPF          := 12345678903;
    ID_DEPTO     := 1;
    ACAO         := 'A';
  
    IF CADASTRA_USUARIO(NOME_USUARIO, PERFIL, ID_DEPTO, CPF, ACAO, RETORNO) THEN
    
      DBMS_OUTPUT.PUT_LINE(RETORNO);
    
    END IF;
  
  END IF; -- LOGIN

EXCEPTION
  WHEN OTHERS THEN
    NULL;
    DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO PRINCIPAL ' || SQLERRM);
  
END;
