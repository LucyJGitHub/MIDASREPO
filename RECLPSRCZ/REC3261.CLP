/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Today's linked account')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC3261 - TODAY'S LINKED ACCOUNT                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 106240             DATE 02MAR98              */
/*                      S01408             DATE 09MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       106240  - Restart error on copy back to RELINKP and file    */
/*                 error on RELINKF in RE3261.                       */
/*       S01408  - Addition of core hook REC3261MP1                  */
/*       S01413  -  Retail 3 Incorporation                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
/*/COPY WNCPYSRC,REC3261001                                          */
/************DCLF       FILE(RELINKP)                              */ /*106240*/
             DCLF       FILE(RELINKF)                                 /*106240*/
/**/
             SNDPGMMSG  MSG('REC3261 - Today''s linked accnt +
                          ') TOMSGQ(MRUNQ)
/**/
/***FOLLOWING CHECK IS DONE TO AVOID RUN OF PROGRAM IF NO LINKED  **/ /*106240*/
/***ACCOUNT**                                                     **/ /*106240*/
/************                                                      */ /*106240*/
/************RCVF                                                  */ /*106240*/
/************MONMSG     MSGID(CPF0864) EXEC(DO)                    */ /*106240*/
/************ GOTO       CMDLBL(ENDPGM)                            */ /*106240*/
/************ENDDO                                                 */ /*106240*/
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
/*  FOLLOWING CHECK IS DONE TO AVOID RUN OF PROGRAM IF NO LINKED   */ /*106240*/
/*  ACCOUNT                                                        */ /*106240*/
                                                                      /*106240*/
             IF         COND(&STAT *EQ 'N') THEN(DO)                  /*106240*/
               RCVF                                                   /*106240*/
               MONMSG     MSGID(CPF0864) EXEC(DO)                     /*106240*/
                 GOTO       CMDLBL(ENDPGM)                            /*106240*/
                 ENDDO                                                /*106240*/
             DLCOBJ     OBJ((RELINKF *FILE *SHRRD))                   /*106240*/
             ENDDO                                                    /*106240*/
                                                                      /*106240*/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3261MP1                                          */
                                                                      /*S01408*/
/**/
             OVRDBF     FILE(REEODPF) SEQONLY(*YES 100)
             OVRDBF     FILE(XREEODPF) SEQONLY(*YES 100)
             OVRDBF     FILE(RELINKP) SEQONLY(*YES 100)
             OVRDBF     FILE(XRELINKP) SEQONLY(*YES 100)
             OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)
             OVRDBF     FILE(XACCNTAB) SEQONLY(*YES 100)
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
             DLTF       FILE(XREEODPF)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XRELINKP)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XACCNTAB)
             MONMSG     MSGID(CPF0000)
STEP1:
             CRTDUPOBJ  OBJ(REEODPF) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(XREEODPF) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REEODPF by +
                          PGM : REC3261 (STEP1)') TOMSGQ(MRUNQ)
                          CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
STEP2:
             CRTDUPOBJ  OBJ(RELINKP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(XRELINKP) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : RELINKP by +
                          PGM : REC3261 (STEP2)') TOMSGQ(MRUNQ)
                          CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
STEP3:
             CRTDUPOBJ  OBJ(ACCNTAB) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(XACCNTAB) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : ACCNTAB by +
                          PGM : REC3261 (STEP3)') TOMSGQ(MRUNQ)
                          CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*/COPY WNCPYSRC,REC3261004                                          */
/**/
                   CHGVAR     VAR(&STAT) VALUE('Y')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
EXIT3:
             CPYF       FROMFILE(XACCNTAB) TOFILE(ACCNTAB) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XACCNTAB in +
                          REC3261 (EXIT3)') TOMSGQ(MRUNQ)
                          CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
EXIT2:
             CPYF       FROMFILE(XRELINKP) TOFILE(RELINKP) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XRELINKP in +
                          REC3261 (EXIT2)') TOMSGQ(MRUNQ)
                          CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
EXIT1:
             CPYF       FROMFILE(&DPLIB/XREEODPF) +
                          TOFILE(&DMLIB/REEODPF) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREEODPF in +
                          REC3261 (EXIT1)') TOMSGQ(MRUNQ)
                          CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*/COPY WNCPYSRC,REC3261005                                          */
/**/
              ENDDO
/**/
             DLTOVR     FILE(REEODPF)
             DLTOVR     FILE(XREEODPF)
             DLTOVR     FILE(RELINKP)
             DLTOVR     FILE(XRELINKP)
             DLTOVR     FILE(ACCNTAB)
             DLTOVR     FILE(XACCNTAB)
/**/
             OVRDBF     FILE(RELINKF) SHARE(*NO) SEQONLY(*NO)         /*106240*/
/*/COPY WNCPYSRC,REC3261002                                          */
             CALL       PGM(RE3261)
             DLTOVR     FILE(RELINKF)                                 /*106240*/
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*/COPY WNCPYSRC,REC3261003                                          */
                   CHGVAR     VAR(&STAT) VALUE('N')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XREEODPF)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XRELINKP)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XACCNTAB)
               MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,REC3261006                                          */
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
/**/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
