/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Submit Journal Posting Job')                    */
/********************************************************************/
/*                                                                  */
/*    Midas - General Ledger Module                         */
/*                                                                  */
/*    GLSBMBCH1 - SUBMIT JNL ENTRY JOB - REAL TIME POSTING          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    PREV AMEND NO             DATE -                              */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&BNUM)
 
/* Declare variables :                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&WRKSTN)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BNUM)   TYPE(*CHAR) LEN(3)
 
/* Global message monitor :                                     */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAGEND))
 
/* Get the current job name so that errors can be sent to user  */
 
             RTVJOBA    JOB(&WRKSTN)
 
/* Send msg to prevent COB taking place during the batch job    */
 
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/* Submit the Posting job :                                     */
 
             SNDPGMMSG  MSGID(USR1000) MSGF(GLUSRMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
 
             SBMJOB     JOB(GLC450) JOBD(MBATCH) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          GLC450 PARM(''' *CAT &BNUM *CAT ''' ''' +
                          *CAT &WRKSTN *TCAT ''')') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ)
 
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)
 
             GOTO       CMDLBL(PGMEND)
 
 TAGEND:
             SNDPGMMSG  MSG('Error in message handling program - +
                          contact System Supervisor')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 PGMEND:     ENDPGM
