/*********************************************************************/
/*XBI    OVRDBF FILE(CLRDBLIBML) TOFILE(QAFDMBRL)                    */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CLRDBLIB CPP')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0030 - Clear data from specified library.                */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      CSM002 *C *CREATE  Date 22Nov02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Set switches off and move.   */
/*       CSM002 - Refresh options from the Bridge.                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(CLRDBLIBML)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGJOB     SWS(XXXXXX00)                                                     /*CPK018*/
 
/* Display member list of all PFs in library to outfile. */
             DSPFD      FILE(&LIB/*ALL) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/CLRDBLIBML)
 
NEXTMEMBER:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(UTC0031)
             ENDDO
 
/* If file has no members then read next record ... */
             IF         COND(&MLNAME *EQ ' ') THEN(DO)
                GOTO       CMDLBL(NEXTMEMBER)
             ENDDO
/* ... otherwise clear the file. */
             CLRPFM     FILE(&LIB/&MLFILE) MBR(&MLNAME)
 
             GOTO       CMDLBL(NEXTMEMBER)
 
UTC0031:
/* Call program to clear data areas and data queues. */
             CALL       PGM(UTC0031) PARM(&LIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ERROR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTC0030 ended abnormally.  See joblog for +
                          more details') TOPGMQ(*PRV) MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
