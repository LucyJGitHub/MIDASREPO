/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Sel GL Journal Entry Interface Batch')       */
/********************************************************************/
/*                                                                  */
/*                Midas GENERAL LEDGER MODULE                   */
/*                                                                  */
/*       GLC0140S - SELECT INTERFACE BATCH                          */
/*                - MIDAS OVERRIDE DATABASE FILE FOR GLBRREL1       */
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
/*       Prev Amend No. S01251             Date 13Feb90              */
/*                      S01184             Date 03Jan90              */
/*                                    DATE  18NOV89                 */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01251 - SYNON PROGRAM/FILE/FIELD NAME CHANGES             */
/*                                                                  */
/*       S01184 - BATCH TEMPLATE FACILITY                           */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RTCD &KEY)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(3)
/* S01184    DCL        VAR(&KEYN) TYPE(*DEC) LEN(3 0)      S01184  */
             DCL        VAR(&KEYN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**********  OVRDBF     FILE(GLBRREL1) TOFILE(GLBTIFL1)            */ /*S01251*/
             OVRDBF     FILE(GLJENHL1) TOFILE(GLJEIHL1)               /*S01251*/
 
/* Call Select Program based over GL Batch Interface File for the    */
/* to be able to Select an Interface Batch from A list of records....*/
 
/*********** CALL       PGM(GLHZSRR) PARM(&RTCD &KEYN)             */ /*S01251*/
             CALL       PGM(GL0140S) PARM(&RTCD &KEYN)                /*S01251*/
 
/*********** DLTOVR     FILE(GLBRREL1)                             */ /*S01251*/
             DLTOVR     FILE(GLJENHL1)                                /*S01251*/
             CHGVAR     VAR(&KEY) VALUE(&KEYN)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
