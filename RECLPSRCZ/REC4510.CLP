/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Cashier TCP/IP listener jobs stop/start')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4510 - Midas Cashier TCP/IP Listener Jobs Stop/Start     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004  *CREATE    Date 30May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture     */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPTION)
 
/*/COPY WNCPYSRC,REC4510INT                                          */
 
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RE4500LNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RE4500JNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RE4500JDA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&LISTJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LISTJUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LISTJNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PORT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(SDBRCHL0)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,REC4510MPS                                          */
 
/* Main processing */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')
/* Read all records in Branch file */
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDDBG))
 
/* Action only for Cashier branches */
 
             IF         COND(&A8LLIS *EQ 'Y') THEN(DO)
/* Create data area name */
                CHGVAR     VAR(&RE4500LNM) VALUE('RE4500L' *TCAT &A8BRCD)
/* STOP Process */
 
                IF         COND(&OPTION *EQ 'STOP      ') THEN(DO)
 
                   CHGVAR     VAR(&RE4500JNM) VALUE('RE4500J' *TCAT &A8BRCD)
                   RTVDTAARA  DTAARA(&RE4500JNM) RTNVAR(&RE4500JDA)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(&LISTJNM) VALUE(%SST(&RE4500JDA 1 10))
                   CHGVAR     VAR(&LISTJUS) VALUE(%SST(&RE4500JDA 11 10))
                   CHGVAR     VAR(&LISTJNB) VALUE(%SST(&RE4500JDA 21 6))
/* Attempt to allocate data area; if able to do so then don't end job. */
                   ALCOBJ     OBJ((&RE4500LNM *DTAARA *EXCL)) WAIT(0)
                   MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
   /* If job information is blank then end abnormally. */
                      IF         COND(&RE4500JNM *EQ ' ') THEN(DO)
                         GOTO       CMDLBL(ABNOR)
                      ENDDO
                      ENDJOB     JOB(&LISTJNB/&LISTJUS/&LISTJNM) OPTION(*IMMED)
                      CHGDTAARA  DTAARA(&RE4500JNM) VALUE(' ')
                      GOTO       CMDLBL(LOOP)
                   ENDDO
/* If data area was allocated then de-allocate. */
                   DLCOBJ     OBJ((&RE4500LNM *DTAARA *EXCL))
 
                ENDDO
 
/* START Process */
                IF         COND(&OPTION *EQ 'START     ') THEN(DO)
 
/* Try to create dtaara in case of new branch */
                   CHKOBJ     OBJ(&DPLIB/&RE4500LNM) OBJTYPE(*DTAARA)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                      CRTDTAARA  DTAARA(&DPLIB/&RE4500LNM) TYPE(*CHAR) +
                            LEN(128) TEXT('Midas Cashier TCP/IP Lock +
                            Data Area for Listener') AUT(*ALL)
                   ENDDO
 
                   ALCOBJ     OBJ((&RE4500LNM *DTAARA *EXCL)) WAIT(0)
 
/* Unable to allocate, Job is already active */
                   MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP))
/* Able to allocate, Job is not running */
                   DLCOBJ     OBJ((&RE4500LNM *DTAARA *EXCL))
                   CHGVAR     VAR(&LISTJNM) VALUE('LIST_' *TCAT &A8BRCD)
                   CHGVAR     VAR(&PORT) VALUE(&A8TCPP)
/************      SBMJOB     CMD(CALL PGM(REC4500) PARM(&A8BRCD &PORT)) +                /*CPK014*/
/************                JOB(&LISTJNM) JOBD(CIJOBD) JOBQ(CIJOBQ) +                    /*CPK014*/
/************                OUTQ(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)                     /*CPK014*/
                   SBMJOB     CMD(CALL PGM(REC4500) PARM(&A8BRCD &PORT)) +
                          JOB(&LISTJNM) JOBD(CIJOBD) JOBQ(CIJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
 
                ENDDO
 
             ENDDO
 
/* Loop through all records */
 
             GOTO       CMDLBL(LOOP)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
ENDDBG:
/* Stop debugging functions if COB */
                IF         COND(&OPTION *EQ 'STOP      ') THEN(DO)
                   RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********        IF         COND(&MPHAS *NE 'A') THEN(DO)                            */ /*CCB020*/
                   IF         COND((&MPHAS *NE 'A') *AND +
                              (&MPHAS *NE 'G')) THEN(DO)                                  /*CCB020*/
                   CALL       PGM(REC4530) PARM('STOP      ')
                   ENDDO
                ENDDO
 
/*/COPY WNCPYSRC,REC4510MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4510ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4510 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC4510END                                          */
 
 
             ENDPGM
