/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Today's Credit Interest Posting List')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC200204 - Midas SD Today's Credit Interest Posting List   */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      CER054  *CREATE    Date 07Apr09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER054 - German Features - Church Tax                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQN &PLEVL &PENTY)
 
             DCL        VAR(&PSEQN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLEVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PENTY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMEMO) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDMSG     MSG('SDC200204 - TODAYS CREDIT INTEREST +
                          POSTINGS') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(SD200204) PARM(&PSEQN)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&PMEMO)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&PMEMO) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
ABNOR:
             SNDMSG     MSG('Program SDC200204 - Todays Credit Interest +
                           Postings ended abnormally.') TOMSGQ(MOPERQ MRUNQ)
 
/* End Program */
 
END:         MONMSG      MSGID(CPF2105)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             ENDPGM
 
