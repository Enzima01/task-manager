--=== TASK MANAGER ===--
--=== Enzo Henrique Favaro ===--

--=== SCHEMA ===--

/*
  tm = task manager
  _t = table
  _s = sequence
  _i = index
*/

--=== DOMAIN TABLES ===--

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

--=== MAIN TABLES ===--

-- USERS
CREATE TABLE tm_users_t(
  id_user NUMBER PRIMARY KEY,
  name_user VARCHAR2(255) NOT NULL,
  email_user VARCHAR2(255) NOT NULL UNIQUE,
  job_title_user VARCHAR2(255),
  register_date DATE DEFAULT SYSDATE,
  active CHAR(1) DEFAULT 'Y'
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
  id_team NUMBER NOT NULL,
  id_user NUMBER NOT NULL,
  job_title VARCHAR2(20) NOT NULL,
  entry_date DATE DEFAULT SYSDATE
);

-- PROJECTS
CREATE TABLE tm_projects_t(
  id_project NUMBER PRIMARY KEY,
  name_project VARCHAR2(255) NOT NULL,
  desc_project VARCHAR2(500),
  start_date DATE NOT NULL,
  previous_end_date DATE NOT NULL,
  end_date DATE,
  id_status NUMBER NOT NULL,
  id_priority NUMBER NOT NULL,
  id_responsable NUMBER NOT NULL,
  creation_date  DATE DEFAULT SYSDATE
);

-- TASKS
CREATE TABLE tm_tasks_t(
  id_task NUMBER PRIMARY KEY,
  name_task VARCHAR2(255) NOT NULL,
  desc_task VARCHAR2(1000),
  start_date DATE,
  previous_end_date DATE,
  end_date DATE,
  id_status NUMBER NOT NULL,
  id_priority NUMBER NOT NULL,
  id_project  NUMBER NOT NULL,
  id_responsable NUMBER,
  id_creator NUMBER NOT NULL,
  creation_date DATE DEFAULT SYSDATE
);

-- TASKS DEPENDENCIES
CREATE TABLE tm_task_dependencies_t(
  id_task_dependence NUMBER PRIMARY KEY,
  id_task NUMBER NOT NULL,
  id_dependent_task NUMBER NOT NULL
);

-- COMMENTS
CREATE TABLE tm_comments_t(
  id_comment NUMBER PRIMARY KEY,
  id_task NUMBER NOT NULL,
  id_author NUMBER NOT NULL,
  comment_text VARCHAR2(2000) NOT NULL,
  date_comment DATE DEFAULT SYSDATE
);

-- STATUS HISTORY
CREATE TABLE tm_status_history_t(
  id_history NUMBER PRIMARY KEY,
  id_task NUMBER NOT NULL,
  id_previous_status NUMBER NOT NULL,
  id_new_status NUMBER NOT NULL,
  id_changed_by NUMBER NOT NULL,
  change_date DATE DEFAULT SYSDATE
);

-- NOTIFICATIONS
CREATE TABLE tm_notifications_t(
  id_notification NUMBER PRIMARY KEY,
  id_receiver NUMBER NOT NULL,
  id_task NUMBER NOT NULL,
  message VARCHAR2(500) NOT NULL,
  notification_Date DATE DEFAULT SYSDATE,
  notification_read CHAR(1) DEFAULT 'N'
);

-- AUDITORY LOG
CREATE TABLE tm_auditory_log_t(
  id_auditory NUMBER PRIMARY KEY,
  affected_table VARCHAR2(50) NOT NULL,
  operation VARCHAR2(30) NOT NULL,
  previous_data VARCHAR2(2000),
  new_data VARCHAR2(2000),
  operation_date DATE DEFAULT SYSDATE,
  user_database VARCHAR2(50) DEFAULT USER
);

-- ERROR LOG
CREATE TABLE tm_error_log_t(
  id_error NUMBER PRIMARY KEY,
  origin_procedure VARCHAR2(100) NOT NULL,
  error_message VARCHAR2(500) NOT NULL,
  stack_trace VARCHAR2(2000) NOT NULL,
  error_date DATE DEFAULT SYSDATE
);

-- SEQUENCES --


-- CONSTRAINTS --


-- INDEXES --
