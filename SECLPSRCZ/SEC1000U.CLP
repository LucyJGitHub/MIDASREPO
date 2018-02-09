/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Drop off SE files Main pgm')                 */
/*********************************************************************/
/*                                                                   */
/*      MidasPlus - Securities Module                                */
/*                                                                   */
/*      SEC1000U : DROP OFF SECURITIES TRADING FILES  MAIN PGM       */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 260765             Date 29Jun09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      095907 *C *CREATE  Date 02Dec05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       260765 - Partially applied fix 182818.                      */
/*                Removed DSPFD command and moved it to CL/SEC1004.  */
/*       095907 - NEW PROGRAM TO CONTROL SE DROP PROCESSING          */
/*                CONTROL OF JOURNALING, SECURITY COPIES OF FILES,   */
/*                DB ERRORS. IF ONE OF THE DROP PGM FAILS, THIS PGM  */
/*                WILL COPY BACK CONCERNED FILES AND WON'T CONTINUE  */
/*                THE PROCESSING AVOIDING TO HAVE DISCREPANCIES      */
/*                BETWEEN FILES, IF DROP IS NOT COMPLETED NORMALLY   */
/*                NO FILE IS DROPPED AND COB PROCESS IS NOT STOPPED  */
/*              - PROCESS DROP OF ALL RECORDS WITH RECI '*' IN TRADSD*/
/*              - IF POSITION 81 IN SESTAT IS NOT 'Y' (MEANING SE    */
/*                DROP NOT REQUESTED ) DO NOT PROCESS THIS PGM IN    */
/*                DAILY SEQUENCE (00002)                             */
/*              - APPLIED 237236, 228542 AND 227749                  */
/*       237236 - RGZPFM added for some files.                       */
/*       228542 - RGZPFM has changed at V5R3                         */
/*       227749 - ADAPT DROP PROCESSING FOR NEW FEATURES             */
/*                ADD PMC2500, SEC6440, SEC6764, SEC6768, SEC7580,   */
/*                CEU017, CSE007.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(79)
             DCL        VAR(&DMLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
 
             /* VARIABLES FOR OPTIONAL FEATURES */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                          VALUE('*FIRST')
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&S01511) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&S01513) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&S01401) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCL        VAR(&DROP) TYPE(*CHAR) LEN(1)
                                                                        /*227749*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')      /*227749*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')      /*227749*/
             DCL        VAR(&ULX004) TYPE(*CHAR) LEN(1) VALUE('N')      /*237236*/
             DCL        VAR(&ULX008) TYPE(*CHAR) LEN(1) VALUE('N')      /*237236*/
             DCL        VAR(&ULX043) TYPE(*CHAR) LEN(1) VALUE('N')      /*237236*/
             DCL        VAR(&ULX610) TYPE(*CHAR) LEN(1) VALUE('N')      /*237236*/
 
/** CHECK FOR SE DROP FIELD IF SEQUENCE = 00003 **/
             IF         COND(&CSEQ = 00003) THEN(DO)
                RTVDTAARA  DTAARA(SESTAT (81 1)) RTNVAR(&DROP)
             IF         COND(&DROP *NE 'Y') THEN(DO)
                   GOTO       CMDLBL(ENDDROP)
                ENDDO
             ENDDO
 
/* CHECK IF DTAARA LDA EXIST IF RUN WITHOUT JOURNALING               */ /*227749*/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)                 /*227749*/
             MONMSG     MSGID(CPF9800) EXEC(DO)                         /*227749*/
                 CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)      /*227749*/
             ENDDO                                                      /*227749*/
                                                                        /*227749*/
/* SETUP CORRECT LIBRARY NAMES                                       */ /*227749*/
                                                                        /*227749*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             CHGVAR    VAR(&PRE)   VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
             CHGVAR    VAR(&JLIB)  VALUE(&PRE *TCAT 'JLIB')
             CHGVAR    VAR(&DPLIB)  VALUE(&PRE *TCAT 'DPLIB')
 
/** CHECK IF SWITCHABLE FEATURE S01513 IS SWITCHED ON                         */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01513')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))
 
