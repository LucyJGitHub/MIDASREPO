/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Monitor batch jobs for Autocall')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0002 - Monitor batch jobs for Autocall                   */
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
/*       PREV AMEND NO. S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SCHED) TYPE(*CHAR) LEN(1)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* Allocate object AC002 */
/**/
             ALCOBJ     OBJ((AC002 *DTAARA *SHRRD)) WAIT(30)
/**/
/* Read through datafile ACDTAFL1 */
/**/
 READ:       CALL       PGM(ACC0008)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Check if the scheduler has closed itself down. */
/**/
 EOF:        RTVDTAARA  DTAARA(ACCOBT (2 1)) RTNVAR(&SCHED)
             IF         COND(&SCHED *EQ 'C') THEN(DLCOBJ OBJ((AC002 +
                          *DTAARA *SHRRD)))
             ELSE       CMD(DO)
               DLYJOB     DLY(60)
               RMVMSG     CLEAR(*ALL)
               GOTO       CMDLBL(READ)
             ENDDO
/**/
             GOTO ENDPGM
/**/
/* Error processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Monitor batch jobs for Autocall ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
