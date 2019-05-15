/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Submit/end HAFMONITOR')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility                      */
/*                                                                   */
/*       HFC0250 - Submit or end HAFMONITOR.                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      046788             DATE  6NOV92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       046788 - New program to give user more control over         */
/*                HAFMONITOR.                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ACTION)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50) +
                          VALUE('Program HFC0250 ended abnormally.')
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(6)
 
/* Global monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* If the action is SUBMIT */
 
             IF         COND(&ACTION *EQ 'SUBMIT') THEN(DO)
 
/* If unable to allocate HFLOCK then HAFMONITOR is already active */
 
                ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(0)
                MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* Inform user that HAFMONITOR is already active */
 
                   RTVMSG     MSGID(HFM0011) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                   CALL       PGM(HFC0010) PARM('HFC0250' 'ENTER' ' ')
                   GOTO       CMDLBL(END)
                ENDDO
 
/* Ensure that DTAARA/HFCOB is blank */
 
                CHGDTAARA  DTAARA(HFCOB) VALUE('     ')
 
/*/COPY WNCPYSRC,HFC0250001                                          */
/* Submit the HAF monitor program */
 
/************** SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +   /*110242*/
/*************               JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +  /*110242*/
/*************               INLLIBL(*JOBD) */                        /*110242*/
/************   SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +                       /*CPK014*/
/************                JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +                      /*CPK014*/
/************                RTGDTA(*JOBD) INLLIBL(*JOBD)             /*110242*/          /*CPK014*/
/************   SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +                       /*CSC023*/
/************             JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
                SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +
                          JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)            /*CSC023*/
                GOTO       CMDLBL(END)
             ENDDO
 
/* If the action is END */
 
             IF         COND(&ACTION *EQ 'END') THEN(DO)
 
/* If unable to allocate HFLOCK then HAFMONITOR is active */
 
                ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(0)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGDTAARA  DTAARA(HFCOB) VALUE(STOP)
                   GOTO       CMDLBL(END)
                ENDDO
 
/* Inform user that HAFMONITOR is not active */
 
                RTVMSG     MSGID(HFM0012) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                CALL       PGM(HFC0010) PARM('HFC0250' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Abnormal termination processing */
 
 ABNOR:
 
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
 
 END:
 
/* Deallocate HFLOCK */
 
             DLCOBJ     OBJ((HFLOCK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
