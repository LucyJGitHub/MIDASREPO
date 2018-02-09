/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FD Control component for audit reports')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       FDC0050 - CONTROLLING COMPONENT FOR AUDIT REPORTS           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/*                      AR853795A          Date 25Oct11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7286            Date 23May05              */
/*                      BUG8891            Date 12Oct05              */
/*                      CSC020             Date 31Mar04              */
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      204748             Date 22Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      089132             DATE 06JUN95              */
/*                      S01408             DATE 04MAY95              */
/*                      070107             DATE 06SEP94              */
/*                      057770             DATE 14FEB94              */
/*                      S01319             DATE 03JAN92              */
/*                      S01319             DATE 05NOV91              */
/*                      S01319             DATE 24SEP91              */
/*                      RT0143             DATE 03JUN91              */
/*                      S01328             DATE 14FEB91              */
/*                      E17362             DATE 09JAN90              */
/*                      E17119             DATE 22FEB89              */
/*                      E16037             DATE 09JAN89              */
/*                      E14443             DATE 02NOV88              */
/*                      S01179             DATE 21OCT88              */
/*                      E13290             DATE 13MAY88              */
/*                      E12943             DATE 27APR88              */
/*                      AB0176             DATE 20APR88              */
/*                      S01145             DATE 18MAR88              */
/*                      E11112             DATE 07MAR88              */
/*                      S01136             DATE 28NOV87              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       AR853795A - FDC0050 has a dump but completed normally       */
/*                  (Child: AR853796)                                */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       BUG8891 - M+ ref DL1956 & DL1950 Single IRS & FRA           */
/*                 revaluation reports can not be found in           */
/*                 intellistor or AS400 during COB                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       204748 - Restrict range of journal receivers used in DSPJRN */
/*                commands. Only need receivers used in input cycle. */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       089132 - FD0570 Gets called if BGFIIN is set on (FRA/IRS)   */
/*                but the work file it uses only gets cleared if     */
/*                Treasury management is on.                         */
/*                Work file was never cleared and report was getting */
/*                bigger and bigger.                                 */
/*       S01408 - Addition of core hook FDC0050MPS                   */
/*       070107 - Additional monitor message required for V2.3 and   */
/*                above of OS400 (CRTJRN command).                   */
/*       057770 - Pgm terminated when trying to end journalling      */
/*                on completion. Pgm should try a number of times    */
/*                before failing. TABLETX may be being updated       */
/*                by one of a number of retail COB components but    */
/*                this should not cause FDC0050 to terminate.        */
/*       S01319 - (HY0033) Remove DRS reference from message.        */
/*       S01319 - Program attempts to DSPJRN of TM files.  If TM     */
/*       (HY0007) is not on the files will not have been jounalled   */
/*                and the program will fall over.                    */
/*       S01319 - Remove redundant processing                        */
/*       RT0143 - OVERRIDE FDAUDARR BEFORE CALLING FD0570 TO         */
/*                AVOID CHAINING PROBLEMS TO FCRSFXPD.               */
/*       S01328 - FRA/IRS REVALUATION - CALL THE FRA AUDIT REPORT    */
/*                PROGRAM AND THE IRS AUDIT REPORT PROGRAM.          */
/*       E17362 - MONMSG INSERTED TO PREVENT CL PROGRAM TERMIATE     */
/*                WHEN JRN(JFDC0050) ALREADY EXIST.                  */
/*       E17119 - REMOVE CALL TO FD0410 (COLOURS AUDIT REPORT)       */
/*       E16037 - RECREATE JRNWORK FILE ONLY ONCE & REMOVE CALL      */
/*                TO FD0370                                          */
/*       E14443 - MONMSG INSERTED TO PREVENT LOOPING ON ERRORS       */
/*       E13290 - RECEIVER INSERTED TO PREVENT LOOPING ON ERRORS     */
/*       E12943 - JOURNAL & JOURNAL RECEIVER CREATED IN XXJLIB       */
/*       AB0176 - ABTTOTPP NO JOURNALED                              */
/*       S01145 - ARBITRAGE                                          */
/*       E11112 - USE COMMITMENT CONTROL TO RESTORE FILES IN CASE    */
/*                OF DATABASE ERRORS                                 */
/*       S01136 - MM INCORPORATION. FD0570 SHOULD ONLY BE CALLED     */
/*                IF MM IS IN THE SYSTEM                             */
/*                                                                   */
/*********************************************************************/
             PGM
/**          PGM        PARM(&JRN &JRNLIB &FROMVL2)                 */
/**                                                                **/
/**   MIDAS Close of Business is assumed to require the            **/
/**   following parameter values which are therefore hard-coded    **/
/**       -- Journal Name -- ICJRN                                 **/
/**       -- Journal Name -- xxJLIB                                **/
/**       -- Starting Sequence Number -- *FIRST                    **/
/**                                                                **/
             DCL        VAR(&JRN)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JRNLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMVL2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FROMVAL) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&WWDBFILE) TYPE(*CHAR)     LEN(8)*/       /*S01319*/
