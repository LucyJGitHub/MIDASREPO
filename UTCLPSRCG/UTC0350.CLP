/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Command processing program for CHGCCSIDS')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0350 - CPP for CHGCCSIDS (Change CCSIDs) command         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG19128            Date 19May08              */
/*       Prev Amend No. BG18582            Date 11Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK022             Date 29Jul05              */
/*                      CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      113280             Date 10Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAA005 *CREATE     Date 02AUG96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG19128 - Handle single file only.                          */
/*       BG18582 - Enhancements to changing CCSIDs.                  */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       113280 - Fails because command parameter is decimal and     */
/*                 input parameter is character.                     */
/*       CAA005 - This is the command processing program for the     */
/*                CHGCCSIDS command.  It changes the CCSID of one or */
/*                more files in a specified library.                 */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&LIB &FILE &NEWCCSID)                                     */ /*113280*/
             PGM        PARM(&LIB &FILE &NEWCCSIDN)                                       /*113280*/
 
/*/COPY WNCPYSRC,UTC0350INT                                          */
 
/** Parameters **/
 
/** Library **/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/** File **/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
/** New CCSID **/
/************DCL        VAR(&NEWCCSID) TYPE(*CHAR) LEN(5)                              */ /*113280*/
 
/** Non-parameter variables **/
 
/** New CCSID - numeric version **/
             DCL        VAR(&NEWCCSIDN) TYPE(*DEC) LEN(5 0)
 
/** Result returned from QCLSCAN **/
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
 
/** Fields used for object list API **/
             DCL        VAR(&USERSPACE) TYPE(*CHAR) LEN(10) /* User +
                          space name */
             DCL        VAR(&QUALSPACE) TYPE(*CHAR) LEN(20) /* +
                          Qualified user space name */
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) /* Format +
                          name */
             DCL        VAR(&QUALOBJ) TYPE(*CHAR) LEN(20) /* +
                          Qualified object name */
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(10) /* Object +
                          type */
             DCL        VAR(&STARTLIST) TYPE(*CHAR) LEN(4) /* Start +
                          of list (binary) */
             DCL        VAR(&STARTLISTN) TYPE(*DEC) LEN(9 0) /* +
                          Start of list (signed) */
             DCL        VAR(&NOOFENT) TYPE(*DEC) LEN(9 0) /* Number +
                          of entries (binary) */
             DCL        VAR(&ENTRYLEN) TYPE(*CHAR) LEN(4) /* Length +
                          of entry (binary) */
             DCL        VAR(&ENTRYLENN) TYPE(*DEC) LEN(9 0) /* +
                          Length of entry (signed) */
             DCL        VAR(&GENHDR) TYPE(*CHAR) LEN(140) /* User +
                          space generic header */
             DCL        VAR(&OBJENT) TYPE(*CHAR) LEN(108) /* List +
                          entry for a particular object */
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(010) /* File to +
                          be processed */
             DCL        VAR(&OBJATR) TYPE(*CHAR) LEN(10) /* Extended +
                          object attribute */
 
/** Others **/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256)
 
/** Standard fields **/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/***COPY*UTCPYSRC,DCL_MSG                                             */                  /*CPK022*/
/***COPY*UTCPYSRC,DCL_STATUS                                          */                  /*CPK022*/
/***COPY*UTCPYSRC,STDERR_DCL                                          */                  /*CPK022*/
/*/COPY GPCPYSRCG,DCL_MSG                                            */                   /*CPK022*/
/*/COPY GPCPYSRCG,DCL_STATUS                                         */                   /*CPK022*/
/*/COPY GPCPYSRCG,STDERR_DCL                                         */                   /*CPK022*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,UTC0350MPS                                          */
 
/** +
    Create a message queue for error reporting +
**/
             DLTMSGQ    MSGQ(QTEMP/CCSID_ERR)
             MONMSG     MSGID(CPF0000)
             CRTMSGQ    MSGQ(QTEMP/CCSID_ERR) TEXT('Error messages +
                          from run of CHGCCSIDS command')
 
/** +
    Check for a single file name selected, rather than a group.     +
    Scan for an asterisk to determine whether *ALL or a generic was +
    entered.                                                        +
**/
             CALL       PGM(QCLSCAN) PARM(&FILE X'010F' X'001F' +
                            '*' X'001F' '0' '0' '' &RESULT)
 
/** +
    If result is zero, no asterisk was found; a single file was +
    specified.  Process it and end.                             +
**/
             IF         COND(&RESULT *EQ 0) THEN(DO)
 
/***************CHGPF      FILE(&LIB/&FILE) CCSID(&NEWCCSID)                           */ /*113280*/
                CALL       PGM(UTC000002) PARM(&LIB &FILE '*REMOVE')                     /*BG19128*/
                CHGPF      FILE(&LIB/&FILE) CCSID(&NEWCCSIDN)                             /*113280*/
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&MSG) VALUE('Error changing CCSID of +
                                file ' *CAT &FILE *BCAT 'in library ' +
                                *CAT &LIB)
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(QTEMP/CCSID_ERR)
                   CHGVAR     VAR(&ERR) VALUE('Y')
                ENDDO
 
                GOTO       CMDLBL(ALL_READ)
 
             ENDDO
 
/* Call program to remove constraints. */                                                /*BG18582*/
/**********  CALL       PGM(UTC000002) PARM(&LIB '*REMOVE')               */ /*BG18582*/ /*BG19128*/
             CALL       PGM(UTC000002) PARM(&LIB &FILE '*REMOVE')                        /*BG19128*/
 
