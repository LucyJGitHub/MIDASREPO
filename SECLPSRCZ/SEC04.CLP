/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Enquiries Control')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC04     CL COMPONENT TO CONTROL SE ENQUIRIES              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 213230             Date 17Oct06              */
/*       Prev Amend No. 235184             Date 04Aug05              */
/*                      214953             Date 11Apr03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CSE010             Date 21Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01401             Date 16Jun93              */
/*                      S01117             Date 10Dec90              */
/*                      S01220             DATE 20NOV89              */
/*                      E23127             DATE 09AUG90              */
/*                      E16158             DATE 10/03/89             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       213230 - Override SECTYX to SECTY to avoid CPF4101 using    */
/*                action code 'E'.                                   */
/*       235184 - Dbase error due to file TRADSDZ3 does not exist.   */
/*                Fix is to do OVRDBF on TRADSDZ3.                   */
/*       214953 - Not able to enquire on depot movement details. Fix */
/*                is to call new pgm SE0071 when option '2' is       */
/*                entered against a WI/WO record transaction.        */
/*       CSE010 - SE Transaction Enhancement                         */
/*       S01401 - SWIFT Messages MT5xxs : override files for         */
/*                retrieval in :- SE1805/SE1806 (called by SE0250,   */
/*                which in turn may be called from most Enquiries).  */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01220 - Amendment for linked enquiry from Risk Management:*/
/*                Data area creation parameters changed.            */
/*       E23127 - DTAARA SESDS RESET SO ENQUIRY SCREENS COME UP     */
/*                BLANK AND NOT WITH PREVIOUS ENQUIRY DETAILS.      */
/*           NB - E16158 FIX INCORRECT.                             */
/*       E16158 - LINKED ENQUIRIES FOR EXPOSURE MANAGEMENT FOR      *  *E16158*/
/*                SECURITIES TRADING NOT WORKING.                   *  *E16158*/
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PGM)
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/**/                                                                  /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
 
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&PGM)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,SEC04001                                            */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE010*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSE010*/
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE010*/
 
/*  SET OFF ALL SWITCHES                                             */
             CHGJOB     SWS(00000000)
 
/*  CLEAR  DTAARA/LDA                                                */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/*/COPY WNCPYSRC,SEC04003                                            */
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE014*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE010*/
             CHGVAR     VAR(&SAR) VALUE('CSE010')                     /*CSE010*/
             CHGVAR     VAR(&CSE010) VALUE('N')                       /*CSE010*/
/**/                                                                  /*CSE010*/
/**  Check if SE Transaction Enhancements is installed */             /*CSE010*/
/**/                                                                  /*CSE010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE010*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE010*/
                CHGVAR     VAR(&CSE010) VALUE('Y')                    /*CSE010*/
             ENDDO                                                    /*CSE010*/
/* OVERRIDE FOR OPEN FILE ERROR */
 
/************OVRDBF     FILE(TABSE) SHARE(*NO)                       * *S01117*/
 
/*  CHECK IF DTAARA/SESDS EXISTS. IF NOT, CREATE IT.                 */
/*           CHKOBJ     OBJ(SESDS.QTEMP) OBJTYPE(*DTAARA)            */
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
                                                                      /*S01220*/
/**********  CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(36)  *****/
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
                                                                      /*S01220*/
/************CHGDTAARA  DTAARA(SESDS (10 9)) VALUE('000000000')*E16158**S01117*/
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')          /*S01117*/
             ENDDO
 
/*  CLEAR DTAARA/SESDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.         */
/*                     AND SET ZONED FIELDS                          */
/*******     CHGDTAARA  DTAARA(SESDS) VALUE(' ')          ***           E16158*/
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')                      /*E23127*/
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE(&PGM)
/*******     CHGDTAARA  DTAARA(SESDS (10 9)) VALUE('000000000')         E16158*/
/************CHGDTAARA  DTAARA(SESDS (10 9)) VALUE('000000000')*E23127**S01117*/
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')          /*S01117*/
 
             IF         COND(&PGM *EQ 'SE0245') THEN(CHGDTAARA +
                          DTAARA(LDA (1 1)) VALUE('N'))
             IF         COND(&PGM *EQ 'se0245') THEN(CHGDTAARA +
                          DTAARA(LDA (1 1)) VALUE('N'))
                                                                      /*S01401*/
