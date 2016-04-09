/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Cust. Serv. Fees - Accruals to date  RPT')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1985 - Customer Service Fees - Accrued to Date Control   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
/** Variables **/
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWFETP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&WWFIRST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/** Global monitor message **/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Set off all job switches **/
 
             CHGJOB     SWS(00000000)
 
/** Create LDA for job in QTEMP if it does not already exist **/
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        ENDDO
 
/**  Clear LDA   **/
 
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
 
/**  Prompt Fields in &RPARM, Substring to retrieve them.  **/
 
             CHGVAR     VAR(&WWACOC) VALUE(%SUBSTRING(&RPARM 1 4))
             CHGVAR     VAR(&WWCUST) VALUE(%SUBSTRING(&RPARM 5 6))
             CHGVAR     VAR(&WWPTFR) VALUE(%SUBSTRING(&RPARM 11 4))
             CHGVAR     VAR(&WWFETP) VALUE(%SUBSTRING(&RPARM 15 4))
             CHGVAR     VAR(&WWFIRST) VALUE('N')
             CHGVAR     VAR(&MODE) VALUE('*FULL')
 
/**  Select records: build query select sentence.  **/
 
/** Retrieve the Account Officer **/
 
             IF   COND(&WWACOC *NE '*ALL')  THEN(DO)
                 CHGVAR VAR(&QRYSLT) VALUE('FQACOC *EQ "' *CAT &WWACOC *CAT '" ')
                 CHGVAR VAR(&WWFIRST) VALUE('Y')
             ENDDO
 
/** Retrieve the Customer Number **/
 
             IF   COND(&WWCUST *NE '*ALL  ')  THEN(DO)
                IF   COND(&WWFIRST *EQ 'N') THEN(DO)
                 CHGVAR VAR(&QRYSLT) VALUE('FQCUST *EQ "' *CAT &WWCUST *CAT '" ')
                 CHGVAR VAR(&WWFIRST) VALUE('Y')
                ENDDO
                ELSE DO
                 CHGVAR     VAR(&QRYSLT) VALUE(&QRYSLT *TCAT ' *AND +
                         FQCUST *EQ "' *CAT &WWCUST *CAT '" ')
                ENDDO
             ENDDO
 
/** Retrieve the Portfolio Reference **/
 
             IF   COND(&WWPTFR *NE '*ALL')  THEN(DO)
                IF   COND(&WWFIRST *EQ 'N') THEN(DO)
                 CHGVAR VAR(&QRYSLT) VALUE('FQPTFR *EQ "' *CAT &WWPTFR *CAT '" ')
                 CHGVAR VAR(&WWFIRST) VALUE('Y')
                ENDDO
                ELSE DO
                 CHGVAR     VAR(&QRYSLT) VALUE(&QRYSLT *TCAT ' *AND +
                         FQPTFR *EQ "' *CAT &WWPTFR *CAT '" ')
                ENDDO
             ENDDO
 
/** Retrieve the Fee type **/
 
             IF   COND(&WWFETP *NE '*ALL')  THEN(DO)
                IF   COND(&WWFIRST *EQ 'N') THEN(DO)
                 CHGVAR VAR(&QRYSLT) VALUE('FQFETP *EQ "' *CAT &WWFETP *CAT '" ')
                 CHGVAR VAR(&WWFIRST) VALUE('Y')
                ENDDO
                ELSE DO
                 CHGVAR     VAR(&QRYSLT) VALUE(&QRYSLT *TCAT ' *AND +
                         FQFETP *EQ "' *CAT &WWFETP *CAT '" ')
                ENDDO
             ENDDO
 
/**  Open query file.  **/
 
             OVRDBF  FILE(GLFEAQPD) TOFILE(GLFEACPD) SHARE(*YES)
             IF   COND(&WWFIRST *EQ 'N') THEN(DO)
             OPNQRYF    FILE((GLFEACPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(GLFEAQPD) KEYFLD((FQBRCA) (FQACOC) +
                          (FQCUST) (FQPTFR) (FQFETP)) +
                          JFLD((GLFEACPD/F6CNUM SDCUSTPD/BBCUST) +
                          (GLFEACPD/F6CNUM *MAPFLD/CNUM) +
                          (GLFEACPD/F6PTFR PMPORTPD/PNPTFR)) +
                          JDFTVAL(*YES) MAPFLD((CNUM +
                          'PMPORTPD/PNCNUM' *CHAR 6) (FQBRCA +
                          F6BRCA) (FQCUST BBCUST) (FQCRNM BBCRNM) +
                          (FQACOC BBACOC) (FQPTFR F6PTFR) (FQPTFN +
                          PNPTFN) (FQFETP F6FETP) (FQCHGR F6CHGR) +
                          (FQACCY F6ACCY) (FQACDT F6ACDT) (FQMACP +
                          F6MACP) (FQOTAJ F6OTAJ) (FQOTSG F6OTSG) +
                          (FQLCD F6LCD) (FQLCTM F6LCTM) (FQCHTP +
                          F6CHTP) (FQFRPE F6FRPE) (FQTOPE F6TOPE))
             ENDDO
             ELSE DO
             OPNQRYF    FILE((GLFEACPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(GLFEAQPD) QRYSLT(&QRYSLT) +
                          KEYFLD((FQBRCA) (FQACOC) (FQCUST) +
                          (FQPTFR) (FQFETP)) JFLD((GLFEACPD/F6CNUM +
                          SDCUSTPD/BBCUST) (GLFEACPD/F6CNUM +
                          *MAPFLD/CNUM) (GLFEACPD/F6PTFR +
                          PMPORTPD/PNPTFR)) JDFTVAL(*YES) +
                          MAPFLD((CNUM 'PMPORTPD/PNCNUM' *CHAR 6) +
                          (FQBRCA F6BRCA) (FQCUST BBCUST) (FQCRNM +
                          BBCRNM) (FQACOC BBACOC) (FQPTFR F6PTFR) +
                          (FQPTFN PNPTFN) (FQFETP F6FETP) (FQCHGR +
                          F6CHGR) (FQACCY F6ACCY) (FQACDT F6ACDT) +
                          (FQMACP F6MACP) (FQOTAJ F6OTAJ) (FQOTSG +
                          F6OTSG) (FQLCD F6LCD) (FQLCTM F6LCTM) +
                          (FQCHTP F6CHTP) (FQFRPE F6FRPE) (FQTOPE +
                          F6TOPE))
             ENDDO
 
/**   Call program  **/
 
             CALL       PGM(GL1985) +
                        PARM(&MODE &RSEQ &RENT &WWACOC &WWCUST &WWPTFR &WWFETP)
             CLOF       OPNID(GLFEACPD)
             DLTOVR     FILE(GLFEAQPD)
 
/** Database error processing **/
 
             IF         COND(%SWITCH(XXXXXX11)) +
                 THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM      ) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1985 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
