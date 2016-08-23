/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CREATE ON LINE POSITIONS FILE')                 */
/********************************************************************/
/*                                                                  */
/*        Midas - Dealing Module                                    */
/*                                                                  */
/*       DLC0802E - CREATE ON LINE POSITIONS FILE                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408            DATE  21FEB96             */
/*       PREV AMEND NO. E20962            DATE  04OCT90             */
/*                      E22608            DATE  04SEP90             */
/*                      E21893            DATE  07AUG90             */
/*                      E15814            DATE  02/02/89            */
/*                      S01117            DATE  02/08/89            */
/*                      S01194            DATE  02/08/89            */
/*                      S03220            DATE  16/05/88            */
/*                      S01129            DATE  03/08/87            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01408 - ADDITION OF CORE HOOK GLC0802E01.                 */
/*       E20962 - OLPOS IS BEING UPDATED TWICE - (FT & DL)          */
/*       E22608 - PROGRAM RENAMED FROM DLC0802E AND ALL DL          */
/*                PROGRAMS CALLED RENAMED TO GL                     */
/*       E21893 - ALLOCATE ACCNT *SHRRD BEFORE CALLING DL0610 TO    */
/*                ENSURE FILE IS NOT LOCKED BY ANOTHER PROGRAM      */
/*       E15814 - A DATABASE ERROR IN DL0630 WOULD GO UNREPORTED    */
/*                AS FTC0280 WOULD SET SWITCHES 7 & 8 OFF AGAIN     */
/*                BEFORE THE ERROR COULD BE REPORTED AND PROCESSED  */
/*                BY EODSTRM2, SO ONLY CALL FTC0280 IF 7 & 8 OFF    */
/*       S01117 - RELEASE 10                                        */
/*       S01194 - NEW STANDING DATA FILES                           */
/*       S03220 - FUNDS TRANSFER INTREFACE                          */
/*       S01129 - INCLUDE FILES REQUIRED FOR SECURITIES TRADING 2   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PARM)                                   /*S01117*/
 
/* &RSEQ, &RLEV, &RENT ARE STANDARD RCF PARAMETERS, NOT USED IN */
/* THIS PROGRAM                                                 */
 
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)                 /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*/COPY WNCPYSRC,GLC0802E02                                          */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
/************DCL        VAR(&FT) TYPE(*CHAR) LEN(1)          /*S03220* *E20962*/
/**/
             CHGJOB     SWS(00000000)
             CLRPFM     FILE(OLPOSHH)
             CLRPFM     FILE(OLPOSOA)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802E01                                          */
                                                                      /*S01408*/
             CLRPFM     FILE(OLPOSOB)
/**/
             SNDMSG     MSG('CREATION OF ONLINE POSITIONS FILE') +
                        TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,GLC0802E03                                          */
/**********  OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
/**********  OVRDBF     FILE(TABLC)   TOFILE(TABDLEI)                 /*S01194*/
             IF         COND(&PARM = '1') THEN(CHGJOB SWS(XXX1XXXX))
             ALCOBJ     OBJ((ACCNT *FILE *SHRRD)) WAIT(1800)          /*E21893*/
/************CALL       PGM(DL0610)                                   /*E22608*/
             CALL       PGM(GL0610)                                   /*E22608*/
             DLCOBJ     OBJ((ACCNT *FILE *SHRRD))                     /*E21893*/
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
                SNDMSG     MSG('UPDATE ONLINE POSITIONS FILE') +
                           TOMSGQ(MRUNQ)
/***************IF*********COND(&PARM = '1') THEN(OVRDBF FILE(EVNTM) +
                          TOFILE(STEVE))     **/                      /*S01129*/
                                                                      /*S01129*/
/*/COPY WNCPYSRC,GLC0802E04                                          */
/*              CALL       PGM(DL0630)                                /*E22608*/
                CALL       PGM(GL0630)                                /*E22608*/
/*/COPY WNCPYSRC,GLC0802E05                                          */
                                                                      /*S01129*/
/***************IF*********COND(&PARM = '1') THEN(DLTOVR FILE(EVNTM))  *S01129*/
                                                                      /*S01129*/
                RTVJOBA    SWS(&SWS)
/**/                                                                  /*S03220*/
/************IF COND(%SWITCH(XXXXXX00)) THEN(DO)            /*E15814*  *E20962*/
/************RTVDTAARA  DTAARA(MMOD (57 1)) RTNVAR(&FT)     /*S03220*  *E20962*/
/************IF COND(&FT *EQ 'Y') THEN(CALL FTC0280)        /*S03220*  *E20962*/
/************ENDDO                                          /*E15814*  *E20962*/
/**/                                                                  /*S03220*/
             ENDDO
/**/
/*********** DLTOVR     FILE(TABLE TABLC)                             /*S01194*/
/**/
             RTVJOBA    SWS(&SWS)                                     /*E15814*/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
