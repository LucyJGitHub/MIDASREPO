/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Setup *GDA with txt for Prev Grp Job')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Standing Data module                          */
/*                                                                   */
/*       SFC446X - SET UP *GDA WITH TEXT FROM PREVIOUS GROUP JOB     */
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
/*       Prev Amend No. 059795             Date 03Jan94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       059795 - If the user ends group job, and then hits attn key */
/*                before taking option in previous job, the old job  */
/*                text is displayed.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&ALLJOB) TYPE(*CHAR) LEN(1056)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000)
             RTVGRPA    GRPJOBL(&ALLJOB)
             CHGDTAARA  DTAARA(*GDA (311 50)) +
                 VALUE(%SST(&ALLJOB 83 50))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
