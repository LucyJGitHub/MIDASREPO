/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Save database and *JRNRCV save files')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control  module                              */
/*                                                                   */
/*       SCC2452 - Save database and *JRNRCV save files              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 02Feb04              */
/*       Prev Amend No. CPK014  *CREATE    Date 14Feb02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Remove submit from MITEMDD record.                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Submit save job. */
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CSC023*/
/************             JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +                      /*CSC023*/
/************             INLLIBL(*JOBD)                                                  /*CSC023*/
             SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +
                          JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