/************DCL        VAR(&WWDBPGM) TYPE(*CHAR) LEN(10) +  ***/     /*S01319*/
/************************ VALUE(FDC0050)                      */      /*S01319*/
/************DCL        VAR(&WWDBM2)   TYPE(*CHAR)     LEN(21)*****/  /*S01319*/
/************DCL        VAR(&WWDBASE)  TYPE(*CHAR)     LEN(3) *****/  /*S01319*/
/**/
/************DCLDTAARA  DTAARA(MMOD)                                 */
/************DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01319*/
/**/                                                                  /*S01328*/
             DCL        VAR(&FI) TYPE(*CHAR) LEN(1)                   /*S01328*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1) VALUE(0)       /*057770*/
             DCL        VAR(&STRRCV) TYPE(*CHAR) LEN(10)                                 /*BUG7286*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                 /*CSC020*/
             DCL        VAR(&ENDSEQ) TYPE(*DEC) LEN(10 0)                                 /*CSC020*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&ENDICRCV) TYPE(*CHAR) LEN(10)                                /*204748*/
             DCL        VAR(&ENDN) TYPE(*DEC) LEN(3 0)                                    /*204748*/
/*/COPY WNCPYSRC,FDC0050001                                          */
             DCLF       FILE(SDMMODPD)                                /*S01328*/
/**/
/**          PROGRAM LEVEL MONMSG                                    */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000  +
                        CPA0000)  EXEC(GOTO CMDLBL(TAG950))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
 
 /***********RCVDTAARA  DTAARA(MMOD)                                */
/************RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)               /*S01319*/
 
/************MONITOR FOR DATA AREA MISSING                            /*S01319*/
/************DBASE REFERENCE POINT 002                                /*S01319*/
 
                                                                      /*S01319*/
/************MONMSG     MSGID(CPF0880) EXEC(DO)                       /*S01319*/
/***************CHGVAR     VAR(&WWDBFILE) VALUE('MMOD')               /*S01319*/
/***************CHGVAR     VAR(&WWDBASE)  VALUE('002')                /*S01319*/
/***************CHGVAR     VAR(&WWDBM2)   VALUE(&WWDBPGM +
                                           *CAT &WWDBFILE +
                                           *CAT &WWDBASE)             /*S01319*/
/***************SNDPGMMSG  MSGID(DBM0002) MSGF(DRSMM) MSGDTA(&WWDBM2) +
                           TOMSGQ(MOPERQ)                             /*S01319*/
/***************   GOTO       CMDLBL(TAG900)                          /*S01319*/
/***************ENDDO                                                 /*S01319*/
/*/COPY WNCPYSRC,FDC0050002                                          */
/**/
/*     Set up operational values for the suppressed parameters      */
/**/
             CHGVAR     VAR(&FROMVL2) VALUE('00001')
             CHGVAR     VAR(&FROMVAL) VALUE(&FROMVL2)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
             CHGVAR     VAR(&JRNLIB ) VALUE(&LIBID *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FDC0050MPS                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&JRN    ) VALUE('ICJRN')
/**/                                                                  /*S01319*/
/*     Receive SDMMODPD for module flags.                             /*S01319*/
/**/                                                                  /*S01319*/
             RCVF                                                     /*S01319*/
/**/
/*     Clear the work files, one for each audit report              */
/**/
/************CLRPFM     FILE(FDAUDAPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDBPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDCPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDDPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDEPP)                                /*S01319*/
             CLRPFM     FILE(FDAUDFPP)
/************CLRPFM     FILE(FDAUDGPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDHPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDIPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDJPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDKPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDLPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDMPP)                                /*S01319*/
/************CLRPFM     FILE(FDAUDNPP)                            */  /*S01328*/
/************CLRPFM     FILE(FDAUDOPP)                            */  /*S01328*/
             CLRPFM     FILE(FDAUDNPP)                                                   /*BUG8891*/
             CLRPFM     FILE(FDAUDOPD)                                                   /*BUG8891*/
             CLRPFM     FILE(FXAUDCPP)                                /*S01319*/
             CLRPFM     FILE(FXAUDEPP)                                /*S01319*/
             CLRPFM     FILE(MMAUDCPP)                                /*S01319*/
             CLRPFM     FILE(MMAUDEPP)                                /*S01319*/
/**/
/******If*FX*present clear the work files                             /*S01319*/
/**/
/************IF         COND(%SUBSTRING(&MMOD 13 1) ='Y')  THEN(DO)   /*S01319*/
/**/
/************      CLRPFM     FILE(FXAUDAPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDBPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDCPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDBPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDDPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDEPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDFPP)                          /*S01319*/
/************      CLRPFM     FILE(FXAUDGPP)                          /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/******If*MM*present clear the work files                             /*S01319*/
 
