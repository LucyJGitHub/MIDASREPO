/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Attach break handling program')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Autocall Module                                     */
/*                                                                   */
/*       ACC0011 - Attach Break Handling Program                     */
/*                                                                   */
/*       This program attaches a break handling program to           */
/*       QSYSOPR. This should already have been done by COBMONITOR   */
/*       so monitor for CPF2451 - message queue allocated to another */
/*       ob - but if this fails for any other reason, then this is   */
/*       an error.                                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      101930             Date 08Jul96              */
/*                      098705             Date 12Feb96              */
/*                      092291             DATE 09FEB96              */
/*                      098705             DATE 02FEB96              */
/*                      CCB001 *CREATE     DATE 01MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       101930 - Remove 098705 as it is wrong.                      */
/*       098705 - COB Monitor should not lock QSYSOPR as this        */
/*                prevents other users from answering the message.   */
/*       092291 - Monitor for message queue already being allocated  */
/*       CCB001 - CoB Enhancements (split down SCC0400).             */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*ACCPYSRC,ACC0011INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,ACC0011INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***COPY*ACCPYSRC,ACC0011MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,ACC0011MPS                                          */                   /*CPK024*/
 
/**/
/*  Attach break handling program ACC0010 to QSYSOPR               */
/*  Monitor for message queue already being allocated to           */
/*  another job.                                                   */
/**/
/************CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK) PGM(ACC0010)   */ /*098705*/
/************CHGMSGQ    MSGQ(QSYSOPR) PGM(ACC0010)      */ /*098705*/ /*101930*/
             CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK) PGM(ACC0010)      /*101930*/
             MONMSG     MSGID(CPF2451)                                /*092291*/
 
/***COPY*ACCPYSRC,ACC0011MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,ACC0011MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*ACCPYSRC,ACC0011ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,ACC0011ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSG('An error occured when trying to att    +
                          ach program ACC0010 to message queue +
                          QSYSOPR') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
/***COPY*ACCPYSRC,ACC0011END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,ACC0011END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
