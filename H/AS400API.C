/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*                                                                  */
/*  Interface to AS400 APIs                                         */
/*                                                                  */
/*  Ex System Programmers Interface Reference Vols 1 & 2            */
/*                                                                  */
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/********************************************************************
 *
 *       Meridian Replication
 *
 *       (c) Finastra International Limited 2021
 *
 *       Last Amend No. MD058809  *CREATE  Date 16Dec21
 *
 ********************************************************************
 *
 *       MD058809 - After installation of MQ9 compatibility patch and
 *                  restart of the Meridian Replication subsystem
 *                  REPMIDASPT, the job MPT1PBSIN ended in MSGW.
 *
 ********************************************************************
 */

/* Common Error structure */

typedef struct
{
   int err_data_len;
   int err_data_back;
   char msg_id??(7??);
   char reserved;
   char err_data??(100??);
} api_error_t;

/********************************************************************/
/* Retrieve Job information - QUSRJOBI                              */
/********************************************************************/

#pragma linkage (QUSRJOBI,OS)
void QUSRJOBI(void *,int,char *,char *,char *,api_error_t *);

/* Format JOBI0700 - Library list information */

typedef struct
{
   int bytes_returned;
   int bytes_available;
   char job_name??(10??);
   char user_name??(10??);
   char job_number??(6??);
   char internal_job_identifier??(16??);
   char job_status??(10??);
   char job_type;
   char job_subtype;
   char reserved??(2??);
   int system_library_count;
   int product_library_count;
   int current_library_exists;
   int user_library_count;
   char library_name??(50??)??(11??);
} JOBI0700_t;


/* Format JOBI0400 - General job information */

typedef struct
{
   int bytes_returned;
   int bytes_available;
   char job_name??(10??);
   char user_name??(10??);
   char job_number??(6??);
   char internal_job_identifier??(16??);
   char job_status??(10??);
   char job_type;
   char job_subtype;
   char time_started[13];
   char time_activated[13];
   char accounting_code[15];
   char job_description_name[10];
   char job_description_library[10];
   char unit_of_work_ID[24];
   char mode_name[8];
   char inquiry_message_reply[10];
   char log_CLP[10];
   char break_message_handling[10];
   char status_message_handling[10];
   char device_recovery_action[13];
   char DDM_conversation_handling[10];
   char date_separator;
   char date_format[4];
   char print_text[30];
   char sumbitters_job_name[10];
   char submitters_user_name[10];
   char submitters_job_number[6];
   char submitters_message_queue_name[10];
   char submitters_message_queue_library[10];
   char time_separator;
   int CCSID;
   char time_scheduled[8];
   char print_key_format[10];
   char sort_sequence[10];
   char sort_sequence_library[10];
   char language_ID[3];
   char country_ID[2];
   char completion_status;
   char signed_on_job;
} JOBI0400_t;
/********************************************************************/
/* Retrieve Object Description - QUSROBJD                           */
/********************************************************************/

#pragma linkage (QUSROBJD,OS)
void QUSROBJD(void *,int,char *,char *,char *,api_error_t *);

/* Format OBJD0100 - Basic information */

typedef struct
{
   int bytes_returned;
   int bytes_available;
   char name??(10??);
   char library_name??(10??);
   char type??(10??);
   char return_library??(10??);
   int auxilliary_storage_pool;
   char owner??(10??);
   char domain??(2??);
   char creation_date_and_time??(13??);
   char change_date_and_time??(13??);
} OBJD0100_t;


/* Format OBJD0200 - Extended information */

typedef struct
{
   int bytes_returned;
   int bytes_available;
   char name??(10??);
   char library_name??(10??);
   char type??(10??);
   char return_library??(10??);
   int auxilliary_storage_pool;
   char owner??(10??);
   char domain??(2??);
   char creation_date_and_time??(13??);
   char change_date_and_time??(13??);
   char extended_object_attribute??(10??);
   char text??(50??);
   char source_file_name??(10??);
   char source_library_name??(10??);
   char source_member_name??(10??);
} OBJD0200_t;

/********************************************************************/
/* Change Library List - QLICHGLL                                   */
/********************************************************************/

#pragma linkage (QLICHGLL,OS)
void QLICHGLL(char *,char *,char *,char *,int,api_error_t *);

/********************************************************************/
/* Retrieve user space pointer - QUSPTRUS                           */
/********************************************************************/


#pragma linkage (QUSPTRUS,OS)
void QUSPTRUS(char *,void **,api_error_t *);


/********************************************************************/
/*  Generic header returned in userspaces following a call to       */
/*  a "LIST" module.                                                */
/********************************************************************/

typedef struct header_struct {
     char user_data›64®;
     int  generic_header_size;
     char header_version›4®;
     char format_name›8®;
     char program_name›10®;
     char time_generated›13®;
     char information_status;
     int  usrspc_used;
     int  parm_section_offset;
     int  parm_section_size;
     int  header_section_offset;
     int  header_section_size;
     int  list_section_offset;
     int  list_section_size;
     int  number_of_entries;
     int  size_of_entry;
} header_struct;

/********************************************************************/
/*  Input parameter section following QBNLPGMI call to retrieve     */
/*  ILE program details.                                            */
/********************************************************************/

typedef struct QBNLPGMI_ip
{
   char user_space??(10??);
   char space_library??(10??);
   char format_name??(8??);
   char program_name??(10??);
   char program_library??(10??);
} QBNLPGMI_ip;


/* Format PGML0100 - Module information */

typedef struct
{
   char program_name??(10??);
   char program_library??(10??);
   char name??(10??);
   char library??(10??);
   char source_file??(10??);
   char source_library??(10??);
   char source_member??(10??);
   char attribute??(10??);
   char creation_date_time??(13??);
   char update_date_time??(13??);
   char sort_sequence_table_name??(10??);
   char sort_sequence_table_library??(10??);
   char language_identifier??(10??);
   int optimization_level;
   int maximum_optimization_level;
   char debug_data??(10??);
   char created_on??(6??);
   char created_for??(6??);
   char reserved??(20??);
   char user_modified;
   char licensed_program??(13??);
   char PTF_number??(5??);
   char APAR_ID??(6??);
   char reserved_2;
   int CCSID;
   char object_control_level??(8??);
   char reserved_3??(100??);
   int SQL_statements;
   char relational_database??(18??);
   char commitment_control??(10??);
   char allow_copy??(10??);
   char close_SQL_cursors??(10??);
   char naming_convention??(10??);
   char date_format??(10??);
   char date_separator;
   char time_format??(10??);
   char time_separator;
   char delay_prepare??(10??);
   char allow_blocking??(10??);
} PGML0100_t;


/********************************************************************/
/* Retrieve data area - QWCRDTAA                                    */
/********************************************************************/

#pragma linkage (QWCRDTAA,OS)
void QWCRDTAA(char *,int,char *,int,int,api_error_t *);

/* Data returned */

#ifndef _DATA_AREA_SIZE_
#define _DATA_AREA_SIZE_ 2048
#define __das__def__
#endif

typedef struct {
   int bytes_available;
   int bytes_returned;
   char type??(10??);
   char library??(10??);
   int length;
   int places;
   char data??(_DATA_AREA_SIZE_??);
} dataarea_t;
#ifdef __das__def__
#undef __das__def__
#undef _DATA_AREA_SIZE_
#endif

/********************************************************************/
/* Send program message - QMHSNDPM                                  */
/********************************************************************/

#pragma linkage (QMHSNDPM,OS)
void QMHSNDPM(char *,char *,char *,int,char *,char *,int,char *,
              api_error_t *);

