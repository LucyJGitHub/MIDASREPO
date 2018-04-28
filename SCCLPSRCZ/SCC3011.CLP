/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Call specific switchable feature maint')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC3011 - Call a Specific Switchable Feature Maintenance    */
/*                 Function.                                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC007  *CREATE    Date 01Oct98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC007 - New program.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SARDESC &SARNUMBER &CORE &PROGRAM)
 
/*/COPY WNCPYSRC,SCC3011INT                                          */
 
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARNUMBER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARDESC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CORE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(60)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(SCSARSPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC3011MPS                                          */
 
 
             IF         COND(&CORE *EQ 'N') THEN(DO)
             OVRDBF     FILE(SCSARSPD) TOFILE(SCSARZPD)
             OVRDBF     FILE(SCSARSL1) TOFILE(SCSARZL1)
             ENDDO
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             IF         COND(&SARNUMBER *NE &AXSARN) THEN(GOTO +
                          CMDLBL(RCVF))
 
             CALL       PGM(&PROGRAM) PARM(&RTNCODE &SARNUMBER +
                          &AXSARD)
 
/*/COPY WNCPYSRC,SCC3011MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC3011ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC3011END                                          */
 
             CALL       PGM(AOSARDR0) PARM(&RTNCODE '*FREE' +
                          &SARNUMBER &STRING)
 
             ENDPGM
