/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Extract Forward Trade Actions')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6200 - Extract Forward Trade Actions                     */
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
/*       Prev Amend No. CPM005             Date 26Jun96              */
/*                      S01124             Date 13Jun94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/3 - DISPLAY OF UNREALISED P&L ON FORWARD      */
/*                         SE TRADE                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*CPM005*/
/*********** DCL        VAR(&DATA) TYPE(*CHAR) LEN(52) ***/           /*CPM005*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*CPM005*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC6200 - PM Extract Forward Trade +
                          Actions') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* CLEAR WORK FILES */
/*********** CLRPFM     FILE(PMFTACPP) ***/                           /*CPM005*/
             CLRPFM     FILE(PMFTACPD)                                /*CPM005*/
/*********** CLRPFM     FILE(PMFPSDPP) ***/                           /*CPM005*/
             CLRPFM     FILE(PMFPSDPD)                                /*CPM005*/
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CALL PM6200 TO EXTRACT FORWARD ACTIONS */
             CALL       PGM(PM6200)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) ***/    /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) ***/    /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL PM6210 TO BUILD FORWARD POSITIONS */
             CALL       PGM(PM6210)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) ***/    /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) ***/    /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL PM6220 TO EXTRACT DETAILS TO PMHOLDPP */
             CALL       PGM(PM6220)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) ***/    /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) ***/    /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ABNOR:      ENDPGM
