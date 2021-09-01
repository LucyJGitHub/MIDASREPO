/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Italian Features Extension Files Purge')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDCM100 - Italian Features Extension Files Purge Control    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/*       Last Amend No. LUC139             Date 08Jan21              */
/*       Prev Amend No. BUG14131 *CREATE   Date 06Jun07              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC139 - UCI Italian returns upgrade to FM2.1               */
/*       BUG14131 - Correction on CER009 Deliverable Data            */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)

/** Set up and send pgm message */

             SNDPGMMSG  MSG('SDCM100 - Italian Features Extension +
                          Files Purge Control') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)

/** Catch Global Errors */

             MONMSG     MSGID(MCH0000 CPF0000 TCP0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/** Clear switches */

             CHGJOB     SWS(00000000)

/** Purge the Extension Files */

/*           CLRPFM     FILE(GLJIT1PD)          */  /*LUC139*/
/*           CLRPFM     FILE(GLJPT1PD)          */  /*LUC139*/

             CALL       PGM(SDM100)

/** If the program fails */

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

/** If the component completes normally, reset the value of the */
/** restart flag to 'N'  */

             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')

             GOTO       CMDLBL(END)

/** Abnormal termination - batch job */

 ABNOR:      CHGJOB     SWS(XXXXXX11)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SDCM100 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:
             ENDPGM
