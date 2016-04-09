/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL COB Prior to File Backup')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC01 - END OF DAY PRIOR TO FILE BACK UP                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01408             DATE 03AUG95               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   S01408 - Core hook added, DLC01MPS                             */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC01MPS                                             /*S01408*/
                                                                      /*S01408*/
/**/
             CLRPFM     FILE(DTRIXDD)
             CLRPFM     FILE(DTRIXHH)
             SNDMSG     MSG('INITIALISE NEW DEALS TRANSACTION FILE') +
                          TOMSGQ(MRUNQ)
/**/
             CALL       PGM(DL0020)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
