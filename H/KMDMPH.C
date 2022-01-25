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

#ifndef _kmdmph_h_
#define _kmdmph_h_
#ifdef __cplusplus
extern "C" {
#endif

#ifndef __ILEC400__
#ifndef _Packed
#define _Packed
#pragma pack(1)
#endif
#endif

#ifndef _WINDOWS_
#ifndef _BOOL_
#define _BOOL_
typedef enum {FALSE,TRUE} BOOL;
#endif
#endif


/* Mapping 'polarities' with respect to sender process */
typedef enum {NET,RNET,LOCAL,REMOTE} mtype;
/*    NET -    Sending via network                     */
/*    RNET -   Replies from network                    */
/*    LOCAL -                                          */
/*    REMOTE -                                         */

/* Source parameter type for mapping fields            */
typedef enum {DNUM,DLIT,DFLD,DDFLT,DHEX,DNONE,DPARM} dtype;
/*    DNUM -    numeric literal   pdata = (double *)   */
/*    DLIT - character literal    pdata = (char *)     */
/*    DFLD - field name           pdata = (char *)     */
/*    DDFLT - type default        pdata = NULL         */
/*    DHEX  - hex literal         pdata = (VARBIN *)   */
/*    DNONE - place holder        pdata = NULL         */
/*    DPARM - eSTRUCT field markerpdata = NULL         */

typedef struct {
   unsigned short len;
   unsigned char data[1];
} vbin;

typedef union {
   double * pDNUM;
   char * pDLIT;
   char * pDFLD;
   vbin * pDHEX;
   void * vNULL;
}  vptr;


/* Structures used for mapping */

/* Class element */

typedef _Packed struct {
   int name;            /* class name */
} Class;


/* Field element */

typedef enum {
eSHORT,
eLONG,
eFLOAT,
eDOUBLE,
eCHAR,
eZCHAR,
eVARCHAR,
eBIN,
eVARBIN,
ePACKED,
eZONED,
eTEXT,
eCOUNT,
eTAG,
eSTRUCT,
eBLOB} ftype;


/* User data type */

typedef _Packed struct {
   int name;
   int base;
   ftype eBASE;
} Datatype;

typedef _Packed struct {
   void * pext;          /* User extension pointer */
   int name;             /* Field name */
   ftype type;           /* Field type */
   unsigned short prec;  /* precision */
   unsigned short scale; /* Scale for decimal and zoned */
   unsigned short attr;  /* Attribute if required */
   short offset;         /* buffer offset of data or -1 if not known */
} Field;

typedef _Packed struct {
   void * pext;          /* User extension pointer */
   char name[10];        /* Field name */
   ftype type;           /* Field type */
   unsigned short prec;  /* precision */
   unsigned short scale; /* Scale for decimal and zoned */
   unsigned short attr;  /* Attribute if required */
   short offset;         /* buffer offset of data or -1 if not known */
} rField;

#define btype(x) master->aDatatype[x->type].eBASE
#define ALLOC_SIZE(x) ((unsigned short) (((btype(x) == eVARCHAR) || \
   (btype(x) == eVARBIN)) ? x->prec + 2 : \
   (btype(x) == ePACKED) ? x->prec/2 + 1 : ((btype(x) == eTEXT) \
   || (btype(x) == eBLOB)) ?\
   MESSAGE_SIZE - x->offset : (btype(x) == eZCHAR) ? x->prec + 1\
   : x->prec))

#define USED_SIZE(x,y) ((unsigned short) (((btype(x) == eVARCHAR) || \
   (btype(x) == eVARBIN)) ? *((unsigned short *) y) + 2: \
   (btype(x) == ePACKED) ? x->prec/2 + 1 : ((btype(x) == eTEXT) || \
   (btype(x) == eBLOB)) ?\
   MESSAGE_SIZE - x->offset : (btype(x) == eZCHAR) ? x->prec + 1\
   : x->prec))

#define DATA_BYTES(x,y) ((unsigned short) (((btype(x) == eVARCHAR) ||\
   (btype(x) == eVARBIN)) ? *((unsigned short *) y) : \
   (btype(x) == ePACKED) ? x->prec/2 + 1 : ((btype(x) == eTEXT) || \
   (btype(x) == eBLOB)) ?\
   MESSAGE_SIZE - x->offset : x->prec))

