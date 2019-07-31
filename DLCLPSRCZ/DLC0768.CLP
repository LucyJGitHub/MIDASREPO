/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Daily purging of Time/Call statements')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0768 - Purge DLTCSTPD records after retention period     */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6474            Date 18Apr05              */
/*                      CDL012  *CREATE    Date 12Aug03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6474 (00041016) - Commitment definition not valid.       */
/*       CDL012 - Interest Statements for Call/Time Deposits.        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)
 
                                                                                         /*BUG6474*/
/** Global monitor message */                                                            /*BUG6474*/
                                                                                         /*BUG6474*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                 /*BUG6474*/
                                                                                         /*BUG6474*/
             SNDPGMMSG  MSG('Daily Purging of Time/Call deposits +
                          Statements') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(DL0768)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('Error in purging +
                          Time/Call deposits statements')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(MOPERQ)
             ENDDO
 
/** SKIP abnormal processing  */                                                         /*BUG6474*/
             GOTO       CMDLBL(END)                                                      /*BUG6474*/
                                                                                         /*BUG6474*/
ABNOR:                                                                                   /*BUG6474*/
             DMPCLPGM                                                                    /*BUG6474*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG6474*/
             CHGJOB     SWS(XXXXXX11)                                                    /*BUG6474*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG6474*/
                                                                                         /*BUG6474*/
/* Abnormal termination - batch job */                                                   /*BUG6474*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0768 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)                                                 /*BUG6474*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG6474*/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
