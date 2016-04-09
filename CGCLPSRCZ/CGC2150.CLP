/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Submit purge/archive job for input cycle')   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2150  - U.D.C. Submit Purge/Archive job for Input Cycle  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. 175941             Date 03Jan01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 123441             Date 09Feb98              */
/*                      S01522             Date 21Nov94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       175941 - Flag field in data area CGDTA to indicate job      */
/*                UDC_PRTGEN is running.                             */
/*       123441 - Specify OUTQ parameter                             */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2150 - U.D.C. Submit Purge/Archive +
                          Job for Input Cycle') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Submit Job */
/* */
/*           SBMJOB     CMD(CALL PGM(CGC2160)) JOB(UDC_PURGE) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) USER(*JOBD) +
                          RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ)       123441*/
             SBMJOB     CMD(CALL PGM(CGC2160)) JOB(UDC_PURGE) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(UDC) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ)                                /*123441*/
/*/**/                                                                /*175941*/
/*/* Flag field in data area to indicate UDC_PRTGEN is running */     /*175941*/
/*/**/                                                                /*175941*/
             CHGDTAARA  DTAARA(CGDTA (357 1)) VALUE('Y')              /*175941*/
/* */
/* Submit Job - Daily Periodic Requests */
/* */
/*           SBMJOB     CMD(CALL PGM(CGC5250)) JOB(UDC_DAILY) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) USER(*JOBD) +
                          RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ)       123441*/
             SBMJOB     CMD(CALL PGM(CGC5250)) JOB(UDC_DAILY) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(UDC) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ)                                /*123441*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2150 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2150 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
