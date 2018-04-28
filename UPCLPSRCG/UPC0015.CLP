/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Standard error handling for failed recs.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0015 - Standard error handling for failed records        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP025             Date 09Dec03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 03Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CUP025 - MidasPlus Bridge changes.                          */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&LF1 &LF2 &PGM &UPSTATPOS &RETURN)                        */ /*CUP025*/
             PGM        PARM(&LF2 &PGM &UPSTATPOS &RETURN)                                /*CUP025*/
 
/************DCL        VAR(&LF1) TYPE(*CHAR) LEN(10)                                  */ /*CUP025*/
             DCL        VAR(&LF2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPSTATPOS) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FAIL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&REPLY) VALUE('Y')
/************OVRDBF     FILE(UPDLVC) TOFILE(&LF1)                                      */ /*CUP025*/
             OVRDBF     FILE(UPDLVC) TOFILE(&LF2)                                         /*CUP025*/
             CALL       PGM(UP0022) PARM(&FAIL)
             DLTOVR     FILE(UPDLVC)
             IF         COND(&FAIL *EQ 'Y') THEN(DO)
                RTVMSG     MSGID(UPM0002) MSGF(UTMSGF) +
                          MSGDTA(&PGM) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0005) MSGF(UTMSGF) +
                          MSGDTA(&LF2) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0023) MSGF(UTMSGF) +
                          MSGDTA(&LF2) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0024) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                CALL PGM(SCC0010) PARM(&PGM 'OPTION' &REPLY)
                IF         COND(&REPLY *EQ 'Y') THEN(DO)
                   RUNQRY     QRY(*NONE) QRYFILE((&LF2))
                   DSPJOBLOG  OUTPUT(*PRINT)
                ENDDO
                CHGVAR     VAR(&RETURN) VALUE('F')
                GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
/**********     CALL       PGM(UPC0021)                                                */ /*CUP033*/
                CALL       PGM(UPC0021) PARM('BrgDeliveredBrgLib')                        /*CUP033*/
                IF         COND(&UPSTATPOS *NE 0) THEN(DO)
                   CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOS 1)) +
                          VALUE('Y')
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGVAR     VAR(&RETURN) VALUE('F')
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0015') MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC0015' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
