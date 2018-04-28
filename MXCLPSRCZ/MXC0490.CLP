/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Update Export Account Keys')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0490 - Update Export Account Keys                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6726            Date 23Jan06              */
/*       Prev Amend No. 240314             Date 29Jun06              */
/*                      BUG11248           Date 23Jan06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX003             Date 05Nov00              */
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG6726- SEC0610/00001 crashed in COB                       */
/*                Fix applied annotated as BUG11248.                 */
/*       240314 - Applied fix 199215.                                */
/*       199215 - DBErr in SEC0610 when MXC0490 attempts to copy     */
/*                an empty multi-membered file.  Fix is to add       */
/*                MONMSG to handle CPF2870.                          */
/*       BUG11248 - SEC0610/00001 crashed in COB.Applied BUG6726     */
/*       CMX003 - Meridian Export Enhancements - Phase 2             */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM  &POST)
 
/*/COPY WNCPYSRC,MXC0490INT                                          */
 
             DCL        VAR(&PGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&POST)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&PSTM)  TYPE(*CHAR) LEN( 5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0490MPS                                          */
 
 
             CHGVAR     VAR(&PSTM) VALUE('POST' *CAT &POST)
 
/* DEALING account keys */
 
             IF         COND(&PGM *EQ 'DLC0606C') THEN(DO)
 
               CPYF       FROMFILE(DKEYSDP) TOFILE(MXAKDLPD) +
                          TOMBR(&PSTM) MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXAKDLPD) MBR(&PSTM))
 
             ENDDO
 
/* LENDING account keys */
 
             IF         COND(&PGM *EQ 'LEC0608A') THEN(DO)
 
               CPYF       FROMFILE(LKEYFED) TOFILE(MXAKLFPD) +
                          TOMBR(&PSTM) MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXAKLFPD) MBR(&PSTM))
 
               CPYF       FROMFILE(LKEY1DP) TOFILE(MXAKLNPD) +
                          TOMBR(&PSTM) MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXAKLNPD) MBR(&PSTM))
 
             ENDDO
 
/* SECURITIES account keys */
 
             IF         COND(&PGM *EQ 'SEC0610') THEN(DO)
 
                                                     /* Start CMX003 */
/*********** CPYF       FROMFILE(SEKEYD) TOFILE(MXAKSEPD) +          */
/***********              FROMMBR(TRADE) TOMBR(&PSTM) MBROPT(*REPLACE*/
             CPYF       FROMFILE(SEKEYD) TOFILE(MXAKSEPD) +
                          FROMMBR(*ALL) TOMBR(&PSTM) MBROPT(*REPLACE)
                                                       /* End CMX003 */
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MXAKSEPD) MBR(&PSTM))
/** Start of Change BUG11248 */
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2870) EXEC(CLRPFM +
                          FILE(MXAKSEPD) MBR(&PSTM))
/** End of Change BUG11248 */
 
             ENDDO
 
 
/*/COPY WNCPYSRC,MXC0490MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0490ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0490 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0490END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
