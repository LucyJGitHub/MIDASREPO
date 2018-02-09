/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC After Trsfr of Base to I/E In-House Procs')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0350 - Controlling program for COB Extract               */
/*                                                                   */
/*                 This program can be used as an Entry Point into   */
/*                 the Midas COB. The program that it calls and the  */
/*                 library that the program resides in are both      */
/*                 parameter driven using SD System Values.          */
/*                                                                   */
/*       (C) Copyright Finastra International Limited 2006           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC027 *Create     Date 15Feb06              */
/*------ Midas Plus 1.2 Base ----------------------------------------*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC027 - This program runs in the Midas COB right after     */
/*                Transfer of Base Currency to Income&Expense. It is */
/*                used as an Entry Point to the COB and the library  */
/*                and program name are parameters defined in the     */
/*                system values file. The first 10 characters of     */
/*                'HeadOfficeExtractCOB'defines the library and      */
/*                the next 10 defines the program to be called.      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CSC027) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&HOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOPGM) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra International Limited 2006')
 
/* Define parameters used in AOSVALR0 to retrieve system value        */
/*/COPY SDCPYSRC,SDSVALDCL                 */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check for Switchable feature CSC027                            */
 
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CSC027')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC027) VALUE('Y'))
 
/* Don't do any processing if Switchable feature CSC027 is OFF.    */
 
             IF         COND(&CSC027 *EQ 'N') THEN(GOTO CMDLBL(END))
 
/* Call AOSVALR0 to get system values for 'HeadOfficeExtractCOB */
 
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'HeadOfficeExtractCOB' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)
 
/* If there is an error finding any system value then end abnormally */
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(END))
 
/* Set value of HO Library/Program Name to be called */
 
             CHGVAR     VAR(&HOLIB) VALUE(%SST(&SVAL1 1 10))
             CHGVAR     VAR(&HOPGM) VALUE(%SST(&SVAL1 11 10))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Call program as defined on the system values file to extract   */
/* Midas data. Any recovery will be handled within called program */
 
             CALL       PGM(&HOLIB/&HOPGM)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0350 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('Copyright Finastra +
                          International Limited 2006')
 
             ENDPGM
