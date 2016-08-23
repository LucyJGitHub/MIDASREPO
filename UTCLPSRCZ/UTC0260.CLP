/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for ADDCHGTYP')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities module                                      */
/*                                                                   */
/*       UTC0260 - CPP for ADDCHGTYP (Add change type and            */
/*                 identifier) command.                              */
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
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILELIB &MEMBER &CHGTYP &CHGID &REPLACE)
 
/***COPY*UTCPYSRC,UTC0260INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0260INT                                          */                   /*CPK024*/
 
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
                          Misys International Banking Systems Ltd. +
                          2001')
 
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
 
/***COPY*UTCPYSRC,UTC0260MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0260MPS                                          */                   /*CPK024*/
 
/*--- Start of main processing --------------------------------------*/
 
/** Separate file and library. */
             CHGVAR     VAR(&FILE) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FILELIB 11 10))
 
/** Query the file, selecting the control record. */
             OVRDBF     FILE(SPOOLS) TOFILE(&LIB/&FILE) MBR(&MEMBER) +
                          LVLCHK(*NO) SHARE(*YES) SEQONLY(*NO)
             OPNQRYF    FILE((&LIB/&FILE &MEMBER)) OPTION(*ALL) +
                          QRYSLT('%sst(spools 23 20) *eq "***** +
                          Type of change"')
 
/** Call the RPG which processes the selected record. */
             CALL       PGM(UT0260) PARM(&RETCODE &CHGTYP &CHGID +
                          &REPLACE)
             CLOF       OPNID(&FILE)
 
/** If return code is nonblank, perform error processing. */
             IF         COND(&RETCODE *NE ' ') THEN(DO)
                IF         COND(&REPLACE *EQ '*YES') THEN(DO)
                   SNDPGMMSG  MSGID(SYS0200) MSGF(UTMSGF) MSGTYPE(*ESCAPE)
                ENDDO
                ELSE       CMD(DO)
                   SNDPGMMSG  MSGID(SYS0202) MSGF(UTMSGF) MSGTYPE(*ESCAPE)
                ENDDO
             ENDDO
 
/***COPY*UTCPYSRC,UTC0260MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0260MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
/*--- End of main processing ----------------------------------------*/
 
 ABNOR:
/***COPY*UTCPYSRC,UTC0260ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0260ERR                                          */                   /*CPK024*/
 
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
                          Misys International Banking Systems Ltd.')
/***COPY*UTCPYSRC,UTC0260END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0260END                                          */                   /*CPK024*/
 
/* (Add any specific end processing here) */
 
             ENDPGM
