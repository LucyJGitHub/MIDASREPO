/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Allocate files')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ106*-*Midas*GL*Allocate files****************************/ /*EML110*/
/*       XXCJ116 - Midas GL Allocate files                           */ /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/ /*EML110*/
/*       (c) Finastra International Limited 2018                     */ /*EML110*/
/*                                                                   */
/*       Last Amend No. EML110             Date 20Jan20              */
/*       Prev Amend No. TFJ11A             Date 23Jan07              */
/*                      TFJ011  *CREATE    Date 15Mar05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ11A - Account Transfer Service                           */
/*       TFJ011 - (CHG006) Allocate files before calling GLJ106      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCOD)

             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*EML110*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*EML110*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             ALCOBJ     OBJ((GLJEIPPD *FILE *EXCL)) WAIT(0)
/* Unable to allocate, Return error parameter */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&RETCOD) VALUE('*ERROR')
             ENDDO
                                                                                          /*TFJ11A*/
             ALCOBJ     OBJ((GLJEIHPD *FILE *EXCL)) WAIT(0)                               /*TFJ11A*/
/* Unable to allocate, Return error parameter */                                          /*TFJ11A*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*TFJ11A*/
             CHGVAR     VAR(&RETCOD) VALUE('*ERROR')                                      /*TFJ11A*/
             ENDDO                                                                        /*TFJ11A*/

             GOTO       CMDLBL(END)

 ABNOR:

              CHGJOB     SWS(XXXXXX11)

/*            SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ106 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) */ /*EML110*/
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ116 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) +
                           /*EML110*/
                MONMSG     MSGID(CPF0000 MCH0000)

/* END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                             Systems Ltd.') */ /*EML110*/
 END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                             2018') /*EML110*/

              ENDPGM
