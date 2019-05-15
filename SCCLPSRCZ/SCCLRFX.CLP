/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear foreign exch. daily files')            */
/*********************************************************************/
/*                                                                   */
/*        Midas     - System Control Module                      */
/*                                                                   */
/*       SCCLRFX - CLEAR DRS FOREIGN EXCHANGE DAILY FILES            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01319             Date 10Oct91              */
/*                      S01343             Date 15Aug91              */
/*                      E18965        DATE 26JUL89                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01319 - Remove redundant processing   .                    */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - SCCLRFX RENAMED FROM SDCLRFX.                    */
/*                                                                   */
/*       E18965 - TEMPORARY PC DEAL NO. FILE CLEARED BEFORE          */
/*                TAKE ON OF AFTER HOURS DEALS.                      */
/*                                                                   */
/*********************************************************************/
/**VERSION**/
/**CLEAR DRS FOREIGN EXCHANGE DAILY FILES     **/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/** MONITOR FOR ERROR MESSAGES                                      **/
             MONMSG     MSGID(CPF0000 MCH0000 CPA0000)
 
/** SEND MESSAGE STATING THAT DAILY FILES BEING CLEARED             **/
             SNDPGMMSG  MSGID(FDM0353) MSGF(DRSMM) TOMSGQ(MRUNQ)
 
/** CLEAR ALL DAILY AUDIT FILES                                     **/
             CLRPFM     FILE(FXAUDAPP)
/************CLRPFM*****FILE(FXAUDBPP)******************************/ /*S01319*/
             CLRPFM     FILE(FXAUDCPP)
/************CLRPFM*****FILE(FXAUDDPP)******************************/ /*S01319*/
             CLRPFM     FILE(FXAUDEPP)
/************CLRPFM*****FILE(FXAUDFPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FXAUDGPP)******************************/ /*S01319*/
/***CLEAR*TEMPORARY*PC*DEALENUMBERBFILE**********************E18965*/ /*S01319*/
/************CLRPFM*****FILE(FXTPCDPP)***********************E18965*/ /*S01319*/
 
/** SEND MESSAGE STATING THAT DAILY FILES ARE CLEARED             **/
             SNDPGMMSG  MSGID(FDM0354) MSGF(DRSMM) TOMSGQ(MRUNQ)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
