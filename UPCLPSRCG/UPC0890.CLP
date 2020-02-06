/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Retrieve file field information')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0890 - Retrieve File Field Information                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP028 *MOVED      Date 09Sep04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP004 *CREATE     Date 30Apr98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP028 - Moved from zone to global.                         */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FIELD &DESC)
 
             DCL        VAR(&FIELD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DESC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Select recds with WHFLDI value equal to passed in variable FIELD */
             OVRDBF     FILE(UPDFFDPD) SHARE(*YES)
             OPNQRYF    FILE((UPDFFDPD)) QRYSLT('WHFLDI *EQ "' +
                          *CAT &FIELD *CAT '"')
 
             CALL       PGM(UP0890) PARM(&DESC)
 
             CLOF       OPNID(UPDFFDPD)
             DLTOVR     FILE(UPDFFDPD)
 
 ABNOR:
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
 
                  SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm UTC0830') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             CHGVAR     VAR(&IN01) VALUE('1')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
