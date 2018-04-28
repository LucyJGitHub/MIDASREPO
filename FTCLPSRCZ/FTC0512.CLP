/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Regular Payments Audit/List-Brca')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0512  - CL Component to control FT0510                   */
/*                  Regular Payments Reporting.                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1060743          Date 26Nov12              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01494  *CREATE    Date 25MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1060743 - All HATS input initial screen appears a         */
/*                   confirmation of NWDC processing                 */
/*       S01494 - BLI Funds Transfer Enhancement.                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RUNTYP &RSEQ &RLEV &RENT)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNTYP) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/** Check if LDA Data area exists and create it if not **/
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
 
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/** Retrieve data area MPHAS **/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
/**********  CALL PGM(CBC000001) PARM(&MPHAS)                                   /*CCB020 AR1060743*/
             CALL PGM(CBC001001) PARM(&MPHAS)                                          /*AR1060743*/
/**/
 
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RUNTYP 1 1))
             CHGVAR     VAR(&RNTP) VALUE(%SST(&RUNTYP 2 7))
 
/**********  IF         COND((%SST(&MPHAS 1 1) = 'C') *AND (&TYPE +
                          *EQ 'A')) THEN(SNDPGMMSG MSG('FT0510 -  +
                          Outgoing Payments Audit List') TOMSGQ(MRUNQ))                */ /*CCB020*/
             IF         COND((&MPHAS *EQ '*YES') *AND (&TYPE +
                          *EQ 'A')) THEN(SNDPGMMSG MSG('FT0510 -  +
                          Outgoing Payments Audit List') TOMSGQ(MRUNQ))                   /*CCB020*/
/**/
/** Run type is a booking branch for audit **/
/**/
             IF         COND(&RNTP *EQ 'FTM2512') THEN(OVRDBF +
                          FILE(OTPAYBB) TOFILE(RPPAYBB))
/**/
/** Run type is a booking branch for list **/
/**/
             IF         COND(&RNTP *EQ 'FTM2515') THEN(DO)
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                           '   '))  THEN(DO)
                  OVRDBF     FILE(OTPAYBB) TOFILE(RPPAYBB) +
                               POSITION(*KEY 1 *N &RENT)
                  OPNDBF     FILE(OTPAYBB) OPTION(*INP)
                  MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPAYBB) +
                               TOFILE(RPPAYBB) POSITION(*END))
                ENDDO
                ELSE      CMD(OVRDBF FILE(OTPAYBB) TOFILE(RPPAYBB))
             ENDDO
/**/
/** Run type is an originating branch **/
/**/
             IF         COND(&RNTP *EQ 'FTM2516') THEN(DO)
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                           '   '))  THEN(DO)
                  OVRDBF     FILE(OTPAYBB) TOFILE(RPPAYOB) +
                               POSITION(*KEY 1 *N &RENT)
                  OPNDBF     FILE(OTPAYBB) OPTION(*INP)
                  MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPAYBB) +
                               TOFILE(RPPAYOB) POSITION(*END))
                ENDDO
                ELSE      CMD(OVRDBF FILE(OTPAYBB) TOFILE(RPPAYOB))
             ENDDO
/**/
/** Printer file overrides **/
/**/
             OVRPRTF    FILE(FT0510P1) SPLFNAME(FT0511P1)
             OVRPRTF    FILE(FT0510AU) SPLFNAME(FT0511AU)
/**/
/** Call program **/
/**/
             CALL       PGM(FT0510) PARM(&RSEQ &RLEV &RENT &TYPE &RNTP)
/**/
/** Check for database errors trapped by program **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&MEM)
/**********    IF         COND(%SST(&MPHAS 1 1) = 'C') THEN(SNDPGMMSG +
                            MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MRUNQ MOPERQ))                                      */ /*CCB020*/
               IF         COND(&MPHAS *EQ '*YES') THEN(SNDPGMMSG +
                            MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MRUNQ MOPERQ))                                         /*CCB020*/
               ELSE       CMD( +
                            SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                            MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ))
             ENDDO
/**/
/** Check for FOOB errors trapped by program **/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********    IF         COND(%SST(&MPHAS 1 1) = 'C') THEN( +
                          SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                          TOMSGQ(MRUNQ MOPERQ))                                        */ /*CCB020*/
               IF         COND(&MPHAS *EQ '*YES') THEN( +
                          SNDPGMMSG MSGID(MEM0002) MSGF(MIDAS) +
                          TOMSGQ(MRUNQ MOPERQ))                                           /*CCB020*/
               ELSE     CMD( +
                          SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ))
             ENDDO
/**/
             GOTO       CMDLBL(END)
ABNOR:
/**/
             SNDPGMMSG  MSG('FT0510 -  Outgoing Payments Audit List +
                          terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
/**/
             CHGJOB     SWS(XXXXXX11)
END:
/**/
/** Delete overrides **/
/**/
             DLTOVR     FILE(OTPAYBB)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(OTPAYBB)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(FT0510P1)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(FT0510AU)
             MONMSG     MSGID(CPF0000)
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
