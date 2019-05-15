/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Bulk create batch member')                   */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0024 - Bulk Transfer Create Batch Member                */
/*                                                                  */
/*       Function : This program adds a new member to PF/EDBULKPD.  */
/*                                                                  */
/*       Called by: ED0020                                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01493 *CREATE     DATE 06JUN94             */
/*                      Xnnnnn             DATE ddmmmyy             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01493 - Midas Export Data Interface Module                */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&BTCHNM &RTCD)
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&BTCHNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Add member to PF/EDBULKPD.   If the member already exists    */
/* this is OK - clear it instead.  It is probably there because */
/* this is a restart after a failed batch.                      */
 
             ADDPFM     FILE(EDBULKPD) MBR(&BTCHNM)
             MONMSG     MSGID(CPF5812 CPF7306) EXEC(CLRPFM +
                          FILE(*LIBL/EDBULKPD) MBR(&BTCHNM))
 
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination */
 
ABNOR:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&RTCD) VALUE('E')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGJOB     SWS('XXXXXX11')
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
