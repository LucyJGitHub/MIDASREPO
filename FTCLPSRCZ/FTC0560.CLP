/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Debit and credit advices - input cycle')     */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0560  - CL COMPONENT TO CONTROL FT0560                   */
/*                  DR/CR ADVICES GENERATION - INPUT CYCLE           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 118633             Date 14May13              */
/*                      AR1060743          Date 26Nov12              */
/*                      CCB020             Date 06Aug12              */
/*                      CER059             Date 19Jul10              */
/*                      BUG23179           Date 04Mar09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/*                      177071             Date 29Mar00              */
/*                      CFT006             Date 31Jan00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408            DATE  15NOV96              */
/*                      102821            DATE  06MAY96              */
/*                      090309            DATE  19OCT95              */
/*                      086139            DATE  30MAR95              */
/*                      S01522            DATE  26JAN95              */
/*                      S01117            DATE  25JAN91              */
/*                      S01194            DATE  25JAN91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       118633 - DLTOVR to ADVGENB before calling FT0560 to prevent */
/*                CPF4173 error when calling FT0560 program.         */
/*              - Applied for MD020426.                              */
/*       AR1060743 - All HATS input initial screen appears a         */
/*                   confirmation of NWDC processing                 */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23179 - Message monitoring for invalid position option   */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       CCB009 - Journal files throughout close of business         */
/*                - Renamed journal TEMPJRN to JFTC0560.             */
/*                - Renamed journal receiver FTTEMPRCV to JFTC0560.  */
/*       177071 - Renamed hook FTC0580001 to FTC0560001              */
/*              - Renamed hook FTC0580002 to FTC0560002              */
/*       CFT006 - Funds Transfer addition of MT101 messages          */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*               S01408 - Addition of core hook FTC0560002           */
/*                        Addition of core hook FTC0560001           */
/*               102821 - Avoid looping if error on ROLLBACK         */
/*               090309 - Seton U7 and U8 once an error is detected  */
/*                        so that the program will fall over         */
/*               086139 - Prompt immediates                          */
/*               S01522 - User Defined Correspondence                */
/*               S01117 - RCF PROCESSING                             */
/*               S01194 - NEW DATABASE HANDLING                      */
/*********************************************************************/
 
/**  PGM                                                         **/ /*S01117*/
     PGM        PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
 
/**  DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                   **/ /*S01194*/
     DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                       /*S01194*/
     DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
     DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                        /*S01117*/
     DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
     DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                      /*S01117*/
     DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)                        /*S01117*/
     DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                    /*S01117*/
/****DCL***     VAR(&PHASE) TYPE(*CHAR) LEN(1)                                  */ /*S01117 CCB020*/
     DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                            /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2) VALUE('GB')     /*S01522*/
             DCL        VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10)            /*S01522*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*S01522*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                         */ /*CCB009 CCB020*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                        */ /*CCB009 CCB020*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
/*/COPY WNCPYSRC,FTC0560003                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))                             /*S01117*/
/**/                                                                 /*S01194*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                         */ /*CCB020*/
/**********               'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
             CHGVAR     VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') /*S01522*/
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*S01522*/
             OVRMSGF    MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)              /*S01522*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*S01522*/
