/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail charges update')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                 */
/*                                                                   */
/*       REC3660 - RETAIL CHARGES CALCULATION UPDATE                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01413 *C *CREATE  Date 13Apr93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook REC3660MP1                   */
/*       S01413  -  Retail 3 Incorporation                           */
/*                  and changes for Release 10 standards.            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM     PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
/*/COPY WNCPYSRC,REC3660001                                          */
             DCLF       FILE(RETRGD)
/*/COPY WNCPYSRC,REC3660002                                          */
/**/
             SNDPGMMSG  MSG('REC3660 - Daily Charges Capitalisation') +
                        TOMSGQ(MRUNQ)
/**/
/*       Following check is done to avoid run of program if no charge*/
/*       processing is required : File RETRGD is empty               */
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
/*/COPY WNCPYSRC,REC3660003                                          */
               SNDPGMMSG  MSG('No data to process in file : RETRGD by +
                          PGM : RE3660') TOMSGQ(MRUNQ)
               GOTO       CMDLBL(ENDCL)
/*/COPY WNCPYSRC,REC3660004                                          */
             ENDDO
/**/
             MONMSG     MSGID(CPF0000)
/**/
                   CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3660MP1                                          */
                                                                      /*S01408*/
/**/
/*                      'BLOCK FILES'                       */
/**/
             OVRDBF     FILE(REEODPF) SEQONLY(*YES 100)
             OVRDBF     FILE(XREEODPF) SEQONLY(*YES 100)
/**/
                IF         COND(&STAT *EQ 'N') THEN(DO)
/**/
               DLTF       FILE(XREEODPF)
               MONMSG     MSGID(CPF0000)
/**/
               CPYF       FROMFILE(REEODPF) TOFILE(&TOLIB/XREEODPF) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*/COPY WNCPYSRC,REC3660009                                          */
/**/
                   CHGVAR     VAR(&STAT) VALUE('Y')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
/*  Remove logical file over physical before copying       */
/*                 and replace after                       */
/**/
               RMVM       FILE(REPOSTL) MBR(REPOSTL)
               MONMSG     MSGID(CPF0000)
/**/
               CPYF       FROMFILE(XREEODPF) TOFILE(REEODPF) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(REEODPF))
/**/
               ADDLFM     FILE(REPOSTL) MBR(REPOSTL)
               MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,REC3660010                                          */
/**/
             ENDDO
/**/
             DLTOVR     FILE(REEODPF)
             DLTOVR     FILE(XREEODPF)
/**/
/*/COPY WNCPYSRC,REC3660005                                          */
             CALL       PGM(RE3660)
/*/COPY WNCPYSRC,REC3660006                                          */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                   CHGVAR     VAR(&STAT) VALUE('N')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XREEODPF)
               MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,REC3660011                                          */
             ENDDO
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/*/COPY WNCPYSRC,REC3660007                                          */
               IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                 SNDPGMMSG  MSG('FILES OUT OF BALANCE - RE3660') +
                            TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,REC3660008                                          */
               ENDDO
/**/
               IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
               ENDDO
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
 ENDCL:
/**/
             ENDPGM
/**/