/************IF         COND(%SUBSTRING(&MMOD 14 1) ='Y')  THEN(DO)   /*S01319*/
 
/************      CLRPFM     FILE(MMAUDAPP)                          /*S01319*/
/************      CLRPFM     FILE(MMAUDBPP)                          /*S01319*/
/************      CLRPFM     FILE(MMAUDCPP)                          /*S01319*/
/************      CLRPFM     FILE(MMAUDDPP)                          /*S01319*/
/************      CLRPFM     FILE(MMAUDEPP)                          /*S01319*/
/************      CLRPFM     FILE(MMAUDFPP)                          /*S01319*/
/************      CLRPFM     FILE(MMAUDGPP)                          /*S01319*/
/************ENDDO                                                    /*S01319*/
                                                                      /*S01145*/
/******If*AB*present clear the work files                             /*S01319*/
 
/************IF         COND(%SUBSTRING(&MMOD 19 1) = 'Y') THEN(DO)   /*S01319*/
 
/************      CLRPFM     FILE(ABAUDCPP)                          /*S01319*/
/************      CLRPFM     FILE(ABAUDDPP)                          /*S01319*/
/************      CLRPFM     FILE(ABAUDEPP)                          /*S01319*/
/************ENDDO                                                    /*S01319*/
                                                                      /*S01145*/
/*     If TM present clear the work files                             /*S01319*/
 
             IF         COND(&BGTRMG *EQ 'Y') THEN(DO)                /*S01319*/
 
                   CLRPFM     FILE(MMAUDAPP)                          /*S01319*/
                   CLRPFM     FILE(FXAUDAPP)                          /*S01319*/
                   CLRPFM     FILE(FDAUDEPP)                          /*S01319*/
/******************CLRPFM     FILE(FDAUDLPP)                   /*S01319 089132*/
 
             ENDDO                                                    /*S01319*/
                                                                      /*089132*/
             IF   ((&BGTRMG *EQ 'Y') *OR +
                   (&BGFIIN *EQ 'Y')) THEN(DO)                        /*089132*/
                   CLRPFM     FILE(FDAUDLPP)                          /*089132*/
                   ENDDO                                              /*089132*/
 
/*  Only recreate journal work file if it does not exist            *  *E16037*/
             CHKOBJ     OBJ(&JRNLIB/JRNWORK) OBJTYPE(*FILE)           /*E16037*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                       /*E16037*/
 
 
/*  Must create JRNWORK b'cos cmd creates it with MAXRCD(10000)     */
/*  All this code is to create a file with correct format using     */
/*  no src b'cos of *libl problem                                   */
/*/COPY WNCPYSRC,FDC0050003                                          */
/*           DSPJRN     JRN(&JRN.&JRNLIB) FILE((TABTB10)) +         *  *E13290*/
/*                        RCVRNG(ICRCV001 *CURRENT) PGM(FRIGFIX) +  *  *E13290*/
/*                        ENTDTALEN(200) OUTPUT(*NONE) +            *  *E13290*/
/*                        OUTFILE(JRNWORK.QTEMP)                    *  *E13290*/
/*********** DSPJRN     JRN(&JRNLIB/&JRN) FILE((TABTB10)) +
                          RCVRNG(ICRCV001 ICRCV001) PGM(FRIGFIX) +
                          ENTDTALEN(200) OUTPUT(*OUTFILE) +
                          OUTFILE(&JRNLIB/JRNWORK) *********************E16037**************CSC020*/
/*************************OUTFILE(QTEMP/JRNWORK)              *S01179* *E16037*/
/*                                                                                          CSC020*/
/*  Determine journal sequence number of next day set up.                                   CSC020*/
/*  (Equivalent to beginning of ICRCV001 in previous releases)                              CSC020*/
/*                                                                                          CSC020*/
/**********  SCRTVJEVT  EVENT(NDSUJR) SEQ(&STRSEQ)                                 *CSC020*BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                                    /*AR853795A*/
/*                                                                                          CSC020*/
/*  If no value returned, then set sequence to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRSEQ *EQ 0) THEN(DO)                                      /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNSEQNBR(&STRSEQ)                                              /*CSC020*/
             ENDDO                                                                        /*CSC020*/
             DSPJRN     JRN(&JRNLIB/&JRN) FILE((TABTB10)) +
                          RCVRNG(*CURCHAIN) FROMENT(&STRSEQ) +
                          TOENT(&STRSEQ) PGM(FRIGFIX) +
                          OUTPUT(*OUTFILE) OUTFILE(&JRNLIB/JRNWORK) +
                          ENTDTALEN(200)                                                  /*CSC020*/
             MONMSG CPF7062
/*/COPY WNCPYSRC,FDC0050004                                          */
/*           CLRPFM     FILE(JRNWORK.QTEMP)         S01179*/
/************CLRPFM     FILE(QTEMP/JRNWORK)  *S01179*                  *E16037*/
             CLRPFM     FILE(&JRNLIB/JRNWORK)                         /*E16037*/
