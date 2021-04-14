/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Maintain triggers')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCMNTTRIG - Maintain Triggers                               */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD055682           Date 31Jul20              */
/*       Prev Amend No. MD055681           Date 31Jul20              */
/*                      MD046248           Date 27Oct17              */
/*                      CCB022             Date 06Aug12              */
/*                      261725             Date 27Jul12              */
/*                      AR725021           Date 14Mar11              */
/*                      BUG27884           Date 08Jul10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      243463             Date 18Nov06              */
/*                      BG18886            Date 23May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      244609             Date 21Dec06              */
/*                      BUG13291           Date 21Dec06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP099             Date 10Jun05              */
/*                      BUG6550            Date 13May05              */
/*                      BG5090R1           Date 18Feb05              */
/*                      BG5090R            Date 14Jan05              */
/*                      BUG5090            Date 13Aug04              */
/*                      CPK020             Date 13Aug04              */
/*                      BUG3379            Date 24Jun04              */
/*                      CGP001 *CREATE     Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055682 - Deliverable Data Split for TRIG                  */
/*       MD055681 - Deliverable Data Split for SAR                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB022 - COB Restructure - COB File Manager                 */
/*       261725 - Added WRKOBJLCK command if file locking occurs.    */
/*       AR725021 - Reversal of applied 243463 fix (Child: AR725022) */
/*       BUG27884 - Applied 243463                                   */
/*       243463 - When U7 and U8 have been switched on to fail the   */
/*                component, do not reset them before program exit   */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG13291 - Apply 244609                                     */
/*       244609 - Trigger was not added to SDHOLPD but component did */
/*                not fail.  Applied part of fix 243422.             */
/*       CUP099 - Error handling can lead to looping.                */
/*       BUG6550 - End Global Updater job before processing trigger  */
/*                 programs.  Only end and start updater on changes  */
/*                 of trigger and during batch jobtype.              */
/*       BG5090R1 - Now it adds two triggers... Remove sequence      */
/*                processing altogether.  Also extend error handling.*/
/*       BG5090R - Fix to reverse BG5090 and cater the error         */
/*                reported by BG5090                                 */
/*       BUG5090 - Doesn't process second trigger if TRACTV = 'N'    */
/*       CPK020 - Addition of command TRIGZONE.                      */
/*                Report for any add/remove trigger errors instead   */
/*                of to msgq(MOPERQ).                                */
/*       BUG3379- Stop duplicate updating of files by only applying  */
/*                 first trigger to file.                            */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&FUNC &FILE &LIVE)                                        */ /*CPK020*/
             PGM        PARM(&ACTION &FILE &TRIGTYPE)                                     /*CPK020*/

/**Function*is:*A*to*ADD,************R*to*REMOVE,*********************/ /*             */ /*CPK020*/
/***************D*to*DISPLAY*active,*E*to*DISPLAY*inactive************/ /*             */ /*CPK020*/
/***************X*to*REMOVE*ALL*for*a*specified*file******************/ /*             */ /*CPK020*/
/*                                                           */
/**File*is:*****(optionally)*a*file*recorded*on*SCTRIGPD**************/ /*             */ /*CPK020*/
/*                                                           */
/**Live*is:*****Y*to*process*only*live*triggers***********************/ /*             */ /*CPK020*/
/***************N*to*process*all*triggers*(live*or*not)***************/ /*             */ /*CPK020*/

/**********  DCL        VAR(&FUNC) TYPE(*CHAR) LEN(1)                                  */ /*CPK020*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(12)                                  /*CPK020*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&LIVE) TYPE(*CHAR) LEN(1)                                  */ /*CPK020*/
             DCL        VAR(&TRIGTYPE) TYPE(*CHAR) LEN(9)                                 /*CPK020*/

/************DCL        VAR(&SYPR) TYPE(*CHAR) LEN(2)                                   /*BG5090R1*/
             DCL        VAR(&TNAM) TYPE(*CHAR) LEN(258)

             DCL        VAR(&TIME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EVNT) TYPE(*CHAR) LEN(10)

/**********  DCL        VAR(&TRGLIV) TYPE(*CHAR) LEN(1)                                */ /*CPK020*/
             DCL        VAR(&TRGACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBRRCDS) TYPE(*DEC) LEN(10 0)                              /*BG5090R1*/