/** CHECK IF SWITCHABLE FEATURE S01511 IS SWITCHED ON                         */
 
             IF COND(&S01513 *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01511')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01511) VALUE('Y'))
             ENDDO
 
/** CHECK IF SWITCHABLE FEATURE S01401 IS SWITCHED ON                         */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01401')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01401) VALUE('Y'))
 
/* Check if feature CSE007 is switched ON. */                         /*227749*/
                                                                      /*227749*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*227749*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*227749*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*227749*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*227749*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CSE007) VALUE('Y'))          /*227749*/
                                                                      /*227749*/
/* Check if feature CEU017 is switched ON. */                         /*227749*/
                                                                      /*227749*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*227749*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*227749*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*227749*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*227749*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CEU017) VALUE('Y'))          /*227749*/
 
/** CHECK IF SWITCHABLE FEATURE ULX004 IS SWITCHED ON                   /*237236*/
/**/                                                                    /*237236*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                     /*237236*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                     /*237236*/
             CHGVAR     VAR(&SAR) VALUE('ULX004')                       /*237236*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)    /*237236*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)              /*237236*/
                  CHGVAR     VAR(&ULX004) VALUE('Y')                    /*237236*/
             ENDDO                                                      /*237236*/
                                                                        /*237236*/
/** CHECK IF SWITCHABLE FEATURE ULX008 IS SWITCHED ON                   /*237236*/
/**/                                                                    /*237236*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                     /*237236*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                     /*237236*/
             CHGVAR     VAR(&SAR) VALUE('ULX008')                       /*237236*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)    /*237236*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)              /*237236*/
                  CHGVAR     VAR(&ULX008) VALUE('Y')                    /*237236*/
             ENDDO                                                      /*237236*/
                                                                        /*237236*/
/** CHECK IF SWITCHABLE FEATURE ULX043 IS SWITCHED ON                   /*237236*/
/**/                                                                    /*237236*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                     /*237236*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                     /*237236*/
             CHGVAR     VAR(&SAR) VALUE('ULX043')                       /*237236*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)    /*237236*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)              /*237236*/
                  CHGVAR     VAR(&ULX043) VALUE('Y')                    /*237236*/
             ENDDO                                                      /*237236*/
                                                                        /*237236*/
/** CHECK IF SWITCHABLE FEATURE ULX610 IS SWITCHED ON                   /*237236*/
/**/                                                                    /*237236*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                     /*237236*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                     /*237236*/
             CHGVAR     VAR(&SAR) VALUE('ULX610')                       /*237236*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)    /*237236*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)              /*237236*/
                  CHGVAR     VAR(&ULX610) VALUE('Y')                    /*237236*/
             ENDDO                                                      /*237236*/
 
   IF  COND(&S01513 *NE 'Y') THEN(GOTO CMDLBL(OUT))
 
             CHGJOB SWS(00000000)
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/* CALL PROGRAM                                                      */
 
             CHGVAR     VAR(&CNAM) VALUE(SEC1001)
             CALL       PGM(SEC1001) PARM(&CNAM &CSEQ)
 
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 1             */
 
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END1))
 
 
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */
 
             CHGVAR     VAR(&CNAM) VALUE(SEC1002)
             CALL       PGM(SEC1002) PARM(&CNAM &CSEQ)
 
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 2             */
 
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END2))
 
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */
 
/* BACKUP EXTENSION FILES FOR EUROPEAN REPORTING */
 
             CHGVAR     VAR(&CNAM) VALUE(SEC1003)
             CALL       PGM(SEC1003) PARM(&CNAM &CSEQ)
 
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 3             */
 
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END3))
 
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */
 
/**********  DSPFD      FILE(CAPRHD) TYPE(*MBR) OUTPUT(*OUTFILE) + */                     /*260765*/
/**********               OUTFILE(QTEMP/CHECK) */                                         /*260765*/
/**********  MONMSG     (CPF0000) */                                                      /*260765*/
 
             CHGVAR     VAR(&CNAM) VALUE(SEC1004)
             CALL       PGM(SEC1004) PARM(&CNAM &CSEQ)
 
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 4             */
 
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END4))
 
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */
 
             CHGVAR     VAR(&CNAM) VALUE(SEC1005)
             CALL       PGM(SEC1005) PARM(&CNAM &CSEQ)
 
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 5             */
 
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END5))
 
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */
 
             CHGVAR     VAR(&CNAM) VALUE(SEC1006)
             CALL       PGM(SEC1006) PARM(&CNAM &CSEQ)
 
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 6             */
 
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END6))
                                                                        /*227749*/
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */ /*227749*/
                                                                        /*227749*/
             CHGVAR     VAR(&CNAM) VALUE(SEC6440)                       /*227749*/
             CALL       PGM(SEC6440) PARM(&CNAM &CSEQ)                  /*227749*/
                                                                        /*227749*/
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 8             */ /*227749*/
                                                                        /*227749*/
