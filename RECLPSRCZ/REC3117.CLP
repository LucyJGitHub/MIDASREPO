/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Account commission calculation')                */
/*********************************************************************/
/*                                                                   */
/*       Midas   Retail Module                               */
/*                                                                   */
/*       REC3117 - ACCOUNT COMMISSION CALCULATION                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 09MAY95              */
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408  -  Addition of core hook REC3117MP1                 */
/*       S01413  -  Retail 3 Incorporation.                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
/* THIS PGM USE SECURITY COPY OF FILES INSTEAD OF JOURNALING */
/**/
             PGM     PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL     VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL     VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL     VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
/*/COPY WNCPYSRC,REC3117001                                          */
             DCLF    FILE(TABTBRE)
/**/
/*    Check if 'Commission on Debit Turn' Ind. is on. */
/**/
             RCVF       RCDFMT(TABTBREF)
/**/
             IF         COND(&CDTO *EQ 'Y') THEN(DO)
             SNDPGMMSG  MSG('REC3117 - Accnt commission calculation +
                          ') TOMSGQ(MRUNQ)
/**/
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3117MP1                                          */
                                                                      /*S01408*/
/**/
             OVRDBF     FILE(REEODPF) SEQONLY(*YES 100)
             OVRDBF     FILE(XREEODPF) SEQONLY(*YES 100)
             OVRDBF     FILE(RECOMD) SEQONLY(*YES 100)
             OVRDBF     FILE(XRECOMD) SEQONLY(*YES 100)
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
             DLTF       FILE(XREEODPF)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XRECOMD)
             MONMSG     MSGID(CPF0000)
/**/
STEP1:
             CRTDUPOBJ  OBJ(REEODPF) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          NEWOBJ(XREEODPF) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REEODPF by +
                          PGM : REC3117 (STEP1)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
STEP2:
             CRTDUPOBJ  OBJ(RECOMD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          NEWOBJ(XRECOMD) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : RECOMD by +
                          PGM : REC3117 (STEP2)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT2)
             ENDDO
/**/
                   CHGVAR     VAR(&STAT) VALUE('Y')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/**/
             ELSE       CMD(DO)
EXIT1:
             CPYF       FROMFILE(XRECOMD) TOFILE(RECOMD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 /**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XRECOMD in +
                          REC3117 (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
EXIT2:
             CPYF       FROMFILE(XREEODPF) TOFILE(REEODPF) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 /**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREEODPF in +
                          REC3117 (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
             ENDDO
/**/
             DLTOVR     FILE(REEODPF)
             DLTOVR     FILE(XREEODPF)
             DLTOVR     FILE(RECOMD)
             DLTOVR     FILE(XRECOMD)
/**/
/*/COPY WNCPYSRC,REC3117002                                          */
             CALL       PGM(RE3117)
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XREEODPF)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XRECOMD)
               MONMSG     MSGID(CPF0000)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