/** +
    Create a user space to hold the list of files to process.       +
**/
             CHGVAR     VAR(&USERSPACE) VALUE('CCSID_FILE')
             CHGVAR     VAR(&QUALSPACE) VALUE(&USERSPACE *CAT +
                          'QTEMP     ')
             CHGVAR     VAR(&QUALOBJ) VALUE(&FILE *CAT &LIB)
             CHGVAR     VAR(&OBJTYPE) VALUE('*FILE')
             CHGVAR     VAR(&FORMAT) VALUE('OBJL0200')
 
             CRTUSRSPC  USRSPC(QTEMP/&USERSPACE) INLSIZE(20000) +
                          DELETE(*YES)
/** +
    Put the list of files into the user space                       +
**/
             CALL       PGM(QUSLOBJ) PARM(&QUALSPACE &FORMAT +
                          &QUALOBJ &OBJTYPE)
/** +
    Get the generic header from the user space (this is a block of  +
    data that all user space APIs set up, which must be retrieved   +
    before the rest of the space. +
**/
             CALL       PGM(QUSRTVUS) PARM(&QUALSPACE X'00000001' +
                          X'0000008C' &GENHDR)
             MONMSG     MSGID(CPF0000)
 
/** +
    Get the specific header from the user space.  This contains the +
    start position of the actual data, the number of data entries and +
    the length of each entry.                                       +
**/
             RTVUSRSPCI USRSPC(QTEMP/&USERSPACE) STRPOS(&STARTLIST) +
                          NBRENT(&NOOFENT) ENTLEN(&ENTRYLEN)
 
/** +
    Convert the binary values into usable numerics                  +
**/
             CHGVAR     VAR(&STARTLISTN) VALUE(%BIN(&STARTLIST))
             CHGVAR     VAR(&ENTRYLENN) VALUE(%BIN(&ENTRYLEN))
 
/** +
    Perform a loop, reading through the data entries in the user +
    space. +
**/
READ_ENTRY:
             IF         COND(&NOOFENT = 0) THEN(GOTO CMDLBL(ALL_READ))
             CALL       PGM(QUSRTVUS) PARM(&QUALSPACE &STARTLIST +
                          &ENTRYLEN &OBJENT)
 
/** +
    Extract the file name and attribute from the user space entry +
**/
             CHGVAR     VAR(&FILE) VALUE(%SST(&OBJENT 1 10))
             CHGVAR     VAR(&OBJATR) VALUE(%SST(&OBJENT 32 10))
 
/** +
    Only physical files have changeable CCSIDs, so ignore all others +
**/
             IF         COND(&OBJATR *EQ 'PF') THEN(DO)
 
/***************CHGPF      FILE(&LIB/&FILE) CCSID(&NEWCCSID)                           */ /*113280*/
/* Certain Midas files have their CCSIDs hard-coded and should not be */                 /*BG18582*/
/*  processed.                                                        */                 /*BG18582*/
                IF         COND(&FILE *EQ 'CGCDSHPD') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'CGCORRPD') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'T_RNFRAS') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'T_RNFXDL') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'T_DFBOO') THEN(DO)                            /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'GLCLJARS') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'MSLISTPD') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'GLEODMPD') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'GLMLJARS') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                IF         COND(&FILE *EQ 'SCPBSAPD') THEN(DO)                           /*BG18582*/
                   GOTO       CMDLBL(NEXT_ENTRY)                                         /*BG18582*/
                ENDDO                                                                    /*BG18582*/
                                                                                         /*BG18582*/
                CHGPF      FILE(&LIB/&FILE) CCSID(&NEWCCSIDN)                             /*113280*/
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&MSG) VALUE('Error changing CCSID of +
                                file ' *CAT &FILE *BCAT 'in library ' +
                                *CAT &LIB)
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(QTEMP/CCSID_ERR)
                   CHGVAR     VAR(&ERR) VALUE('Y')
                ENDDO
             ENDDO
 
/** +
    Increase the start position of the list by the length of a list +
    entry, and convert the new value to binary +
**/
NEXT_ENTRY:                                                                              /*BG18582*/
             CHGVAR     VAR(&STARTLISTN) VALUE(&STARTLISTN + &ENTRYLENN)
             CHGVAR     VAR(%BIN(&STARTLIST)) VALUE(&STARTLISTN)
/** +
    Decrease the number of list entries +
**/
             CHGVAR     VAR(&NOOFENT) VALUE(&NOOFENT - 1)
 
             GOTO       CMDLBL(READ_ENTRY)
 
ALL_READ:
/* Call program to add constraints back. */                                              /*BG18582*/
/**********  CALL       PGM(UTC000002) PARM(&LIB '*ADD')                  */ /*BG18582*/ /*BG19128*/
             CALL       PGM(UTC000002) PARM(&LIB &FILE '*ADD')                           /*BG19128*/
/** +
    If any errors were detected, print off the message queue and +
    notfify the user.                                            +
**/
             IF         COND(&ERR *EQ 'Y') THEN(DO)
                DSPMSG     MSGQ(QTEMP/CCSID_ERR) OUTPUT(*PRINT)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('One or +
                             more errors occurred when changing +
                             CCSIDs.  Check printout and joblog.') +
                             MSGTYPE(*ESCAPE)
             ENDDO
 
/*/COPY WNCPYSRC,UTC0350MPE                                          */
 
             RETURN
 
 ABNOR:
/*/COPY WNCPYSRC,UTC0350ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/***COPY*UTCPYSRC,STDERR                                              */                  /*CPK022*/
/*/COPY GPCPYSRCG,STDERR                                              */                  /*CPK022*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,UTC0350END                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