/**IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END8))             227749 243026*/
                                                                        /*227749*/
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */ /*227749*/
                                                                        /*227749*/
             CHGVAR     VAR(&CNAM) VALUE(SEC6764)                       /*227749*/
             CALL       PGM(SEC6764) PARM(&CNAM &CSEQ)                  /*227749*/
                                                                        /*227749*/
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 9             */ /*227749*/
                                                                        /*227749*/
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END9))                  /*227749*/
                                                                        /*227749*/
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */ /*227749*/
                                                                        /*227749*/
             CHGVAR     VAR(&CNAM) VALUE(SEC6768)                       /*227749*/
             CALL       PGM(SEC6768) PARM(&CNAM &CSEQ)                  /*227749*/
                                                                        /*227749*/
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 10            */ /*227749*/
                                                                        /*227749*/
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END10))                 /*227749*/
                                                                        /*227749*/
/* IF NO ERRORS - CALL NEXT PROGRAM                                  */ /*227749*/
                                                                        /*227749*/
             CHGVAR     VAR(&CNAM) VALUE(SEC7580)                       /*227749*/
             CALL       PGM(SEC7580) PARM(&CNAM &CSEQ)                  /*227749*/
                                                                        /*227749*/
/* GOTO ABNORMAL TERMINATION IF ANY ERROR IN COMPONENT 11            */ /*227749*/
                                                                        /*227749*/
   IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END11))                 /*227749*/
                                                                        /*227749*/
             GOTO       CMDLBL(ENDPGM)                                  /*227749*/
 
