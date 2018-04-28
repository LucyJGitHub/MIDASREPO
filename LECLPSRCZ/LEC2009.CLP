/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Loan Manager interface monitor')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2009 - Loan Manager Interface Monitor                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Function:  To call the Loan Manager Interface Monitor pgm   */
/*                                                                   */
/*       Calls:     LE2009                                           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 203561  *CREATE    Date 17Jun02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       203561 - Enable greater user control over the Loan Manager  */
/*                Interface. Also, build in more handshaking between */
/*                the two products and allow for better control of   */
/*                Loan Manager branches and servers                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/** Global Monitor Message:                                       */
/** If an unmonitored message occurs perform error processing     */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             CALL       PGM(LE2009)
 
/* Error processing                                               */
/* Retrieve LDA and store values                                  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination                                          */
 ABNOR:
             SNDPGMMSG  MSG('Loan Manager Interface Monitor has +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SCC0010) PARM('LEC2009' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Normal termination                                            */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
