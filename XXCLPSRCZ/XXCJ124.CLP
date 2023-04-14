/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account Pooling Housekeeping')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ114*-*Account*Pooling*Housekeeping***********************/ /*EML110*/
/*       XXCJ124 - Account Pooling Housekeeping                      */ /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/ /*EML110*/
/*       (c) Finastra International Limited 2018                     */ /*EML110*/
/*                                                                   */
/*       Last Amend No. 255739             Date 20Oct22              */
/*       Prev Amend No. EML110             Date 20Jan20              */
/*                      TFJ011  *CREATE    Date 24Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       255739 - MIDAS+ : Midas+ : I/F number on Cash Pooling has   */
/*                not been assigned correctly.                       */
/*              - Applied for MD-60621.                              */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Pooling Housekeeping                       */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*EML110*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*EML110*/

                                                                                         /*255739*/
             DCLF       FILE(XXPICDPP)                                                   /*255739*/
                                                                                         /*255739*/
/* ----------------------------------------------------------------- */
/* Global monitor message                                            */
/* ----------------------------------------------------------------- */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* ----------------------------------------------------------------- */
/* Initialization                                                    */
/* ----------------------------------------------------------------- */

/*           SNDPGMMSG  MSG('GLCJ114 - Midas GL Account Pooling Housekeeping +
                          Program') TOMSGQ(MRUNQ) */ /*EML110*/
             SNDPGMMSG  MSG('XXCJ124 - Midas GL Account Pooling Housekeeping +
                          Program') TOMSGQ(MRUNQ) /*EML110*/

/* Obtain Batch No. from Pooling ICD file    */                                           /*255739*/
             RCVF       RCDFMT(XXPICDD0)                                                  /*255739*/
                                                                                          /*255739*/
/* Reset Batch No. from Pooling ICD file   */                                             /*255739*/
             CHGDTAARA  DTAARA(XXPBTCHDA (1 3)) VALUE(&JJ1BNO)                            /*255739*/
                                                                                          /*255739*/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF1015) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
             CHGJOB     SWS(XXXXXX00)

             IF         COND(&JOBTYPE = '0') THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             ENDDO

/* ----------------------------------------------------------------- */
/* Main processing                                                   */
/* ----------------------------------------------------------------- */

/*           CLRPFM     FILE(GLPLDTPP) */ /*EML110*/
/*           CLRPFM     FILE(GLJEIPXA) */ /*EML110*/
/*           CALL       PGM(GLJ114)    */ /*EML110*/
             CLRPFM     FILE(XXPLDTPP) /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000) /*EML110*/
             CLRPFM     FILE(XXJEIPXA) /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000) /*EML110*/
             CALL       PGM(XXJ124) /*EML110*/

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

/* ----------------------------------------------------------------- */
/* Abnormal processing                                               */
/* ----------------------------------------------------------------- */

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             IF         COND(&JOBTYPE = '0') THEN(DO)
/*              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ114 +
                             ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) */ /*EML110*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ124 +
                             ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) +
                             /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

/* ----------------------------------------------------------------- */
/* End Program                                                       */
/* ----------------------------------------------------------------- */

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*EML110*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*EML110*/

             ENDPGM