/* Group item for struct header array */

typedef _Packed struct group_entry {
   unsigned short groupid ;    /* group id */
   BOOL check;                /* Used at execution time */
} group_entry;

/* 'struct' header */

typedef _Packed struct {
   void * pext;               /* User extension */
   unsigned short classno;    /* Class number */
   unsigned short id;         /* Struct identifier */
   int name;                  /* Struct name */
   Field * aField;            /* Field array address */
   unsigned short nField;     /* Number of fields */
   short maxlen;              /* maximum buffer size (-1 of TEXT or BLOB) */
   unsigned short firstrepeat;/* first field in repeat group */
   unsigned short repeatsize; /* size of repeating group */
   unsigned short firstvar;   /* First variable field number
                                 (relative to 1) */
   unsigned char ufld[20];    /* User character field */
   unsigned short ngroup;     /* number of dependency groups */
   group_entry entry[1];      /* dependency group array */
   /* ... */
} Struct;

typedef _Packed struct {
   void * pext;               /* User extension */
   unsigned short classno;    /* Class number */
   unsigned short id;         /* Struct identifier */
   char name[10];             /* Struct name */
   Field * aField;            /* Field array address */
   unsigned short nField;     /* Number of fields */
   short maxlen;              /* maximum buffer size (-1 of TEXT or BLOB) */
   unsigned short firstrepeat;/* first field in repeat group */
   unsigned short repeatsize; /* size of repeating group */
   unsigned short firstvar;   /* First variable field number
                                 (relative to 1) */
   unsigned char ufld[20];    /* User character field */
   unsigned short ngroup;     /* number of dependency groups */
   group_entry entry[1];      /* dependency group array */
   /* ... */
} rStruct;

/* Dependency group structure */

typedef _Packed struct {
   int name;                  /* group name */
   unsigned short nmap;       /* items in array */
   unsigned short map[1];     /* first map in group */
} Dgroup;

/* Field to field link */

typedef enum {
LNONE,
LPARM,
LDFLT,
LLIT,
LSYS,
LINT,
LFIELD
} ltype;

typedef _Packed struct {
   ltype type;               /* Source data type */
   unsigned short index;     /* source field index or literal offset*/
} Link;

typedef _Packed struct {
   Link * aLink;             /* Link array address */
   char * lit;               /* Literal buffer */
   mtype type;               /* Map type */
   unsigned short from;      /* source struct id */
   unsigned short to;        /* target struct id */
   unsigned short nLink;     /* Number of links */
   unsigned short groupid;   /* Dependency group */
} Map;

/* Master control block */
/* Fuctions accessed via pointers */

   /* Receive a message from the engine (Target side) */
typedef _Packed struct Master Master;
typedef int (* preceivedata_t) (
            Master * mast,         /* Master control block */
            unsigned short stream, /* Receive stream */
            unsigned long tid,     /* Transaction id
                                      (or 0 if not under commitment control) */
            char * data,           /* Pointer to data structure */
            unsigned short len,    /* Bytes of data contained in struct */
            Struct * pStruct       /* Target struct address */
            );


   /* Receive a message from the engine (Source side) */

typedef int (* prreceivedata_t) (
            Master * mast,         /* Master control block */
            unsigned long tid,     /* Transaction id
                                      (or 0 if not under commitment control */
            char * data,           /* Pointer to data structure */
            unsigned short len,    /* Bytes of data contained in struct */
            Struct * pStruct       /* Target struct address */
            );

typedef int (convert_user_type_t)  (rStruct * fromstruct,
                        rField * fromfield,
                        char * fromdata,
                        char source_extender,
                        rStruct * tostruct,
                        rField * tofield,
                        char * todata);


/* Initialise userfield to default */

typedef (set_default_t) (rField * field,char * data);


