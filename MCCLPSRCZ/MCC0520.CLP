/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Update Diary Events')                        */
/********************************************************************/
/*                                                                  */
/*       Midas Management Accounts Module                           */
/*                                                                  */
/*       MCC0520 - Update Diary Events                              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CMC001 *Created    Date 18Mar96             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CMC001 - Management Accounts Enhancement for PCA:          */
/*                Created for Management Accounts.                  */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&FLAGS)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
 
             DCL        VAR(&FLAGS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('MCC0520 - Mgmt Account Diary Update') +
                             TOMSGQ(MRUNQ)
/**/
/** Update Diary                                                            */
/**/
             CALL       PGM(MC0520) PARM(&FLAGS)
/**/
/** DATABASE ERROR                                                          */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
             GOTO       CMDLBL(ENDPGM)
ABNOR:       CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MCC0520 - ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