/************DCL        VAR(&TRGCNT) TYPE(*DEC)  LEN(2 0)                               /*BG5090R1*/
/************DCL        VAR(&WFILE) TYPE(*CHAR) LEN(10)                      /*CPK020*/ /*BG5090R1*/
/************DCL        VAR(&WTIME) TYPE(*CHAR) LEN(1)                       /*CPK020*/ /*BG5090R1*/
/************DCL        VAR(&WEVNT) TYPE(*CHAR) LEN(1)                       /*CPK020*/ /*BG5090R1*/
/************DCL        VAR(&WSEQ) TYPE(*CHAR) LEN(2)                       /*BUG5090*/ /*BG5090R1*/
/************DCL        VAR(&WFLAG) TYPE(*CHAR) LEN(1) VALUE('N')           /*BG5090R*/ /*BG5090R1*/
/* Parameters passed to UP008010 - write/report error message program                     /*CPK020*/
             DCL        VAR(&GENPGM)    TYPE(*CHAR) LEN(10) VALUE('SCMNTTRIG')            /*CPK020*/
             DCL        VAR(&ERRORMSG)  TYPE(*CHAR) LEN(100)                              /*CPK020*/
             DCL        VAR(&ALCOBJERR) TYPE(*CHAR) LEN(1)  VALUE('N')                    /*CPK020*/
             DCL        VAR(&WRTFILE)   TYPE(*CHAR) LEN(10)                               /*CPK020*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(512)                               /*BG5090R1*/
                                                                                          /*CCB022*/
/* Parameters passed to SC001005 */                                                       /*CCB022*/
                                                                                          /*CCB022*/
             DCL        VAR(&SPECMSG) TYPE(*CHAR) LEN(400)                                /*CCB022*/
             DCL        VAR(&SPECFLAG) TYPE(*CHAR) LEN(1)                                 /*CCB022*/

/**********  DCLF       FILE(SCTRIGJ0) */                                               /*MD055682*/
             DCLF       FILE(SCTRGJW1) ALWNULL(*YES)                                    /*MD055682*/

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             OVRMSGF    MSGF(MIDAS) TOMSGF(GBMIDAS)                                     /*BG5090R1*/
/**********  OVRDBF     FILE(SCTRIGJ0) SHARE(*NO) */                           /*BUG3379**MD055682*/
                                                                                         /*BUG3379*/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
/**********  IF         COND((&JOBTYPE = '0') & (&ACTION = +              */ /*BUG6550*/ /*BG18886*/
/**********               '*RMVALLTRIG'***&ACTION = '*RMVTRIG'***+        */ /*BUG6550*/ /*BG18886*/
/**********               &ACTION = '*ADDTRIG')) THEN(CALL +              */ /*BUG6550*/ /*BG18886*/
/**********               PGM(GOC0002) PARM('END  ' '*LIBL     ' ' '))    */ /*BUG6550*/ /*BG18886*/
             IF         COND((&JOBTYPE = '0') & (&ACTION = +
                          '*RMVALLTRIG' *OR &ACTION = '*RMVTRIG' *OR +
                          &ACTION = '*ADDTRIG')) THEN(CALL +
                          PGM(GOC0002) PARM('END  ' '*LIBL     ' ' '))       /*BUG6550*/ /*BG18886*/

/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYPR)                              /*BG5090R1*/

