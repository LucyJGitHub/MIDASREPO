/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIdas UP Source length retrieval for compare')        */
/*O*R****OVRDBF*LENX*QADSPFFD*****************************************/                  /*BUG8856*/
/********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0600  - Source length retrieval                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK025             Date 11Jul06              */
/*       Prev Amend No. BUG8856            Date 07Oct05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 11Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK025  - File UPCDFDPD is redundant. Use file UPFFDSTPD.   */
/*       BUG8856 - DSPFFD changed at V5R3.  Use core outfile instead */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&LEN)
 
             DCL        VAR(&LEN) TYPE(*DEC) LEN(3 0)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**********  DCLF       FILE(LENX)                                                       /*BUG8856*/
/**********  DCLF       FILE(UPCDFDPD)                               */           /*BUG8856 CPK025*/
             DCLF       FILE(UPFFDSTPD)                                                   /*CPK025*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
 C:          RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(&WHRLEN *EQ 112) THEN(DO)
                CHGVAR     VAR(&LEN) VALUE(112)
             ENDDO
             IF         COND(&WHRLEN *EQ 092) THEN(DO)
                CHGVAR     VAR(&LEN) VALUE(92)
             ENDDO
             GOTO       CMDLBL(C)
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:      RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGID(&MSGID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(&MSGID *EQ ' ') THEN(CHGVAR VAR(&MSGID) +
                          VALUE('*NULL'))
             CHGVAR     VAR(&MSG) VALUE('Error ' *CAT &MSGID *BCAT ' +
                          caused program UPC0600 to terminate; see +
                          errors previously listed')
             SNDPGMMSG  MSG(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
