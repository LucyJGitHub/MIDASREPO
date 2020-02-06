/*STD    CLPBASE                                                     */
/*EXI    TEXT('Utility to patch account keys')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Dealing Module                             */
/*                                                                   */
/*       UTCB23884 - CL program to call datapatch PGM/UTB23884       */
/*                                                                   */
/*       (c) Copyright Finastra International Limited 2009           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG23884 *CREATE   Date 11Jun09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23884 - Tax deduction on MM Deals shows customer name    */
/*                  as narrative                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra International Limited +
                          Systems 2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Start of program */
 
             SNDPGMMSG  MSG('Utility Patch UTCB23884 started') TOMSGQ(MRUNQ)
 
/* Check if parameter passed is 'U', 'u', 'A' or 'a' or if invalid. */
 
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
             SNDPGMMSG  MSG('Invalid parameter passed to UTCB23884') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. It should either be +
                          ''U'' or ''u'' for Update and ''A'' or +
                          ''a'' for Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Start Commitment Control */
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/* Call PGM/UTB23884 */
 
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(UTB23884) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCB23884 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             ROLLBACK
 
             GOTO       CMDLBL(ENDPGM)
 
 END:        SNDPGMMSG  MSG('Utility Patch UTCB23884 succesfully +
                          ended') TOMSGQ(MOPERQ)
             COMMIT
 
/* End program */
 ENDPGM:     ENDCMTCTL
             ENDPGM
