/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Journal Entry Extraction Monitor Submit')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0300 - Journal Entry Extraction Monitor Submit           */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG11035           Date 20Apr06              */
/*                      CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG11035 - Change OUTQ to point to correct zone             */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((GOAUMTDQ *DTAQ *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((GOAUMTDQ *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/**********  SBMJOB     JOB(GO_AUD_MON) JOBD(MBATCH) +                 */               /*BUG11035*/
/**********               JOBQ(INTERFACE) USER(*JOBD) RTGDTA(*JOBD) +  */               /*BUG11035*/
/**********               RQSDTA('CALL GOC0302') INLLIBL(*JOBD)        */               /*BUG11035*/
             SBMJOB     JOB(GO_AUD_MON) JOBD(MBATCH) JOBQ(INTERFACE) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GOC0302') INLLIBL(*JOBD)                         /*BUG11035*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('GOC0300 has ended ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
