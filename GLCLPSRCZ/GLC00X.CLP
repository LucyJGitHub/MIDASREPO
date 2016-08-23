/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Nostro file setup')                          */
/********************************************************************/
/*                                                                  */
/*     Midas GENERAL LEDGER MODULE                                  */
/*                                                                  */
/*     GLC00X  -  NOSTRO FILE SET UP                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01408         DATE 21FEB96                   */
/*     PREV AMEND NO. 066422         DATE 03MAR94                   */
/*                    036796         DATE 10JAN94                   */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     S01408  -  ADDITION OF CORE HOOK GLC00X001.                  */
/*     066422  -  REMOVE CALL TO GL0580. RSACMTPD DOES NOT NEED TO  */
/*                BE SET UP IN A NEW SYSTEM.                        */
/*     036796  -  NEW PROGRAM TO INITIALISE ALL OLPOS* AND PRONO*   */
/*                FILES - CALLED FROM INITIAL FILE SETUP PGM GLC92. */
/*                THIS PROCESSING WAS PREVIOUSLY DONE IN DL MODULE  */
/*                BY DLC00X.                                        */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM                                                      /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE(ALL)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75) +
                        VALUE('Job terminated - database in error')
/*/COPY WNCPYSRC,GLC00X002                                           */
/**/
             SNDMSG     MSG('Set up OLPOS & PRONO before DAY +
                          1') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(PRONOHH)
             CLRPFM     FILE(PRONOPN)
             CLRPFM     FILE(PRONTHH)
             CLRPFM     FILE(PRONTPP)
             CLRPFM     FILE(PRONTZX)
             CLRPFM     FILE(OLPOSHH)
             CLRPFM     FILE(OLPOSOA)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC00X001                                           */
                                                                      /*S01408*/
             CLRPFM     FILE(OLPOSOB)
             CLRPFM     FILE(RSACMTPD)
/*/COPY WNCPYSRC,GLC00X003                                           */
/**/
             SNDMSG     MSG('Creation of online positions file') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
             CALL       PGM(GL0610)                                   /*E22608*/
             RTVJOBA    JOB(&JOB)   SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 8 1) *NE '1') THEN(DO)
/**/
                SNDMSG     MSG('Create temp. projected nostro balances file') +
                           TOMSGQ(MRUNQ)
                CALL       PGM(GL0575)                                /*E22608*/
                RTVJOBA    JOB(&JOB)   SWS(&SWS)
/**/
                IF         COND(%SUBSTRING(&SWS 8 1) *NE '1') THEN(DO)
/**/
/******************SNDMSG     MSG('Nostro events report') +             066422*/
/*****************************TOMSGQ(MRUNQ)                             066422*/
/******************CALL       PGM(GL0580) PARM(&RSEQ &RENT)     E22608  066422*/
/******************RTVJOBA    JOB(&JOB)   SWS(&SWS)                     066422*/
/**/
/******************IF         COND(%SUBSTRING(&SWS 8 1) *NE '1') THEN(DO066422*/
/**/
/*********************CALL    PGM(CB0140) PARM('GL0580    ' '00001')    066422*/
/*********************RTVJOBA JOB(&JOB)   SWS(&SWS)                     066422*/
/**/
                      SNDMSG     MSG('OLPOS & PRONO file set up +
                                    complete') TOMSGQ(MRUNQ)
/**/                                                                   /*66422*/
                      ENDDO
/**/
                   ELSE       CMD(DO)
                      SNDMSG   MSG(&MSG)  TOMSGQ(&JOB)
                      SNDMSG   MSG(&MSG)  TOMSGQ(MOPERQ)
                   ENDDO
/**/
/******************ENDDO                                               *066422*/
/**/
/***************ELSE      CMD(DO)                                      *066422*/
/******************SNDMSG   MSG(&MSG)  TOMSGQ(&JOB)                    *066422*/
/******************SNDMSG   MSG(&MSG)  TOMSGQ(MOPERQ)                  *066422*/
/***************ENDDO                                                  *066422*/
/**/
                ENDDO
/**/
             ELSE      CMD(DO)
                SNDMSG   MSG(&MSG)  TOMSGQ(&JOB)
                SNDMSG   MSG(&MSG)  TOMSGQ(MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
