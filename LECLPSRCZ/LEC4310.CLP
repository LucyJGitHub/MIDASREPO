/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Cash flow Using All-in-Rate Revaluation')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       LEC4310 - Cash Flow Using All-in-Rate Revaluation           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG10874           Date 16Mar06              */
/*       Prev Amend No. 232628             Date 14Mar05              */
/*                      CAS009             Date 04May04              */
/*                      CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG10874 - Empty member of LOAMSDK not copied               */
/*       232628 - CAS009 Rollover patch (LE).                        */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare variables */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             SNDPGMMSG  MSG('LEC4310 - Customer Lending Cash Flow +
                          Using All-in-Rate Revaluation') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
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
 
/* Clear LECFLAPD file */
 
             CLRPFM     FILE(LECFLAPD)
 
/* Clear PF/LECFLFPD if CAS009 is enabled. */                                             /*CAS009*/
                                                                                          /*CAS009*/
             IF         COND(&CAS009 *EQ 'Y') +
/**********             THEN(CLRPFM FILE(LECFLFPD))  ***/                          /*CAS009 232628*/
             DO                                                                           /*232628*/
                CLRPFM FILE(LECFLFPD)                                                     /*232628*/
                CLRPFM FILE(LESCAMPD)                                                     /*232628*/
                CPYF       FROMFILE(LOAMSDK) TOFILE(LESCAMPD) +
                             MBROPT(*REPLACE) INCREL((*IF RECI *EQ +
                             'D') (*AND AMTP *EQ 'SC')) FMTOPT(*MAP *DROP)                /*232628*/
                MONMSG     MSGID(CPC2957)                                                 /*232628*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*BUG10874*/
                                                                                          /*232628*/
             ENDDO                                                                        /*232628*/
                                                                                          /*CAS009*/
/* Call LE Cash Flow Using All-in-Rate Revaluation */
 
             CALL       PGM(LE4310)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC4310 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
