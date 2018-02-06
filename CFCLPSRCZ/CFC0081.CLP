/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Tram input cycle initiation')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Confirmation Matching Module                    */
/*                                                                   */
/*       CFC0081 - TRAM Input Cycle Initiation Control               */
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
/*                      110242             Date 07Nov96              */
/*                      077466             DATE 17OCT94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       077466 - New program created to control the ICI processing  */
/*                for TRAM.                                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
 
/* Download Client Details to TRAM */
 
             CALL       PGM(CFC0080) PARM('   ')
 
/* Submit the CONTROL PROGRAM which is active throughout I/C */
 
/*********** SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +       /*110242*/
/***********              JOBD(MBATCH) JOBQ(CFJOBQA) */               /*110242*/
/************SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                           /*CPK014*/
/************             JOBD(MBATCH) JOBQ(CFJOBQA) RTGDTA(*JOBD) +                      /*CPK014*/
/************             INLLIBL(*JOBD)                              /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                           /*CSC023*/
/************             JOBD(MBATCH) JOBQ(CFJOBQA) USER(*JOBD) +                        /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                         /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +
                          JOBD(MBATCH) JOBQ(CFJOBQA) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
 
/* Clear branch groupings extract file */
 
             CLRPFM     FILE(CFBREXPD)
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal termination processing */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program CFC0081 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
