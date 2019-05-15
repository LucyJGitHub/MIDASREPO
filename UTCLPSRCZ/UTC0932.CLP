/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Display help document')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Utilities                                        */
/*                                                                   */
/*       UTC0932 - Display Help Document Called by UT0930            */
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
/*       Prev Amend No. CUP004 *CREATE     Date 07May98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&HDOC &HFLR &HLBL &RTNCDE)
/**/
             DCL        VAR(&HDOC) TYPE(*CHAR) LEN(12)
             DCL        VAR(&HFLR) TYPE(*CHAR) LEN(13)
             DCL        VAR(&HLBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 OFC0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             DSPHLPDOC  DOC(&HDOC) FLR(&HFLR) HLPLBL(&HLBL)
 
             CHGVAR     VAR(&RTNCDE) VALUE('          ')
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGVAR     VAR(&RTNCDE) VALUE('HELPTAG')
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