/*           CHGPF      FILE(JRNWORK.QTEMP) SIZE(*NOMAX)   *S01179*/
/************CHGPF      FILE(QTEMP/JRNWORK) SIZE(*NOMAX)  *S01179*    /*E16037*/
             CHGPF      FILE(&JRNLIB/JRNWORK) SIZE(*NOMAX)            /*E16037*/
 
/************DSPJRN     JRN(&JRNLIB/&JRN) RCVRNG(ICRCV001 *CURRENT) +
                          ENTTYP(BR UR UB UP PT DR DL) ENTDTALEN(200) +
                     OUTPUT(*OUTFILE) OUTFILE(&JRNLIB/JRNWORK)*E16037* *S01319*/
/*                    OUTPUT(*OUTFILE) OUTFILE(QTEMP/JRNWORK) *S01179* *E16037*/
 
/************DSPJRN*****JRN(&JRNLIB/&JRN) FILE((FXCDAFPP) (FXMCOMPP) +
                          (MMCDAFPP) (MMMCOMPP) (FXDOLMPP) +
                          (MMLMCYPP) (FDCCYPPP) (FDINTRPP) +
                          (FDLCCYPP)) RCVRNG(ICRCV001 *CURRENT) +
                          ENTTYP(BR UR UB UP PT DR DL) ENTDTALEN(200) +
                          OUTPUT(*OUTFILE) OUTFILE(&JRNLIB/JRNWORK) +
                                                           /*S01319*/ /*S01319*/
 
/*/COPY WNCPYSRC,FDC0050005                                          */
/********    DSPJRN     JRN(&JRNLIB/&JRN) FILE((FXCDAFPP) (FXMCOMPP) +
                          (MMCDAFPP) (MMMCOMPP) (FDINTRPP) +
                          (FDLCCYPP)) RCVRNG(ICRCV001 *CURRENT) +
                          ENTTYP(BR UR UB UP PT DR DL) +
                          ENTDTALEN(200) OUTPUT(*OUTFILE) +
                          OUTFILE(&JRNLIB/JRNWORK)************ /*S01319                   /*204748*/
/*                                                                  */                    /*204748*/
/*  Calculate last receiver saved at input cycle termination.       */                    /*204748*/
/*  Positions 11 to 20 of JNSTAT contain next receiver to be saved. */                    /*204748*/
/*  Subtract 1 from the receiver number to get the last one saved.  */                    /*204748*/
/*                                                                  */                    /*204748*/
/*********** RTVDTAARA  DTAARA(JNSTAT (11 10)) RTNVAR(&ENDICRCV) *****************204748****CSC020*/
/*********** CHGVAR     VAR(&ENDN) VALUE(%SST(&ENDICRCV 6 3)) ********************204748****CSC020*/
/*********** CHGVAR     VAR(&ENDN) VALUE(&ENDN - 1) ******************************204748****CSC020*/
/*********** CHGVAR     VAR(%SST(&ENDICRCV 6 3)) VALUE(&ENDN) ********************204748****CSC020*/
/*                                                                  */                    /*204748*/
/*  Display only journal entries created duing input cycle.         */                    /*204748*/
/*                                                                  */                    /*204748*/
/************DSPJRN     JRN(&JRNLIB/&JRN) FILE((FXCDAFPP) (FXMCOMPP) +
                          (MMCDAFPP) (MMMCOMPP) (FDINTRPP) +
                          (FDLCCYPP)) RCVRNG(ICRCV001 &ENDICRCV) +
                          ENTTYP(BR UR UB UP PT DR DL) +
                          OUTPUT(*OUTFILE) OUTFILE(&JRNLIB/JRNWORK) +
                          ENTDTALEN(200) ********************************************204748*CSC020*/
/*                                                                                          CSC020*/
/*  Determine journal sequence number of end of input cycle.                                CSC020*/
/*  (When MPHAS was changed to 'B')                                                         CSC020*/
/*                                                                                          CSC020*/
/**********  SCRTVJEVT  EVENT(MPHAS) FLAG(B) SEQ(&ENDSEQ)                         *CSC020**BUG7286*/
/**********  SCRTVJEVT  EVENT(MPHAS) FLAG(B) RECEIVER(&STRRCV) +                       */ /*CCB020*/
/**********               SEQ(&ENDSEQ)                                         */ /*BUG7286 CCB020*/
             SCRTVJEVT  EVENT(MPHAS) FLAG(C) RECEIVER(&STRRCV) +
                          SEQ(&ENDSEQ)                                                    /*CCB020*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                                    /*AR853795A*/
             DSPJRN     JRN(&JRNLIB/&JRN) FILE((FXCDAFPP) (FXMCOMPP) +
                          (MMCDAFPP) (MMMCOMPP) (FDINTRPP) +
                          (FDLCCYPP)) RCVRNG(*CURCHAIN) +
                          FROMENT(&STRSEQ) TOENT(&ENDSEQ) ENTTYP(BR +
                          UR UB UP PT DR DL) OUTPUT(*OUTFILE) +
                          OUTFILE(&JRNLIB/JRNWORK) ENTDTALEN(200)                         /*CSC020*/
 
             MONMSG CPF7062     /*   No journal entries to convert  */
             DSPJRN     JRN(&JRNLIB/&JRN) FILE((DLFRARPP) +
                          (DLSWPRPD)) RCVRNG(*CURCHAIN) ENTTYP(BR +
                          UR UB UP PT DR DL) OUTPUT(*OUTFILE) +
                          OUTFILE(&JRNLIB/JRNWORK) OUTMBR(*FIRST +
                          *ADD) ENTDTALEN(200) FROMENT(&STRSEQ) +
                          TOENT(&ENDSEQ)                                                 /*BUG8891*/
             MONMSG CPF7062     /*   No journal entries to convert */                    /*BUG8891*/
