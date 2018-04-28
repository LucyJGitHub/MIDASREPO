/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL CS Fees Outstanding Settlements Control')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1987 - Customer Service Fees Outstanding Settlements     */
/*                 Control                                           */
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
             DCL        VAR(&WWAUID) TYPE(*CHAR) LEN(1)
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
 
/** Clear LDA **/
 
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
             CHGVAR     VAR(&WWACOC) VALUE(%SUBSTRING(&RPARM 1 4))
             CHGVAR     VAR(&WWCUST) VALUE(%SUBSTRING(&RPARM 5 6))
             CHGVAR     VAR(&WWPTFR) VALUE(%SUBSTRING(&RPARM 11 4))
             CHGVAR     VAR(&WWFETP) VALUE(%SUBSTRING(&RPARM 15 4))
             CHGVAR     VAR(&WWAUID) VALUE(%SUBSTRING(&RPARM 19 1))
             CHGVAR     VAR(&WWFIRST) VALUE('N')
             CHGVAR     VAR(&MODE) VALUE('*FULL')
 
/* Select records */
/* Retrieve the Account Officer */
 
             IF   COND(&WWACOC *NE '*ALL')  THEN(DO)
                 CHGVAR VAR(&QRYSLT) VALUE('FQACOC *EQ "' *CAT &WWACOC *CAT '" ')
                 CHGVAR VAR(&WWFIRST) VALUE('Y')
             ENDDO
 
/* Retrieve the Customer Number */
 
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
 
/* Retrieve the Portfolio Reference */
 
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
 
/* Retrieve the Fee type */
 
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
 
/* Retrieve the Settlement Authorised */
 
             IF   COND(&WWAUID *NE 'X')  THEN(DO)
                IF   COND(&WWFIRST *EQ 'N') THEN(DO)
                 CHGVAR VAR(&QRYSLT) VALUE('FQAUID *EQ "' *CAT &WWAUID *CAT '" ')
                 CHGVAR VAR(&WWFIRST) VALUE('Y')
                ENDDO
                ELSE DO
                 CHGVAR     VAR(&QRYSLT) VALUE(&QRYSLT *TCAT ' *AND +
                         FQAUID *EQ "' *CAT &WWAUID *CAT '" ')
                ENDDO
             ENDDO
 
             OVRDBF  FILE(GLOTSQPD) TOFILE(GLOTSTPD) SHARE(*YES)
             IF   COND(&WWFIRST *EQ 'N') THEN(DO)
             OPNQRYF    FILE((GLOTSTPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(GLOTSQPD) KEYFLD((FQBRCA) (FQACOC) +
                          (FQCUST) (FQPTFR) (FQFETP)) +
                          JFLD((GLOTSTPD/F7CNUM SDCUSTPD/BBCUST) +
                          (GLOTSTPD/F7CNUM *MAPFLD/CNUM) +
                          (GLOTSTPD/F7PTFR PMPORTPD/PNPTFR)) +
                          JDFTVAL(*YES) MAPFLD((CNUM +
                          'PMPORTPD/PNCNUM' *CHAR 6) (FQBRCA +
                          F7BRCA) (FQCUST BBCUST) (FQCRNM BBCRNM) +
                          (FQACOC BBACOC) (FQPTFR F7PTFR) (FQPTFN +
                          PNPTFN) (FQFETP F7FETP) (FQCHGR F7CHGR) +
                          (FQACCY F7ACCY) (FQFRPE F7FRPE) (FQTOPE +
                          F7TOPE) (FQACDT F7ACDT) (FQMACP F7MACP) +
                          (FQOTAJ F7OTAJ) (FQOTSG F7OTSG) (FQSTCY +
                          F7STCY) (FQACCN F7ACCN) (FQSTBR F7STBR) +
                          (FQSCUS F7SCUS) (FQACSQ F7ACSQ) (FQSTVD +
                          F7STVD) (FQAUID F7AUID) (FQLCD F7LCD) +
                          (FQLCTM F7LCTM) (FQCHTP F7CHTP))
             ENDDO
             ELSE DO
             OPNQRYF    FILE((GLOTSTPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(GLOTSQPD) QRYSLT(&QRYSLT) +
                          KEYFLD((FQBRCA) (FQACOC) (FQCUST) +
                          (FQPTFR) (FQFETP)) JFLD((GLOTSTPD/F7CNUM +
                          SDCUSTPD/BBCUST) (GLOTSTPD/F7CNUM +
                          *MAPFLD/CNUM) (GLOTSTPD/F7PTFR +
                          PMPORTPD/PNPTFR)) JDFTVAL(*YES) +
                          MAPFLD((CNUM 'PMPORTPD/PNCNUM' *CHAR 6) +
                          (FQBRCA F7BRCA) (FQCUST BBCUST) (FQCRNM +
                          BBCRNM) (FQACOC BBACOC) (FQPTFR F7PTFR) +
                          (FQPTFN PNPTFN) (FQFETP F7FETP) (FQCHGR +
                          F7CHGR) (FQACCY F7ACCY) (FQACDT F7ACDT) +
                          (FQMACP F7MACP) (FQOTAJ F7OTAJ) (FQOTSG +
                          F7OTSG) (FQSTCY F7STCY) (FQACCN F7ACCN) +
                          (FQSTBR F7STBR) (FQSCUS F7SCUS) (FQACSQ +
                          F7ACSQ) (FQSTVD F7STVD) (FQAUID F7AUID) +
                          (FQFRPE F7FRPE) (FQTOPE F7TOPE) (FQLCD +
                          F7LCD) (FQLCTM F7LCTM) (FQCHTP F7CHTP))
             ENDDO
 
/*   Call program  */
 
             CALL       PGM(GL1987) +
                        PARM(&MODE &RSEQ &RENT &WWACOC &WWCUST &WWPTFR &WWFETP &WWAUID)
             CLOF       OPNID(GLOTSTPD)
             DLTOVR     FILE(GLOTSQPD)
 
 
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) +
                 THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      MONMSG     MSGID(CPF0000)
                      GOTO       CMDLBL(END)
                 ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination. **/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1987 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
