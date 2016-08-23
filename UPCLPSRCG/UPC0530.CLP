/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Retrieve file name from *LDA for compare')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0530 - Retrieve file name from *LDA                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM005  *MOVED     Date 17Aug05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001             DATE 21Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM005 - Changes for the Bridge compare for MidasPlus.      */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RCD &FMT)
 
             DCL        VAR(&RCD) TYPE(*CHAR) LEN(92)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(200)
             DCL        VAR(&NEWF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             RTVDTAARA  DTAARA(*LDA (1 10)) RTNVAR(&NEWF)
             CHGVAR     VAR(&FMT) VALUE(&NEWF)
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:      RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGID(&MSGID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(&MSGID *EQ ' ') THEN(CHGVAR VAR(&MSGID) +
                          VALUE('*NULL'))
             CHGVAR     VAR(&MSG) VALUE('Error ' *CAT &MSGID *BCAT ' +
                          caused program UPC0530 to terminate; see +
                          errors previously listed')
             SNDPGMMSG  MSG(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
