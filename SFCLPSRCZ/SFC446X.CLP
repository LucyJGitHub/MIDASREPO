/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Setup *GDA with txt for Prev Grp Job')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Standing Data module                          */
/*                                                                   */
/*       SFC446X - SET UP *GDA WITH TEXT FROM PREVIOUS GROUP JOB     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 059795             DATE 03JAN94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       059795 - If the user ends group job, and then hits attn key */
/*                before taking option in previous job, the old job  */
/*                text is displayed.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&ALLJOB) TYPE(*CHAR) LEN(1056)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000)
             RTVGRPA    GRPJOBL(&ALLJOB)
             CHGDTAARA  DTAARA(*GDA (311 50)) +
                 VALUE(%SST(&ALLJOB 83 50))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
