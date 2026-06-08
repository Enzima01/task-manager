--*******************************--
--=== TASK MANAGER ===--
--=== Enzo Henrique Favaro ===--
--*******************************--

--=== SCHEMA ===--

/*

  tm_ = task manager
  _t = table
  _s = sequence
  _i = index
  
*/

--*********************--
--=== DOMAIN TABLES ===--
--*********************--

-- STATUS
CREATE TABLE tm_status_t(
  id_status NUMBER PRIMARY KEY,
  desc_status VARCHAR2(30) NOT NULL UNIQUE,
  active_status CHAR(1) DEFAULT 'Y'
);

-- PRIORITIES
CREATE TABLE tm_priorities_t(
  id_priority NUMBER PRIMARY KEY,
  desc_priority VARCHAR2(20) NOT NULL UNIQUE,
  level_priority NUMBER NOT NULL UNIQUE -- represents the level order (1 = low until 4 = critic)
);

--*********************--
--=== MAIN TABLES ===--
--*********************--

-- USERS
CREATE TABLE tm_users_t(
  id_user NUMBER PRIMARY KEY,
  name_user VARCHAR2(255) NOT NULL,
  email_user VARCHAR2(255) NOT NULL UNIQUE,
  job_title_user VARCHAR2(255),
  register_date DATE DEFAULT SYSDATE,
  active CHAR(1) DEFAULT 'Y',
  CONSTRAINT tm_chk_active CHECK (active IN ('Y','N'))
);

-- TEAMS
CREATE TABLE tm_teams_t(
  id_team NUMBER PRIMARY KEY,
  name_team VARCHAR2(255) NOT NULL UNIQUE,
  desc_team VARCHAR2(300),
  creation_date DATE DEFAULT SYSDATE
);

-- TEAM USERS
CREATE TABLE tm_team_users_t(
  id_team_users  NUMBER PRIMARY KEY,
  id_team NUMBER NOT NULL REFERENCES tm_teams_t(id_team),
  id_user NUMBER NOT NULL REFERENCES tm_users_t(id_user),
  user_role VARCHAR2(20) NOT NULL, -- MEMBER or LEADER
  entry_date DATE DEFAULT SYSDATE,
  CONSTRAINT tm_chk_job_title CHECK (job_title IN ('MEMBER','LEADER'))
);

-- PROJECTS
CREATE TABLE tm_projects_t(
  id_project NUMBER PRIMARY KEY,
  name_project VARCHAR2(255) NOT NULL,
  desc_project VARCHAR2(500),
  start_date DATE NOT NULL,
  previous_end_date DATE NOT NULL,
  end_date DATE,
  id_status NUMBER NOT NULL REFERENCES tm_status_t(id_status),
  id_priority NUMBER NOT NULL REFERENCES tm_priorities_t(id_priority),
  id_responsable NUMBER NOT NULL REFERENCES tm_users_t(id_user),
  creation_date  DATE DEFAULT SYSDATE,
  CONSTRAINT tm_chk_project_date CHECK (previous_end_date > start_date)
);

-- TASKS
CREATE TABLE tm_tasks_t(
  id_task NUMBER PRIMARY KEY,
  name_task VARCHAR2(255) NOT NULL,
  desc_task VARCHAR2(1000),
  start_date DATE,
  previous_end_date DATE,
  end_date DATE,
  id_status NUMBER NOT NULL REFERENCES tm_status_t(id_status),
  id_priority NUMBER NOT NULL REFERENCES tm_priorities_t(id_priority),
  id_project  NUMBER NOT NULL REFERENCES tm_projects_t(id_project),
  id_responsable NUMBER REFERENCES tm_users_t(id_user),
  id_creator NUMBER NOT NULL REFERENCES tm_users_t(id_user),
  creation_date DATE DEFAULT SYSDATE,
  CONSTRAINT tm_chk_task_date CHECK (previous_end_date > start_date)
);

-- TASKS DEPENDENCIES
CREATE TABLE tm_task_dependencies_t(
  id_task_dependence NUMBER PRIMARY KEY,
  id_task NUMBER NOT NULL REFERENCES tm_tasks_t(id_task),
  id_dependent_task NUMBER NOT NULL REFERENCES tm_tasks_t(id_task)
);

-- COMMENTS
CREATE TABLE tm_comments_t(
  id_comment NUMBER PRIMARY KEY,
  id_task NUMBER NOT NULL REFERENCES tm_tasks_t(id_task),
  id_author NUMBER NOT NULL REFERENCES tm_users_t(id_user),
  comment_text VARCHAR2(2000) NOT NULL,
  date_comment DATE DEFAULT SYSDATE
);

