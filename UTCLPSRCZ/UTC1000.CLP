/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Midas Information screen generator')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC1000 - Generic Midas Information screen generator        */
/*                                                                   */
/*       This program accepts a list of message IDs from the user,   */
/*       along with some other data, and prepares them for display   */
/*       by a Midas Information screen.                              */
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
/*       Prev Amend No. 089864 *CREATE     Date 07AUG96              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       089864 - This was created to ease this fix, but it is       */
/*                completely generic.                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETURNCODE &CALLER &MSG01 &MSG02 +
                          &MSG03 &MSG04 &MSG05 &MSG06 &MSG07 &MSG08 +
                          &MSG09 &MSG10 &HELPIND &CALLED &OPTION +
                          &REPLY)
 
/*/COPY WNCPYSRC,UTC1000INT                                          */
 
/*/COPY UTCPYSRC,STDERR_DCL                                          */
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* Code +
                          to return to the calling program */
             DCL        VAR(&CALLER) TYPE(*CHAR) LEN(10) /* The +
                          program that called this one */
             DCL        VAR(&MSG01) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG02) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG03) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG04) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG05) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG06) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG07) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG08) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG09) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG10) TYPE(*CHAR) LEN(7)
             DCL        VAR(&HELPIND) TYPE(*DEC) LEN(2 0) /* The +
                          help indicator to switch on */
             DCL        VAR(&CALLED) TYPE(*CHAR) LEN(10) /* The +
                          program that this one is to call */
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10) /* The +
                          screen format to display */
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1) /* The user's +
                          reply value */
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50) /* The +
                          retrieved message data. */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/*/COPY WNCPYSRC,UTC1000MPS                                          */
 
/** +
    Each message must be written to the appropriate part of the +
    MIDASMSG data area. +
**/
 
             IF         COND(&MSG01 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG01) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG02 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG02) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG03 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG03) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG04 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG04) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG05 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG05) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG06 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG06) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG07 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG07) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG08 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG08) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG09 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG09) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (501 50)) VALUE(&MESSAGE)
             ENDDO
 
             IF         COND(&MSG10 *NE ' ') THEN(DO)
                RTVMSG     MSGID(&MSG10) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (551 50)) VALUE(&MESSAGE)
             ENDDO
/** +
    Set on the appropriate byte of MIDASMSG to cause the correct +
    help indicator to be activated. +
**/
             IF         COND(&HELPIND *NE 0) THEN(DO)
 
                CHGDTAARA  DTAARA(MIDASMSG (&HELPIND 1)) VALUE('1')
 
             ENDDO
 
             CALL       PGM(&CALLED) PARM(&CALLER &OPTION &REPLY)
 
/*/COPY WNCPYSRC,UTC1000MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/*/COPY WNCPYSRC,UTC1000ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RETURNCODE) VALUE('ERROR')
 
             CHGVAR     VAR(&MSGDTA) VALUE('UTC1000')
/*/COPY UTCPYSRC,STDERR                                              */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,UTC1000END                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
