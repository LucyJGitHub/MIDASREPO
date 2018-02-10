/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Penalty Termination Reporting COB')          */
/*********************************************************************/
/*                                                                   */
/*       MIDAS¦DBA - Dealing Money Market Module                     */
/*                                                                   */
/*       MMC5294 - Penalty Termination COB Daily Reporting           */
/*                                                                   */
/*       (C) Copyright Finastra International Limited 2008           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 256795  *CREATE    Date 25Sep08              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       256795 - Penalty Termination of Time Deposits (CDL052)      */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &TYPE)
 
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                        Copyright FINASTRA INTERNATIONAL LIMITED 2008')
 
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('CDL052')
             DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)
 
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/** Check if LDA Data area exists and create it if not **/
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA DTAARA(QTEMP/LDA) +
                        TYPE(*CHAR) LEN(256) VALUE(' ') +
                        TEXT('Midas SD LOCAL DATA AREA EQUIVALENT') +
                        AUT(*USE))
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSDY)
             IF         COND(&RTCD *NE '       ') +
                           THEN(GOTO CMDLBL(END))
 
             SNDPGMMSG  MSG('MMC5294 - MM Penalty Termination Daily +
                Reporting')  TOMSGQ(MRUNQ)
 
/** Call program **/
 
             CALL       PGM(MM5291) PARM(&RSEQ &RLEV &RENT &TYPE)
 
/** Check for database error **/
 
             IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
                  RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
 
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MRUNQ MOPERQ)
                  CHGVAR     VAR(&MEM) VALUE('MMC5294 - Job Terminated, +
                             Database in error')
                  SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                  GOTO ABNOR
             ENDDO
 
             GOTO END
 
ABNOR:
 
             SNDPGMMSG  MSG('MM5294 -  MM Penalty Termination Daily +
               reporting terminated abnormally') +
                        TOMSGQ(MRUNQ MOPERQ)
 
             CHGJOB     SWS(XXXXXX11)
/**/
 END:
     CHGVAR &MKICPY '(c) Copyright FINASTRA INTERNATIONAL LIMITED 2008'
 
 ENDPGM
