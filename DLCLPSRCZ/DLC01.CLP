/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL COB Prior to File Backup')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC01 - END OF DAY PRIOR TO FILE BACK UP                   */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 03Aug95              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*   S01408 - Core hook added, DLC01MPS                             */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
                          Finastra International Limited')
             ENDPGM
