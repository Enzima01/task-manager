--*******************************--
--=== TASK MANAGER ===--
--=== Enzo Henrique Favaro ===--
--*******************************--

--*********************--
--=== PACKAGE SPEC ===--
--*********************--
/*

  tm_ = task manager
  _k = package
  _p = procedure
  _f = function
  v_ = variable
  p_ = parameter
  ex_ = exception
  
*/

CREATE OR REPLACE PACKAGE TM_USERS_K AS

   PROCEDURE TM_CREATE_USER_P(P_NAME      IN VARCHAR2,
                              P_EMAIL     IN VARCHAR2,
                              P_JOB_TITLE IN VARCHAR2);

END TM_USERS_K;
/

--*********************--
--=== PACKAGE BODY ===--
--*********************--

CREATE OR REPLACE PACKAGE BODY TM_USERS_K AS

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
         INSERT INTO TM_USERS_T
            (ID_USER,
             NAME_USER,
             EMAIL_USER,
             JOB_TITLE_USER)
         VALUES
            (TM_USERS_S.NEXTVAL,
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

END TM_USERS_K;
/
