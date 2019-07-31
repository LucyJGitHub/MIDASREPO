/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Validity checker for ADDCHGTYP')             */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities module                                      */
/*                                                                   */
/*       UTC0265 - Validity checker for ADDCHTYP (Add change type    */
/*                 and identifier) command.                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAA002 *C *CREATE  Date 31Oct95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILELIB &MEMBER &CHGTYP &CHGID &REPLACE)
 
/***COPY*UTCPYSRC,UTC0265INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0265INT                                          */                   /*CPK024*/
 
/*--- Parameters ----------------------------------------------------*/
             DCL        VAR(&FILELIB) TYPE(*CHAR) LEN(20) /* File +
                          and library */
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10) /* Member */
             DCL        VAR(&CHGTYP) TYPE(*CHAR) LEN(6) /* Change +
                          type */
             DCL        VAR(&CHGID) TYPE(*CHAR) LEN(6) /* Change +
                          identifier */
             DCL        VAR(&REPLACE) TYPE(*CHAR) LEN(4) /* Whether +
                          or not to replace existing values. */
 
/*--- Parameters broken down ----------------------------------------*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) /* File */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) /* Library */
 
/*--- Job type ------------------------------------------------------*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*--- Externalised declares for object existence and sending status +
      messages. -----------------------------------------------------*/
/*/COPY UTCPYSRC,DCL_EXIST                                           */
/*/COPY UTCPYSRC,DCL_MSG                                             */
 
/*--- Fields for error handling -------------------------------------*/
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(10) /* Return +
                          code */
             DCL        VAR(&ERRID) TYPE(*CHAR) LEN(7) /* Error +
                          message ID. */
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(2000) /* Error +
                          message data. */
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/***COPY*UTCPYSRC,UTC0265MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0265MPS                                          */                   /*CPK024*/
 
/*--- Start of main processing --------------------------------------*/
 
/** Separate file and library. */
             CHGVAR     VAR(&FILE) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FILELIB 11 10))
 
/** Check existence of file. */
             CHGVAR     VAR(&OBJ) VALUE(&FILE)
             CHGVAR     VAR(&OBJLIB) VALUE(&LIB)
             CHGVAR     VAR(&OBJTYPE) VALUE('*FILE')
/*/COPY UTCPYSRC,OBJEXIST                                            */
 
/** The OBJEXIST module returns a flag.  If it is 'N', use the +
    externalised routines to set up and send a suitable message.  */
             IF         COND(&OBJEXISTS *EQ 'N') THEN(DO)
/*/COPY UTCPYSRC,OBJEXMSGN                                           */
/*/COPY UTCPYSRC,SNDCPD0006                                          */
             ENDDO
 
/** Only check object authority and member existence if file exists. */
             ELSE       CMD(DO)
 
/** Similarly, check that the user has suitable authority to the file */
             CHGVAR     VAR(&AUT) VALUE('*CHANGE')
 
/*/COPY UTCPYSRC,OBJAUTCHK                                           */
 
/** The OBJAUTCHK module returns a flag.  If it is 'N', use the +
    externalised routines to set up and send a suitable message.  */
             IF         COND(&AUTOK *EQ 'N') THEN(DO)
/*/COPY UTCPYSRC,OBJAUTMSG                                           */
/*/COPY UTCPYSRC,SNDCPD0006                                          */
             ENDDO
 
/** Only check the member if user has enough authority. */
             ELSE       CMD(DO)
 
/** Check whether the selected member exists. */
             CHGVAR     VAR(&MBR) VALUE(&MEMBER)
/*/COPY UTCPYSRC,MBREXIST                                            */
             IF         COND(&MBREXISTS *EQ 'N') THEN(DO)
/** The MBREXIST module returns a flag.  If it is 'N', use the +
    externalised routines to set up and send a suitable message.  */
/*/COPY UTCPYSRC,MBREXMSGN                                           */
/*/COPY UTCPYSRC,SNDCPD0006                                          */
             ENDDO
             ENDDO
             ENDDO
 
/** Use an externalised routine to return an error message to the +
    command processor. */
/*/COPY UTCPYSRC,VC_END                                              */
 
/***COPY*UTCPYSRC,UTC0265MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0265MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
/*--- End of main processing ----------------------------------------*/
 
 ABNOR:
/***COPY*UTCPYSRC,UTC0265ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0265ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
/** Receive all previous diagnostic messages and send them to the   **/
/** caller:                                                         **/
             RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSGDTA(&ERRDTA) +
                          MSGID(&ERRID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             IF         COND(&ERRID *NE ' ') THEN(DO)
                SNDPGMMSG  MSGID(&ERRID) MSGF(QCPFMSG) MSGDTA(&ERRDTA) +
                             MSGTYPE(*DIAG)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** Receive escape message and send it to the caller:               **/
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&ERRDTA) +
                          MSGID(&ERRID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&ERRID) MSGF(QCPFMSG) MSGDTA(&ERRDTA) +
                          MSGTYPE(*DIAG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ESC:         SNDPGMMSG  MSGID(CPF0001) MSGF(QSYS/QCPFMSG) +
                          MSGDTA(ADDCHGTYP) MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/***COPY*UTCPYSRC,UTC0265END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0265END                                          */                   /*CPK024*/
 
/* (Add any specific end processing here) */
 
             ENDPGM
