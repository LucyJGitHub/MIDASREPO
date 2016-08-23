/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas¦ABS Account Ranges by Authorised Users')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Security Profile Facility                           */
/*                                                                   */
/*       SFC0922 - ACCOUNT RANGES BY AUTHORISED USERS REPORT         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE024  *CREATE    Date 07Oct05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE024 - COUNTRY LEVEL SWITCHABLE FEATURE :                 */
/*                SECURITY FEATURES FOR RESTRICTED ACCOUNTS          */
/*                                                                   */
/*********************************************************************/
             PGM  PARM(&SEQ &LVL &ENT)
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL  VAR(&SEQ)  TYPE(*CHAR)  LEN(5)
             DCL  VAR(&LVL)  TYPE(*CHAR)  LEN(1)
             DCL  VAR(&ENT)  TYPE(*CHAR)  LEN(3)
             DCL  VAR(&RTCD) TYPE(*CHAR)  LEN(7)
             DCL  VAR(&MODE) TYPE(*CHAR)  LEN(1)
             DCL  VAR(&MEM)  TYPE(*CHAR)  LEN(50)
 
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
             CALL PGM(SF0922) PARM(&RTCD  &MODE  &SEQ  &LVL  &ENT)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ABNORMAL:   SNDPGMMSG  MSG('Account Ranges by Authorised Users +
                  Program SF0922 Ended ABNORMALLY') +
                  TOMSGQ(MOPERQ MRUNQ)
                  MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&MKICPY) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
 ENDPGM
