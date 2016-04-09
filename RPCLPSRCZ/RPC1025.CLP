/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Plato i/face - download entire sys - COB')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1025 - Midas-Plato Interface - Download entire system-COB*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CPL003  *CREATE    Date 12Oct99              */
/*       Prev Amend No. ------             Date --------             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPL003 - Midas-Plato Interface.                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSTS) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global Monitor Message                                        **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1025 Midas-Plato Interface - +
                          Download Entire Midas System - COB') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Set status of component for start of processing.               **/
 
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CSTS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
 
/* Call the program to download the entire database.             **/
 
             CALL       PGM(RPC1020)
 
/* If any errors are reported, perform error processing.         **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(TAG998)
             ENDDO
 
/* Set status of component for successful completion.             **/
 
             CHGVAR     VAR(&CSTS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
 
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC1025 Midas-Plato +
                          Interface - Download Entire Midas System +
                          - COB - Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
