/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Standard compn for run COB')                 */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0051 - STANDARD COMPONENT FOR CALLING                    */
/*                 CLOSE OF BUSINESS COMPONENTS                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 081912             DATE 18JAN95              */
/*       PREV AMEND NO. BHF053             DATE 10MAY90              */
/*                                                                   */
/*********************************************************************/
/*       081912 - Allow string to be 256 for parameters              */
/*       BHF053 - CHANGED PROGRAM TO DUMP IF ERROR.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CCOT &CPRM &INDU7 &INDU8 &ERROR)
/**/
             DCL        VAR(&CCOT) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&CPRM) TYPE(*CHAR) LEN(100)                *081912*/
             DCL        VAR(&CPRM) TYPE(*CHAR) LEN(256)               /*081912*/
             DCL        VAR(&INDU7) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INDU8) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/************DCL        VAR(&CMD) TYPE(*CHAR) LEN(122)                 *081912*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(278)                /*081912*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* CALL PROGRAM WITH PARAMETERS USING QCMDEXC (IF ANY) */
/**/
             CHGVAR     VAR(&CMD) VALUE('CALL ' *CAT &CCOT +
                          *CAT ' PARM(' *CAT &CPRM *CAT ')')
/************CALL       PGM(QCMDEXC) PARM(&CMD 122)                    *081912*/
             CALL       PGM(QCMDEXC) PARM(&CMD 278)                   /*081912*/
/**/
             RTVJOBA    SWS(&SWS)
/**/
/* IF U7 OR U8 SET ON BY CALLED PROGRAM             */
/* SET UP PARAMETER TO BE PASSED BACK TO CB0050     */
/**/
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(CHGVAR +
                          VAR(&INDU7) VALUE('1'))
             IF         COND(%SST(&SWS 8 1) *EQ '1') THEN(CHGVAR +
                          VAR(&INDU8) VALUE('1'))
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* DATABASE ERROR PROCESSING FOR ERROR IN THIS PROGRAM */
/* PARAMETERS AMEND TO SHOW DATABASE ERROR IN COMPONENT CALLED */
/**/
 ABNOR:      CHGVAR     VAR(&ERROR) VALUE('1')
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             DMPCLPGM                                               /* BHF053 */
             SNDPGMMSG  MSG('PROGRAM CBC0051 HAS TERMINATED - REFER TO-
 FURTHER MESSAGES TO DETERMINE WHICH COMPONENT HAS FAILED') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
 ENDPGM:     ENDPGM
