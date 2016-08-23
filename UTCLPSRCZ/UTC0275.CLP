/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Validity checker for GENPAGNUM command')     */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities module                                      */
/*                                                                   */
/*       UTC0270 - Validity checker for GENPAGNUM (Generate page     */
/*                 numbers) command                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       Last Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILELIB &RELEASE &PTF)
 
/***COPY*UTCPYSRC,UTC0275INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0275INT                                          */                   /*CPK024*/
 
/*--- Parameters ----------------------------------------------------*/
             DCL        VAR(&FILELIB) TYPE(*CHAR) LEN(20) /* File +
                          and library */
             DCL        VAR(&RELEASE) TYPE(*CHAR) LEN(4) /* Release */
             DCL        VAR(&PTF) TYPE(*CHAR) LEN(2) /* PTF */
 
/*--- Parameters broken down ----------------------------------------*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) /* File */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) /* Library */
 
/*--- Job type ------------------------------------------------------*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
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
 
/*--- Start of main processing --------------------------------------*/
 
/***COPY*UTCPYSRC,UTC0275MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0275MPS                                          */                   /*CPK024*/
 
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
 
/** Only check object authority if the file exists. */
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
             ENDDO
 
/** Use an externalised routine to return an error message to the +
    command processor. */
/*/COPY UTCPYSRC,VC_END                                              */
 
/***COPY*UTCPYSRC,UTC0275MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0275MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
/*--- End of main processing ----------------------------------------*/
 
ABNOR:
/***COPY*UTCPYSRC,UTC0275ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0275ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             UTC0270 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
/* (Set up messages for Midas information screen and call */
/* appropriate module program to display screen)          */
 
             ENDDO
 
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
                          MSGDTA(GENPAGNUM) MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/***COPY*UTCPYSRC,UTC0275END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0275END                                          */                   /*CPK024*/
 
/* (Add any specific end processing here) */
 
             ENDPGM
