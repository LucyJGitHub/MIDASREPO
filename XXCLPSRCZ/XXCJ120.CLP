/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Pooling Instructions Proof list (JE)')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ110*-*Midas*GL*Pooling Instructions Proof list (MM)******/  /*JMI108*/
/*       XXCJ120 - Midas GL Pooling Instructions Proof list (MM)     */  /*JMI108*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/  /*JMI108*/
/*       (c) Finastra International Limited 2018                     */  /*JMI108*/
/*                                                                   */
/*       Last Amend No. JMI108             Date 31May18              */
/*       Prev Amend No. TFJ011  *CREATE    Date 23Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Balance Pooling                            */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&PAPSEQ &SEQ &LVL &ENT)

             DCL        VAR(&PAPSEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI108*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI108*/

/* Global monitor message */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)

/* Call the Midas GL Pooling Instructions Proof list (JE) */
             CHGJOB     SWS(XXXXXX00)
/*           CALL       PGM(GLJ110) PARM(&PAPSEQ &SEQ &LVL &ENT) */ /*JMI108*/
             CALL       PGM(XXJ120) PARM(&PAPSEQ &SEQ &LVL &ENT) /*JMI108*/

/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
             SNDMSG     MSG('Midas GL Pooling Instructions Proof +
                          list (JE) has terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.') */ /*JMI108*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*JMI108*/

             ENDPGM
