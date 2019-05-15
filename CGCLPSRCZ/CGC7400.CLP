/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CG Audit Letter Reminder Housekeeping')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7400 - CG Audit Letter Reminder Housekeeping (COB)       */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG24239           Date 08Jun09              */
/*                      CER041  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG24239 - Component CGC7400 00001 failed.                  */
/*       CER041 - Audit Letters Correspondence                       */
/*                (Upgrade of FGE132 and FGE171)                     */
/*                                                                   */
/*********************************************************************/
 
/**********  PGM        PARM(&CNAM &CSEQ)      */                                       /*BUG24239*/
             PGM                                                                        /*BUG24239*/
 
/*  Declare the variables                                            */
 
/**********  DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)               */                 /*BUG24239*/
/**********  DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                 */                 /*BUG24239*/
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
 
/*-------------------------------------------------------------------*/
/* Global Monitor Message                                            */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
 
/*  Send a message to say the component is running                   */
 
             SNDPGMMSG  MSG('CGC7400 - CG Audit Letter +
                   Reminder Housekeeping') TOMSGQ(MRUNQ)
 
 
/*  Call the Housekeeping Program                                    */
 
             CALL       PGM(CG7400)
 
/*  Database error handling                                          */
 
             IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
                RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&DATA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/* Function termination                                             */
 
             GOTO END
/*-------------------------------------------------------------------*/
/* Abnormal termination processing                                   */
/*-------------------------------------------------------------------*/
ABNORMAL:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC7400 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC7400 ended abnormally') MSGTYPE(*ESCAPE)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2008')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*  Logical end of the program                                       */
 END:
 
/* Normal termination                                             */
 
             CHGVAR  VAR(&CPYFLD) +
                VALUE('Copyright Finastra International Limited +
                      2008')
             MONMSG (CPF0000 MCH0000 RPG0000)
 
 
             ENDPGM
