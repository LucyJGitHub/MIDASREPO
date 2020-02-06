/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Select GL Standing Journal Batch')              */
/********************************************************************/
/*                                                                  */
/*                Midas GENERAL LEDGER MODULE                   */
/*                                                                  */
/*       GLC0160S - SELECT STANDING JOURNAL BATCH                   */
/*                - MIDAS OVERRIDE DATABASE FILE FOR GLBRREL1       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*  Prev Amend No. 244686            Date 28Feb07                    */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*               S01251                    DATE : 13FEB90           */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  MD046248 - Finastra Rebranding                                   */
/*  244686  - Added the missing fields to GLJESHPD which CAP086      */
/*            and CSC024 introduced to GZGLJENHPD in order for the   */
/*            2 files to be synchronized. (Recompile only)           */
/*  S01251 - SYNON PROGRAM/FILE/FILED NAME CHANGES                  */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RTCD &KEY)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&KEYN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*********** OVRDBF     FILE(GLBRREL1) TOFILE(GLBRTEL1)            */ /*S01251*/
             OVRDBF     FILE(GLJENHL1) TOFILE(GLJESHL1)               /*S01251*/
 
/* Call Select Program based over GL Batch Template File for the     */
/* to be able to Select a Template Batch from A list of records......*/
 
/*********** CALL       PGM(GLHZSRR) PARM(&RTCD &KEYN)             */ /*S01251*/
             CALL       PGM(GL0140S) PARM(&RTCD &KEYN)                /*S01251*/
 
/*********** DLTOVR     FILE(GLBRREL1)                             */ /*S01251*/
             DLTOVR     FILE(GLJENHL1)                                /*S01251*/
             CHGVAR     VAR(&KEY) VALUE(&KEYN)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
