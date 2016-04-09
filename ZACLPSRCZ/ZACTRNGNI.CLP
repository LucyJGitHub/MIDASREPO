/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ZA Control trans num. gen. - interactive')      */
/*********************************************************************/
/*                                                                   */
/*       Midas Standard routines                                     */
/*                                                                   */
/*       ZACTRNGNI - Control Interactive Trans. Number Generation    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC024             Date 09Aug05              */
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP003  *CREATE    Date 24May98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC024 - Open Month End                                     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP003 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RETURNCODE &MODU &TRTY)
/**/
/** Declares                                                         */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/** Return code, module, transaction type **/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODU      ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TRTY      ) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&PGMCALL)     TYPE(*CHAR) LEN(50)
 
/** +
    The global monitor sends an escape message, which will end the +
    program instantly if it is executed. +
**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area')
             MONMSG     MSGID(CPF0000)
 
/**/
/**  Attempt to allocate transaction number generation program */
/**/
             ALCOBJ     OBJ((ZATRNGEN *PGM *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                GOTO    CMDLBL(END)
             ENDDO
     /*BEGIN CSC024 */
             OVRDBF     FILE(ZAAVSTXX) TOFILE(ZAAVSTL0) SHARE(*NO)
             OVRDBF     FILE(ZAAVFFXX) TOFILE(ZAAVFFL0) SHARE(*NO)
             OVRDBF     FILE(ZAAVSDXX) TOFILE(ZAAVSDL0) SHARE(*NO)
     /*END   CSC024 */
 
/**/
/**  Call the transaction number generation program */
/**  to create 10 transaction numbers */
/**/
             CALL       PGM(ZATRNGEN) PARM(&RETURNCODE &MODU &TRTY +
                          X'0000010F')
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO    CMDLBL(ABNOR)
             ENDDO
 
     /*BEGIN CSC024  */
             DLTOVR     FILE(ZAAVSTXX)
             DLTOVR     FILE(ZAAVFFXX)
             DLTOVR     FILE(ZAAVSDXX)
     /*END   CSC024  */
/**/
/**  If error found, end this program */
/**/
             IF         COND(&RETURNCODE = 'Error') THEN(DO)
                GOTO    CMDLBL(ABNOR)
             ENDDO
 
/**/
/**  Submit Batch generation program */
/**/
             CHGVAR     VAR(&PGMCALL) VALUE('CALL ZACTRNGNB PARM(' +
                          *CAT 'OK ' *CAT ' ' *CAT &MODU +
                          *CAT ' ' *CAT &TRTY *CAT ')')
/************SBMJOB     JOB(TRNOGEN) JOBD(MBATCH) JOBQ(MEODQ) +                           /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) +                                     /*CSC023*/
/************             RQSDTA(&PGMCALL) INLLIBL(*CURRENT) +                            /*CSC023*/
/************             MSGQ(*NONE)                                                     /*CSC023*/
             SBMJOB     JOB(TRNOGEN) JOBD(MBATCH) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&PGMCALL) INLLIBL(*CURRENT) +
                          MSGQ(*NONE) OUTQ(*JOBD)                                         /*CSC023*/
 
             GOTO END
 
ABNOR:
             CHGVAR     VAR(&RETURNCODE) VALUE('Error')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          while generating transaction numbers') +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
/**/
/**  Deallocate transaction number generation program */
/**/
END:
             DLCOBJ     OBJ((ZATRNGEN *PGM *EXCL))
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
