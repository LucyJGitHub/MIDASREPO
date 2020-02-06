/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Checking components processed in COB')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0001 - Checking of components being processed in COB.    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 092291             DATE 12FEB96              */
/*                      S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       092291 _ Clear ACMSGQ before attaching break program        */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&COMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SCHED) TYPE(*CHAR) LEN(1)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* Allocate data area AC001 */
/**/
             ALCOBJ     OBJ((AC001 *DTAARA *SHRRD)) WAIT(30)
/**/
/*  Attach break handling program ACC0003 to ACMSGQ                */
/**/
             CLRMSGQ    MSGQ(ACMSGQ)                                  /*092291*/
             CHGMSGQ    MSGQ(ACMSGQ) DLVRY(*BREAK) PGM(ACC0003)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Create data area LDA */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
/* Set active flag on datafile to 'Y' */
/**/
             CALL       PGM(AC0007) PARM('ACC0001   ' 'Y')
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
 LOOP:       CHGJOB     SWS(XXXXX0XX)
             RMVMSG     CLEAR(*ALL)
             CALL       PGM(AC0004) PARM(&COMP &SEQ)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             IF         COND(%SWITCH(XXXXX1XX)) THEN(SNDPGMMSG +
                          MSGID(ACM0004) MSGF(GBACMSGF) +
                          MSGDTA(&COMP *CAT &SEQ) TOMSGQ(ACMSGQ))
/**/
/* Check if the scheduler has closed itself down. */
/**/
             RTVDTAARA  DTAARA(ACCOBT (2 1)) RTNVAR(&SCHED)
             IF         COND(&SCHED *EQ 'C') THEN(DO)
/**/
/* Set active flag on datafile to 'N' */
/**/
               CALL       PGM(AC0007) PARM('ACC0001   ' 'N')
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                            CMDLBL(ABNOR))
             DLCOBJ     OBJ((AC001 *DTAARA *SHRRD))
             ENDDO
             ELSE       CMD(DO)
                DLYJOB     DLY(60)
                GOTO CMDLBL(LOOP)
             ENDDO
/**/
             GOTO ENDPGM
/**/
/* Error processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Checking of components being processed +
                          in COB ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
