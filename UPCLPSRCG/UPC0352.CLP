/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Handle existing libraries for move')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0352 - Handle existing libraries for move                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     Date 20Nov98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MOVLIB &RETURN)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MOVLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* If library already exists then ask user what is required */
CHOOSE:
             RTVMSG     MSGID(UPM0015) MSGF(UTMSGF) +
                          MSGDTA(&MOVLIB) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(UPM0007) MSGF(UTMSGF) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(UPM0016) MSGF(UTMSGF) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(UPM0017) MSGF(UTMSGF) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(UPM0018) MSGF(UTMSGF) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('UPC0352' 'OPTION2' &REPLY1)
             IF         COND(&REPLY1 *EQ 'D') THEN(DO)
                CLRLIB     LIB(&MOVLIB)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
             ENDDO
             IF         COND(&REPLY1 *EQ 'C') THEN(DO)
                CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
                CHGVAR     VAR(&RETURN) VALUE('C')
                GOTO       CMDLBL(END)
             ENDDO
/* If not one of the options then redisplay screen with message */
             IF         COND(&REPLY1 *NE 'D' *AND &REPLY1 *NE 'I' +
                          *AND &REPLY1 *NE 'C') THEN(DO)
                RTVMSG     MSGID(UPM0012) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (551 50)) VALUE(&MESSAGE)
                GOTO       CMDLBL(CHOOSE)
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
