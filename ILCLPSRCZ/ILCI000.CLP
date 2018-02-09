/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Module Full Installation')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILCI000  - IBLC 2002 FULL MODULE INSTALLATION               */
/*                  FROM EXISTING BL MODULE                          */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG10108           Date 25Jan06              */
/*                      BUG10059           Date 24Jan06              */
/*                      CER001             Date 25Apr05              */
/*                      IL0025             Date 27Dec01              */
/*                      201093             Date 13Dec01              */
/*                      ULX043             DATE 21AUG01              */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG10108 - Failed during switching off                      */
/*       BUG10059 - Initialisation failed                            */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       IL0025 - Setup SECTYDXL if 'xP' or 'HL' - Run SE0040YL      */
/*       201093 - FT PROGRAMS TO RUN                                 */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
/**********  PGM                                                     */
             PGM        PARM(&RTCODE &MODULE)
 
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FAIL) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(1)
 
             CHGJOB     SWS(00000000)
                                                                                        /*BUG10108*/
/** Only proceed with the initialisation if mode is '1' or '2' */                       /*BUG10108*/
                                                                                        /*BUG10108*/
             IF         COND(&MODULE *EQ '3') THEN(DO)                                  /*BUG10108*/
             GOTO       CMDLBL(MODE3)                                                   /*BUG10108*/
             ENDDO                                                                      /*BUG10108*/
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&MLIB) VALUE(%SST(&SDSTAT 6 2) *CAT 'DMLIB')
 
             GOTO       CMDLBL(NEXT)
NEXT:
/* Check To See If File Set Up Has Been Run Before              */
 
             CALL       PGM(ILI000) PARM(&FAIL)
 
             IF         COND(&FAIL *EQ 'Y') THEN(DO)
             SNDUSRMSG  MSG('IBLC 2002 file set up has been run before, do +
                          you wish to continue? (Y/N)') VALUES(Y N) +
                          DFT(N) TOMSGQ(*EXT) MSGRPY(&END)
             ENDDO
 
             IF         COND((&END *EQ ('N')) *OR (&END *EQ ('n'))) +
                          THEN(DO)
             GOTO       CMDLBL(TERM)
             ENDDO
 
/*   Generate Dataara ILSTAT  */
 
             DLTDTAARA  DTAARA(&MLIB/ILSTAT)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             CRTDTAARA  DTAARA(&MLIB/ILSTAT) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('IBLC 2002 Returns Data Area')
             CHGDTAARA  DTAARA(ILSTAT (1 1)) VALUE(' ')
/**********  CALL       PGM(ILI001)                              */
 
/*   Re/Generate Trailer File (ILFCTLPA)  */
 
             CLRPFM     FILE(ILFCTLPA)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(ILI005)
 
/***  Retrieve BLDIVIPD content  ***/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ILDIVAPD)
             MONMSG     MSGID(CPF2817)
/** Start of Change BUG010059 */
/**********  CALL       ILDIVA01                                      */                /*BUG10059*/
/** End of Change BUG010059 */
 
 
/*    Extension files creation                                     */
 
/*           Standing Data */
 
             CALL       PGM(SD0061XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(SD0061YL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
             CALL       PGM(SD0181XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(SD0181YL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
             CALL       PGM(SD0011XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(SD0011YL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
             CALL       PGM(SD0021XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(SD0021YL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
             CALL       PGM(SD0031XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(SD0031YL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*           General Ledger */
 
             CALL       PGM(GL0100XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(GL0100YL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
 
 
/*           Retail */
 
             CALL       PGM(RE0253XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
             CALL       PGM(RE0150XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*           Securities Trading */
 
             CALL       PGM(SE0020XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
             CALL       PGM(SE0040XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(SE0040YL)                                 /*IL0025*/
/** Start of Change BUG010059 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/** End of Change BUG010059 */
 
 
/*           Futures & Options */
 
             CALL       PGM(FF0150XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 /*  FF MARGINSETUP */
             CALL       PGM(ILC0645MXL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*           Funds Transfer */
 
             CALL       PGM(FT0055XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(FT0055YL)                              /*201093*/
/** Start of Change BUG010059 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/** End of Change BUG010059 */
 
 
             CALL       PGM(FT0045XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(FT0045YL)                              /*201093*/
/** Start of Change BUG010059 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/** End of Change BUG010059 */
 
 
             CALL       PGM(FT0080XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(FT0080YL)                              /*201093*/
/** Start of Change BUG010059 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/** End of Change BUG010059 */
 
 
             CALL       PGM(FT0070XL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CALL       PGM(FT0070YL)                              /*201093*/
/** Start of Change BUG010059 */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/** End of Change BUG010059 */
                                                                                        /*BUG10108*/
/** Process Mode 3 here */                                                              /*BUG10108*/
                                                                                        /*BUG10108*/
 MODE3:                                                                                 /*BUG10108*/
                                                                                        /*BUG10108*/
 
 TERM:       ENDPGM