/* COPY BACK LIVE RECORDS IF ANY COMPONENT NOT CORRECT               */
                                                                        /*227749*/
 END11:      CPYF       FROMFILE(*LIBL/XSECODRPD) TOFILE(SECODRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODRPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECODPPD) TOFILE(SECODPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODPPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOALPD) TOFILE(SECOALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOALPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOREPD) TOFILE(SECOREPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOREPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOEXPD) TOFILE(SECOEXPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOEXPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOFRPD) TOFILE(SECOFRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOFRPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOCEPD) TOFILE(SECOCEPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOCEPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECONFPD) TOFILE(SECONFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECONFPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECONCPD) TOFILE(SECONCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECONCPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECODVPD) TOFILE(SECODVPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODVPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECORGPD) TOFILE(SECORGPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORGPD))                               /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOFPPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOCRPD) TOFILE(SECOCRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOCRPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOCCPD) TOFILE(SECOCCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOCCPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECORBPD) TOFILE(SECORBPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORBPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSECORSPD) TOFILE(SECORSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORSPD))                               /*227749*/
 
             STRJRNPF   FILE(SECODRPD SECODPPD SECOALPD SECOREPD +
                          SECOEXPD SECOFRPD SECOCEPD SECONFPD +
                          SECONCPD SECODVPD SECORGPD SECOOFPD +
                          SECOCRPD SECOCCPD SECORBPD SECORSPD) +
                          JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)     /*227749*/
              MONMSG     (CPF0000)                                      /*227749*/
 
 END10:      CPYF       FROMFILE(*LIBL/XSEBLKPPD) TOFILE(SEBLKPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEBLKPPD))                               /*227749*/
             IF         COND((&CSE007 *EQ 'Y') *OR (&CSE007 *EQ +
                          'Y')) THEN(DO)                                /*227749*/
             CPYF       FROMFILE(*LIBL/XSECOBKPD) TOFILE(SECOBKPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOBKPD))                               /*227749*/
             ENDDO                                                      /*227749*/
                                                                        /*227749*/
             STRJRNPF   FILE(SEBLKPPD SECOBKPD) JRN(ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                /*227749*/
             MONMSG     (CPF0000)                                       /*227749*/
                                                                        /*227749*/
 /***END9:   CPYF       FROMFILE(*LIBL/XSEERRFPD) TOFILE(SEERRPFD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           227749 243026*/
 /***        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERRFPD))                          227749 243026*/
 END9:       CPYF       FROMFILE(*LIBL/XSEERDPPD) TOFILE(SEERDPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERDPPD))                               /*227749*/
             CPYF       FROMFILE(*LIBL/XSEERALPD) TOFILE(SEERALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERALPD))                               /*227749*/
                                                                        /*227749*/
             STRJRNPF   FILE(SEERRFPD SEERDPPD SEERALPD) JRN(ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                /*227749*/
             MONMSG     (CPF0000)                                       /*227749*/
                                                                        /*227749*/
 /***END8:   CPYF       FROMFILE(*LIBL/XSEOCFSPD) +
                          TOFILE(*LIBL/SEOCFSPD) MBROPT(*REPLACE)  227749 243026*/
 /***        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEOCFSPD))                            227749 243026*/
 
 /***        CPYF       FROMFILE(*LIBL/XSESCFAPD) +
                          TOFILE(*LIBL/SESCFAPD) MBROPT(*REPLACE)    227749 243026*/
 /***        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SESCFAPD))                            227749 243026*/
 
 /***        STRJRNPF   FILE(SEOCFSPD SESCFAPD) JRN(ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)             227749 243026*/
 /***        MONMSG     (CPF0000)                                    227749 243026*/
 
/**END7:     CPYF       FROMFILE(*LIBL/XPMCPOSPD) +
                          TOFILE(*LIBL/PMCPOSPD) MBROPT(*REPLACE)    227749 243026*/
/***         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSPD))                            227749 243026*/
 
/***         STRJRNPF   FILE(PMCPOSPD) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)             227749 243026*/
/***         MONMSG     (CPF0000)                                    227749 243026*/
                                                                        /*227749*/
END6:        CPYF       FROMFILE(XSEPCA) TOFILE(SEPCA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEPCA))
             CPYF       FROMFILE(XSEPCBD) TOFILE(SEPCBD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEPCBD))
             CPYF       FROMFILE(XSEPCCD) TOFILE(SEPCCD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEPCCD))
 
             STRJRNPF   FILE(SEPCA SEPCBD SEPCCD) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
 
END5:        CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +
                        FROMMBR(POSETA) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETA))
             CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                        FROMMBR(POSETD) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETD))
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
/***         CPYF       FROMFILE(XPOSETDX1) TOFILE(POSETDX1) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              243026*/
/***         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETDX1))                             243026*/
/***         CPYF       FROMFILE(XPOSETDX2) TOFILE(POSETDX2) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              243026*/
/***         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETDX2))                             243026*/
                   ENDDO
 
             STRJRNPF   FILE(POSETA POSETD) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             STRJRNPF   FILE(POSETDX1) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(POSETDX2) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             ENDDO
 
END4:        CPYF       FROMFILE(XDPOSNA) TOFILE(DPOSNA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPOSNA))
             CPYF       FROMFILE(XDPOSND) TOFILE(DPOSND) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPOSND))
             CPYF       FROMFILE(XUDEPPA) TOFILE(UDEPPA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(UDEPPA))
             CPYF       FROMFILE(XUDEPPD) TOFILE(UDEPPD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(UDEPPD))
             CPYF       FROMFILE(XCDEPPA) TOFILE(CDEPPA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CDEPPA))
             CPYF       FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CDEPPD))
             CPYF       FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CPOSNA))
             CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CPOSND))
             CPYF       FROMFILE(XCAPRHA) TOFILE(CAPRHA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CAPRHA))
             CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CAPRHD))
             CPYF       FROMFILE(XBKMTHA) TOFILE(BKMTHA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKMTHA))
             CPYF       FROMFILE(XBKMTHD) TOFILE(BKMTHD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKMTHD))
             CPYF       FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKPHDA))
             CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKPHDD))
             CPYF       FROMFILE(XBKPHHA) TOFILE(BKPHHA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKPHHA))
             CPYF       FROMFILE(XBKPHHD) TOFILE(BKPHHD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKPHHD))
             CPYF       FROMFILE(XBKPOSA) TOFILE(BKPOSA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKPOSA))
             CPYF       FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BKPOSD))
             CPYF       FROMFILE(XBPACHA) TOFILE(BPACHA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BPACHA))
             CPYF       FROMFILE(XBPACHD) TOFILE(BPACHD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BPACHD))
 
             STRJRNPF   FILE(DPOSNA DPOSND UDEPPA UDEPPD CDEPPA +
                          CDEPPD CPOSNA CPOSND BKPHDA BKPHDD BKPHHA +
                          BKPHHD BKPOSA BKPOSD BPACHA BPACHD) +
                          JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
 
