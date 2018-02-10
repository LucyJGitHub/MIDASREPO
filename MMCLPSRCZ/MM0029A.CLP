/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Revalue daily positions control')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - MM Dealer Module                                */
/*                                                                   */
/*       MM0029A - REVALUE DAILY POSITIONS CONTROL                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01319             Date  03Dec91             */
/*                    S01117            DATE   18FEB91               */
/*                    E20773            DATE   25FEB90               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*     S01319 - Changes for Project Harry.  FOJOBQ and FOJOBD no     */
/*              longer used.                                         */
/*     S01117 - UPGRADED FOR RELEASE 10.                             */
/*                                                                   */
/*     E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)          */
/*              & INLLIBL(*JOBD).                                    */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*     Program checks whether Revaluation is in progress, and if not */
/*     It submits MM0053.                                            */
PGM
 
                                                            /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                            /*S01117*/
             DCLF       FILE(MMREVCLL)
/**/
/* GLOBAL ERROR TRAP                                               */
             MONMSG     MSGID(CPF0000 CPA0000 RPG0000 MCH0000) +
                          EXEC(GOTO CMDLBL(TAG999))
/**/
 
             OVRDBF     FILE(MMREVCLL) SHARE(*NO)
 
/**/
/** READ FILE                                                      */
             RCVF
             DLTOVR     FILE(MMREVCLL)
/**/
/**/
/** IF REVALUATION IN PROGRESS IND THEN DO NOTHING                 */
             IF         COND(&IDRIPI *EQ 'Y')   THEN(GOTO TAG001)
/**/
/** SUBMIT JOB                                                     */
/* E20773    SBMJOB     JOBD(FOJOBD) USER(*JOBD) RTGDTA(MBATCH) +
                          RQSDTA('CALL MM0053 PARM('' '')') +
                          MSGQ(MOPERQ)    E20773 */
/************SBMJOB*****JOBD(FOJOBD) USER(*JOBD) RTGDTA(MBATCH) +
/***********************  RQSDTA('CALL MM0053 PARM('' '')') +
/***********************  INLLIBL(*JOBD) MSGQ(MOPERQ) /* E20773 */    /*S01319*/
/************SBMJOB     JOBD(MEODD) USER(*CURRENT) RTGDTA(MBATCH) +                       /*CPK014*/
/************             RQSDTA('CALL MM0053 PARM('' '')') +                             /*CPK014*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*S01319*/          /*CPK014*/
/************SBMJOB     JOBD(MEODD) USER(*JOBD) RTGDTA(MBATCH) +                          /*CSC023*/
/************             RQSDTA('CALL MM0053 PARM('' '')') +                             /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CPK014*/ /*CSC023*/
             SBMJOB     JOBD(MEODD) USER(*JOBD) RTGDTA(MBATCH) +
                          RQSDTA('CALL MM0053 PARM('' '')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/**/
/* BRANCH TO END OF PROGRAM                                         */
   GOTO TAG001
/**/
/* ERROR HANDLING ROUTINE                                           */
   TAG999:
              CHGDTAARA DTAARA(*LDA (171 10) ) VALUE('MM0029A')
              CHGDTAARA DTAARA(*LDA (181 3) ) VALUE('991')
              DMPCLPGM
 
 
 TAG001:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
