/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM COB Valuation Statements Print')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC0952 - PRINT REGULAR PORTFOLIO VALUATION STATEMENTS      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 19JUL96              */
/*       Prev Amend No. CCG009             DATE 01JUN95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       CCG009 - Private Banking UDC      (NEW PROGRAM)             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLVL &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*CPM005*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*CPM005*/
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)               /*CPM005*/
             DCL        VAR(&FLIB) TYPE(*CHAR) LEN(10)                /*CPM005*/
/*/COPY WNCPYSRC,PMC0952001                                          */
 
             SNDPGMMSG  MSG('PMC0952 - Print Regular Portfolio +
                          Valuation Statements') TOMSGQ(MRUNQ)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
                                                                      /*CPM005*/
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */                     /*CPM005*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*CPM005*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*CPM005*/
 
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*CPM005*/
             CHGVAR     VAR(&FLIB) VALUE(&PRE *TCAT 'DMLIB')          /*CPM005*/
 
             CPYF       FROMFILE(&FLIB/PMPORTPD) +
                          TOFILE(&FMLIB/PMMERGPD) MBROPT(*REPLACE)    /*CPM005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
                                                                      /*CPM005*/
             CPYF       FROMFILE(&FLIB/PMCNSDPD) +
                          TOFILE(&FMLIB/PMMERGPD) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)                          /*CPM005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
 
/* OPEN QRYF SELECTING STATEMENTS TO BE PRINTED USING STANDARD       */
/* FORMAT AND CALL PM0950 TO PRINT STATEMENTS                        */
 
             OVRDBF     FILE(PMPTDVPD) SHARE(*YES)
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
 
             OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +
                          QNEUDC *NE "Y" *AND QNFRMT *EQ "S" ') +
                          KEYFLD((QNHLDM) (QNVLNT) (QNACOC) +
                          (QNLANG) (QNCNUM) (QNRQNO) (QNADCD) +
                          (QNPTFR))
 
             CALL       PGM(PM0950) PARM(&RSEQ)
 
             DLTOVR     FILE(*ALL)
             CLOF       OPNID(PMPTDVPD)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* OPEN QRYF SELECTING STATEMENTS TO BE PRINTED USING SPECIAL BANK   */
/* FORMAT AND CALL PM9950 TO PRINT STATEMENTS                        */
 
             OVRDBF     FILE(PMPTDVPD) SHARE(*YES)
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
 
             OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +
                          QNEUDC *NE "Y" *AND QNFRMT *EQ "B"') +
                          KEYFLD((QNHLDM) (QNVLNT) (QNACOC) +
                          (QNLANG) (QNCNUM) (QNRQNO) (QNADCD) +
                          (QNPTFR))
 
             CALL       PGM(PM9950) PARM(&RSEQ)
 
             DLTOVR     FILE(*ALL)
             CLOF       OPNID(PMPTDVPD)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*/COPY WNCPYSRC,PMC0952002                                          */
 
/**/                                                                  /*CPM005*/
ENDPGM:      RCLRSC                                                   /*CPM005*/
             DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
