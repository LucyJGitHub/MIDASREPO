/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Pooling Data Error Report')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ113*-*Midas*GL*Pooling*Data Error Report*****************/ /*EML110*/
/*       XXCJ123 - Midas GL Pooling Data Error Report                */ /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2005************/ /*EML110*/
/*       (c) Finastra International Limited 2018                     */ /*EML110*/
/*                                                                   */
/*       Last Amend No. EML110             Date 20Jan20              */
/*       Prev Amend No. TFJ011  (CHG141)   Date 23Jan07              */
/*                      TFJ011  *CREATE    Date 26Aug05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - (CHG141) Further Requirements by the Bank          */
/*       TFJ011 - (CHG014) Create a Data Error Report                */
/*                                                                   */
/*********************************************************************/

/**********  PGM        PARM(&RTCD &SEQ &LVL &ENT) */                                     /*CHG141*/
             PGM        PARM(&RTCD &SEQ &LVL &ENT &PSQNO)                                 /*CHG141*/

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT)  TYPE(*CHAR) LEN(3)                                     /*CHG141*/
             DCL        VAR(&PSQNO)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2005') */ /*EML110*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*EML110*/

/* Global monitor message */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)

/* Call the Midas GL Pooling Data Error Report */
             CHGJOB     SWS(XXXXXX00)
/**********  CALL       PGM(GLJ113) PARM(&SEQ &LVL &ENT) */                               /*CHG141*/
/*             CALL       PGM(GLJ113) PARM(&SEQ &LVL &ENT &PSQNO) */ /*CHG141*/ /*EML110*/
             CALL       PGM(XXJ123) PARM(&SEQ &LVL &ENT &PSQNO) /*EML110*/

/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               CHGVAR     VAR(&RTCD) VALUE('*ERROR ')
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO

/*             RGZPFM     FILE(GLPIDLPP) */ /*EML110*/
             RGZPFM     FILE(XXPIDLPP) /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000)

             GOTO       CMDLBL(END)

ABNOR:
             SNDMSG     MSG('Midas GL Pooling Data Error List has +
                          terminated abnormally') TOMSGQ(MOPERQ MRUNQ)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*EML110*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International limited +
                          2018') /*EML110*/

             ENDPGM