/* Create temporary file to hold error messages. */                                       /*CPK020*/
             DLTF       FILE(QTEMP/UPERRMQT)                                              /*CPK020*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK020*/
             CRTPF      FILE(QTEMP/UPERRMQT) RCDLEN(100) +
                          TEXT('Temporary file for holding error +
                          messages')                                                      /*CPK020*/
                                                                                          /*CCB022*/
             DLTF       FILE(QTEMP/SCTRIGQT)                                              /*CCB022*/
             MONMSG     MSGID(CPF2105)                                                    /*CCB022*/
             CRTPF      FILE(QTEMP/SCTRIGQT) RCDLEN(400) +
                          TEXT('Temporary file for holding error +
                          messages') LVLCHK(*NO)                                          /*CCB022*/

/**********  IF         COND(&FUNC *= 'A' *AND &FUNC *= 'R' *AND +                     */ /*CPK020*/
/**********               &FUNC *= 'D' *AND &FUNC *= 'E' *AND +                        */ /*CPK020*/
/**********               &FUNC *= 'X') THEN(GOTO +                                    */ /*CPK020*/
/**********               CMDLBL(ABNOR))                                               */ /*CPK020*/

/**********  IF         COND(&LIVE *= 'Y' *AND &LIVE *= 'N') +                         */ /*CPK020*/
/**********               THEN(GOTO CMDLBL(ABNOR))                                     */ /*CPK020*/

/**********  IF         COND(&FUNC = 'A' *AND &LIVE *= 'Y') +                          */ /*CPK020*/
/**********               THEN(GOTO CMDLBL(ABNOR))                                     */ /*CPK020*/

/**********  IF         COND(&FUNC = 'X' *AND &FILE = '        ') +                    */ /*CPK020*/
/**********               THEN(GOTO CMDLBL(ABNOR))                                     */ /*CPK020*/

/**********  IF         COND(&FUNC = 'X') THEN(GOTO CMDLBL(REMOVEALL))                 */ /*CPK020*/
             IF         COND(&ACTION *EQ '*RMVALLTRIG') THEN(GOTO +
                          CMDLBL(REMOVEALL))                                              /*CPK020*/

AGAIN:
/**Set*work*variables*to*previous*value*from*SCTRIGJ0. */                    /*CPK020*/ /*BG5090R1*/
/************CHGVAR     VAR(&WFILE) VALUE(&TRFILE)                           /*CPK020*/ /*BG5090R1*/
/************CHGVAR     VAR(&WTIME) VALUE(&TRTIME)                           /*CPK020*/ /*BG5090R1*/
/************CHGVAR     VAR(&WEVNT) VALUE(&TREVNT)                           /*CPK020*/ /*BG5090R1*/
/************CHGVAR     VAR(&WSEQ) VALUE(&TRSEQ)                            /*BUG5090*/ /*BG5090R1*/

             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(CHECK))                         /*BG5090R1*/
/************MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CHECK))                         /*BG5090R1*/
                                                                            /*BG5090R*/ /*BG5090R1*/
/************IF         COND(&TRFILE *NE &WFILE *OR &TRTIME *NE +
/************             &WTIME *OR &TREVNT *NE &WEVNT) THEN(DO)           /*BG5090R*/ /*BG5090R1*/
/************CHGVAR     VAR(&WFLAG) VALUE('N')                              /*BG5090R*/ /*BG5090R1*/
/************ENDDO                                                          /*BG5090R*/ /*BG5090R1*/

/**If*the*new*fields*match*the*previous*values*then*do*not*atttempt*to**/    /*CPK020*/ /*BG5090R1*/
/***process*trigger.                                                   */    /*CPK020*/ /*BG5090R1*/
/************IF         COND(&TRFILE *EQ &WFILE *AND &TRTIME *EQ +                      /*BG5090R1*/
/************             &WTIME *AND &TREVNT *EQ &WEVNT *AND +                         /*BG5090R1*/
/************             &WFLAG *EQ 'Y') THEN(DO)                          /*BG5090R*/ /*BG5090R1*/
/**********               &TRSEQ *EQ &WSEQ) THEN(DO)                 */          /*BUG5090 BG5090R*/
/**********               &WTIME *AND &TREVNT *EQ &WEVNT) THEN(DO)   */           /*CPK020 BUG5090*/
/************   GOTO       CMDLBL(AGAIN)                                     /*CPK020*/ /*BG5090R1*/
/************ENDDO                                                           /*CPK020*/ /*BG5090R1*/

/**********  IF         COND(&LIVE = 'Y' *AND &TRACTV *= 'Y') +                        */ /*CPK020*/
/**********               THEN(GOTO CMDLBL(AGAIN))                                     */ /*CPK020*/
             IF         COND(&TRIGTYPE *EQ '*LIVETRIG' *AND &TRACTV +
                          *NE 'Y') THEN(GOTO CMDLBL(AGAIN))                               /*CPK020*/

/**********  IF         COND(&FUNC *= 'R') THEN(+                                      */ /*CPK020*/
/**********  CHGVAR     VAR(&TRSEQ) VALUE('01'))                           */ /*BUG3379*/ /*CPK020*/

/**Check*For*'Live'*Trigger**/ /*                                                      */ /*CPK020*/
/**********  CALL       PGM(SCCHKLTRG) PARM(&TRFILE &TRTIME &TREVNT +                  */ /*CPK020*/
/**********               &TRSEQ &TRGLIV)                                              */ /*CPK020*/

/**********  IF         COND(&LIVE = 'Y' *AND &TRGLIV *= 'Y') +                        */ /*CPK020*/
/**********               THEN(GOTO CMDLBL(AGAIN))                                     */ /*CPK020*/

             IF         COND(&TRTIME = 'A') THEN(CHGVAR VAR(&TIME) +
                          VALUE('*AFTER'))
             IF         COND(&TRTIME = 'B') THEN(CHGVAR VAR(&TIME) +
                          VALUE('*BEFORE'))

             IF         COND(&TREVNT = 'I') THEN(CHGVAR VAR(&EVNT) +
                          VALUE('*INSERT'))
             IF         COND(&TREVNT = 'D') THEN(CHGVAR VAR(&EVNT) +
                          VALUE('*DELETE'))
             IF         COND(&TREVNT = 'U') THEN(CHGVAR VAR(&EVNT) +
                          VALUE('*UPDATE'))
             IF         COND(&TREVNT = 'R') THEN(CHGVAR VAR(&EVNT) +
                          VALUE('*READ'))

/************CHGVAR     VAR(&TNAM) VALUE(&SYPR *CAT '_' *CAT +                          /*BG5090R1*/
/************             &TRFILE *TCAT '_' *CAT &TRTIME *CAT +                         /*BG5090R1*/
/************             '_' *CAT &TREVNT *CAT '_' *CAT &TRSEQ)                        /*BG5090R1*/
             CHGVAR     VAR(&TNAM) VALUE(&TRFILE *TCAT '_' *CAT +
                          %SST(&TIME 2 9) *TCAT '_' *CAT %SST(&EVNT +
                          2 9))                                                         /*BG5090R1*/

/* Display if active */
/**********  IF         COND(&FUNC = 'D') THEN(DO)                                     */ /*CPK020*/
/**********     IF         COND(&FILE = '        ' *OR &FILE = &TRFILE) +              */ /*CPK020*/
/**********                  THEN(DO)                                                  */ /*CPK020*/
             IF         COND(&ACTION *EQ '*DSPACTIVE') THEN(DO)                           /*CPK020*/
                IF         COND(&FILE *EQ '*ALL' *OR &FILE *EQ &TRFILE) +
                             THEN(DO)                                                     /*CPK020*/
/************      CALL       PGM(SCCHKTRIG) PARM(&TRFILE &TRTIME &TREVNT +             /*BG5090R1*/
/************                   &TRSEQ &TRGACT &TRGCNT)                                 /*BG5090R1*/
                   CALL       PGM(SCCHKTRIG) PARM(&TRFILE &TNAM &TRGACT)                /*BG5090R1*/
                   IF         COND(&TRGACT = 'Y') THEN(SNDMSG MSG(&TNAM +
                                *TCAT ' is ACTIVE') TOMSGQ(MRUNQ))
                ENDDO
             ENDDO

/* Display if NOT active */
/**********  IF         COND(&FUNC = 'E') THEN(DO)                                     */ /*CPK020*/
/**********     IF         COND(&FILE = '        ' *OR &FILE = &TRFILE) +              */ /*CPK020*/
/**********                  THEN(DO)                                                  */ /*CPK020*/
             IF         COND(&ACTION *EQ '*DSPINACTIVE') THEN(DO)                         /*CPK020*/
                IF         COND(&FILE *EQ '*ALL' *OR &FILE *EQ &TRFILE) +
                             THEN(DO)                                                     /*CPK020*/
/************      CALL       PGM(SCCHKTRIG) PARM(&TRFILE &TRTIME &TREVNT +             /*BG5090R1*/
/************                   &TRSEQ &TRGACT &TRGCNT)                                 /*BG5090R1*/
                   CALL       PGM(SCCHKTRIG) PARM(&TRFILE &TNAM &TRGACT)                /*BG5090R1*/
                   IF         COND(&TRGACT = 'N') THEN(SNDMSG MSG(&TNAM +
                                *TCAT ' is NOT ACTIVE') TOMSGQ(MRUNQ))
                ENDDO
             ENDDO

/* Remove */
/**********  IF         COND(&FUNC = 'R') THEN(DO)                                     */ /*CPK020*/
/**********     IF         COND(&FILE = '        ' *OR &FILE = &TRFILE) +              */ /*CPK020*/
/**********                  THEN(DO)                                                  */ /*CPK020*/
             IF         COND(&ACTION *EQ '*RMVTRIG') THEN(DO)                             /*CPK020*/
                IF         COND(&FILE *EQ '*ALL' *OR &FILE *EQ &TRFILE) +
                             THEN(DO)                                                     /*CPK020*/
                                                                                          /*CCB022*/
/**********        IF         COND(&TRFILE *EQ 'SCSARDPD' *OR &TRFILE +
                                *EQ 'SCTRIGPD' *OR &TRFILE *EQ +
                                'SDMMIDPD' *OR &TRFILE *EQ 'SCSARTPD') +
                                THEN(DO) */                                     /*CCB022**MD055681*/
/**********        IF         COND(&TRFILE *EQ 'SCSRDCTD' *OR &TRFILE +
                                *EQ 'SCSRDBTD' *OR &TRFILE     +
                                *EQ 'SCSRDXTD' *OR &TRFILE     +
                                *EQ 'SCTRIGPD' *OR &TRFILE *EQ +
                                'SDMMIDPD' *OR &TRFILE *EQ 'SCSARTPD') +
                                THEN(DO) */                                   /*MD055681**MD055682*/
                   IF         COND(&TRFILE *EQ 'SCSRDCTD' *OR &TRFILE +
                                *EQ 'SCSRDBTD' *OR &TRFILE     +
                                *EQ 'SCSRDXTD' *OR &TRFILE     +
                                *EQ 'SCTRGCTD' *OR &TRFILE     +
                                *EQ 'SCTRGBTD' *OR &TRFILE     +
                                *EQ 'SCTRGXTD' *OR &TRFILE     +
                                *EQ 'SDMMIDPD' *OR &TRFILE     +
                                *EQ 'SCSRTCTD' *OR &TRFILE     +
                                *EQ 'SCSRTBTD' *OR &TRFILE     +
                                *EQ 'SCSRTXTD') +
                                THEN(DO)                                                /*MD055682*/
                      CHGVAR     VAR(&SPECMSG) VALUE('*SPECIAL  RMVPFTRG +
                                   FILE(' *CAT &TRFILE *CAT ') TRG(' *CAT +
                                   &TNAM *CAT ')')                                        /*CCB022*/
                      CALL       PGM(SC001005) PARM('*WRITE' &SPECMSG)                    /*CCB022*/
                      CHGVAR     VAR(&SPECFLAG) VALUE('Y')                                /*CCB022*/
                      GOTO       CMDLBL(AGAIN)                                            /*CCB022*/
                   ENDDO                                                                  /*CCB022*/
                                                                                          /*CCB022*/
                   ALCOBJ     OBJ((&TRFILE *FILE *EXCL)) WAIT(1)
                   MONMSG     MSGID(CPF1002) EXEC(DO)
                     WRKOBJLCK OBJ(&TRFILE) OBJTYPE(*FILE) MBR(*ALL) OUTPUT(*PRINT)       /*261725*/
                     SNDMSG     MSG(&TRFILE *CAT ' not allocated - see spool file +
                                for locking details') TOMSGQ(MOPERQ)                      /*261725*/
/**********          SNDMSG     MSG(&TRFILE *CAT ' not allocated') +                   */ /*CPK020*/
/**********                     TOMSGQ(MOPERQ)                                         */ /*CPK020*/
/*    if file different from previous, send out error line to report UP008010P1.          /*CPK020*/
                     IF         COND(&TRFILE *NE &WRTFILE) THEN(DO)                       /*CPK020*/
                        CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not removed from ' +
                                   *CAT &TRFILE *TCAT '.')                                /*CPK020*/
                        CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)           /*CPK020*/
                        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                       /*CPK020*/
                            GOTO       CMDLBL(ABNOR)                                      /*CPK020*/
                        ENDDO                                                             /*CPK020*/
                        CHGVAR     VAR(&WRTFILE) VALUE(&TRFILE)                           /*CPK020*/
                     ENDDO                                                                /*CPK020*/
                     CHGVAR     VAR(&ALCOBJERR) VALUE('Y')                                /*CPK020*/
/**********          CHGJOB     SWS(XXXXXX11)                                          */ /*CPK020*/
                     GOTO       CMDLBL(AGAIN)
                   ENDDO
                   RMVPFTRG   FILE(&TRFILE) TRG(&TNAM)
/************      MONMSG     MSGID(CPF0000)                                            /*BG5090R1*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)                                   /*BG5090R1*/
                                                                                        /*BG5090R1*/
/* Check if trigger still there                */                                       /*BG5090R1*/
                   CALL       PGM(SCCHKTRIG) PARM(&TRFILE &TNAM &TRGACT)                /*BG5090R1*/
                   IF         COND(&TRGACT = 'Y') THEN(DO)                              /*BG5090R1*/
/*    if file different from previous, send out error line to report UP008010P1.   */   /*BG5090R1*/
                      IF         COND(&TRFILE *NE &WRTFILE) THEN(DO)                    /*BG5090R1*/
                         CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not removed from ' +
                                      *CAT &TRFILE *TCAT '.')                           /*BG5090R1*/
                         CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)        /*BG5090R1*/
                         IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                    /*BG5090R1*/
                            GOTO       CMDLBL(ABNOR)                                    /*BG5090R1*/
                         ENDDO                                                          /*BG5090R1*/
                         CHGVAR     VAR(&WRTFILE) VALUE(&TRFILE)                        /*BG5090R1*/
                      ENDDO                                                             /*BG5090R1*/
                      CHGVAR     VAR(&ALCOBJERR) VALUE('Y')                             /*BG5090R1*/
                      ENDDO                                                             /*BG5090R1*/
                   ENDDO                                                                /*BG5090R1*/
                   DLCOBJ     OBJ((&TRFILE *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO

/* Add */
/**********  IF         COND(&FUNC = 'A') THEN(DO)                                     */ /*CPK020*/
/**********     IF         COND(&FILE = '        ' *OR &FILE = &TRFILE) +              */ /*CPK020*/
/**********                  THEN(DO)                                                  */ /*CPK020*/
             IF         COND(&ACTION *EQ '*ADDTRIG') THEN(DO)                             /*CPK020*/
                IF         COND(&FILE *EQ '*ALL' *OR &FILE *EQ &TRFILE) +
                             THEN(DO)                                                     /*CPK020*/
                                                                                          /*CCB022*/
/**********        IF         COND(&TRFILE *EQ 'SCSARDPD' *OR &TRFILE +
                                *EQ 'SCTRIGPD' *OR &TRFILE *EQ +
                                'SDMMIDPD' *OR &TRFILE *EQ 'SCSARTPD') +
                                THEN(DO) */                                     /*CCB022**MD055681*/
/**********        IF         COND(&TRFILE *EQ 'SCSRDCTD' *OR &TRFILE +
                                *EQ 'SCSRDBTD' *OR &TRFILE     +
                                *EQ 'SCSRDXTD' *OR &TRFILE     +
                                *EQ 'SCTRIGPD' *OR &TRFILE *EQ +
                                'SDMMIDPD' *OR &TRFILE *EQ 'SCSARTPD') +
                                THEN(DO) */                                   /*MD055681**MD055682*/
                   IF         COND(&TRFILE *EQ 'SCSRDCTD' *OR &TRFILE +
                                *EQ 'SCSRDBTD' *OR &TRFILE     +
                                *EQ 'SCSRDXTD' *OR &TRFILE     +
                                *EQ 'SCTRGCTD' *OR &TRFILE     +
                                *EQ 'SCTRGBTD' *OR &TRFILE     +
                                *EQ 'SCTRGXTD' *OR &TRFILE     +
                                *EQ 'SDMMIDPD' *OR &TRFILE     +
                                *EQ 'SCSRTCTD' *OR &TRFILE     +
                                *EQ 'SCSRTBTD' *OR &TRFILE     +
                                *EQ 'SCSRTXTD') +
                                THEN(DO)                                                /*MD055682*/
                      CHGVAR     VAR(&SPECMSG) VALUE('*SPECIAL  ADDPFTRG +
                                   FILE(' *CAT &TRFILE *CAT ') TRGTIME(' +
                                   *CAT &TIME *CAT ') TRGEVENT(' *CAT +
                                   &EVNT *CAT ') PGM(SCTRIGGER) +
                                   RPLTRG(*YES) TRG(' *CAT &TNAM *CAT ')')                /*CCB022*/
                      IF         COND(&EVNT *EQ '*UPDATE') THEN(DO)
                         CHGVAR     VAR(&SPECMSG) VALUE(&SPECMSG *BCAT +
                                      'TRGUPDCND(*CHANGE)')                               /*CCB022*/
                      ENDDO                                                               /*CCB022*/
                      CALL       PGM(SC001005) PARM('*WRITE' &SPECMSG)                    /*CCB022*/
                      CHGVAR     VAR(&SPECFLAG) VALUE('Y')                                /*CCB022*/
                      GOTO       CMDLBL(AGAIN)                                            /*CCB022*/
                   ENDDO                                                                  /*CCB022*/
                   ALCOBJ     OBJ((&TRFILE *FILE *EXCL)) WAIT(1)
                   MONMSG     MSGID(CPF1002) EXEC(DO)
                     WRKOBJLCK OBJ(&TRFILE) OBJTYPE(*FILE) MBR(*ALL) OUTPUT(*PRINT)       /*261725*/
                     SNDMSG     MSG(&TRFILE *CAT ' not allocated - see spool file +
                                for locking details') TOMSGQ(MOPERQ)                      /*261725*/
/**********          SNDMSG     MSG(&TRFILE *CAT ' not allocated') +                   */ /*CPK020*/
/**********                     TOMSGQ(MOPERQ)                                         */ /*CPK020*/
/*    if file different from previous, send out error line to report UP008010P1.          /*CPK020*/
                     IF         COND(&TRFILE *NE &WRTFILE) THEN(DO)                       /*CPK020*/
                        CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not added to ' +
                                   *CAT &TRFILE *TCAT '.')                                /*CPK020*/
                        CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)           /*CPK020*/
                        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                       /*CPK020*/
                            GOTO       CMDLBL(ABNOR)                                      /*CPK020*/
                        ENDDO                                                             /*CPK020*/
                        CHGVAR     VAR(&WRTFILE) VALUE(&TRFILE)                           /*CPK020*/
                     ENDDO                                                                /*CPK020*/
                     CHGVAR     VAR(&ALCOBJERR) VALUE('Y')                                /*CPK020*/
/**********          CHGJOB     SWS(XXXXXX11)                                          */ /*CPK020*/
                     GOTO       CMDLBL(AGAIN)
                   ENDDO
                   IF         COND(&EVNT *EQ '*UPDATE') THEN(DO)
                      ADDPFTRG   FILE(&TRFILE) TRGTIME(&TIME) TRGEVENT(&EVNT) +
                                   PGM(SCTRIGGER) RPLTRG(*YES) TRG(&TNAM) +
                                   TRGUPDCND(*CHANGE)
/************         MONMSG     MSGID(CPF0000)                                         /*BG5090R1*/
/************         CHGVAR     VAR(&WFLAG) VALUE('Y')                     /*BG5090R*/ /*BG5090R1*/
                      MONMSG     MSGID(CPF0000) EXEC(DO)                                /*BG5090R1*/
                                                                                        /*BG5090R1*/
/*  If file different from previous, send out error line to report UP008010P1. */       /*BG5090R1*/
                        IF         COND(&TRFILE *NE &WRTFILE) THEN(DO)                  /*BG5090R1*/
                           CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not added to ' +
                                      *CAT &TRFILE *TCAT '.')                           /*BG5090R1*/
                           CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)      /*BG5090R1*/
                           IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                  /*BG5090R1*/
                               GOTO       CMDLBL(ABNOR)                                 /*BG5090R1*/
                           ENDDO                                                        /*BG5090R1*/
                           CHGVAR     VAR(&WRTFILE) VALUE(&TRFILE)                      /*BG5090R1*/
                        ENDDO                                                           /*BG5090R1*/
                        CHGVAR     VAR(&ALCOBJERR) VALUE('Y')                           /*BG5090R1*/
                        GOTO       CMDLBL(AGAIN)                                        /*BG5090R1*/
                      ENDDO                                                             /*BG5090R1*/
                   ENDDO
                   IF         COND(&EVNT *NE '*UPDATE') THEN(DO)
                      ADDPFTRG   FILE(&TRFILE) TRGTIME(&TIME) TRGEVENT(&EVNT) +
                                   PGM(SCTRIGGER) RPLTRG(*YES) TRG(&TNAM)
/************         MONMSG     MSGID(CPF0000)                                         /*BG5090R1*/
/************         CHGVAR     VAR(&WFLAG) VALUE('Y')                     /*BG5090R*/ /*BG5090R1*/
                      MONMSG     MSGID(CPF0000) EXEC(DO)                                /*BG5090R1*/
                                                                                        /*BG5090R1*/
/*  If file different from previous, send out error line to report UP008010P1. */       /*BG5090R1*/
                        IF         COND(&TRFILE *NE &WRTFILE) THEN(DO)                  /*BG5090R1*/
                           CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not added to ' +
                                      *CAT &TRFILE *TCAT '.')                           /*BG5090R1*/
                           CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)      /*BG5090R1*/
                           IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                  /*BG5090R1*/
                               GOTO       CMDLBL(ABNOR)                                 /*BG5090R1*/
                           ENDDO                                                        /*BG5090R1*/
                           CHGVAR     VAR(&WRTFILE) VALUE(&TRFILE)                      /*BG5090R1*/
                        ENDDO                                                           /*BG5090R1*/
                        CHGVAR     VAR(&ALCOBJERR) VALUE('Y')                           /*BG5090R1*/
                        GOTO       CMDLBL(AGAIN)                                        /*BG5090R1*/
                      ENDDO                                                             /*BG5090R1*/
                   ENDDO
                   DLCOBJ     OBJ((&TRFILE *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO

             GOTO       CMDLBL(AGAIN)

 REMOVEALL:
/* Remove All Triggers for a Specified File */

/* Check if any triggers present                                                     */ /*BG5090R1*/
                   DSPFD      FILE(&FILE) TYPE(*TRG) OUTPUT(*OUTFILE) +
                                OUTFILE(QTEMP/CHKANYTRG) OUTMBR(*FIRST +
                                *REPLACE)                                               /*BG5090R1*/
                   RTVMBRD    FILE(QTEMP/CHKANYTRG) NBRCURRCD(&NBRRCDS)                 /*BG5090R1*/
                   IF         COND(&NBRRCDS = 0) THEN(GOTO CMDLBL(END))                 /*BG5090R1*/
                   ALCOBJ     OBJ((&FILE *FILE *EXCL)) WAIT(1)
                   MONMSG     MSGID(CPF1002) EXEC(DO)
                     WRKOBJLCK OBJ(&FILE) OBJTYPE(*FILE) MBR(*ALL) OUTPUT(*PRINT)         /*261725*/
                     SNDMSG     MSG(&FILE *CAT ' not allocated - see spool file +
                                for locking details') TOMSGQ(MOPERQ)                      /*261725*/
/**********          SNDMSG     MSG(&FILE *CAT ' not allocated') +                     */ /*CPK020*/
/**********                     TOMSGQ(MOPERQ)                                         */ /*CPK020*/
/*    send out error line to report UP008010P1                                            /*CPK020*/
                     CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not removed from ' +
                                   *CAT &FILE *TCAT '.')                                  /*CPK020*/
                     CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)              /*CPK020*/
                     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                          /*CPK020*/
                         GOTO       CMDLBL(ABNOR)                                         /*CPK020*/
                     ENDDO                                                                /*CPK020*/
/**********          GOTO       CMDLBL(ABNOR)                                          */ /*CPK020*/
/**********          CHGJOB     SWS(XXXXXX11)                                          */ /*CPK020*/
                     CHGVAR     VAR(&ALCOBJERR) VALUE('Y')                                /*CPK020*/
                     GOTO       CMDLBL(CHECK)                                             /*CPK020*/
                   ENDDO
                   RMVPFTRG   FILE(&FILE) TRGTIME(*ALL) TRGEVENT(*ALL) +
                                TRG(*ALL)
/************      MONMSG     MSGID(CPF0000)                                            /*BG5090R1*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)                                   /*BG5090R1*/
/*    send out error line to report UP008010P1                                       */ /*BG5090R1*/
                     CHGVAR     VAR(&ERRORMSG) VALUE('Trigger(s) not removed from ' +
                                   *CAT &FILE *TCAT '.')                                /*BG5090R1*/
                     CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)            /*BG5090R1*/
                     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                        /*BG5090R1*/
                         GOTO       CMDLBL(ABNOR)                                       /*BG5090R1*/
                     ENDDO                                                              /*BG5090R1*/
                   ENDDO                                                                /*BG5090R1*/
                   DLCOBJ     OBJ((&FILE *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
/**********        GOTO       CMDLBL(END)                                                 /*CPK020*/

CHECK:
                                                                                          /*CCB022*/
/* Call program to process add/rmv trigger commands from SCTRIGQT */                      /*CCB022*/
                                                                                          /*CCB022*/
             IF         COND(&SPECFLAG = 'Y') THEN(DO)                                    /*CCB022*/
                CALL       PGM(SC001005) PARM('*PROC' ' ')                                /*CCB022*/
             ENDDO                                                                        /*CCB022*/
                                                                                          /*CCB022*/
/* Call program to produce report UP008010P1.                                             /*CPK020*/
             CALL       PGM(UP008010) PARM(*REPORT &GENPGM ' ')                           /*CPK020*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CUP022*/
                GOTO       CMDLBL(ABNOR)                                                  /*CUP022*/
             ENDDO                                                                        /*CUP022*/
             CHGSPLFA   FILE(UP008010P1) SPLNBR(*LAST) +
                          USRDTA(&GENPGM)                                                 /*CPK020*/

             IF         COND(&ALCOBJERR = 'Y') THEN(CHGJOB +
                          SWS(00000011))                                                  /*CPK020*/
             IF         COND(&ALCOBJERR = 'Y') THEN(GOTO CMDLBL(ABNOR))                 /*BG5090R1*/
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CPK020*/
                GOTO       CMDLBL(END)
/**********  ENDDO                                                                        /*CPK020*/

 ABNOR:
             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCMNTTRIG ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

/* Abnormal termination - interactive job */

             IF         COND(&JOBTYPE = '1') THEN(DO)
                RTVMSG     MSGID(MEM5007) MSGF(MIDAS) MSG(&MSGDTA)                      /*BG5090R1*/
                MONMSG     MSGID(CPF0000)                                                 /*CUP099*/
                RCLRSC                                                                  /*BG5090R1*/
                MONMSG     MSGID(CPF0000 MCH0000)                                       /*BG5090R1*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)                                              /*BG5090R1*/
/************   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +                                 /*BG5090R1*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                   /*BG5090R1*/
/************   MONMSG     MSGID(CPF0000 MCH0000)                                       /*BG5090R1*/
             ENDDO

END:
/************IF         COND((&JOBTYPE = '0') & (&ACTION = +             */ /*BUG6550*/ /*BG18886*/
/************             '*RMVALLTRIG'***&ACTION = '*RMVTRIG'***+       */ /*BUG6550*/ /*BG18886*/
/************             &ACTION = '*ADDTRIG')) THEN(CALL +             */ /*BUG6550*/ /*BG18886*/
/************             PGM(GOC0002) PARM('START' '*LIBL     ' ' ')    */ /*BUG6550*/ /*BG18886*/
/**********  IF         COND((&JOBTYPE = '0') & (&ACTION = +                           */ /*243463*/
/**********               '*RMVALLTRIG' *OR &ACTION = '*RMVTRIG' *OR +                 */ /*243463*/
/**********               &ACTION = '*ADDTRIG')) THEN(CALL +                           */ /*243463*/
/**********               PGM(GOC0002) PARM('START' '*LIBL     ' ' '))      */ /*B18886*/ /*243463*/
/**********  IF         COND(%SWITCH(XXXXXX00) *AND (&JOBTYPE = '0') +               */ /*AR725021*/
/**********               *AND (&ACTION *EQ '*RMVALLTRIG' *OR +                      */ /*AR725021*/
/**********               &ACTION *EQ '*RMVTRIG' *OR &ACTION *EQ +                   */ /*AR725021*/
/**********               '*ADDTRIG')) THEN(CALL PGM(GOC0002) +                      */ /*AR725021*/
/**********               PARM('START' '*LIBL     ' ' '))                 */ /*243463*/ /*AR725021*/
                                                                                        /*AR725021*/
             IF         COND((&JOBTYPE = '0') & (&ACTION = +
                          '*RMVALLTRIG' *OR &ACTION = '*RMVTRIG' *OR +
                          &ACTION = '*ADDTRIG')) THEN(CALL +
                          PGM(GOC0002) PARM('START' '*LIBL     ' ' '))                  /*AR725021*/
                                                                                          /*244609*/
/** Remove this 244609 when BUG6550 is also removed from this program */                  /*244609*/
                                                                                          /*244609*/
             IF         COND(&ALCOBJERR = 'Y') THEN(CHGJOB +
                          SWS(XXXXXX11))                                                  /*244609*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
