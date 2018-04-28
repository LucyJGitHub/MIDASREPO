/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Add File Members to Teller Trans')           */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                         */
/*                                                                   */
/*       REC4206 - Add File Members to Teller Transaction File       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG2488            Date 31May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      096490             Date 28Nov95              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG2488- Logical file REDDSSRCDV/TTRANL6 is based over  a   */
/*                phsical which is set to members = *nomax.  Amend   */
/*                TTRANL6 and create a  new logical file TTRANL7.    */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001  -  Retail Teller System                             */
/*                                                                   */
/*********************************************************************/
             PGM       PARM(&TBRI &TLID &RETCD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEMBR)  TYPE(*CHAR)  LEN(4)
             DCL        VAR(&TBRI)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&TLID)   TYPE(*CHAR)  LEN(3)
             DCL        VAR(&RETCD)  TYPE(*CHAR)  LEN(2)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                              ABNORMAL)
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('REC4206 - Retail Teller System Add File +
                             Members') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* IF TELLER - ID IS NOT BLANKS */
/**/
             IF         (&TLID *NE BLANKS) THEN(DO)
/**/
/* SET VARIABLE &MEMBR AS &TBRI + THE TELLER-ID PASSED */
/**/
/**********      CHGVAR &MEMBR (&TBRI****&TLID)                                     */ /*BG18886*/
                 CHGVAR &MEMBR (&TBRI *CAT &TLID)                                      /*BG18886*/
/**/
/* ADD PHYSICAL FILE MEMBER TO TTRANPD */
/* ONLY IF MEMBER DOES NOT EXIST */
/**/
                 CHKOBJ TTRANPD *FILE MBR(&MEMBR)
                 MONMSG     MSGID(CPF9815)  EXEC(DO)
                            ADDPFM FILE(TTRANPD) MBR(&MEMBR)
                 ENDDO
/**/
/* ADD PHYSICAL FILE MEMBER TO TTRANPT AND INITIALISE MEMBER */
/* ONLY IF MEMBER DOES NOT EXIST */
/**/
                 CHKOBJ TTRANPT *FILE MBR(&MEMBR)
                 MONMSG     MSGID(CPF9815)  EXEC(DO)
                            ADDPFM FILE(TTRANPT) MBR(&MEMBR)
                            INZPFM FILE(TTRANPT) MBR(&MEMBR) TOTRCDS(1)
                 ENDDO
/**/
/* ADD LOGICAL FILE MEMBER TO TTRANL1 */
/* ONLY IF MEMBER DOES NOT EXIST */
/**/
                 CHKOBJ TTRANL1 *FILE MBR(&MEMBR)
                 MONMSG     MSGID(CPF9815)  EXEC(DO)
                      ADDLFM FILE(TTRANL1)   MBR(&MEMBR) +
                      DTAMBRS((TTRANPD (&MEMBR)) (TTRANPT (&MEMBR)))
                 ENDDO
/**/
/* ADD LOGICAL FILE MEMBER TO TTRANL2 */
/* ONLY IF MEMBER DOES NOT EXIST */
/**/
                 CHKOBJ TTRANL2 *FILE MBR(&MEMBR)
                 MONMSG     MSGID(CPF9815)  EXEC(DO)
                      ADDLFM FILE(TTRANL2)   MBR(&MEMBR) +
                      DTAMBRS((TTRANPD (&MEMBR)) (TTRANPT (&MEMBR)))
                 ENDDO
/**/                                                                                     /*BUG2488*/
/* ADD LOGICAL FILE MEMBER TO TTRANL7 */                                                 /*BUG2488*/
/* ONLY IF MEMBER DOES NOT EXIST */                                                      /*BUG2488*/
/**/                                                                                     /*BUG2488*/
                 CHKOBJ TTRANL7 *FILE MBR(&MEMBR)                                        /*BUG2488*/
                 MONMSG     MSGID(CPF9815)  EXEC(DO)                                     /*BUG2488*/
                      ADDLFM FILE(TTRANL7)   MBR(&MEMBR) +
                      DTAMBRS((TTRANPD (&MEMBR)))                                        /*BUG2488*/
                 ENDDO                                                                   /*BUG2488*/
/********************************************************************/
/**/
/** SET UP FILE OVERRIDES*/
/**/
             OVRDBF     FILE(TTRANL1) MBR(&MEMBR) SECURE(*YES) +
                          SHARE(*YES)
             OVRDBF     FILE(TTRANL2) MBR(&MEMBR) SECURE(*YES) +
                          SHARE(*YES)
             OVRDBF     FILE(TTRANL7) MBR(&MEMBR) SECURE(*YES) +
                          SHARE(*YES)                                                    /*BUG2488*/
/********************************************************************/
/**/
/** REBUILD ACCESS PATH */
/**/
             OPNDBF     FILE(TTRANL1) OPTION(*ALL) MBR(&MEMBR)
             CLOF       OPNID(TTRANL1)
             OPNDBF     FILE(TTRANL2) OPTION(*ALL) MBR(&MEMBR)
             CLOF       OPNID(TTRANL2)
             OPNDBF     FILE(TTRANL7) OPTION(*ALL) MBR(&MEMBR)                           /*BUG2488*/
             CLOF       OPNID(TTRANL7)                                                   /*BUG2488*/
/**/
/* SETON U2 FOR RE4203 MODE 2 PROCESSING*/
/**/
             CHGJOB     SWS(X1XXXXXX)
/**/
/** SET UP FILE OVERRIDES */
/**/
             OVRDBF     FILE(TTRNT) SHARE(*NO) SECURE(*YES)
             OVRDBF     FILE(TTRANPT) MBR(&MEMBR) SECURE(*YES)
/**/
/** DAILY TELLER TRANSACTION FILES CREATION */
/**/
             CALL       PGM(RE4203) PARM(&TBRI &TLID)
/**/
/* DELETE ALL OVERRIDES AND EXIT */
/**/
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* ABNORMAL TERMINATION */
/**/
ABNORMAL:
/**/
/* SET RETURN CODE PARAMETER &RETCD TO '01' */
/**/
             CHGVAR     VAR(&RETCD) VALUE('01')
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
