/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Start Midas/Tram interface control')         */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  CONFIRMATION MATCHING                         */
/*                                                                   */
/*   CFCONTSTR  -  START MIDAS/TRAM INTERFACE CONTROL                */
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
/*                      E00000             DATE 00XXX00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*                                                                   */
/*********************************************************************/
 
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +       /*110242*/
/*************            JOBD(*LIBL/MBATCH) JOBQ(*LIBL/CFJOBQA) */   /*110242*/
/************SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                           /*CPK014*/
/************             JOBD(*LIBL/MBATCH) JOBQ(*LIBL/CFJOBQA) +                        /*CPK014*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                           /*CSC023*/
/************             JOBD(*LIBL/MBATCH) JOBQ(*LIBL/CFJOBQA) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +
                          JOBD(*LIBL/MBATCH) JOBQ(*LIBL/CFJOBQA) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)            /*CSC023*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
 
