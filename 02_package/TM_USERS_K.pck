--*******************************--
--=== TASK MANAGER ===--
--=== Enzo Henrique Favaro ===--
--*******************************--

--*********************--
--=== PACKAGE SPEC ===--
--*********************--
/*

  TM_ = task manager
  _K = package
  _P = procedure
  _F = function
  V_ = variable
  P_ = parameter
  EX_ = exception
  
*/

CREATE OR REPLACE PACKAGE TM_USERS_K AS

   PROCEDURE TM_CREATE_USER_P(P_NAME      IN VARCHAR2,
                              P_EMAIL     IN VARCHAR2,
                              P_JOB_TITLE IN VARCHAR2);
                              
   
   
   PROCEDURE TM_ADD_TO_TEAM_P(P_ID_USER IN NUMBER,
                              P_ID_TEAM IN NUMBER,
                              P_USER_ROLE IN VARCHAR2);
   
   --PROCEDURE TM_DEACTIVE_USER_P(P_ID IN NUMBER);
   
   FUNCTION TM_FIND_USER_BY_EMAIL_F(P_EMAIL IN VARCHAR2) RETURN NUMBER;
                              
   

END TM_USERS_K;
/

--*********************--
--=== PACKAGE BODY ===--
--*********************--

CREATE OR REPLACE PACKAGE BODY TM_USERS_K AS

--=== TM_CREATE_USER_P ===--

   PROCEDURE TM_CREATE_USER_P(P_NAME      IN VARCHAR2,
                              P_EMAIL     IN VARCHAR2,
                              P_JOB_TITLE IN VARCHAR2) IS
   
      V_COUNT_EMAIL NUMBER;
      EX_EMAIL_ALREADY_EXISTS EXCEPTION;
   BEGIN
      SELECT COUNT(*)
        INTO V_COUNT_EMAIL
        FROM TM_USERS_T TMUSERS
       WHERE TMUSERS.EMAIL_USER = P_EMAIL;
   
      IF V_COUNT_EMAIL = 0 THEN
         INSERT INTO TM_USERS_T(ID_USER,
                                NAME_USER,
                                EMAIL_USER,
                                JOB_TITLE_USER) VALUES(TM_USERS_S.NEXTVAL,
                                                       P_NAME,
                                                       P_EMAIL,
                                                       P_JOB_TITLE);
      
         COMMIT;
      ELSE
         RAISE EX_EMAIL_ALREADY_EXISTS;
      END IF;
   EXCEPTION
      WHEN EX_EMAIL_ALREADY_EXISTS THEN
         RAISE_APPLICATION_ERROR(-20001,'The e-mail ('|| P_EMAIL ||') is already being used. Try again!');
   END TM_CREATE_USER_P;
   
--==================================================================================================================--

--=== TM_ADD_TO_TEAM_P ===-- 
 
   PROCEDURE TM_ADD_TO_TEAM_P(P_ID_USER IN NUMBER,
                              P_ID_TEAM IN NUMBER,
                              P_USER_ROLE IN VARCHAR2) IS
   BEGIN
   DBMS_OUTPUT.PUT_LINE('');
                              
   END TM_ADD_TO_TEAM_P;
   
--==================================================================================================================--

--=== TM_CREATE_USER_P ===-- 

--PROCEDURE TM_DEACTIVE_USER_P(P_ID IN NUMBER);

--==================================================================================================================--

--=== TM_FIND_USER_BY_EMAIL_F ===-- 

  FUNCTION TM_FIND_USER_BY_EMAIL_F(P_EMAIL IN VARCHAR2) RETURN NUMBER IS
  
  BEGIN
  
  RETURN 0;
  
  END TM_FIND_USER_BY_EMAIL_F;
  
--==================================================================================================================--  

END TM_USERS_K;
/