/*/COPY WNCPYSRC,SEC04002                                            */
/***  Override files for use in SE1805/6 which are called from   ***/ /*S01401*/
/***  SE0250 which may be being called directly or may be called ***/ /*S01401*/
/***  indirectly from several of the Linked Enquiry programs.    ***/ /*S01401*/
                                                                      /*S01401*/
                OVRDBF FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)     /*S01401*/
                OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)     /*S01401*/
                OVRDBF FILE(TRADSDZ3) TOFILE(TRADSDY2) SHARE(*NO)                         /*235184*/
 
/*/COPY WNCPYSRC,SEC04004                                            */
             IF COND(&CSE010 *EQ 'Y') THEN(DO)                        /*CSE010*/
                  OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)   /*CSE010*/
                  OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)   /*CSE010*/
                  OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)   /*CSE010*/
                  OVRDBF FILE(TRADSX1)  TOFILE(TRADS)    SHARE(*NO)   /*CSE010*/
                  OVRDBF FILE(SECTYX) TOFILE(SECTY) SHARE(*NO)                            /*213230*/
             ENDDO                                                    /*CSE010*/
             IF COND(&PGM *EQ 'SE0043') THEN(DO)                      /*CSE010*/
                CALL       PGM(&PGM) PARM('E' ' ')                    /*CSE010*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)    /*CSE010*/
                   SNDPGMMSG MSG('Option ended in error. Enter +
                      to continue.') TOPGMQ(*EXT)                     /*CSE010*/
                   GOTO ENDPGM                                        /*CSE010*/
                ENDDO                                                 /*CSE010*/
             ENDDO                                                    /*CSE010*/
             ELSE (DO)                                                /*CSE010*/
/*  CALL ENQUIRY PROGRAM                                             */
             IF         COND((&PGM *EQ 'SE0220') *OR (&PGM *EQ +
                          'SE0226') *OR (&PGM *EQ 'SE0236')) THEN(DO)                     /*214953*/
                  OVRDBF FILE(DPTMVDZ1) TOFILE(DPTMVDY1) SHARE(*NO)                       /*214953*/
                  OVRDBF FILE(DPTMVDZ2) TOFILE(DPTMVDY2) SHARE(*NO)                       /*214953*/
                  OVRDBF FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                       /*214953*/
             ENDDO                                                                        /*214953*/
             CALL       PGM(&PGM)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG MSG('Option ended in error. Enter +
                      to continue.') TOPGMQ(*EXT)
             IF         COND(&PGM *EQ 'SE0245') THEN(CHGDTAARA +
                          DTAARA(LDA (1 1)) VALUE(' '))
             IF         COND(&PGM *EQ 'se0245') THEN(CHGDTAARA +
                          DTAARA(LDA (1 1)) VALUE(' '))
             IF         COND((&PGM *EQ 'SE0220') *OR (&PGM *EQ +
                          'SE0226') *OR (&PGM *EQ 'SE0236')) THEN(DO)                     /*214953*/
                  DLTOVR FILE(DPTMVDZ1)                                                   /*214953*/
                  DLTOVR FILE(DPTMVDZ2)                                                   /*214953*/
                  DLTOVR FILE(DPTMVDZ3)                                                   /*214953*/
             ENDDO                                                                        /*214953*/
                GOTO ENDPGM
             ENDDO
 
/*/COPY WNCPYSRC,SEC04005                                            */
             ENDDO                                                    /*CSE010*/
             IF         COND(&PGM *EQ 'SE0245') THEN(CHGDTAARA +
                          DTAARA(LDA (1 1)) VALUE(' '))
             IF         COND(&PGM *EQ 'se0245') THEN(CHGDTAARA +
                          DTAARA(LDA (1 1)) VALUE(' '))
 
/*  CHECK IF RETURN CODE IS ZERO. IF YES, DATABASE ERROR             */
             RTVDTAARA  DTAARA(SESDS (9 1)) RTNVAR(&RTN)
             IF         COND(&RTN = '0') THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC04    - Job Terminated, +
                                         Database in Error')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) +
                TOMSGQ(MOPERQ MRUNQ)
                GOTO ENDPGM
             ENDDO
 
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR *ALL                                              /*S01401*/
             ENDPGM                                                   /*S01117*/
