/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account Pooling Housekeeping')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ114*-*Account*Pooling*Housekeeping***********************/ /*JMI108*/
/*       XXCJ124 - Account Pooling Housekeeping                      */ /*JMI108*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/ /*JMI108*/
/*       (c) Finastra International Limited 2018                     */ /*JMI108*/
/*                                                                   */
/*       Last Amend No. JMI108             Date 31May18              */
/*       Prev Amend No. TFJ011  *CREATE    Date 24Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Pooling Housekeeping                       */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI108*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI108*/

/* ----------------------------------------------------------------- */
/* Global monitor message                                            */
/* ----------------------------------------------------------------- */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* ----------------------------------------------------------------- */
/* Initialization                                                    */
/* ----------------------------------------------------------------- */

/*           SNDPGMMSG  MSG('GLCJ114 - Midas GL Account Pooling Housekeeping +
                          Program') TOMSGQ(MRUNQ) */ /*JMI108*/
             SNDPGMMSG  MSG('XXCJ124 - Midas GL Account Pooling Housekeeping +
                          Program') TOMSGQ(MRUNQ) /*JMI108*/

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

/*           CLRPFM     FILE(GLPLDTPP) */ /*JMI108*/
/*           CLRPFM     FILE(GLJEIPXA) */ /*JMI108*/
/*           CALL       PGM(GLJ114)    */ /*JMI108*/
             CLRPFM     FILE(XXPLDTPP) /*JMI108*/
             CLRPFM     FILE(XXJEIPXA) /*JMI108*/
             CALL       PGM(XXJ124) /*JMI108*/

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
                             ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) */ /*JMI108*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ124 +
                             ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) +
                             /*JMI108*/
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

/* ----------------------------------------------------------------- */
/* End Program                                                       */
/* ----------------------------------------------------------------- */

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*JMI108*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*JMI108*/

             ENDPGM