/**/                                                                 /*S01117*/
/*   IF C.O.B JOURNAL FILES TO TEMPORARY JOURNAL                     /*S01117*/
/**/                                                                 /*S01117*/
/**********  RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&PHASE)                       */ /*S01117 CCB020*/
/**********  CALL       PGM(CBC000001) PARM(&MPHAS)                             /*CCB020 AR1060743*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                    /*AR1060743*/
/**********  IF         COND(&PHASE *EQ 'C') THEN(DO)                           */ /*S01117 CCB020*/
             IF         COND(&MPHAS *EQ '*YES') THEN(DO)                                  /*CCB020*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)               /*S01117*/
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))        /*S01117*/
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')        /*S01117*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/FTTEMPRCV)                                /*S01117*/ /*CCB009*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRFTC0560)                                 */ /*CCB009 CCB020*/
/**********  CRTJRN     JRN(&JLIB/FTTEMPJRN) JRNRCV(FTTEMPRCV)                 /*S01117*/ /*CCB009*/
/**********  CRTJRN     JRN(&JLIB/JFTC0560) JRNRCV(JRFTC0560)                   */ /*CCB009 CCB020*/
 /********** STRJRNPF   FILE(CQCODDD CQCOCDD CQPADDD CQPACDD INPAYDD +                    /*CFT006*/
 /***********             OTPAYDD) JRN(FTTEMPJRN) IMAGES(*BOTH) +                         /*CFT006*/
 /**********              OMTJRNE(*OPNCLO)                                     /*S01117*/ /*CFT006*/
/**********  STRJRNPF   FILE(CQCODDD CQCOCDD CQPADDD CQPACDD INPAYDD +
/**********               OTPAYDD FT101HPD FT102HPD) JRN(FTTEMPJRN) +
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                       /*CFT006*/ /*CCB009*/
/**********  STRJRNPF   FILE(CQCODDD CQCOCDD CQPADDD CQPACDD INPAYDD +                 */ /*CCB020*/
/**********               OTPAYDD FT101HPD FT102HPD) JRN(JFTC0560) +                   */ /*CCB020*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                        */ /*CCB009 CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
             ENDDO                                                   /*S01117*/
 /**/
/**/                                                                 /*S01194*/
     CHGJOB     SWS(XXXXXX00)
/**/                                                                 /*S01117*/
/** set up override **/                                              /*S01117*/
/**/                                                                 /*S01117*/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(ADVGENB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(ADVGENB) OPTION(*INP)
/**********  MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(ADVGENB) + */                   /*BUG23179*/
/**********               POSITION(*END))                          */                   /*BUG23179*/
                                                                                        /*BUG23179*/
             MONMSG     MSGID(CPF4125 CPF4137) EXEC(OVRDBF +
                          FILE(ADVGENB) POSITION(*END))                                 /*BUG23179*/
                                                                                        /*BUG23179*/
             ENDDO
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) + */                /*CPK009*/ /*CPK016*/
/**********               CMTSCOPE(*JOB)                     */                /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                           */ /*S01522 CCB020*/
             IF         COND(&MPHAS *EQ '*NO') THEN(DO)                                   /*CCB020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
             ROLLBACK                                                 /*S01522*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*S01522*/
/*********** GOTO       CMDLBL(END)                         */ /*S01522 090309*/
             GOTO       CMDLBL(ERROR)                                 /*090309*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
/*       Check User Defined Correspondence is installed */            /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CG4620) PARM(&W0RTN &W0CMT)               /*S01522*/
                                                                      /*S01522*/
             RCLRSC                                                   /*S01522*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             SNDPGMMSG  MSG('User Defined Correspondence Extract +
                          failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ) MSGTYPE(*INFO) /*S01552*/
             ROLLBACK                                                 /*S01522*/
/*********** GOTO       CMDLBL(END)                         */ /*S01522 090309*/
             GOTO       CMDLBL(ERROR)                                 /*090309*/
             ENDDO                                                    /*S01522*/
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                             /*CCG015*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
                GOTO       CMDLBL(ERROR)                                                  /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                                                                                          /*CCG015*/
             ENDDO                                                    /*S01522*/
             ENDDO                                                    /*S01522*/
/**/                                                                                      /*118633*/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)                   /*118633*/
                DLTOVR     FILE(ADVGENB)                                                  /*118633*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 /*118633*/
             ENDDO                                                                        /*118633*/
