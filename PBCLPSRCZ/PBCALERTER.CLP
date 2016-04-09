/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Format MQSeries msg for Alerter')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       PBCALERTER - Submit job PBALERTER                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPB009  *CREATE    Date 13Sep02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPB009 - PB Operator Message Handling                       */
/*                (PB Alerter - error tracking)                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&P_GRAVITY &P_APP &P_PROCESS &P_TITLE +
                          &P_BODY)
 
             DCL        VAR(&P_GRAVITY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P_APP) TYPE(*CHAR) LEN(15)
             DCL        VAR(&P_PROCESS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&P_TITLE) TYPE(*CHAR) LEN(255)
             DCL        VAR(&P_BODY) TYPE(*CHAR) LEN(3000)
 
/* Submit PBALERTER */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ENDPGM))
 
             SBMJOB     CMD(CALL PGM(PBALERTER) PARM(&P_GRAVITY +
                          &P_APP &P_PROCESS &P_TITLE &P_BODY)) +
                          JOB(PBCALERTER) JOBD(TIJOBD) OUTQ(*JOBD) +
                          USER(*JOBD) LOGCLPGM(*NO)
 
ENDPGM:
             ENDPGM