END3:        CPYF       FROMFILE(XDPTMVA) TOFILE(DPTMVA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPTMVA))
             CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPTMVD))
 
                IF         COND(&S01401 *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(XDPTMVDX1) TOFILE(DPTMVDX1) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPTMVDX1))
             CPYF       FROMFILE(XDPTMVDX2) TOFILE(DPTMVDX2) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPTMVDX2))
                   ENDDO
 
             STRJRNPF   FILE(DPTMVA DPTMVD) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             STRJRNPF   FILE(DPTMVDX1) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(DPTMVDX2) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
                   ENDDO
 
END2:        CPYF       FROMFILE(XHSTTRA) TOFILE(HSTTRA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(HSTTRA))
             CPYF       FROMFILE(XHSTTRD) TOFILE(HSTTRD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(HSTTRD))
             CPYF       FROMFILE(XSETLEA) TOFILE(SETLEA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SETLEA))
             CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SETLED))
             CPYF       FROMFILE(XTRAUTD) TOFILE(TRAUTD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRAUTD))
             CPYF       FROMFILE(XTRATXD) TOFILE(TRATXD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRATXD))
             CPYF       FROMFILE(XHSTAUD) TOFILE(HSTAUD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(HSTAUD))
 
             CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRADSD))
 
             IF COND(&S01401 *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(XTRADSDX1) TOFILE(TRADSDX1) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRADSDX1))
             CPYF       FROMFILE(XTRADSDX2) TOFILE(TRADSDX2) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRADSDX2))
                   ENDDO
 
             STRJRNPF   FILE(HSTTRA HSTTRD SETLEA SETLED TRAUTD +
                          TRATXD) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(TRADSD) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             STRJRNPF   FILE(TRADSDX1) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(TRADSDX2) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
                   ENDDO
 
END1:        CPYF       FROMFILE(XSECTYA) TOFILE(SECTYA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECTYA))
             CPYF       FROMFILE(XSECTYD) TOFILE(SECTYD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECTYD))
             CPYF       FROMFILE(XSNDEVA) TOFILE(SNDEVA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SNDEVA))
             CPYF       FROMFILE(XSNDEVD) TOFILE(SNDEVD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SNDEVD))
             CPYF       FROMFILE(XSEDEVA) TOFILE(SEDEVA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEDEVA))
             CPYF       FROMFILE(XSEDEVD) TOFILE(SEDEVD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEDEVD))
             CPYF       FROMFILE(XSESWHTPD) TOFILE(SESWHTPD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SESWHTPD))
/***         CPYF       FROMFILE(XSECTYDX7) TOFILE(SECTYDX7) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                  243026*/
/***         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECTYDX7))                               243026*/
 
/***         STRJRNPF   FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
                          SEDEVD SESWHTPD SECTYDX7) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                243026*/
             STRJRNPF   FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
                          SEDEVD SESWHTPD ) JRN(&JLIB/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*243026*/
             MONMSG     (CPF0000)
 
MESSAGE:     CHGVAR     VAR(&MSG) VALUE('SECDROP ended abnormally')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
ENDPGM:      DLTF       FILE(XSECTYA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSECTYD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSNDEVA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSNDEVD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSEDEVA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSEDEVD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSESWHTPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XHSTTRA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XHSTTRD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSETLEA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XSETLED)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XTRAUTD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XTRATXD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XHSTAUD)
             MONMSG     MSGID(CPF0000)
