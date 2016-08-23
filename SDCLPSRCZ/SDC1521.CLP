/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Fiduciary deposits commission/charge grp')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Fiduciary Deposits.                                 */
/*                                                                   */
/*       SDC1521 - Fiduciary Deposits Commission/Charge Groups       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Last Amend No. CDL006 *Create     Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDL006 - Fiduciary Deposit                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MRDT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL       VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL       VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* */
/* Check if switchable feature CDL006 is switched on. */
/* */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CDL006')
/* */
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
/* */
             IF         COND(&RTCD *EQ '       ') THEN(DO)
/* */
/* Create LDA if not present        */
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/* */
/* Reset external switches */
/* */
             CHGJOB     SWS(00000000)
/* */
/* If report running in input cycle call SD1521 with parameter 'L'   */
/* */
             IF         COND(&MODE *EQ 'L') THEN(DO)
             OVRDBF     FILE(SDCCGRL0) SHARE(*YES)
             OPNQRYF    FILE((SDCCGRL0)) QRYSLT('CCRECI *NE ''*''') +
                          KEYFLD(*FILE)
             CALL       PGM(SD1521) PARM('L' &RSEQ)
             CLOF       OPNID(SDCCGRL0)
             DLTOVR     FILE(SDCCGRL0)
             ENDDO
/* */
/* If report running in COB select records changed today before      */
/* calling SD1521 with parameter of 'I' or 'A'                       */
/* */
             ELSE       CMD(DO)
/* */
/* Send program message */
/* */
             SNDPGMMSG  MSG('SDC1521 - Fiduciary Commission/Charge +
                          Groups Report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT (117 5)) RTNVAR(&MRDT)
/* */
/* Select records changed today */
/* */
             OVRDBF     FILE(SDCCGRL0) SHARE(*YES)
             OPNQRYF    FILE((SDCCGRL0)) QRYSLT('RDATE *EQ "' *CAT +
                          &MRDT *CAT '"') KEYFLD(*FILE) +
                          MAPFLD((WDATE CCLCD *ZONED 5) (RDATE +
                          WDATE *CHAR 5))
 
             CALL       PGM(SD1521) PARM(&MODE &RSEQ)
             CLOF       OPNID(SDCCGRL0)
             DLTOVR     FILE(SDCCGRL0)
             ENDDO
/* */
/* Process any data base error */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ENDDO
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
