/*********************************************************************/
/*XBI    CRTPF      FILE(QTEMP/UPSBSD) RCDLEN(132)                   */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Check sbs. routing & job queue entries')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0131 - Check subsystem routing entries and job queue     */
/*                  entries                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP016 *CREATE     Date 01Apr03              */
/*                      xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ERROR)
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&JOBQECOUNT) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&RTGECOUNT) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&JOBQEFIRST) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&RTGEFIRST) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&JOBQELAST) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&RTGELAST) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&JOBQEFLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTGEFLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIRSTJQE) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&FIRSTRTGE) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(UPSBSD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             CHGVAR     VAR(&JOBQECOUNT) VALUE(&JOBQECOUNT + 1)
             CHGVAR     VAR(&RTGECOUNT) VALUE(&RTGECOUNT + 1)
 
/* Find string at beginning of list of Job Queue Entries */
             IF         COND(%SST(&UPSBSD 4 3) *EQ 'Nbr' *AND +
                          &FIRSTJQE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&JOBQEFIRST) VALUE(&JOBQECOUNT + 1)
                CHGVAR     VAR(&FIRSTJQE) VALUE(Y)
             ENDDO
/* If first Job Queue Entry found then check for last */
             IF         COND(&JOBQEFIRST *NE 0) THEN(DO)
                IF         COND(%SST(&UPSBSD 4 3) *EQ '   ') THEN(DO)
                   CHGVAR     VAR(&JOBQELAST) VALUE(&JOBQECOUNT - 1)
                   CPYF       FROMFILE(UPSBSD) TOFILE(QTEMP/NCJOBQE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FROMRCD(&JOBQEFIRST) TORCD(&JOBQELAST)
                   CHGVAR     VAR(&JOBQEFIRST) VALUE(0)
                   CHGVAR     VAR(&JOBQELAST) VALUE(0)
                   CHGVAR     VAR(&JOBQEFLAG) VALUE('Y')
                ENDDO
             ENDDO
 
/* Find string at beginning of list of Routing Entries */
             IF         COND(%SST(&UPSBSD 15 3) *EQ 'Nbr' *AND +
                          &FIRSTRTGE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RTGEFIRST) VALUE(&RTGECOUNT + 1)
                CHGVAR     VAR(&FIRSTRTGE) VALUE(Y)
             ENDDO
/* If first Job Queue Entry found then check for last */
             IF         COND(&RTGEFIRST *NE 0) THEN(DO)
                IF         COND(%SST(&UPSBSD 15 3) *EQ '999') THEN(DO)
                   CHGVAR     VAR(&RTGELAST) VALUE(&RTGECOUNT)
                   CPYF       FROMFILE(UPSBSD) TOFILE(QTEMP/NCRTGE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FROMRCD(&RTGEFIRST) TORCD(&RTGELAST)
                   CHGVAR     VAR(&RTGEFIRST) VALUE(0)
                   CHGVAR     VAR(&RTGELAST) VALUE(0)
                   CHGVAR     VAR(&RTGEFLAG) VALUE('Y')
                ENDDO
             ENDDO
 
/* If both job queue entries and routing entries found then stop reading file and process */
             IF         COND(&JOBQEFLAG *EQ 'Y' *AND &RTGEFLAG *EQ +
                          'Y') THEN(GOTO CMDLBL(REPORT))
 
             GOTO       CMDLBL(READNEXT)
REPORT:
/* Call programs to edit NCJOBQE and NCRTGE so that library names are not relevant */
             OVRDBF     FILE(UPSBSD) TOFILE(NCJOBQE)
             CALL       PGM(SM0131) PARM('J' &ERROR)
             DLTOVR     FILE(UPSBSD)
             IF         COND(&ERROR *EQ 'Y') THEN(GOTO CMDLBL(ABNOR))
 
             OVRDBF     FILE(UPSBSD) TOFILE(NCRTGE)
             CALL       PGM(SM0131) PARM('R' &ERROR)
             DLTOVR     FILE(UPSBSD)
             IF         COND(&ERROR *EQ 'Y') THEN(GOTO CMDLBL(ABNOR))
 
/* Compare files with supplied core data */
             CMPPFM     NEWFILE(COREJOBQE) OLDFILE(NCJOBQE) +
                          OLDMBR(*FIRST) OUTPUT(*PRINT) +
                          OPTION(*LONGLINES)
             CMPPFM     NEWFILE(CORERTGE) OLDFILE(NCRTGE) +
                          OLDMBR(*FIRST) OUTPUT(*PRINT) +
                          OPTION(*LONGLINES)
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&ERROR) VALUE('Y')
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
