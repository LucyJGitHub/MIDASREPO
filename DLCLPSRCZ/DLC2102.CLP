/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deposits without trust agr. or tax.   i/c')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC2102 - Deposits Without Trust Agreemeent or Taxable      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Phase:  I/C  on request                                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CDL006  *CREATE    Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL006 - Dealing Fiduciary.                                 */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RPARM &RSEQ &RLEV &RENT)
 
/* Declare variables                                               */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* RCF Sequence Number                                             */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
 
/* RCF Level Flag                                                  */
 
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
/* RCF Entity Code (ALL/COMP/BCH)                                  */
 
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
             SNDPGMMSG  MSG('DLC2102 - Fiduciary Deposits without +
                          Trust Agreement') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Select records                                                  */
 
             CHGVAR     VAR(&QRYSLT) VALUE(' DTYP *EQ %VALUES("FT" +
                          "DT") *AND RECI *EQ "D" ')
 
             IF         COND(&RENT *NE ' ' *AND &RENT *NE 'ALL') +
                          THEN(CHGVAR VAR(&QRYSLT) VALUE(&QRYSLT +
                          *TCAT ' *AND BBBRCD *EQ "' *CAT &RENT *CAT +
                          '" '))
 
             OVRDBF     FILE(DLDTKGPD) TOFILE(DEALSDC) SHARE(*YES)
 
             OPNQRYF    FILE((DEALSDC) (SDCUSTPD)) FORMAT(DLDTKGPD) +
                          QRYSLT(&QRYSLT) KEYFLD((BBBRCD) (BBACOC) +
                          (BBCUST) (DLNO)) JFLD((ACNUM BBCUST)) +
                          MAPFLD((ACNUM CNUM *CHAR 6))
 
/* Setup parameter                                                 */
 
             CHGVAR     VAR(&MODE) VALUE(%SST(&RPARM 1 1))
 
/* Call program                                                    */
 
             CALL DL2102 PARM(&MODE &RSEQ &RLEV &RENT)
 
             DLTOVR     FILE(DLDTKGPD)
             CLOF       OPNID(DEALSDC)
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job                                */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DLC2102 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
