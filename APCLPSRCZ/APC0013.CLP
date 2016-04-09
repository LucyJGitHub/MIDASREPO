/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AP API transactions repaired/completed today')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APC0013 - Transactions Repaired/Completed Today             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. CAP190             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG13549 *CREATE   Date 14Mar07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CAP190 - Customer Exchange MQ enabling.  (Recompile)        */
/*       BUG13549 - Reverse MQ Series Interface Changes. Create      */
/*                  another CL for MQ instead.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*   Set off switches  */
/**/
             CHGJOB     SWS(00000000)
/**/
/*   Retrieve job information  */
/**/
             RTVJOBA       JOB(&JOB)
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 1 1))
/**/
/*   Check if another job is active and wait until it has ended */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 CHECK:      CRTDTAARA  DTAARA(&TOLIB/APC0013) TYPE(*CHAR) LEN(1)
             MONMSG     MSGID(CPF1023) EXEC(DO)
             DLYJOB     DLY(30)
             GOTO       CMDLBL(CHECK)
             ENDDO
/**/
/* Call report program     */
/**/
 CLEAR:      CLRPFM     FILE(APTLOGPD)
 
             MONMSG     MSGID(CPF1002) EXEC(DO)
             DLYJOB     DLY(60)
             GOTO       CMDLBL(CLEAR)
             ENDDO
 
             CALL       PGM(AP0013LE) PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
/* Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
/**/
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination  */
/**/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            APC0013 ended abnormally ') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        DLTDTAARA  DTAARA(&TOLIB/APC0013)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
