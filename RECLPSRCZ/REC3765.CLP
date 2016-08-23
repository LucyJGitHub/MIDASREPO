/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CONSOLIDATED INT. STATEMENT PRINT')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC3765 - INTEREST STATEMENT PRINT - CONSOLIDATED           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
/**/
/* declare &BJLANG as a program field as this hasn't been incorp to */
/*    SDBANKPD yet */
             DCL        VAR(&BJLANG) TYPE(*CHAR) LEN(2) VALUE('GB')
/*/COPY WNCPYSRC,REC3765001                                          */
/**/
             DCLF       FILE(SDBANKPD)
/**/
             SNDPGMMSG  MSG('REC3765 - Consolidated Retail interests +
                          statements  ') TOMSGQ(MRUNQ)
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              SNDPGMMSG  MSG('Record not found in file : SDBANKPD by +
                          PGM : REC3765') TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&BJLANG) VALUE(GB)
             ENDDO
/**/
    CHGVAR         VAR(&MSGF) VALUE(&BJLANG *TCAT 'REPTMSGF')
/**/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&MSGF)
             OVRDBF     FILE(ACCRACJ) TOFILE(EACCRACJ)
             OVRDBF     FILE(ACCNT) TOFILE(EACCNT)
/*/COPY WNCPYSRC,REC3765002                                          */
             CALL       PGM(RE3765) PARM(&BJLANG)
/*/COPY WNCPYSRC,REC3765003                                          */
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDCL:       ENDPGM
