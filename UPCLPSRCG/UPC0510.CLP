/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Compare message handling')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0510  - Compare message handling                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM005  *MOVED     Date 17Aug05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001 *CREATE     Date 07Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM005 - Changes for the Bridge compare for MidasPlus.      */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ZAPGVN &ZAPGRL &ZAMSID &ZAMSGF &ZAMSDA +
                          &ZAMSTP)
 
             DCL        VAR(&ZAPGVN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZAPGRL) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ZAMSID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ZAMSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZAMSDA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&ZAMSTP) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             IF        COND(&ZAMSID *EQ ' ') THEN(CHGVAR VAR(&ZAMSID) +
                          VALUE(YYY0101))
             IF         COND(&ZAPGVN *EQ ' ') THEN(DO)
                CHGVAR     VAR(&ZAPGVN) VALUE('*')
                CHGVAR     VAR(&ZAPGRL) VALUE('*PRV')
             ENDDO
             ELSE       CMD(DO)
                IF      COND(&ZAPGRL *EQ ' ') THEN(CHGVAR VAR(&ZAPGRL) +
                          VALUE(*SAME))
             ENDDO
             IF         COND(&ZAMSTP *EQ ' ') THEN(CHGVAR VAR(&ZAMSTP) +
                          VALUE(*DIAG))
             IF         COND((&ZAPGVN *EQ *EXT) *OR (&ZAPGRL *EQ *EXT)) +
                          THEN(SNDPGMMSG MSGID(&ZAMSID) +
                          MSGF(&ZAMSGF) MSGDTA(&ZAMSDA) +
                          TOPGMQ(*EXT) MSGTYPE(&ZAMSTP))
             ELSE       CMD(SNDPGMMSG MSGID(&ZAMSID) MSGF(&ZAMSGF) +
                          MSGDTA(&ZAMSDA) TOPGMQ(&ZAPGRL (&ZAPGVN)) +
                          MSGTYPE(&ZAMSTP))
             RMVMSG     CLEAR(*ALL)
 
             GOTO       CMDLBL(ENDPGM)
ABNOR:
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGID(&MSGID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(&MSGID *EQ ' ') THEN(CHGVAR VAR(&MSGID) +
                          VALUE('*NULL'))
             CHGVAR     VAR(&MSG) VALUE('Error ' *CAT &MSGID *BCAT ' +
                          caused program UPC0510 to terminate; see +
                          errors previously listed')
             SNDPGMMSG  MSG(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
