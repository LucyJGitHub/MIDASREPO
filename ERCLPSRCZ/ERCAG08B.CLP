/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AGDL Extract details in batch')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - AGDL reporting Module                               */
/*                                                                   */
/*       ERCAG08B- AGDL Extract details BATCH PROCESSING             */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG11160           Date 25Apr05              */
/*                      CER001             Date 25Apr05              */
/*                      CC0001             Date 20Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG11160-Change outq to point to correct zone               */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       CC0001 - Change Control for DL                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*  Declare variables  */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/**********  SBMJOB     CMD(CALL PGM(ERCAG08)) JOB(ERCAG08) +
                          JOBD(MIDASIC) JOBQ(*JOBD) MSGQ(*NONE)      */                   /*CER001*/
/**********  SBMJOB     CMD(CALL PGM(ERCAG08)) JOB(ERCAG08) +
                          JOBD(MIDASIC) JOBQ(*JOBD) USER(*JOBD) MSGQ(*NONE)  */  /*CER001 BUG11160*/
             SBMJOB     CMD(CALL PGM(ERCAG08)) JOB(ERCAG08) +
                          JOBD(MIDASIC) JOBQ(*JOBD) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) MSGQ(*NONE)                         /*BUG11160*/
 
 
 
/***  End Program  ***/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