/*/COPY WNCPYSRC,FDC0050006                                          */
 
             IF         COND(&BGTRMG *EQ 'Y') THEN(DO)                /*S01319*/
 
/*/COPY WNCPYSRC,FDC0050007                                          */
/*********** DSPJRN     JRN(&JRNLIB/&JRN) FILE((FXDOLMPP) (MMLMCYPP) + */      /*S01319*/ /*204748*/
/***********              (FDCCYPPP)) RCVRNG(ICRCV001 *CURRENT) +      */      /*S01319*/ /*204748*/
/***********              ENTTYP(BR UR UB UP PT DR DL) +               */      /*S01319*/ /*204748*/
/***********              ENTDTALEN(200) OUTPUT(*OUTFILE) +            */      /*S01319*/ /*204748*/
/***********              OUTFILE(&JRNLIB/JRNWORK) OUTMBR(*FIRST +     */      /*S01319*/ /*204748*/
/***********              *ADD)                                        */      /*S01319*/ /*204748*/
/*                                                                                        /*204748*/
/*  Display only journal entries created during input cycle.                              /*204748*/
/*                                                                                        /*204748*/
/*********** DSPJRN     JRN(&JRNLIB/&JRN) FILE((FXDOLMPP) (MMLMCYPP) +
                          (FDCCYPPP)) RCVRNG(ICRCV001 &ENDICRCV) +
                          ENTTYP(BR UR UB UP PT DR DL) +
                          OUTPUT(*OUTFILE) OUTFILE(&JRNLIB/JRNWORK) +
                          OUTMBR(*FIRST *ADD) ENTDTALEN(200) ***********************204748**CSC020*/
             DSPJRN     JRN(&JRNLIB/&JRN) FILE((FXDOLMPP) (MMLMCYPP) +
                          (FDCCYPPP)) RCVRNG(*CURCHAIN) +
                          FROMENT(&STRSEQ) TOENT(&ENDSEQ) ENTTYP(BR +
                          UR UB UP PT DR DL) OUTPUT(*OUTFILE) +
                          OUTFILE(&JRNLIB/JRNWORK) OUTMBR(*FIRST +
                          *ADD) ENTDTALEN(200)                                            /*CSC020*/
             MONMSG CPF7062     /*   No journal entries to convert */ /*S01319*/
/*/COPY WNCPYSRC,FDC0050008                                          */
             ENDDO                                                    /*S01319*/
 
             ENDDO                                                    /*E16037*/
/**/                                                                  /*E16037*/
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/*  Create a journal receiver and journal should errors occur in    *  *E11112*/
/*  programs called affecting PF/TABLETX.                           *  *E11112*/
/*/COPY WNCPYSRC,FDC0050009                                          */
/************CRTJRNRCV  JRNRCV(JRFDC0050)                 *  *E11112*  *E12943*/
/*           CRTJRNRCV  JRNRCV(JRFDC0050.&JRNLIB)           /*E12943*  *S01179*/
             CRTJRNRCV  JRNRCV(&JRNLIB/JRFDC0050)          /*E12943*   *S01179*/
             MONMSG CPF7010                                           /*E11112*/
/************CRTJRN     JRN(JFDC0050) JRNRCV(JRFDC0050)               /*E12943*/
/*           CRTJRN    JRN(JFDC0050.&JRNLIB) JRNRCV(JRFDC0050)  *E12943*S01179*/
             CRTJRN     JRN(&JRNLIB/JFDC0050) JRNRCV(JRFDC0050) +
                          /*E12943*S01179*/
             MONMSG CPF7010                                           /*E17362*/
             MONMSG CPF7015                                           /*070107*/
 
/* FIX AB0176  */
/*           JRNPF      FILE(TABLETX MMTTOTPP FXTTOTPP) JRN(JFDC0050) + */
/*                        IMAGES(*BOTH)          */                   /*E11112*/
/*           JRNPF      FILE(TABLETX MMTTOTPP FXTTOTPP ABTTOTPP )  +
                          JRN(JFDC0050) IMAGES(*BOTH)   *    *AB0176*  *S01179*/
