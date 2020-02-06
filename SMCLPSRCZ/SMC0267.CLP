/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Rebuild logical file member, special case')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0267 - Rebuild logical file member, special cases        */
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
             PGM        PARM(&RETURN &PREFIX)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *TCAT 'DMLIB')
 
READNEXT:
RETRY:
             RMVM       FILE(MXBLLELL1) MBR(*ALL)
             ADDLFM     FILE(MXBLLELL1) MBR(MXBLLELL1) +
                          DTAMBRS((&DMLIB/MXBLLELPD (CLZZ CLGU)))
 
             RMVM       FILE(MXDELELL1) MBR(*ALL)
             ADDLFM     FILE(MXDELELL1) MBR(MXDELELL1) +
                          DTAMBRS((&DMLIB/MXDELELPD (CLZZ CLGU)))
 
             RMVM       FILE(MXMELELL1) MBR(*ALL)
             ADDLFM     FILE(MXMELELL1) MBR(MXMELELL1) +
                          DTAMBRS((&DMLIB/MXMELELPD (CLZZ CLGU)))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(SMC0267) +
                          MSG(&MESSAGE)
/*/COPY UPCPYSRCG,C_UPERRA                                           */
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
