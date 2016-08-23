/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Start/stop TLX/FAX work monitor')            */
/*********************************************************************/
/*                                                                   */
/*     Midas - TELEX WORK MONITOR                                */
/*                                                                   */
/*     MTC5020 - COMMUNICATIONS WITH ORION SYSTEM.                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO 081507  *CREATE   DATE 20JAN95                  */
/*     PREV AMEND NO XXXXXX            DATE XXAAAXX                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     081507 - ORION UPGRADE.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&STRSTP &JOB)
 
             DCL        VAR(&STRSTP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/******************************************************/
/******** S T A R T    W O R K   M O N I T O R ********/
/******************************************************/
 
             IF         COND(&STRSTP *EQ 'START') THEN(DO)
 
/**** CHECK IF JOB ALREADY ACTIVE ****/
               ALCOBJ     OBJ((CC3020DA *DTAARA *EXCL))
               MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDBRKMSG  MSG('MIDAS Telex Work Monitor program +
                            already active') TOMSGQ(&JOB)
                 GOTO       CMDLBL(END)
               ENDDO
 
/**** START MONITOR ****/
               CALL       PGM(CC0020) PARM('1' ' ')
               SNDPGMMSG  MSG('MIDAS TELEX Work Monitor program +
                            started') TOMSGQ(MOPERQ)
               SNDBRKMSG  MSG('MIDAS Telex Work Monitor program +
                            started') TOMSGQ(&JOB)
             ENDDO
 
/******************************************************/
/********* S T O P    W O R K   M O N I T O R *********/
/******************************************************/
 
             IF         COND(&STRSTP *EQ 'STOP ') THEN(DO)
 
/**** CHECK IF JOB ACTIVE ****/
              ALCOBJ     OBJ((CC3020DA *DTAARA *EXCL))
              MONMSG     MSGID(CPF0000) EXEC(DO)
 
/**** END MONITOR ****/
               CALL       PGM(CC0020) PARM('0' ' ')
               SNDPGMMSG  MSG('MIDAS TELEX Work Monitor program ended +
                            normally') TOMSGQ(MOPERQ)
               SNDBRKMSG  MSG('MIDAS Telex Work Monitor program ended +
                            normally') TOMSGQ(&JOB)
               GOTO       CMDLBL(END)
              ENDDO
 
              DLCOBJ     OBJ((CC3020DA *DTAARA *EXCL))
              SNDBRKMSG  MSG('MIDAS Telex Work Monitor program not +
                           ended. It was not active.') TOMSGQ(&JOB)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
