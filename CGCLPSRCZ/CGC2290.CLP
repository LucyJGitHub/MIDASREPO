/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG PB Valuation statements')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC2290  - PB Valuation Statements                          */
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
/*       Prev Amend No. CPM005             Date 25Jul96              */
/*                      CCG009             Date 01Jun95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       CCG009 - Private Banking UDC   (NEW PROGRAM)                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ &EXTRACT &MEMBER +
                          &COMMIT_OPT)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&COMP_NAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&COMP_SEQA)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
/* */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&STATUS)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
/* */                                                                 /*CPM005*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)               /*CPM005*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)               /*CPM005*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*CPM005*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*CPM005*/
/*/COPY WNCPYSRC,CGC2290001                                          */
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2290 - PB Valuation Statements') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
 
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
 
/* */
/* Run Extract Component */
/* */
             CHGVAR     VAR(&COMP_SEQA) VALUE(&COMP_SEQ)
             CHGVAR     VAR(&MSG_DATA) VALUE(&COMP_NAME *CAT +
                          &COMP_SEQA *CAT &EXTRACT *CAT &MEMBER +
                          *CAT &COMMIT_OPT)
             SNDPGMMSG  MSGID(CGD1271) MSGF(CGUSRMSG) +
                          MSGDTA(&MSG_DATA) TOPGMQ(*PRV)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*CPM005*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*CPM005*/
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')         /*CPM005*/
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')         /*CPM005*/
                                                                      /*CPM005*/
             CPYF       FROMFILE(&DMLIB/PMPORTPD) +
                          TOFILE(&DPLIB/PMMERGPD) MBROPT(*REPLACE)    /*CPM005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
                                                                      /*CPM005*/
             CPYF       FROMFILE(&DMLIB/PMCNSDPD) +
                          TOFILE(&DPLIB/PMMERGPD) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)                          /*CPM005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
                                                                      /*CPM005*/
             OVRDBF     FILE(PMPTDVXX) TOFILE(PMPTDVPD) SHARE(*NO)
 
             CALL       PGM(CG4150) PARM(&RTN_CODE &COMMIT_OPT)
             ROLLBACK
/*/COPY WNCPYSRC,CGC2290002                                          */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
 
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2290 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2290 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
/*ENDCLPGM:***RCLRSC*****LVL(*CALLER)                                 /*CPM005*/
 ENDCLPGM:   DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             RCLRSC     LVL(*CALLER)                                  /*CPM005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
