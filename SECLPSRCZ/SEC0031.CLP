/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Initialisation program for CSE031')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading module                           */
/*                                                                   */
/*       SEC0031 - Switch on CSE031                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CSE031  *CREATE    Date 05Apr02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE031 - Coupon Fixing for Floating Rate Notes              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,SEC0031INT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,SEC0031MPS                                          */
 
/* Mode 1 - First call */
             IF         COND(&PMODE *EQ '1') THEN(DO)
                ?          CSE031ON ?-MODE(*ON) ??AUTOFIX(*N) ??BDC(*N)
                MONMSG     MSGID(CPF6801) EXEC(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Mode 2 - Second call */
             IF         COND(&PMODE *EQ '2') THEN(DO)
                ?          CSE031ON ?-MODE(*ON) ??AUTOFIX(*N) ??BDC(*N)
                MONMSG     MSGID(CPF6801) EXEC(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Mode 3 - Deletion */
             IF         COND(&PMODE *EQ '3') THEN(DO)
                CSE031ON   MODE(*OFF) AUTOFIX(*YES) BDC(N)
                MONMSG     MSGID(CPF6801) EXEC(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,SEC0031MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SEC0031ERR                                          */
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
             SNDPGMMSG  MSG('Program SEC0031 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SEC0031END                                          */
 
             ENDPGM