-- STATUS HISTORY
CREATE TABLE tm_status_history_t(
  id_history NUMBER PRIMARY KEY,
  id_task NUMBER NOT NULL   REFERENCES tm_tasks_t(id_task),
  id_previous_status NUMBER NOT NULL REFERENCES tm_status_t(id_status),
  id_new_status NUMBER NOT NULL REFERENCES tm_status_t(id_status),
  id_changed_by NUMBER NOT NULL REFERENCES tm_users_t(id_user),
  change_date DATE DEFAULT SYSDATE
);

-- NOTIFICATIONS
CREATE TABLE tm_notifications_t(
  id_notification NUMBER PRIMARY KEY,
  id_receiver NUMBER NOT NULL REFERENCES tm_users_t(id_user),
  id_task NUMBER NOT NULL REFERENCES tm_tasks_t(id_task),
  message VARCHAR2(500) NOT NULL,
  notification_date DATE DEFAULT SYSDATE,
  notification_read CHAR(1) DEFAULT 'N',
  CONSTRAINT tm_chk_notification_read CHECK (notification_read IN ('Y','N'))
);

-- AUDITORY LOG
CREATE TABLE tm_auditory_log_t(
  id_auditory NUMBER PRIMARY KEY,
  affected_table VARCHAR2(50) NOT NULL,
  operation VARCHAR2(30) NOT NULL,
  previous_data VARCHAR2(2000),
  new_data VARCHAR2(2000),
  operation_date DATE DEFAULT SYSDATE,
  user_database VARCHAR2(50) DEFAULT USER,
  CONSTRAINT tm_chk_operation CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- ERROR LOG
CREATE TABLE tm_error_log_t(
  id_error NUMBER PRIMARY KEY,
  origin_procedure VARCHAR2(100) NOT NULL,
  error_message VARCHAR2(500) NOT NULL,
  stack_trace VARCHAR2(2000) NOT NULL,
  error_date DATE DEFAULT SYSDATE
);

--*********************--
--=== SEQUENCES ===--
--*********************--

-- USERS
CREATE SEQUENCE tm_users_s START WITH 1 INCREMENT BY 1;

-- TEAMS
CREATE SEQUENCE tm_teams_s START WITH 1 INCREMENT BY 1;

-- TEAM USERS
CREATE SEQUENCE tm_team_users_s START WITH 1 INCREMENT BY 1;

-- PROJECTS
CREATE SEQUENCE tm_projects_s START WITH 1 INCREMENT BY 1;

-- TASKS
CREATE SEQUENCE tm_tasks_s START WITH 1 INCREMENT BY 1;

-- TASKS DEPENDENCIES
CREATE SEQUENCE tm_task_dependencies_s START WITH 1 INCREMENT BY 1;

-- COMMENTS
CREATE SEQUENCE tm_comments_s START WITH 1 INCREMENT BY 1;

-- STATUS HISTORY
CREATE SEQUENCE tm_status_history_s START WITH 1 INCREMENT BY 1;

-- NOTIFICATIONS
CREATE SEQUENCE tm_notifications_s START WITH 1 INCREMENT BY 1;

-- AUDITORY LOG
CREATE SEQUENCE tm_auditory_log_s START WITH 1 INCREMENT BY 1;

-- ERROR LOG
CREATE SEQUENCE tm_error_log_s START WITH 1 INCREMENT BY 1;

--*********************--
--=== CONSTRAINTS ===--
--*********************--

ALTER TABLE tm_team_users_t 
ADD CONSTRAINT TM_UQ_TEAMUSR_TEAM_USER UNIQUE (id_team,id_user);

ALTER TABLE tm_task_dependencies_t
ADD CONSTRAINT TM_UQ_DEP_TASK_DEPENDENT UNIQUE (id_task, id_dependent_task);

--*********************--
--=== INDEXES ===--
--*********************--

CREATE INDEX TM_IDX_TASK_I ON tm_tasks_t(id_project, id_responsable, id_status);
CREATE INDEX TM_IDX_COM_TASK_I ON tm_comments_t(id_task);
CREATE INDEX TM_IDX_NOTIFICATION_I ON tm_notifications_t(id_receiver,id_task);
CREATE INDEX TM_IDX_HIS_TASK_I ON tm_status_history_t(id_task);
CREATE INDEX TM_IDX_DEP_TASK_I ON tm_task_dependencies_t(id_task);
CREATE INDEX TM_IDX_AUD_TABLE_I ON tm_auditory_log_t(affected_table);

--*******************************--