/**/                                                                                      /*118633*/
/**/                                                                 /*S01117*/
/**/
/** call program & monitor for untrapped errors **/
/**/
/**  CALL       PGM(FT0560)                                      **/ /*S01117*/
/**/                                                                  /*S01408*/
/*/C*PY*WNCPYSRC,FTC0580001******************************* /*S01408*/ /*177071*/
/*/COPY WNCPYSRC,FTC0560001                                           /*177071*/
/**/                                                                  /*S01408*/
     CALL       PGM(FT0560) PARM('B' &RSEQ &RLEV &RENT)              /*S01117*/
/**/                                                                  /*S01408*/
/*/C*PY*WNCPYSRC,FTC0580002******************************* /*S01408*/ /*177071*/
/*/COPY WNCPYSRC,FTC0560002                                           /*177071*/
/**/                                                                  /*S01408*/
     MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG  MSG('Update failed, advices +
                           not produced.') TOPGMQ(*EXT)
/***********    GOTO END                                           */ /*090309*/
                GOTO ERROR                                            /*090309*/
     ENDDO
/*/COPY WNCPYSRC,FTC0560004                                          */
/**/
/** check for database errors trapped by program **/
/**/
     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
/**             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)    **/ /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)        /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT)  TOMSGQ(MOPERQ)
     ENDDO
/*  */                                                                /*086139*/
/*  If phase A and UDC then prompt */                                 /*086139*/
/*  */                                                                /*086139*/
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                           */ /*086139 CCB020*/
             IF         COND(&MPHAS *EQ '*NO') THEN(DO)                                   /*CCB020*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*086139*/
                                                                      /*086139*/
/* Prompt for immediate print */                                      /*086139*/
             CALL       PGM(CGC5217) PARM(' ')                        /*086139*/
             MONMSG     MSGID(CPF0000)                                /*086139*/
             ENDDO                                                    /*086139*/
             ENDDO                                                    /*086139*/
                                                                      /*086139*/
             GOTO       CMDLBL(END)                                   /*S01117*/
/**/
/**********ERROR:      ROLLBACK                                      */                   /*CCG015*/
 ERROR:                                                                                   /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
             ROLLBACK                                                                     /*CCG015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*102821*/
             CHGJOB     SWS(XXXXXX11)                                 /*090309*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01117*/
             SNDPGMMSG  MSG('DEBIT/CREDIT ADVICES PROGRAM TERMINATED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01117*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01117*/
 
/**END:         ENDPGM                                          **/   /*S01117*/
 END:
/**/                                                                 /*S01117*/
/** delete overrides **/                                             /*S01117*/
/**/                                                                 /*S01117*/
/**********  DLTOVR     FILE(ADVGENB) */                                                  /*118633*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                             /*S01117 118633*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01117*/
/**/                                                                 /*S01117*/
/*   IF C.O.B                                                        /*S01117*/
/**/                                                                 /*S01117*/
/**********  IF         COND(&PHASE *EQ 'C') THEN(DO)                           */ /*S01117 CCB020*/
             IF         COND(&MPHAS *EQ '*YES') THEN(DO)                                  /*CCB020*/
             CLOF       OPNID(ADVGENB)                               /*S01117*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*S01117*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                         */ /*S01117 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                          */ /*S01117 CCB020*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/FTTEMPJRN)                        /*S01117*/ /*CCB009*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/JFTC0560)                          */ /*CCB009 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                          */ /*S01117 CCB020*/
/**********  DLTJRN     JRN(&JLIB/FTTEMPJRN)                                   /*S01117*/ /*CCB009*/
/**********  DLTJRN     JRN(&JLIB/JFTC0560)                                     */ /*CCB009 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                          */ /*S01117 CCB020*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/FTTEMPRCV) */                             /*S01117*/ /*CCB009*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRFTC0560)                                 */ /*CCB009 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                          */ /*S01117 CCB020*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                         */ /*S01117 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                          */ /*S01117 CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
             ENDDO                                                   /*S01117*/
/**/                                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01117*/
/**/
        ENDPGM                                                       /*S01117*/
