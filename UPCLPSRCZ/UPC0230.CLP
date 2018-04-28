/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Apply old PRTF spool attr. to new PRTF')     */
/*OVR    OVRDBF FILE(PRTFSPL) TOFILE(QAFDSPOL)                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0230 - Apply old PRTF Spool Attribute to new PRTF        */
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
 
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(PRTFSPL)
 
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
             IF         COND(&SPHOLD *EQ 'N') THEN(CHGVAR VAR(&HOLD) +
                          VALUE('*NO '))
             IF         COND(&SPHOLD *EQ 'Y') THEN(CHGVAR VAR(&HOLD) +
                          VALUE('*YES'))
             IF         COND(&SPSAVE *EQ 'N') THEN(CHGVAR VAR(&SAVE) +
                          VALUE('*NO '))
             IF         COND(&SPSAVE *EQ 'Y') THEN(CHGVAR VAR(&SAVE) +
                          VALUE('*YES'))
             IF         COND(&SPPRTY *EQ '0001') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('1   '))
             IF         COND(&SPPRTY *EQ '0002') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('2   '))
             IF         COND(&SPPRTY *EQ '0003') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('3   '))
             IF         COND(&SPPRTY *EQ '0004') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('4   '))
             IF         COND(&SPPRTY *EQ '0005') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('5   '))
             IF         COND(&SPPRTY *EQ '0006') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('6   '))
             IF         COND(&SPPRTY *EQ '0007') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('7   '))
             IF         COND(&SPPRTY *EQ '0008') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('8   '))
             IF         COND(&SPPRTY *EQ '0009') THEN(CHGVAR +
                          VAR(&SPPRTY) VALUE('9   '))
             CHGPRTF    FILE(*LIBL/&SPFILE) OUTQ(&SPOTQL/&SPOUTQ) +
                          FORMTYPE(&SPFMTP) COPIES(&SPCOPY) +
                          HOLD(&HOLD) SAVE(&SAVE) OUTPTY(&SPPRTY) +
                          USRDTA(&SPUDTA)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGPRTF    FILE(*LIBL/&SPFILE) OUTQ(&SPOUTQ) +
                          FORMTYPE(&SPFMTP) COPIES(&SPCOPY) +
                          HOLD(&HOLD) SAVE(&SAVE) OUTPTY(&SPPRTY) +
                          USRDTA(&SPUDTA)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG    MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0230) +
                          MSG(&MESSAGE)
/*/COPY UPCPYSRC,C_UPERRA                                            */
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
