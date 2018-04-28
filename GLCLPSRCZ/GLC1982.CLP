/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Cust. Serv. Fees - Fees Accrued Today RPT')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1982 - Customer Service Fees - Fees Accrued Today        */
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
 
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
/** Variables **/
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
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
 
             OVRDBF  FILE(GLTAHQPD) TOFILE(GLTAHIPD) SHARE(*YES)
             OPNQRYF    FILE((GLTAHIPD) (SDCUSTPD)) FORMAT(GLTAHQPD) +
                          KEYFLD((FQBRCA) (FQACOC) (FQFEPT) +
                          (FQFETP) (FQCUST) (FQPTFR) (FQCHGR) +
                          (FQRECI) (FQDPRF) (FQSHSN) (FQINVT) +
                          (FQSCCY) (FQNORM) (FQCPHI)) +
                          JFLD((GLTAHIPD/F2CNUM SDCUSTPD/BBCUST)) +
                          JDFTVAL(*YES) MAPFLD((FQBRCA F2BRCA) +
                          (FQCUST BBCUST) (FQACOC BBACOC) (FQPTFR +
                          F2PTFR) (FQFETP F2FETP) (FQFEPT F2FEPT) +
                          (FQCHGR F2CHGR) (FQRECI F2RECI) (FQINST +
                          F2INST) (FQSRHO F2SRHO) (FQHORF F2HORF) +
                          (FQHCCY F2HCCY) (FQHOAM F2HOAM) (FQHACH +
                          F2HACH) (FQFRAT F2FRAT) (FQCCCY F2CCCY) +
                          (FQCHAM F2CHAM) (FQDPRF F2DPRF) (FQSHSN +
                          F2SHSN) (FQINVT F2INVT) (FQSCCY F2SCCY) +
                          (FQNORM F2NORM) (FQCPHI F2CPHI) (FQFERC +
                          F2FERC) (FQTHTI F2THTI) (FQMINA F2MINA) +
                          (FQMAXA F2MAXA) (FQRANG F2RANG) (FQADAC +
                          F2ADAC) (FQADAM F2ADAM) (FQACAC F2ACAC) +
                          (FQACAM F2ACAM) (FQFRPE F2FRPE) (FQTOPE +
                          F2TOPE))
 
/** Call program **/
 
             CALL       PGM(GL1982) PARM(&RSEQ &RENT &MODE)
             CLOF       OPNID(GLTAHIPD)
             DLTOVR     FILE(GLTAHQPD)
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) +
                 THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      ROLLBACK
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      GOTO       CMDLBL(END)
                 ENDDO
 
                 GOTO   CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1982 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
