/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Consolidated int. statement print')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC3762 - INTEREST STATEMENT PRINT - CONSOLIDATED           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 25Jul96              */
/*                      S01408             Date 01Apy96              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 -  Addition of core hook REC3762MPE                  */
/*       S01408  - Addition of core hook REC3762INT                  */
/*                 Addition of core hook REC3762MPS                  */
/*                 Addition of core hook REC3762001                  */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,REC3762INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
/**/
/* declare &BJLANG as a program field as this hasn't been incorp to */
/*    SDBANKPD yet */
             DCL        VAR(&BJLANG) TYPE(*CHAR) LEN(2) VALUE('GB')
/**/
/*/COPY WNCPYSRC,REC3762001                                          */
/**/
             DCLF       FILE(SDBANKPD)
/**/
/*/COPY WNCPYSRC,REC3762MPS                                          */
 
             SNDPGMMSG  MSG('REC3762 - Consolidated Retail interests +
                          statements  ') TOMSGQ(MRUNQ)
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              SNDPGMMSG  MSG('Record not found in file : SDBANKPD by +
                          PGM : REC3762') TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&BJLANG) VALUE(GB)
             ENDDO
    CHGVAR         VAR(&MSGF) VALUE(&BJLANG *TCAT 'REPTMSGF')
/**/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&MSGF)
             OVRDBF     FILE(ACCRACJ) TOFILE(EACCRACJ)
             OVRDBF     FILE(ACCNT) TOFILE(EACCNT)
             CALL       PGM(RE3762) PARM(&BJLANG)
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,REC3762MPE                                          /*S01408*/
/*                                                                   /*S01408*/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCL:       ENDPGM
