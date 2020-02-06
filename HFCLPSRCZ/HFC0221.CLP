/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Clear all JRNTEMP members')                  */
/*OVR  : OVRDBF HFLIST QSYS/QADSPOBJ                                :*/
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0221  - CLEAR ALL JRNTEMP MEMBERS                        */
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
/*       Prev Amend No. S01379             Date 17Sep92              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*   Compiler directive for file HFLIST                              */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
             DCLF       FILE(HFLIST)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
/* */
/* Delete work file if it exists */
/* */
             DLTF       FILE(QTEMP/HFLIST)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Get description of all J* files */
/* */
             DSPOBJD    OBJ(&HFLIB/J*) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/HFLIST)
             MONMSG     MSGID(CPF0000) EXEC(RETURN)
 
/* */
/* Read details of this file */
/* */
 LOOP:       RCVF
 
/* */
/* EOF so end */
/* */
             MONMSG     MSGID(CPF0000) EXEC(RETURN)
 
/* */
/* Clear the JRNTEMP member */
/* */
             CLRPFM     FILE(&HFLIB/&ODOBNM) MBR(JRNTEMP)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Process next file */
/* */
             GOTO       CMDLBL(LOOP)
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0221 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
