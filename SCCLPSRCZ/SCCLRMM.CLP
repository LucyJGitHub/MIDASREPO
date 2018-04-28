/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear money market daily files')             */
/*********************************************************************/
/*                                                                   */
/*        Midas     - System Control Module                      */
/*                                                                   */
/*       SCCLRMM - CLEAR DRS MONEY MARKET FILES                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01319        DATE 10OCT91                   */
/*       PREV AMEND NO. S01343        DATE 15AUG91                   */
/*                      E18965        DATE 26JUL89                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01319 - Remove redundant processing   .                    */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - SCCLRMM RENAMED FROM SDCLRMM.                    */
/*       E18965 - TEMPORARY PC DEAL NO. FILE CLEARED BEFORE          */
/*                TAKE ON OF AFTER HOURS DEALS.                      */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**VERSION**/
/**CLEAR DRS MONEY MARKET DAILY FILES     **/
 
/** MONITOR FOR ERROR MESSAGES                                      **/
             MONMSG     MSGID(CPF0000 MCH0000 CPA0000)
 
/** SEND MESSAGE STATING THAT DAILY FILES BEING CLEARED             **/
             SNDPGMMSG  MSGID(FDM0355) MSGF(DRSMM) TOMSGQ(MRUNQ)
 
/** CLEAR ALL DAILY AUDIT FILES                                     **/
             CLRPFM     FILE(MMAUDAPP)
/************CLRPFM*****FILE(MMAUDBPP)******************************/ /*S01319*/
             CLRPFM     FILE(MMAUDCPP)
/************CLRPFM*****FILE(MMAUDDPP)******************************/ /*S01319*/
             CLRPFM     FILE(MMAUDEPP)
/************CLRPFM*****FILE(MMAUDFPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(MMAUDGPP)******************************/ /*S01319*/
/****CLEAR*TEMPORARY*PC*DEAL*NUMBER*FILE********************E18965*/  /*S01319*/
/************CLRPFM*****FILE(MMTPCDPP)**********************E18965*/  /*S01319*/
 
 /** SEND MESSAGE STATING THAT DAILY FILES ARE CLEAR                **/
             SNDPGMMSG  MSGID(FDM0356) MSGF(DRSMM) TOMSGQ(MRUNQ)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
