/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Cash flow revaluation')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Mode                                        */
/*                                                                   */
/*       LEC4110 - Cash Flow Revaluation                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS001  *CREATE    Date 23Nov01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                     */                 /*MD049139*/
             PGM        PARM(&RUNCOND)                                                  /*MD049139*/

/* Declare variables */

             DCL        VAR(&RUNCOND) TYPE(*CHAR) LEN(6)                                /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD049139*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             SNDPGMMSG  MSG('LEC4110 - Customer Lending Cash Flow +
                          Revaluation') TOMSGQ(MRUNQ)

             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             RTVJOBA    TYPE(&JOBTYPE)

/** Determine if switchable feature CLE025 is switched ON then     */                   /*MD049139*/
/** check if program should run based on feature and parameter     */                   /*MD049139*/
                                                                                        /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              (&RUNCOND *EQ 'CLE025')) *OR +
                             ((&CLE025 *NE 'Y') *AND +
                              (&RUNCOND *NE 'CLE025'))) THEN(GOTO +
                        CMDLBL(END))                                                    /*MD049139*/
                                                                                        /*MD049139*/
/* Clear LECFLWPD file */

             CLRPFM     FILE(LECFLWPD)

/* Call LE Cash Flow Revaluation */

             CALL       PGM(LE4110)

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
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC4110 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