typedef _Packed struct streamhdr streamhdr;
 _Packed struct Master {
   Class * aClass;           /* All of the classes */
   Datatype * aDatatype;     /* All of the user data types */
   Struct ** apStruct;       /* All of the structs */
   char * aExt;              /* Struct extension */
   Map * aMap;               /* All of the maps */
   Dgroup ** apDgroup;       /* All of the dependency groups */
   char * sysbuff;           /* System variables buffer */
   char * intbuff;           /* Internal variables buffer */
   char * names;             /* Array for all names */
   preceivedata_t preceivedata;
   prreceivedata_t prreceivedata;
   convert_user_type_t * convert_user_type;
   set_default_t * set_default;
   unsigned short nClass;
   unsigned short nDatatype;
   unsigned short nStruct;
   unsigned short nMap;
   unsigned short nDgroup;
   unsigned short nn;        /* Current length of name array */

/* Framing data for messages */

   unsigned short dholen;    /* Required header for output */
   unsigned short dtolen;    /* required trailer for output */
   unsigned short dhilen;    /* header size on inputs */

   unsigned short rdholen;   /* Required header for output */
   unsigned short rdtolen;   /* required trailer for output */
   unsigned short rdhilen;   /* header size on inputs */

/* The following flags determine whether the mapping engine
   takes responsibility for freeing source messages or not. */

   BOOL return_input;
   BOOL return_rinput;
   streamhdr * pstream;
   unsigned short nstream;
   int name;
   int max_map_msg;
   char dec; /* Decimal point character */
};

/*
   Macros for accessing components.

   There are two types of macro.
   1. form XXXX(n)
      Returns the nth Xxxx structure from a previously resolved
      lower level. Except for CLASS(n) and TYPE(n), these 'resolve'
      the current structure by storing its address in a globally
      scoped static pointer with a fixed name.

    2. form cXXXX
      Returns the currently resolved structure of the type. Note that
      cMAP and cCLASS do not exist as they would be of little use.

    The point of this exercise is to reduce the amount of pointer
    resolution required at execution time.

    The required globally scoped static pointers are as follows:

    static Struct * pcS1;
    static Struct * pcS2;
    static Field * pcF1;
    static Field * pcF2;
    static Dgroup * pcD;
    static Map * pcM;
    static Link * pcL;

*/

#define TYPE(x) (*(master->aDatatype + x))
#define CLASS(x) (*(master->aClass + x))
#define pSTRUCT1(x) (pcS1 = *(master->apStruct + x))
#define pSTRUCT2(x) (pcS2 = *(master->apStruct + x))
#define STRUCT1(x) (*(pcS1 = *(master->apStruct + x)))
#define STRUCT2(x) (*(pcS2 = *(master->apStruct + x)))
#define DGROUP(x) (*(pcD = *(master->apDgroup + x)))
#define pFIELD1(x) (pcF1 = pcS1->aField + x)
#define pFIELD2(x) (pcF2 = pcS2->aField + x)
#define FIELD1(x) (*(pcF1 = pcS1->aField + x))
#define FIELD2(x) (*(pcF2 = pcS2->aField + x))
#define MAP(x) (*(pcM = master->aMap + x))
#define LINK(x) (*(pcL = pcM->aLink + x))

#define cSTRUCT1 (*pcS1)
#define cSTRUCT2 (*pcS2)
#define cFIELD1 (*pcF1)
#define cFIELD2 (*pcF2)
#define cDGROUP (*pcD)
#define cMAP (*pcM)
#define cLINK (*pcL)
#define N_(x) (master->names + x)


/*

   Script to table mapping functions

*/
void script_in(Master *);
void usertypes_in(void);
void usertype_def_in(int id,char * type,char * base);
void end_usertypes_in(void);
void classes_in(void);
void class_def_in(int id,char * sclass);
void end_classes_in(void);
void process_in(char * name);
void procparm_in(char * zstring);
void end_process_in(void);
void struct_in(char * name,char ext,int id,char * sclass,char * ufld,
               char * desc);
void struct_field_in(char * type,int * pprec,int * pscale,
                  char * name,int * pattr,char * desc);
