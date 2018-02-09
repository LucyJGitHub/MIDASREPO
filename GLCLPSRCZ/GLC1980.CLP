/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Cust. Serv. Fees - Accruals Adjustm. RPT')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1980 - Customer Service Fees - Accrual Adjustments       */
/*                 Audit                                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
/** Variables **/
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
 
             OVRDBF  FILE(GLFEAQPD) TOFILE(GLFEACPD) SHARE(*YES)
             OPNQRYF    FILE((GLFEACPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(GLFEAQPD) KEYFLD((FQBRCA) (FQACOC) +
                          (FQCUST) (FQPTFR) (FQFETP)) +
                          JFLD((GLFEACPD/F6CNUM SDCUSTPD/BBCUST) +
                          (GLFEACPD/F6CNUM *MAPFLD/CNUM) +
                          (GLFEACPD/F6PTFR PMPORTPD/PNPTFR)) +
                          JDFTVAL(*YES) MAPFLD((CNUM 'PMPORTPD/PNCNUM' *CHAR 6)         +
                          (FQBRCA F6BRCA) (FQCUST BBCUST) (FQCRNM BBCRNM) +
                          (FQACOC BBACOC) (FQPTFR F6PTFR) (FQPTFN +
                          PNPTFN) (FQFETP F6FETP) (FQCHGR F6CHGR) +
                          (FQACCY F6ACCY) (FQACDT F6ACDT) (FQMACP +
                          F6MACP) (FQOTAJ F6OTAJ) (FQOTSG F6OTSG) +
                          (FQLCD F6LCD) (FQLCTM F6LCTM) (FQCHTP +
                          F6CHTP) (FQFRPE F6FRPE) (FQTOPE F6TOPE))
 
/** Call program **/
 
             CALL       PGM(GL1980) PARM(&MODE &RSEQ)
             CLOF       OPNID(GLFEACPD)
             DLTOVR     FILE(GLFEAQPD)
 
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
                            GLC1980 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
