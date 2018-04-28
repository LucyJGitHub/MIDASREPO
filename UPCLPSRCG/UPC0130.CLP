/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Copy files with data')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0130 - Copy files with data                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CUP008             Date 27Sep00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CUP003 *CREATE     Date 22Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP008 - Change to handle multi-membered files.             */
/*       CUP003 - Copy files with data                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PTFDTA &RETURN)
 
             DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&LEN) TYPE(*DEC) LEN(4 0) VALUE(50)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&USTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(UPDLVCL9)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&USTS) VALUE('C')
READNEXT:
 
             IF         COND(&AUMBNM *NE ' ') THEN(DO)
/*/COPY UPCPYSRCG,C_UP0020A                                          */
             ENDDO
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              GOTO       CMDLBL(END)
             ENDDO
 
/* Set up screen for messages */
             CHGVAR     VAR(&MESSAGE) VALUE(' ')
             CHGVAR     VAR(&MESSAGE) VALUE('File to be copied:' +
                          *BCAT &AUMBNM)
             CALL       PGM(UTC0069) PARM(&MESSAGE &LEN)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             CALL       PGM(UTC0069) PARM(&AUMBTX &LEN)
             CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&AUMBTX)
             CHGVAR     VAR(&MESSAGE) VALUE('Records to be copied +
                          with' *BCAT &AUCPYO)
             CALL       PGM(UTC0069) PARM(&MESSAGE &LEN)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
             CHGVAR     VAR(&MESSAGE) VALUE('Do you wish to copy +
                          this file?')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
 
             CALL       PGM(SCC0010) PARM('UPC0130' 'OPTION' &OPTION)
 
             IF         COND(&OPTION *EQ 'Y') THEN(DO)
/************   CPYF       FROMFILE(&PTFDTA/&AUMBNM) TOFILE(&AUMBNM) +                 */ /*CUP008*/
/************             FROMMBR(*FIRST) TOMBR(*FROMMBR) +                            */ /*CUP008*/
/************             MBROPT(&AUCPYO)                                              */ /*CUP008*/
                CPYF       FROMFILE(&PTFDTA/&AUMBNM) TOFILE(&AUMBNM) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(&AUCPYO)                   /*CUP008*/
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&USTS) VALUE('F')
                   GOTO       CMDLBL(READNEXT)
                ENDDO
             ENDDO
 
             CHGVAR     VAR(&OPTION) VALUE('N')
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
