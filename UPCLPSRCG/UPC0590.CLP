/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Shell for UPC0600 with diff. src length')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0590  - Shell for UPC0600 (according to source length)   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP033             Date 28Nov06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG8856            Date 08Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 11Feb98              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP033 - UPCDFDPD is redundant.  Use new outfile instead    */
/*       BUG8856 - DSPFFD changed at V5R3.  Use core outfile instead */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&FILEA &LIBA &FILEB &LIBB &LEN)
 
             DCL        VAR(&LEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&FILEA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILEB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&LENA) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&LENB) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Set up DSPFFD outfile */                                                              /*BUG8856*/
             DLTF       FILE(QTEMP/UPCDFDPD)                                             /*BUG8856*/
             MONMSG     MSGID(CPF0000)                                                    /*CUP033*/
             DLTF       FILE(QTEMP/UPFFDSTPD)                                             /*CUP033*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG8856*/
/**********  CPYF       FROMFILE(UPCDFDPD) TOFILE(QTEMP/UPCDFDPD) +                    */ /*CUP033*/
/**********               CRTFILE(*YES)                                    */ /*BUG8856*/ /*CUP033*/
/**********  OVRDBF     FILE(UPCDFDPD) TOFILE(QTEMP/UPCDFDPD) +                        */ /*CUP033*/
/**********               OVRSCOPE(*JOB)                                   */ /*BUG8856*/ /*CUP033*/
                                                                                         /*BUG8856*/
/************DSPFFD     FILE(&LIBA/&FILEA) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/LENX)                                         */ /*BUG8856*/
             CPYF       FROMFILE(UPFFDSTPD) TOFILE(QTEMP/UPFFDSTPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CUP033*/
             DSPFFD     FILE(&LIBA/&FILEA) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/UPCDFDPD)                                        /*BUG8856*/
             CPYF       FROMFILE(QTEMP/UPCDFDPD) +
                          TOFILE(QTEMP/UPFFDSTPD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)                                              /*CUP033*/
             OVRDBF     FILE(UPFFDSTPD) TOFILE(QTEMP/UPFFDSTPD) +
                          OVRSCOPE(*JOB)                                                  /*CUP033*/
             CALL       PGM(UPC0600) PARM(&LENA)
/************DSPFFD     FILE(&LIBB/&FILEB) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/LENX)                                         */ /*BUG8856*/
             DSPFFD     FILE(&LIBA/&FILEB) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/UPCDFDPD)                                        /*BUG8856*/
             CPYF       FROMFILE(QTEMP/UPCDFDPD) +
                          TOFILE(QTEMP/UPFFDSTPD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)                                              /*CUP033*/
             CALL       PGM(UPC0600) PARM(&LENB)
             IF         COND(&LENA *EQ 112) THEN(DO)
                CHGVAR     VAR(&LEN) VALUE(112)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             IF         COND(&LENB *EQ 112) THEN(DO)
                CHGVAR     VAR(&LEN) VALUE(112)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             CHGVAR     VAR(&LEN) VALUE(092)
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:      RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGID(&MSGID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(&MSGID *EQ ' ') THEN(CHGVAR VAR(&MSGID) +
                          VALUE('*NULL'))
             CHGVAR     VAR(&MSG) VALUE('Error ' *CAT &MSGID *BCAT ' +
                          caused program UPC0590 to terminate; see +
                          errors previously listed')
             SNDPGMMSG  MSG(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ENDPGM:
/**********  DLTOVR     FILE(UPCDFDPD) LVL(*JOB)                           */ /*BUG8856*/ /*CUP033*/
             DLTOVR     FILE(UPFFDSTPD) LVL(*JOB)                                         /*CUP033*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG8856*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
