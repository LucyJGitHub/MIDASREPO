/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Menu which drives SAR information file')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC4000 - Creates a menu which drives SC0440, allowing      */
/*                 the user to display switchable feature details    */
/*                 ordered by certain keys.                          */
/*                 It overrides the physical file containing SF      */
/*                 details (SCSARSPD) with logical files SCSARSL1    */
/*                 (SFs keyed by SF number); SCSARSL2                */
/*                 keyed by primary module); and SCSARSL3            */
/*                 (keyed on release level).                         */
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
/*       Prev Amend No. CSC005  *CREATE    Date 08May98              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC005 - New suite of programs and files to permit          */
/*                insertion of switchable features via passwords.    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&DEVNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OPT) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SC0440DF) RCDFMT(UIMENU1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    JOB(&DEVNM) USER(&USER) NBR(&NBR)
 
 REDSP:      CHGVAR     VAR(&OPT) VALUE(0)
 
             SNDRCVF    RCDFMT(UIMENU1)
 
/* If the user presses F3= Exit */
 
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))
 
/* option one - keyed by SF number */
 
             IF         COND(&OPT *EQ 1) THEN(DO)
                OVRDBF     FILE(SCSARSPD) TOFILE(*LIBL/SCSARSL1)
                CALL       PGM(*LIBL/SC0440) PARM(&OPT ' ')
             ENDDO
 
/* option two -  keyed by primary module*/
 
             IF         COND(&OPT *EQ 2) THEN(DO)
                OVRDBF     FILE(SCSARSPD) TOFILE(*LIBL/SCSARSL2)
                CALL       PGM(*LIBL/SC0440) PARM(&OPT ' ')
             ENDDO
 
/* option three - keyed by release level*/
 
             IF         COND(&OPT *EQ 3) THEN(DO)
                OVRDBF     FILE(SCSARSPD) TOFILE(*LIBL/SCSARSL3)
                CALL       PGM(*LIBL/SC0440) PARM(&OPT ' ')
             ENDDO
 
             GOTO       CMDLBL(REDSP)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC4000 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
