/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Monitor batch jobs for Autocall')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0008 - Monitor batch jobs for Autocall                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 096408             DATE 19APR96              */
/*       PREV AMEND NO. 098705             DATE 07FEB96              */
/*                      S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       096408 - Beep sent at end of COB if ACC0008 is in ALLOC WAIT*/
/*                and has not yet check that scheduler is close      */
/*       098705 - If system is now in Input Cycle, do not output     */
/*                error message that batch jobs have ended.          */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*098705*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SCHED) TYPE(*CHAR) LEN(1)                /*096408*/
             DCLF       FILE(ACDTAFL1)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* Read through datafile ACDTAFL1 */
/**/
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
/**/
/* If system is in Input Cycle, end program */                        /*098705*/
/**/                                                                  /*098705*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*098705*/
             IF         COND(&MPHAS *EQ 'A') THEN(GOTO +
                          CMDLBL(ENDPGM))                             /*098705*/
/**/                                                                  /*098705*/
/* Try to allocate batch job dataarea. */
/**/
             ALCOBJ     OBJ((&APBJDN *DTAARA *EXCL)) WAIT(30)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(READ))
             DLCOBJ     OBJ((&APBJDN *DTAARA *EXCL))
/**/
/* If dataarea can be allocated, batch job is not running - */
/* error has occured.                                       */
/**/
/* Check if the scheduler has closed itself down. */                  /*096408*/
/**/                                                                  /*096408*/
             RTVDTAARA  DTAARA(ACCOBT (2 1)) RTNVAR(&SCHED)           /*096408*/
             IF         COND(&SCHED *NE 'C') THEN(DO)                 /*096408*/
             SNDPGMMSG  MSGID(ACM0003) MSGF(GBACMSGF) +
                          MSGDTA(&APBJNM) TOMSGQ(ACMSGQ)
                          ENDDO                                       /*096408*/
             GOTO       CMDLBL(READ)
/**/
/* Error processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Monitor batch jobs for Autocall ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
