/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Compounding Interest Enquiry/Amend')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1641 - OIS Compounding Interest Rate Enquiry/Amend       */
/*                                                                   */
/*                 Calls program DL1641 during I/C                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CIR007 - Overnight Index Swaps                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Global monitor message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Main Processing                                                */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** DEALSDG is updated by DL1652 (Amend), but not DL1641           */
/** Override share(*no) is required.                               */
             OVRDBF     FILE(DEALS) SHARE(*NO)
 
/** Call enquiry/amend program                                     */
             CALL       PGM(DL1641)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/** Abnormal termination - batch job                               */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DL1641 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