Struct * end_struct_in(void);
void map_in(mtype,char * groupid,int tid,int sid);
void map_field_in(dtype,vptr pdata);
void end_map_in(void);
void end_script_in(void);
/*

   Mapping table to script functions

*/
int  script_out(char * file_name);
void usertypes_out(void);
void usertype_def_out(int id,char * type,char * base);
void end_usertypes_out(void);
void classes_out(void);
void class_def_out(int id,char * sclass);
void end_classes_out(void);
void process_out(char * name);
void procparm_out(char * zstring);
void end_process_out(void);
void struct_out(char * name,char ext,int id,char * sclass,char * ufld,
                char * desc);
void struct_field_out(char * type,int * pprec,int * pscale,
                  char * name,int * pattr,char * desc);
void end_struct_out(void);
void map_out(mtype type,char * groupid,int tid,int sid);
void map_field_out(dtype type,vptr pdata);
void end_map_out(void);
void end_script_out(void);
/*
   script file access
*/
int load_script(Master *,char *);

/* Mapping engine interface calls */

/* The engine is designed run as a DLL/Service program so it does not
   rely on user supplied external functions. Where user processing IS
   required,this is accessed via function pointers passed during
   initialisation. */


   /* Target initialisation */

typedef int (* tinit_t) (Master * mast,/* Address of master block */
                        unsigned short streams,
                        void * puser
                        );

   /* Initialisation call by Source side */
extern Master * new_master(int,char *);
extern Master * minit(char * product, /* Product being mapped */
               char * env,           /* Unit */
               char * process,
               tinit_t ptinit,     /* Target initialisation function */
               unsigned short streams,/* No of streams to support */
               void * puser           /* Source to target information */
               );

   /* Send data from source side */

int senddata(
             Master * mast,       /* Master control block */
             unsigned short stream,        /* Send stream >= 1 */
             unsigned long tid,            /* Transaction ID */
             char * data,                  /* Send buffer */
             short sid,                    /* Struct Id (optional) */
             char * sname,                 /* Struct name (optional) */
             short dlen                    /* data length */
             );


   /* Send data from target side (reverse send) */

int rsenddata(
             Master * mast,       /* Master control block */
             unsigned long tid,            /* Transaction ID */
             char * data,                  /* Send buffer */
             short sid,                    /* Struct Id (optional) */
             char * sname,                 /* Struct name (optional) */
             short dlen                    /* data length */
             );

/* Target initialisation */

extern int tinit(Master * mast,unsigned short streams,
                                  void * puser);

/* Error text */

extern char ErrorText[120];

extern unsigned short HTONS(unsigned short host_short);
extern unsigned short NTOHS(unsigned short net_short);
extern unsigned long HTONL(unsigned long host_long);
extern unsigned long NTOHL(unsigned long net_long);
extern float HTONF(float host_float);
extern float NTOHF(float net_float);
extern double HTOND(double host_double);
extern double NTOHD(double net_double);
extern char * HTONC(char * host_char,int len);
extern char * NTOHC(char * net_char,int len);

#define NTOH_SHORT(x) *((short *) x) = NTOHS(*((short *) x))
#define NTOH_LONG(x) *((long *) x) = NTOHL(*((long *) x))
#define NTOH_FLOAT(x) *((float *) x) = NTOHF(*((float *) x))
#define NTOH_DOUBLE(x) *((double *) x) = NTOHD(*((double *) x))
#define NTOH_CHAR(x,y) NTOHC(x,y)

#define HTON_SHORT(x) *((short *) x) = HTONS(*((short *) x))
#define HTON_LONG(x) *((long *) x) = HTONL(*((long *) x))
#define HTON_FLOAT(x) *((float *) x) = HTONF(*((float *) x))
#define HTON_DOUBLE(x) *((double *) x) = HTOND(*((double *) x))
#define HTON_CHAR(x,y) HTONC(x,y)

#define MALLOC(x) (x *) malloc(sizeof(x))

extern char * map_file(char *);
extern char * system_field_address(Master *,char *);
extern short get_struct_id_by_name(Master *,char *);
extern short get_field_offset_by_name(Master *,short,char *);

#ifndef __ILEC400__
#pragma pack()
#endif

#ifdef __cplusplus
}
#endif
#endif
