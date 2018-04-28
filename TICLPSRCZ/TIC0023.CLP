/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Environment support functions:routines3-6')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0023 - TI Environment Support Functions: Routines 3-6.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CTI001  *CREATE    Date 03OCT97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CTI001 - Requirements clarification for Midas/TI Interface  */
/*                Program created.                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ROUTINE &MNEM &LIB)
 
/*/COPY WNCPYSRC,TIC0020INT                                          */
 
             DCL        VAR(&ROUTINE) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MNEM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,TIC0020MPS                                          */
 
/*/COPY WNCPYSRC,TIC0020MPE                                          */
 
/* Find required prefix */
 
             IF         COND(&MNEM *NE '   ') THEN(CHGVAR +
                          VAR(&PREFIX) VALUE(%SST(&MNEM 1 2)))
             ELSE       CMD(RTVDTAARA DTAARA(SDSTAT (6 2)) +
                          RTNVAR(&PREFIX))
 
             IF         COND(&ROUTINE *EQ 3) THEN(DO)
               GOTO     CMDLBL(ROUTINE03)
             ENDDO
 
             IF         COND(&ROUTINE *EQ 4) THEN(DO)
               GOTO     CMDLBL(ROUTINE04)
             ENDDO
 
             IF         COND(&ROUTINE *EQ 5) THEN(DO)
               GOTO     CMDLBL(ROUTINE05)
             ENDDO
 
             IF         COND(&ROUTINE *EQ 6) THEN(DO)
               GOTO     CMDLBL(ROUTINE06)
             ENDDO
 
 
/* Otherwise routine passed as paramter is invalid */
 
             GOTO       CMDLBL(ABNOR)
 ROUTINE03:
 
/* Return the Program library name */
 
             CHGVAR &DMLIB (&PREFIX *TCAT 'DMLIB')
             RTVDTAARA  DTAARA(&DMLIB/TIDTA (11 10)) RTNVAR(&LIB)
             GOTO       CMDLBL(END)
 
 ROUTINE04:
 
/* Return the File library name */
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DMLIB   ')
             GOTO       CMDLBL(END)
 
 ROUTINE05:
 
/* Return the Input library name */
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'DMLIB   ')
             GOTO       CMDLBL(END)
 
 ROUTINE06:
 
/* Force extra components to xxTILIB */
 GOTO ROUTINE03
 
/* Return the Work library name */
 
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *CAT 'JLIB    ')
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,TIC0020ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0023 ended abnormally - see job log')
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,TIC0020END                                          */
 
             ENDPGM
