/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Apply old PRTF attribute to new PRTF')       */
/*OVR    OVRDBF FILE(PRTFATR) TOFILE(QAFDPRT)                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0220 - Apply old PRTF Attribute to new PRTF              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     Date 10Aug98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETURN)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&PGRT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRTT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DEVT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEVN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SHAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LVLC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DPLX) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(PRTFATR)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              GOTO       CMDLBL(END)
             ENDDO
RETRY:
             CHGVAR     VAR(&RETURN) VALUE(' ')
             IF         COND(&PRDPLX *EQ 'N') THEN(CHGVAR VAR(&DPLX) +
                          VALUE('*NO    '))
             IF         COND(&PRDPLX *EQ 'Y') THEN(CHGVAR VAR(&DPLX) +
                          VALUE('*YES   '))
             IF         COND(&PRDPLX *EQ 'T') THEN(CHGVAR VAR(&DPLX) +
                          VALUE('*TUMBLE'))
             IF         COND(&PRSHAR *EQ 'N') THEN(CHGVAR VAR(&SHAR) +
                          VALUE('*NO '))
             IF         COND(&PRSHAR *EQ 'Y') THEN(CHGVAR VAR(&SHAR) +
                          VALUE('*YES'))
             IF         COND(&PRLVLC *EQ 'N') THEN(CHGVAR VAR(&LVLC) +
                          VALUE('*NO '))
             IF         COND(&PRLVLC *EQ 'Y') THEN(CHGVAR VAR(&LVLC) +
                          VALUE('*YES'))
             IF         COND(&PRPLNG *EQ -1) THEN(CHGVAR VAR(&PRTT) +
                          VALUE('*BLANK'))
             IF         COND(&PRPLNG *EQ 0) THEN(CHGVAR VAR(&PRTT) +
                          VALUE('*JOB'))
             IF         COND(&PRPLNG *GT 0) THEN(CHGVAR VAR(&PRTT) +
                          VALUE(&PRPTXT))
             IF         COND(&PRPGRT *EQ 0) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('*DEVD'))
             IF         COND(&PRPGRT *EQ -1) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('*COR '))
             IF         COND(&PRPGRT *EQ -2) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('*AUTO'))
             IF         COND(&PRPGRT *EQ 360) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('0    '))
             IF         COND(&PRPGRT *EQ 90) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('90   '))
             IF         COND(&PRPGRT *EQ 180) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('180  '))
             IF         COND(&PRPGRT *EQ 270) THEN(CHGVAR VAR(&PGRT) +
                          VALUE('270  '))
             CALL       PGM(UP0220) PARM(&PRDEVT &DEVN)
             CHGVAR     VAR(&DEVT) VALUE('*SAME     ')
             IF         COND(&DEVN *EQ 0) THEN(CHGVAR VAR(&DEVT) +
                          VALUE('*SCS      '))
             IF         COND(&DEVN *EQ 256) THEN(CHGVAR VAR(&DEVT) +
                          VALUE('*IPDS     '))
             IF         COND(&DEVN *EQ 512) THEN(CHGVAR VAR(&DEVT) +
                          VALUE('*AFPDS    '))
             IF         COND(&DEVN *EQ 768) THEN(CHGVAR VAR(&DEVT) +
                          VALUE('*LINE     '))
             IF         COND(&DEVN *EQ 1024) THEN(CHGVAR VAR(&DEVT) +
                          VALUE('*AFPDSLINE'))
             IF         COND(&DEVN *EQ 1280) THEN(CHGVAR VAR(&DEVT) +
                          VALUE('*USERASCII'))
             CHGPRTF    FILE(*LIBL/&PRFILE) DEV(&PRDEVN) +
                          DEVTYPE(&DEVT) PAGESIZE(&PRFSZL &PRFSZW) +
                          LPI(&PRLPI) CPI(&PRCPI) OVRFLW(&PROVRF) +
                          LVLCHK(&LVLC) DRAWER(&PRDRAW) +
                          FONT(&PRFONT) PAGRTT(&PGRT) +
                          MULTIUP(&PRMULT) PRTTXT(&PRTT) +
                          DUPLEX(&DPLX) SHARE(&SHAR)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0220) +
                          MSG(&MESSAGE)
/*/COPY UPCPYSRC,C_UPERRA                                            */
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
