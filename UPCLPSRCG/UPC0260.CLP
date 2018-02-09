/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Foreign logical files installation')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0260 - Foreign Logical Files Installation                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 25Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CPK010             Date 13Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 06Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CPK010 - Problems found in DBAR3.00 alpha site              */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PTFUPG &RETURN)
 
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&SAVF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(UPTDBRQF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              GOTO       CMDLBL(END)
             ENDDO
             CHGVAR     VAR(&RECURSIVE) VALUE('N')                                        /*CPK010*/
RETRY:
             CHGVAR     VAR(&RETURN) VALUE(' ')
             IF         COND(&TDREFX *NE '          ') THEN(DO)
/************   CHGVAR    VAR(&SAVF) VALUE('LF' *CAT %SST(&TDREFX 1 8))                */ /*CPK010*/
                CHGVAR    VAR(&SAVF) VALUE(&TDREFX)                                       /*CPK010*/
                CHKOBJ     OBJ(&PTFUPG/&SAVF) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(READNEXT))
                RSTOBJ     OBJ(&TDREFX) SAVLIB(&TDRELX) DEV(*SAVF) +
                          SAVF(&PTFUPG/&SAVF)
                GOTO       CMDLBL(READNEXT)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0260) +
                          MSG(&MESSAGE)
/*/COPY UPCPYSRCG,C_UPERRA                                           */
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
