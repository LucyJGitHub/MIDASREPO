/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Determine the licence level')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0003 - Determine the Midas Licence Level                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 27Sep01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      159708  *CREATE    Date 23Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging:                               */
/*                - Amend the position of the release level number.  */
/*       159708 - Program to display release level at Midas          */
/*                initialisation.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MLICL &MSGNUMBER)
 
/*/COPY WNCPYSRC,SCC0003INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SARN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MLICL) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSGNUMBER) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(SCSARDL2)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC0003MPS                                          */
 
/* Read the records until end to find latest licence record */
 LOOP1:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/**********  CHGVAR     VAR(&MLICL) VALUE(%SST(&SARN 5 1)) */                             /*CPK014*/
             CHGVAR     VAR(&MLICL) VALUE(%SST(&SARN 6 1))                                /*CPK014*/
 
             GOTO       CMDLBL(LOOP1)
 
/*/COPY WNCPYSRC,SCC0003MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination  */
 
/*/COPY WNCPYSRC,SCC0003ERR                                          */
 
             IF         COND(&MSGNUMBER *EQ '08') THEN(DO)
                CHGJOB     SWS(XXXXXX11)
             ENDDO
 
             SNDPGMMSG  MSG('Program SCC0003 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC0003END                                          */
 
             ENDPGM
