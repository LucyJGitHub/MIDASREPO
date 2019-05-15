/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Cash Flow Using All-in-Rate Revaluation')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Money Market Dealing Module                         */
/*                                                                   */
/*       MMC4310 - Midas MM Cash Flow Using All-in-Rate Revaluation  */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS009             Date 04May04              */
/*                      CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MMC4310 - Midas MM Cash Flow using +
                          All-in-Rate Revaluation') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area LDA */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             RTVJOBA    TYPE(&JOBTYPE)
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is enabled. */                                                         /*CAS009*/
/**/                                                                                      /*CAS009*/
           CHGVAR     VAR(&PRTCD) VALUE('       ')                                        /*CAS009*/
           CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                        /*CAS009*/
           CHGVAR     VAR(&PSARD) VALUE('CAS009')                                         /*CAS009*/
                                                                                          /*CAS009*/
           CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                    /*CAS009*/
                                                                                          /*CAS009*/
           CHGVAR     VAR(&CAS009) VALUE('N')                                             /*CAS009*/
           IF         COND(&PRTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                                /*CAS009*/
           ELSE       DO                                                                  /*CAS009*/
           IF         COND(&PRTCD *NE '*NRF   ') +
                      THEN(GOTO CMDLBL(ABNOR))                                            /*CAS009*/
           ENDDO                                                                          /*CAS009*/
 
/* Clear MMCFLAPD file */
 
             CLRPFM     FILE(MMCFLAPD)
 
/* Clear PF/MMCFLFPD if CAS009 is enabled. */                                             /*CAS009*/
                                                                                          /*CAS009*/
             IF         COND(&CAS009 *EQ 'Y') +
                        THEN(CLRPFM FILE(MMCFLFPD))                                       /*CAS009*/
                                                                                          /*CAS009*/
/* Call MM Cash Flow Revaluation */
 
             CALL       PGM(MM4310)
 
/* File controls out of balance */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSG('File Controls Out of Balance') +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MMC4310 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