/************STRJRNPF   FILE(TABLETX MMTTOTPP FXTTOTPP ABTTOTPP) +
                          JRN(JFDC0050) IMAGES(*BOTH)           S01179  S01319*/
             STRJRNPF   FILE(TABLETX MMTTOTPP FXTTOTPP) +
                          JRN(JFDC0050) IMAGES(*BOTH)                 /*S01319*/
             MONMSG CPF7030                                           /*E17362*/
/*/COPY WNCPYSRC,FDC0050010                                          */
             ENDDO                                                    /*CCB009*/
/*           BGNCMTCTL *CHG    S01179*/
/**********  STRCMTCTL *CHG                                    /*S01179 CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
/* END FIX AB0176  */
             MONMSG CPF8351                                           /*S01319*/
 
             CALL       PGM(FD0510)           /* Split the journal  */
/**/
/*     Run the audit reports - If U7 is on a database error has     */
/*             occurred - bypass further audit program calls.       */
/*                                                                  */
/*     If U8 is on by itself, the files are out of balance          */
/*                      - bypass further audit program calls.       */
/**/
/******Run*the*User*Security*Information*Audit*Report.               /*S01319*/
/**/                                                                 /*S01319*/
/************CALL       PGM(FD0350)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/******Run*the Nostro Numbers Audit Report.                          /*S01319*/
/**/
/************CALL       PGM(FD0360)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/******Run*the*Customer*Currency*Defaults*Audit*Report.             *  *E16037*/
/**/
/************CALL       PGM(FD0370)                                    *E16037*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +*E16037*/
/*************************THEN(GOTO CMDLBL(TAG900))                    *E16037*/
/**/
/******Run*the*Exchange*Rates*Audit*Report.                          /*S01319*/
/**/
/************CALL       PGM(FD0380)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/*     Run the Location/Currency Audit Report.                     */
/**/
             CALL       PGM(FD0390)
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))
/**/
/******Run*the*Branch*Codes*Audit*Report.                            /*S01319*/
/**/
/************CALL       PGM(FD0400)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/******Run*the*Default*Colours*Audit*Report.************************/ /*E17119*/
/**/                                                                  /*E17119*/
/************CALL       PGM(FD0410)                                   /*E17119*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
/*************************THEN(GOTO CMDLBL(TAG900))*/                 /*E17119*/
/*                                                                 */ /*E17119*/
/**/
/******Run*the*Counterparty*Nostros*Audit*Report.                     /*S01319*/
/**/
/************CALL       PGM(FD0420)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*Currency*Details*Audit*Report.                        /*S01319*/
/**/
/************CALL       PGM(FD0460)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*Base*Rates*Audit*Report                               /*S01319*/
 
/************CALL       PGM(FD0540)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*MM*Interest*rates*Audit*Report*if*MM*module*present  */
 
/********IF      COND(%SUBSTRING(&MMOD 14 1) ='Y') THEN(DO) /*S01136*  *S01319*/
/************OVRDBF     FILE(FDAUDARR) TOFILE(FD0570AU)     /*RT0143*  *S01319*/
/************CALL       PGM(FD0570)                                   /*S01319*/
/************DLTOVR     FILE(FDAUDARR)                      /*RT0143*  *S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                   /*S01319*/
/************ENDDO                                          /*S01136* /*S01319*/
/* */                                                                 /*S01328*/
/* READ SDMMODPD FOR FRA/IRS IND. IF ON PROCESS FRA/IRS JRN ENTRIES,    S01328*/
/* BY CALLING DL1933 WITH PARM 'F' FOR FRA AND THEN 'I' FOR IRS         S01328*/
/* */                                                                 /*S01328*/
/********RCVF************************************************S01328*/ /*S01319*/
/* */                                                                 /*S01328*/
             IF         COND(&BGFIIN *EQ 'Y') THEN(DO)                /*S01328*/
/* */                                                                 /*S01328*/
             OVRDBF     FILE(DLFIRSLL) TOFILE(DLFRARL3)               /*S01328*/
             OVRDBF     FILE(FDAUFILL) TOFILE(FDAUDNLL)               /*S01328*/
             CHGVAR     VAR(&FI) VALUE('F')                           /*S01328*/
/* */                                                                 /*S01328*/
             CALL       PGM(DL1933) PARM(&FI)                         /*S01328*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                   /*S01328*/
/* */                                                                 /*S01328*/
             DLTOVR     FILE(DLFIRSLL)                                /*S01328*/
             DLTOVR     FILE(FDAUFILL)                                /*S01328*/
