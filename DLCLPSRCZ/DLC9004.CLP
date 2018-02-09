/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Generate opening balances for AUS006')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC9004 - Generate Opening Balances for AUS006.             */
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
/*       Prev Amend No. 154460  *CREATE    Date 28Jan99              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       154460 -  New Program to be prompted when switching on      */
/*                 AUS006.                                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETURNCDE &CALLMODE)
 
/*/COPY WNCPYSRC,DLC9004INT                                          */
 
             DCL        VAR(&RETURNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CALLMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Switchable feature is in delete mode */
 
             IF         COND(&CALLMODE *EQ '3') THEN(GOTO CMDLBL(END))
 
/* Local data area to identify database errors */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Override file and run program DL9004 */
 
/*/COPY WNCPYSRC,DLC9004MPS                                          */
 
             OVRDBF     FILE(OUTPUT) TOFILE(HISTSAA)
 
             CALL       PGM(DL9004) PARM(&RETURNCDE &CALLMODE)
 
/*/COPY WNCPYSRC,DLC9004MPE                                          */
 
             GOTO       CMDLBL(END)
 
/* Error Processing */
 
 ABNOR:
/*/COPY WNCPYSRC,DLC9004ERR                                          */
 
             CHGVAR     VAR(&RETURNCDE) VALUE('FAILURE')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DLC9004END                                          */
 
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