/***         DLTF       FILE(XSECTYDX7)                              243026*/
/***         MONMSG     MSGID(CPF0000)                               243026*/
 
             DLTF       FILE(XDPTMVA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XDPTMVD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(XDPOSNA)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(XDPOSND)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XUDEPPA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XUDEPPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XCDEPPA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XCDEPPD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(XCPOSNA)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(XCPOSND)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XCAPRHA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XCAPRHD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKMTHA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKMTHD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKPHDA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKPHDD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKPHHA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKPHHD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKPOSA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBKPOSD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBPACHA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XBPACHD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XPOSETA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XPOSETD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XTRADSD)
             MONMSG     MSGID(CPF0000)
/**********  DLTF       FILE(CHECK) */                                                    /*260765*/
/**********  MONMSG     MSGID(CPF0000) */                                                 /*260765*/
 /* FOR PMC2500 */                                                      /*227749*/
 /***        DLTF       FILE(XPMCPOSPD)                            227749 243026*/
 /***        MONMSG     MSGID(CPF0000)                             227749 243026*/
                                                                        /*227749*/
 /* FOR SEC6440 */                                                      /*227749*/
             DLTF       FILE(XSEOCFSPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSESCFAPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
                                                                        /*227749*/
 /* FOR SEC6764 */                                                      /*227749*/
             DLTF       FILE(XSEERDPPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSEERRFPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSEERALPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
                                                                        /*227749*/
/* FOR SEC6768 */                                                       /*227749*/
             DLTF       FILE(XSEBLKPPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
     IF COND((&CSE007 *EQ 'Y') *OR (&CEU017 *EQ 'Y')) THEN(DO)          /*227749*/
             DLTF       FILE(XSECOBKPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             ENDDO                                                      /*227749*/
                                                                        /*227749*/
/* FOR SEC7580 */                                                       /*227749*/
             DLTF       FILE(XSECODRPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECODPPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOALPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOREPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOEXPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOFRPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOCEPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECONFPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECONCPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECODVPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECORGPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOOFPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOCRPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECOCCPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECORBPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
             DLTF       FILE(XSECORSPD)                                 /*227749*/
             MONMSG     MSGID(CPF0000)                                  /*227749*/
                                                                        /*227749*/
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             DLTF       FILE(XTRADSDX1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XTRADSDX2)
             MONMSG     MSGID(CPF0000)
                   ENDDO
 
                IF         COND(&S01401 *EQ 'Y') THEN(DO)
             DLTF       FILE(XDPTMVDX1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XDPTMVDX2)
             MONMSG     MSGID(CPF0000)
                   ENDDO
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             DLTF       FILE(XPOSETDX1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XPOSETDX2)
             MONMSG     MSGID(CPF0000)
                   ENDDO
 
/* START JOURNALING ON SPECIFIED FILES                               */
 
/***         STRJRNPF   FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
                          SEDEVD SESWHTPD HSTTRA HSTTRD SETLEA +
                          SETLED TRAUTD TRATXD DPTMVA DPTMVD DPOSNA +
                          DPOSND UDEPPA UDEPPD CDEPPA CDEPPD CPOSNA +
                          CPOSND BKPHDA BKPHDD BKPHHA BKPHHD BKPOSA +
                          BKPOSD BPACHA BPACHD POSETA POSETD TRADSD +
                          SEPCA SEPCBD SEPCCD SECTYDX7) +
                          JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                          227749 243026*/
             STRJRNPF   FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
                          SEDEVD SESWHTPD HSTTRA HSTTRD SETLEA +
                          SETLED TRAUTD TRATXD DPTMVA DPTMVD DPOSNA +
                          DPOSND UDEPPA UDEPPD CDEPPA CDEPPD CPOSNA +
                          CPOSND BKPHDA BKPHDD BKPHHA BKPHHD BKPOSA +
                          BKPOSD BPACHA BPACHD POSETA POSETD TRADSD +
                          SEPCA SEPCBD SEPCCD ) +
                          JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                              /*243026*/
             MONMSG     (CPF0000)
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             STRJRNPF   FILE(TRADSDX1) JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(TRADSDX2) JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
                   ENDDO
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             STRJRNPF   FILE(DPTMVDX1) JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(DPTMVDX2) JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
                   ENDDO
 
                   IF COND(&S01401 *EQ 'Y') THEN(DO)
             STRJRNPF   FILE(POSETDX1) JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             STRJRNPF   FILE(POSETDX2) JRN(&JLIB/ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     (CPF0000)
             ENDDO
 
/* RESET SESTAT POS.81 TO AVOID DOUBLE RUN, SEQUENCE '00003' IS CONDITIONNED  */
/* BY THIS VALUE IN EACH SEC100X                                              */
/************IF         COND(&CSEQ = 00002) THEN(DO)*****/
             CHGDTAARA  DTAARA(SESTAT (81 1)) VALUE('N')
/************ENDDO*****/
 
                  CHGVAR    VAR(&BUSY) VALUE('N')
                  CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)
 
OUT:        CHGJOB SWS(00000000)
             CALL       PGM(SCC000060) PARM('SECTYD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('SESWHTPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SEDEVD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('SNDEVD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('HSTTRD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('SETLED' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('TRAUTD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('HSTAUD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('TRATXD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('TRADSD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('TRADSDX1' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('TRADSDX2' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('DPTMVD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('DPTMVDX1' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('DPTMVDX2' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('DPOSND' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('UDEPPD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('CDEPPD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('CPOSND' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('CAPRHD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('BKPHDD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('BKPHHD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('BKPOSD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('BPACHD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('BKMTHD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('POSETD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('POSETDX1' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('POSETDX2' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SEPCBD' '*FIRST')                   /*228542*/
             CALL       PGM(SCC000060) PARM('SEPCCD' '*FIRST')                   /*228542*/
 
/*   PMC2500 */                                                         /*227749*/
/***         RGZPFM     FILE(PMCPOSPD)                             227749 243026*/
/***         MONMSG     MSGID(CPF2981)                             227749 243026*/
/*   SEC6440 */                                                         /*227749*/
             CALL       PGM(SCC000060) PARM('SEOCFSPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SESCFAPD' '*FIRST')                 /*228542*/
/*   SEC6764 */                                                         /*227749*/
             CALL       PGM(SCC000060) PARM('SEERRFPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SEERDPPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SEERALPD' '*FIRST')                 /*228542*/
/*   SEC6768 */                                                         /*227749*/
             CALL       PGM(SCC000060) PARM('SEBLKPPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOBKPD' '*FIRST')                 /*228542*/
/*   SEC7580 */                                                         /*227749*/
             CALL       PGM(SCC000060) PARM('SECODRPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECODPPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOALPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOREPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOEXPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOFRPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOCEPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECONFPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECONCPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECODVPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECORGPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOOFPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOCRPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECOCCPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECORBPD' '*FIRST')                 /*228542*/
             CALL       PGM(SCC000060) PARM('SECORSPD' '*FIRST')                 /*228542*/
                                                                        /*227749*/
             IF         COND(&ULX043 *EQ 'Y') THEN(DO)                           /*237236*/
             CALL       PGM(SCC000060) PARM('SESDX1PD' '*FIRST')                 /*237236*/
             ENDDO                                                               /*237236*/
                                                                                 /*237236*/
             IF         COND(&ULX008 *EQ 'Y') THEN(DO)                           /*237236*/
             IF         COND(&ULX004 *EQ 'Y') THEN(DO)                           /*237236*/
             CALL       PGM(SCC000060) PARM('SEDPX1PD' '*FIRST')                 /*237236*/
             CALL       PGM(SCC000060) PARM('SETRX1PD' '*FIRST')                 /*237236*/
             ENDDO                                                               /*237236*/
             CALL       PGM(SCC000060) PARM('SESDX3PD' '*FIRST')                 /*237236*/
             ENDDO                                                               /*237236*/
                                                                                 /*237236*/
             IF         COND(&ULX610 *EQ 'Y') THEN(DO)                           /*237236*/
             CALL       PGM(SCC000060) PARM('SESDX2PD' '*FIRST')                 /*237236*/
             ENDDO                                                               /*237236*/
                                                                                 /*237236*/
             CHGDTAARA  DTAARA(SESTAT (81 1)) VALUE('N')                /*227749*/
                                                                        /*227749*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                          /*227749*/
                ENDJRNPF   FILE(*ALL) JRN(ICJRN)                        /*227749*/
                MONMSG     MSGID(CPF0000)                               /*227749*/
             ENDDO                                                      /*227749*/
                                                                        /*227749*/
ENDDROP:     ENDPGM
 
