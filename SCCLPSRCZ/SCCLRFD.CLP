/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear st/data (FD) daily files')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCCLRFD - Clear DRS Standing Data Daily Files               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 079953             Date 29Dec94              */
/*                      S01319             Date 10Oct91              */
/*                      S01343             DATE 15AUG91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       079953 - Clear FDAUDLPP.                                    */
/*       S01319 - Remove redundant processing.                       */
/*       S01343 - SC/RR/SD module rename project.                    */
/*                - SCCLRFD renamed from SDCLRFD.                    */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/** MONITOR FOR ERROR MESSAGES                                      **/
             MONMSG     MSGID(CPF0000)
             MONMSG     MSGID(MCH0000)
             MONMSG     MSGID(CPA0000)
/**/
/** SEND MESSAGE STATING THAT DAILY FILES BEING CLEARED             **/
             SNDPGMMSG  MSGID(FDM0351) MSGF(DRSMM) TOMSGQ(MRUNQ)
/**/
/** CLEAR ALL DAILY AUDIT FILES                                     **/
/*/COPY WNCPYSRC,SCCLRFD001                                          */
/************CLRPFM*****FILE(FDAUDAPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDBPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDCPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDDPP)******************************/ /*S01319*/
             CLRPFM     FILE(FDAUDEPP)
             CLRPFM     FILE(FDAUDFPP)
             CLRPFM     FILE(FDAUDLPP)                                /*079953*/
/************CLRPFM*****FILE(FDAUDGPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDHPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDIPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDJPP)******************************/ /*S01319*/
/************CLRPFM*****FILE(FDAUDKPP)******************************/ /*S01319*/
/**/
/** SEND MESSAGE STATING THAT DAILY FILES BEING CLEARED             **/
             SNDPGMMSG  MSGID(FDM0352) MSGF(DRSMM) TOMSGQ(MRUNQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
