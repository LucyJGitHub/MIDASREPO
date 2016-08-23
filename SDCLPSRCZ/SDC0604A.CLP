/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Customer Reports')                              */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Standing Data Module                           */
/*                                                                   */
/*       SDC0604A - CUSTOMER REPORTS                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BG12497           Date   20Nov06             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408            Date   26Apr96             */
/*                      BHF605                   07Sep90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*     BG12497 - SD0630 made redundant.                             */
/*     S01408 -  Addition of core hook SDC0604A01                   */
/*     BHF605 - NEEDS TO DO OVERRIDE DATABASE FILES IF RUNNING      */
/*            - SD0350 THE ACCOUNT KEYS LIST                        */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PRM01 &RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                            */
             DCL        VAR(&PRM01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
 
/* */
             IF         (&PRM01 *EQ 'SD0610') THEN(DO)
                CHGVAR     &MSG VALUE('CUSTOMER NAMES LIST EXECUTING')
                GOTO ENDCHECK
             ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0630') THEN(DO)                                   /*BG12497*/
/**********     CHGVAR     &MSG VALUE(' AVAILABLE CUSTOMER NUMBERS LIST +                /*BG12497*/
/**********     EXECUTING')                                                              /*BG12497*/
/**********     GOTO ENDCHECK                                                            /*BG12497*/
/**********  ENDDO                                                                       /*BG12497*/
/* */
             IF         (&PRM01 *EQ 'SD0620') THEN(DO)
                CHGVAR     &MSG VALUE(' CUSTOMERS BY PARENT LIST EXECUTING')
                GOTO ENDCHECK
             ENDDO
/* */                                                                 /*BHF605*/
 /*  Override the ACCOUNT KEY file for use within the called program   *BHF605*/
             IF         (&PRM01 *EQ 'SD0350') THEN(DO)                /*BHF605*/
                OVRDBF     FILE(ACKEYI) TOFILE(ACKEY)                 /*BHF605*/
                OVRDBF     FILE(ACKEYU) TOFILE(ACKEY)                 /*BHF605*/
                CHGVAR     &MSG VALUE(' ACCOUNT KEYS LIST EXECUTING') /*BHF605*/
                GOTO ENDCHECK                                         /*BHF605*/
             ENDDO                                                    /*BHF605*/
/*                                                           */
/*/COPY WNCPYSRC,SDC0604A01                                  */       /*S01408*/
/*                                                           */
/* */
 ENDCHECK:   CALL       PGM(&PRM01) PARM(&RSEQ)
/* */
             RTVJOBA    SWS(&SWS)
/* */
             IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                CHGJOB     SWS(XXXXXX1X)
             CHGVAR     VAR(&MSG) VALUE(' JOB TERMINATED - DATABASE +
                          IN ERROR')
             SNDMSG     MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM     /* END CL PGM */
