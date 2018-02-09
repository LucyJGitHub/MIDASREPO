/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - End Feeder and Trigger-COB')   */
/*********************************************************************/
/*                                                                   */
/*       Midas / Replication                                         */
/*                                                                   */
/*     RPC5045 - Midas-TrOpics Interface - End Feeder and Trigger-COB*/
/*                                                                   */
/*       (C) COPYRIGHT Finastra International Limited 2005           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD026             Date 05Apr05              */
/*                      UTROPX  *CREATE    Date 21Dec01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TrOpics Interface                            */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSTS) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                           Copyright Finastra International Limited +
                           2001')
/**/
/**  Global Monitor Message                                        **/
/**/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC5045 Midas-TrOpics Interface - End +
                          Feeder and Trigger - COB') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
/**/
/** Set status of component for start of processing.               **/
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CSTS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
/**/
/**  Call the program to end the Feeder and Trigger jobs.          **/
/**/
             CALL       PGM(RPC5040)
/**/
/**  If any errors are reported, perform error processing.         **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(TAG998)
             ENDDO
/**/
/** Set status of component for successful completion.             **/
/**/
             CHGVAR     VAR(&CSTS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
 
             GOTO       CMDLBL(TAG999)
 
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
TAG998:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job terminated - RPC5045 Midas-TrOpics +
                          Interface - End Feeder and Trigger - COB +
                          - Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
/**/
/**  End of Program:                                                 */
TAG999:
             ENDPGM
