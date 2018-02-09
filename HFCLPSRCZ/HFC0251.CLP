/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Start HAFMONITOR')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility                      */
/*                                                                   */
/*       HFC0251 - Start HAFMONITOR in Input Cycle Initiation        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      077466             Date 17Oct94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       077466 - New program created to start the HAFMONITOR        */
/*                if required.                                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&HAFFMT) TYPE(*CHAR) LEN(200)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Access PF/SDHAFDPD to determine whether to submit HAFMONITOR */
 
             CALL       PGM(AOHAFDR0) PARM(&RTCD '*FIRST' &HAFFMT)
 
/* Database error handling */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOHAFDPD') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(%SST(&HAFFMT 14 1) *EQ 'Y') THEN(DO)
               ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(0)
 
/* If unable to allocate HFLOCK then HAFMONITOR is already active  */
/* in the process of being submitted                               */
 
               MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
 
/* Ensure that DTAARA/HFCOB is blank */
 
               CHGDTAARA  DTAARA(HFCOB) VALUE('     ')
 
/* Submit the HAF monitor program */
 
/************  SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +                        /*CPK014*/
/************               JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +                       /*CPK014*/
/************               RTGDTA(*JOBD) INLLIBL(*JOBD)                                  /*CPK014*/
/************  SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +                        /*CSC023*/
/************             JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
               SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +
                          JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)            /*CSC023*/
 
/* Deallocate HFLOCK */
 
               DLCOBJ     OBJ((HFLOCK *DTAARA *EXCL))
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal termination processing */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program HFC0251 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
