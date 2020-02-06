/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Cust. Serv. Fees - Settl. Authoris.  RPT')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1981 - Customer Service Fees -  Settlements              */
/*                 Authorisations Audit Control                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
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
 
             OVRDBF  FILE(GLOTSQPD) TOFILE(GLOTSTPD) SHARE(*YES)
             OPNQRYF    FILE((GLOTSTPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(GLOTSQPD) +
                          KEYFLD((FQBRCA) (FQACOC) (FQCUST) (FQPTFR) +
                          (FQFETP)) JFLD((GLOTSTPD/F7CNUM +
                          SDCUSTPD/BBCUST) (GLOTSTPD/F7CNUM +
                          *MAPFLD/CNUM) (GLOTSTPD/F7PTFR +
                          PMPORTPD/PNPTFR)) +
                          JDFTVAL(*YES) +
                          MAPFLD((CNUM 'PMPORTPD/PNCNUM' *CHAR 6) (FQBRCA F7BRCA) (FQCUST BBCUST) +
                          (FQCRNM BBCRNM) (FQACOC BBACOC) (FQPTFR F7PTFR) (FQCHGR F7CHGR) +
                          (FQPTFN PNPTFN) (FQFETP F7FETP) (FQACCY F7ACCY) (FQACDT F7ACDT) +
                          (FQMACP F7MACP) (FQOTAJ F7OTAJ) (FQOTSG F7OTSG) +
                          (FQSTCY F7STCY) (FQACCN F7ACCN) (FQSTBR F7STBR) +
                          (FQSCUS F7SCUS) (FQACSQ F7ACSQ) (FQSTVD F7STVD) +
                          (FQAUID F7AUID) (FQLCD F7LCD) (FQLCTM F7LCTM) +
                          (FQCHTP F7CHTP) (FQFRPE F7FRPE) (FQTOPE F7TOPE))
 
/** Call program **/
 
             CALL       PGM(GL1981) PARM(&MODE &RSEQ &RENT)
             CLOF       OPNID(GLOTSTPD)
             DLTOVR     FILE(GLOTSQPD)
 
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
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
                            GLC1981 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