/* */                                                                 /*S01328*/
/**********  OVRDBF     FILE(DLFIRSLL) TOFILE(DLIRSRL3) */                    /*S01328*/ /*BUG8891*/
/**********  OVRDBF     FILE(FDAUFILL) TOFILE(FDAUDOLL) */                    /*S01328*/ /*BUG8891*/
             OVRDBF     FILE(FDAUFILL) TOFILE(FDAUDOL1)                                  /*BUG8891*/
/**********  CHGVAR     VAR(&FI) VALUE('I') */                                /*S01328*/ /*BUG8891*/
/* */                                                                 /*S01328*/
/**********  CALL       PGM(DL1933) PARM(&FI) */                              /*S01328*/ /*BUG8891*/
             CALL       PGM(DL1933B)                                                     /*BUG8891*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                   /*S01328*/
/* */                                                                 /*S01328*/
/**********  DLTOVR     FILE(DLFIRSLL) */                                     /*S01328*/ /*BUG8891*/
             DLTOVR     FILE(FDAUFILL)                                /*S01328*/
/* */                                                                 /*S01328*/
         ENDDO                                                        /*S01328*/
/* */                                                                 /*S01328*/
/*                                                                  */
/******Run*FX*audit*reports*if*FX*module*is*present                   /*S01319*/
/**/
/********IF         COND(%SUBSTRING(&MMOD 13 1) ='Y')  THEN(DO)       /*S01319*/
/**/
/******Run*the*Daylight*&*Overnight*Currency*Limits*Audit*Report      /*S01319*/
/**/
/************CALL       PGM(FX0210)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/******Run*the*System*Status*Information*Audit*Report.               /*S01319*/
/**/
/************CALL       PGM(FX0220)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/*     Run the Complete Deal Amendable Fields Audit Report.         */
/**/
             CALL       PGM(FX0230)
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))
/**/
/******Run*the*Deal*Defaults*By*Dealer*Audit*Report.                 /*S01319*/
/**/
/************CALL       PGM(FX0240)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/*     Run the Mandatory Fields For Complete Deals Audit Report.   */
/**/
             CALL       PGM(FX0250)
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))
/**/
/******Run*the*User*Type*Definition*Data*Audit*Report.               /*S01319*/
/**/
/************CALL       PGM(FX0260)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/******Run*the*User*Type*Authority*Information*Audit*Report.         /*S01319*/
/**/
/************CALL       PGM(FX0270)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
/**/
/********ENDDO                                                       /*S01319*/
/*                                                                  */
 
/******Run*MM*audit*reports*if*MM*module*is*present                   /*S01319*/
 
/********IF         COND(%SUBSTRING(&MMOD 14 1) ='Y')  THEN(DO)       /*S01319*/
 
/******Run*the*Daylight*&*Overnight*Currency*Limits*Audit*Report      /*S01319*/
 
/************CALL       PGM(MM0021)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*System*Status*Information*Audit*Report.               /*S01319*/
 
/************CALL       PGM(MM0020)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/*     Run the Complete Deal Amendable Fields Audit Report.         */
 
             CALL       PGM(MM0019)
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))
 
/******Run*the*Deal*Defaults*By*Dealer*Audit*Report.                 /*S01319*/
 
/************CALL       PGM(MM0018)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/*     Run the Mandatory Fields For Complete Deals Audit Report.   */
 
             CALL       PGM(MM0017)
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))
 
/******Run*the*User*Type*Definition*Data*Audit*Report.               /*S01319*/
 
/************CALL       PGM(MM0016)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*User*Type*Authority*Information*Audit*Report.         /*S01319*/
 
/************CALL       PGM(MM0015)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/********ENDDO                                                       /*S01319*/
 
/*     If TM present or FRA/IRS present run the MM Interest Rates     /*S01319*/
/*     Audit Report                                                   /*S01319*/
         IF         COND((&BGTRMG *EQ 'Y') *OR +
                        (&BGFIIN *EQ 'Y')) THEN(DO)                   /*S01319*/
             CALL       PGM(FD0570)                                   /*S01319*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                   /*S01319*/
         ENDDO                                                        /*S01319*/
                                                                      /*S01319*/
/*     If TM present run TM-related audit reports.                    /*S01319*/
         IF         COND(&BGTRMG *EQ 'Y') THEN(DO)                    /*S01319*/
                                                                      /*S01319*/
/**/                                                                  /*S01319*/
/*     Run the Exchange Rates Audit Report.                        */ /*S01319*/
/**/                                                                  /*S01319*/
             CALL       PGM(FD0380)                                   /*S01319*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                   /*S01319*/
/**/                                                                  /*S01319*/
/*     Run the FX Daylight & Overnight Currency Limits Audit Report   /*S01319*/
/**/                                                                  /*S01319*/
             CALL       PGM(FX0210)                                   /*S01319*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                   /*S01319*/
/**/                                                                  /*S01319*/
/*     Run the MM Daylight & Overnight Currency Limits Audit Report   /*S01319*/
/**/                                                                  /*S01319*/
             CALL       PGM(MM0021)                                   /*S01319*/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(GOTO CMDLBL(TAG900))                   /*S01319*/
                                                                      /*S01319*/
                                                                      /*S01319*/
         ENDDO                                                        /*S01319*/
 
                                                                      /*E16037*/
/*     Delete journal work file                                      * *E16037*/
                                                                      /*E16037*/
             DLTF       FILE(&JRNLIB/JRNWORK)                         /*E16037*/
                                                                      /*E16037*/
                                                                      /*S01145*/
/******Run*AB*audit*reports*if*AB*module*is*present                   /*S01319*/
 
/********IF         COND(%SUBSTRING(&MMOD 19 1) ='Y')  THEN(DO)       /*S01319*/
 
/******Run*the*System*Status*Indicators*Audit*Report.                /*S01319*/
 
/************CALL       PGM(AB0090)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*Deal*Defaults*by*Dealer*Audit*Report.                 /*S01319*/
 
/************CALL       PGM(AB0080)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/******Run*the*User*Type*Definition*Audit*Report.                    /*S01319*/
 
/************CALL       PGM(AB0070)                                  /*S01319*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1))/+
                          THEN(GOTO CMDLBL(TAG900))                  /*S01319*/
 
/********ENDDO                                                       /*S01319*/
                                                                      /*S01145*/
 
             GOTO TAG998
TAG900:
 
/********IF         COND(%SWITCH(XXXXXX0X)) THEN(SNDMSG MSG('DRS +  */
/********             Standing Data Audit Reports out of +          */
/********             balance') TOMSGQ(MOPERQ MRUNQ))               */
/********IF         COND(%SWITCH(XXXXXX1X)) THEN(SNDMSG MSG('DRS +  */
/********             Standing Data Audit Reports -- database +     */
/********             error') TOMSGQ(MOPERQ MRUNQ))                 */
/********                                                           */
         ROLLBACK                                                     /*E11112*/
/************IF*****COND(%SWITCH(XXXXXX01)) THEN(SNDMSG MSG('DRS +*/  /*S01319*/
/*************************Audit Reports out of balance') +        */  /*S01319*/
/*************************TOMSGQ(MOPERQ MRUNQ))                   */  /*S01319*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDMSG +
                          MSG('Audit Reports out of balance') +
                          TOMSGQ(MOPERQ MRUNQ))                       /*S01319*/
         DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000) +
                          EXEC(GOTO CMDLBL(TAG999))                   /*E11112*/
 
             GOTO TAG999
TAG950:
 
                CHGDTAARA  DTAARA(*LDA (171 9)) VALUE(FDC0050)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000)
                CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000)
         DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000) +
                          EXEC(GOTO CMDLBL(TAG999))
 
TAG998:                                                               /*E11112*/
             COMMIT     CMTID(FDC0050)                                /*E11112*/
             MONMSG     MSGID(CPF8350)                                /*E13290*/
TAG999:
             ENDCMTCTL                                                /*E11112*/
             MONMSG     MSGID(CPF8350)                                /*E13290*/
/*/COPY WNCPYSRC,FDC0050011                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/************ENDJRNPF   FILE(*ALL) JRN(JFDC0050)            /*E11112*  *E12943*/
/*           ENDJRNPF   FILE(*ALL) JRN(JFDC0050.&JRNLIB)    /*E12943*   S01179*/
             ENDJRNPF   FILE(*ALL) JRN(&JRNLIB/JFDC0050) /*E12943*      S01179*/
             MONMSG     MSGID(CPF9801)                                /*E14443*/
             MONMSG     MSGID(CPF7031) EXEC(DO)                      /*057770*/
                  DLYJOB     DLY(30)                                 /*057770*/
                  CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)           /*057770*/
                  IF         COND(&COUNT *LE 5) THEN(GOTO TAG999)    /*057770*/
                  ELSE       CMD(GOTO CMDLBL(TAG950))                /*057770*/
             ENDDO                                                   /*057770*/
             CHGJOB     INQMSGRPY(*DFT)                               /*E11112*/
/************DLTJRN     JRN(JFDC0050)                       /*E11112*  *E12943*/
/*           DLTJRN     JRN(JFDC0050.&JRNLIB)               /*E12943*  *S01179*/
             DLTJRN     JRN(&JRNLIB/JFDC0050) /*E12943*  *S01179*/
             MONMSG     MSGID(CPF2105)                                /*E14443*/
/************DLTJRNRCV  JRNRCV(JRFDC0050)                   /*E11112*  *E12943*/
/*           DLTJRNRCV  JRNRCV(JRFDC0050.&JRNLIB)           /*E12943*  *S01179*/
             DLTJRNRCV  JRNRCV(&JRNLIB/JRFDC0050) /*E12943*  *S01179*/
             MONMSG     MSGID(CPF2105)                                /*E14443*/
             CHGJOB     INQMSGRPY(*RQD)                               /*E11112*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,FDC0050012                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
