/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Input cycle processing')                     */
/********************************************************************/
/*                                                                  */
/*         Midas   Securities Trading Module                        */
/*                                                                  */
/*         SEC02 - INPUT CYCLE PROCESSING                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD031             Date 10Apr06              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 02Feb04              */
/*                      CGP001             Date 23May03              */
/*                      213041             Date 09Dec02              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      208189             Date 12Aug02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      204747             Date 02May02              */
/*                      201230             Date 21Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSE028             Date 06Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      186055             Date 06Nov00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/*                      CSE006             Date 25Jun99              */
/*                      CPB001             Date 02Jul99              */
/*                      CSE010           Date 21Jun99                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                        138957           Date 16Jul98             */
/*                        CEU017           Date 03Avr98             */
/*                        CSE007           Date 19Jan97             */
/*                        125378           DATE 11Feb98             */
/*                        S01408           DATE 10Feb98             */
/*                        103747           DATE 10APR97             */
/*                      . CSE003           DATE 11OCT96             */
/*                        S01408           DATE 30SEP96             */
/*                        S01408           DATE 26SEP96             */
/*                        S01408           DATE 21FEB96             */
/*                        084923           DATE 13APR95             */
/*                        080065           DATE 12DEC94             */
/*                        S01496           DATE 24OCT94             */
/*                        S01486           DATE 18OCT94             */
/*                        S01502           DATE 12DEC94             */
/*                        S01464           DATE 04APR94             */
/*                        S01446           DATE 07OCT93             */
/*                        S01401           DATE 16JUN93             */
/*                        S01220           DATE 21FEB91             */
/*                        E24417           DATE 14FEB91             */
/*                        S01322             DATE  31JAN91          */
/*                        S01117             DATE  10DEC90          */
/*                        S01269             DATE  10JUL90          */
/*                        E23408             DATE  06SEP90          */
/*                        E21717             DATE  25APR90          */
/*                        E17618             DATE  06/04/89         */
/*                        E16096             DATE  23/03/89         */
/*                        E16870             DATE  08/03/89         */
/*                        S01176             DATE  24/08/88         */
/*                        E13952             DATE  09/08/88         */
/*                        S01169             DATE  10/06/88         */
/*                        S01129             DATE  11/05/88         */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD031 - Enhanced Centralised Static Data                   */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGP001 - Global Processing                                  */
/*       213041 - DB error on SE0180 due to missing file TRADSDZ2.   */
/*       208189 - CPF5123 received on POSET1 if CSE023 is *ON        */
/*       204747 - Check on CSE028                                    */
/*       201230 - Add override to file DPTMVDZ3 to file DPTMVDY2,    */
/*                if calling SE0070 as this also calls SE1807.       */
/*       CSE028 - Standing Settlement Instructions Enhancement       */
/*       186055 - All sort of errors are being encountered in        */
/*                Position Settlement Maintenace                     */
/*                (For CSE023 - Treaty Withholding Tax)              */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       CSE006 - Repo Enhancement                                   */
/*       CPB001 - 'Private Banking' Module                           */
/*       CSE010 - SE Transaction Enhancement                         */
/*       138957 - Corporate Actions: Review information passed to  */
/*                RPG/SE0040 (Security Details Maintenance) for a  */
/*                Name Change event where the Security Shortname   */
/*                is being changed (when F15 is pressed).          */
/*       CEU017 - Securities Redenomination Euro Changes           */
/*       CSE007 - Corporate Actions                                */
/*       125378 - Add OVRDBF CPOSN SHARE(*NO) if calling SE0190    */
/*                as this also calls SE0050 (for S01496)           */
/*       S01408 - Addition of core hook SEC02024 (manually)        */
/*              - Addition of core hook SEC02023 (manually)        */
/*              - Addition of core hook SEC02MP2 (manually)        */
/*              - Addition of core hook SEC02MP1 (manually)        */
/*       103747 - Check whether PF/SEACKD is allocated to another  */
/*                job.                                             */
/*       CSE003 - '?' processing for Security Shortname in SE0050, */
/*                SE0070 and SE0170.                               */
/*       S01408 - Addition of core hook SEC02004                   */
/*       S01408 - Addition of core hook SEC02003                   */
/*       S01408 - Addition of core hook SEC02001                   */
/*                Addition of core hook SEC02002                   */
/*       084923 - Send 'MIDAS' message to MSTATUS to balance with  */
/*                MIDASRMV CALL, which otherwise removes a message */
/*                sent by another job.                             */
/*       080065 - PM & LB wrongly conditionned in SEC02            */
/*       S01496 - Incorp. of Private Bank. SE Enhancements (S10978)*/
/*       S01486 - Portfolio Management Enhancement                 */
/*       S01502 - BLI Telekurs Processing.                         */
/*                SESTAT increased in length from 128 to 133 bytes */
/*       S01464 - Safe Custody Fees.                               */
/*       S01446 - Customer Commissions (Courtage)                  */
/*       S01401 - SWIFT Messages MT5xxs : override files for       */
/*                retrieval in :-                                  */
/*                         (1) SE1805/SE1806 (called by SE0050).   */
/*                              (which may be called by SE0190).   */
/*                         (2) SE1817        (called by SE0170).   */
/*                         (3) SE1807/SE1808 (called by SE0070).   */
/*              - To submit confirmations to batch if Trades       */
/*                or Depot Movements just maintained.              */
/*       S01220 - Amendment for linked enquiry from Risk Management*/
/*                Data area creation parameters changed.           */
/*       E24417  - SE0140 NOW REDUNDANT                             */
/*       S01322 - REMOVAL OF RT BOND                               */
/*       S01117 - MULTIBRANCHING                                   */
/*       S01269 - NEW PROGRAMS ADDED AND NEW PARAMETERS PASSED     */ /*S01269*/
/*                TO SE0050 FOR TRADES AUTHORISATION               */ /*S01269*/
/*       E23408 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF     */
/*                RETAIL II OR INTEREST ON ACCOUNTS INSTALLED -    */
/*                SETON U1 IF RE OR IA = 'Y'.                      */
/*       E21717 - ADD OVERRIDE FOR SEDEV IN SE0040                 */
/*       E17618 - ONLY CHECK FOR COMPLETION OF EXTEL PROCESSING    */
/*                IF EXTEL INTERFACE IS PRESENT.                   */
/*       E16096 - REMOVE OVERRIDE TO TRADS FOR SE0050              */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                   */
/*       S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)               */
/*       E13952 - OVERRIDE FOR CALL OF POSITION SETTLEMENTS        */
/*       S01169 - SECURITIES TRADING 3.1                           */
/*                  (BAER INCORPORATION)                           */
/*       S01129 - SE INCORPORATION                                 */
/*                                                                 */
/********************************************************************/
             PGM        PARM(&PARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(8)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&DL) TYPE(*LGL)
             DCL        VAR(&RE) TYPE(*LGL)
             DCL        VAR(&IA) TYPE(*LGL)                           /*E23408*/
             DCL        VAR(&EX) TYPE(*LGL)                           /*S01169*/
             DCL        VAR(&PM) TYPE(*LGL)                           /*S01486*/
             DCL        &EXST  *CHAR   1          /* Extel status        */
/**/
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
             DCL       VAR(&MMOD)  TYPE(*CHAR)  LEN(256)
/*           DCL       VAR(&SESTAT) TYPE(*CHAR)  LEN(256)       /*S01169E16870*/
/************DCL       VAR(&SESTAT) TYPE(*CHAR)  LEN(128)         E16870S01502*/
             DCL       VAR(&SESTAT) TYPE(*CHAR)  LEN(133)             /*S01502*/
/**/                                                                  /*S01496*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01496*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01496*/
             DCL        VAR(&S01496) TYPE(*CHAR) LEN(1)               /*S01496*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*080065*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*103747*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE010*/
             DCL        VAR(&CSE006) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
             DCL        VAR(&CSE023) TYPE(*CHAR) LEN(1) VALUE('N')    /*186055*/
             DCL        VAR(&CSE028) TYPE(*CHAR) LEN(1) VALUE('N')    /*204747*/
             DCL        VAR(&CGP001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGP001*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
/*/COPY WNCPYSRC,SEC02005                                            */
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01496*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01496*/
             CHGVAR     VAR(&SAR) VALUE('S01496')                     /*S01496*/
             CHGVAR     VAR(&S01496) VALUE('N')                       /*S01496*/
/**/                                                                  /*S01496*/
/**  Check if Jyske Enhancements is installed */                      /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
                CHGVAR     VAR(&S01496) VALUE('Y')                    /*S01496*/
             ENDDO                                                    /*S01496*/
/* Check if 'Corporate Actions' is *ON */                             /*CSE007*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
                                                                      /*CSE007*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE007*/
                  CHGVAR     VAR(&CSE007) VALUE('Y')                  /*CSE007*/
             ENDDO                                                    /*CSE007*/
                                                                      /*CSE006*/
/* Check if 'Repo Enhancement' is *ON */                              /*CSE006*/
             CHGVAR     VAR(&SAR) VALUE('CSE006')                     /*CSE006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE006*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE006*/
                                                                      /*CSE006*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE006*/
                  CHGVAR     VAR(&CSE006) VALUE('Y')                  /*CSE006*/
             ENDDO                                                    /*CSE006*/
                                                                      /*CEU017*/
/* Check if 'Securities Redenomination is *ON */                      /*CEU017*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
                                                                      /*CEU017*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CEU017*/
                  CHGVAR     VAR(&CEU017) VALUE('Y')                  /*CEU017*/
             ENDDO                                                    /*CEU017*/
                                                                      /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
                                                                      /*CEU017*/
/*/COPY WNCPYSRC,SEC02006                                            */
/**/                                                                  /*CSE010*/
/**  Check if Transaction Enhancements is installed */                /*CSE010*/
/**/                                                                  /*CSE010*/
             CHGVAR     VAR(&SAR) VALUE('CSE010')                     /*CSE010*/
             CHGVAR     VAR(&CSE010) VALUE('N')                       /*CSE010*/
/**/                                                                  /*CSE010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE010*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE010*/
                CHGVAR     VAR(&CSE010) VALUE('Y')                    /*CSE010*/
             ENDDO                                                    /*CSE010*/
/**/                                                                  /*CSE010*/
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)                /*CSE010*/
                OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
                OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
                OVRDBF     FILE(SECTYZ3) TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
                OVRDBF     FILE(TRADSX1) TOFILE(TRADS) SHARE(*NO)     /*CSE010*/
                OVRDBF     FILE(DPMVX)   TOFILE(DPMV)  SHARE(*NO)     /*CSE010*/
                OVRDBF     FILE(SECTYX)  TOFILE(SECTY) SHARE(*NO)     /*CSE010*/
             ENDDO                                                    /*CSE010*/
/**/                                                                  /*186055*/
/* Check if CSE023 is installed */                                    /*186055*/
/**/                                                                  /*186055*/
             CHGVAR     VAR(&SAR) VALUE('CSE023')                     /*186055*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*186055*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*186055*/
             CHGVAR     VAR(&CSE023) VALUE('N')                       /*186055*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*186055*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*186055*/
                CHGVAR     VAR(&CSE023) VALUE('Y')                    /*186055*/
             ENDDO                                                    /*186055*/
/**/                                                                  /*204747*/
/* Check if CSE028 is installed */                                    /*204747*/
/**/                                                                  /*204747*/
             CHGVAR     VAR(&SAR) VALUE('CSE028')                     /*204747*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*204747*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*204747*/
/**********  CHGVAR     VAR(&CSE023) VALUE('N')                                /*204747*/ /*208189*/
             CHGVAR     VAR(&CSE028) VALUE('N')                                           /*208189*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*204747*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*204747*/
                CHGVAR     VAR(&CSE028) VALUE('Y')                    /*204747*/
             ENDDO                                                    /*204747*/
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&SAR)  VALUE('CRE020')                                        /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
               GOTO   CMDLBL(ERR)                                                         /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/                                                                                      /*CGP001*/
/* Check if CGP001 is enabled */                                                          /*CGP001*/
/**/                                                                                      /*CGP001*/
             CHGVAR     VAR(&SAR) VALUE('CGP001')                                         /*CGP001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGP001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGP001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CGP001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CGP001*/
                CHGVAR     VAR(&CGP001) VALUE('Y')                                        /*CGP001*/
             ENDDO                                                                        /*CGP001*/
/**/                                                                  /*S01486*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*080052*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01486*/
/**/                                                                  /*S01486*/
/**/
             CHGJOB SWS(00000000)
/**/
             RTVDTAARA MMOD RTNVAR(&MMOD)
             CHGVAR &DL VALUE(%SST(&MMOD 2 1) *EQ 'Y')
             CHGVAR &RE VALUE(%SST(&MMOD 16 1) *EQ 'Y')
             CHGVAR &IA VALUE(%SST(&MMOD 23 1) *EQ 'Y')               /*E23408*/
/*********** CHGVAR &PM VALUE(%SST(&MMOD 75 1) *EQ 'Y')       /*S01486  080065*/
             IF &DL CHGJOB SWS(X1000000)
             IF COND(&RE *OR &IA) THEN(CHGJOB SWS(1X000000))          /*E23408*/
/************IF*&RE*CHGJOB*SWS(1X000000)                          **/ /*E23408*/
/*********** IF &PM CHGJOB SWS(XXX1XXXX)                     /*S01486   080065*/
/*********** IF         COND(%SST(&FMT 65 1) *NE 'Y') THEN(CHGJOB +
                          SWS(XXX1XXXX))                ***********/  /*080065*/
             IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(CHGJOB +
                          SWS(XXX1XXXX))                              /*080065*/
/**/                                                                  /*S01169*/
             RTVDTAARA SESTAT RTNVAR(&SESTAT)                         /*S01169*/
             CHGVAR &EX VALUE(%SST(&SESTAT 63 1) *EQ 'Y')             /*S01169*/
             IF &EX CHGJOB SWS(XX100000)                              /*S01169*/
/*/COPY WNCPYSRC,SEC02022                                            */
/**/
/* PERFORM FILE OVERIDE DEPENDING ON PROGRAM TO BE CALLED           */
             IF COND(&PARM = 'SE6020') THEN(DO)                       /*S01464*/
                OVRDBF     FILE(SECFGRXX) TOFILE(SECFGRPD) SHARE(*NO) /*S01464*/
                GOTO CALLP                                            /*S01464*/
             ENDDO                                                    /*S01464*/
             IF COND(&PARM = 'SE6030') THEN(DO)                       /*S01464*/
                OVRDBF     FILE(SECICFXX) TOFILE(SECICFPD) SHARE(*NO) /*S01464*/
                GOTO CALLP                                            /*S01464*/
             ENDDO                                                    /*S01464*/
             IF COND(&PARM = 'SE6040') THEN(DO)                       /*S01464*/
                OVRDBF     FILE(SESCFAXX) TOFILE(SESCFAPD) SHARE(*NO) /*S01464*/
                GOTO CALLP                                            /*S01464*/
             ENDDO                                                    /*S01464*/
             IF COND(&PARM = 'SE6050') THEN(DO)                       /*S01464*/
                OVRDBF     FILE(SESCFAXX) TOFILE(SESCFAPD) SHARE(*NO) /*S01464*/
                OVRDBF     FILE(SEOCFSXX) TOFILE(SEOCFSPD) SHARE(*NO) /*S01464*/
                GOTO CALLP                                            /*S01464*/
             ENDDO                                                    /*S01464*/
             IF COND(&PARM = 'SE6070') THEN(DO)                       /*S01464*/
                OVRDBF     FILE(SECGCDXX) TOFILE(SECGCDPD) SHARE(*NO) /*S01464*/
                GOTO CALLP                                            /*S01464*/
             ENDDO                                                    /*S01464*/
             IF COND(&PARM = 'SE5010') THEN(DO)                       /*S01176*/
                OVRDBF     FILE(CPPRIX) TOFILE(CPPRID) SHARE(*NO)     /*S01176*/
                GOTO CALLP                                            /*S01176*/
             ENDDO                                                    /*S01176*/
             IF COND(&PARM = 'SE0010') THEN(DO)
                OVRDBF     FILE(SEMKCX) TOFILE(SEMKC) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0020') THEN(DO)
                OVRDBF     FILE(INVTPX) TOFILE(INVTP) SHARE(*NO)
             IF COND(&CGP001 *EQ 'Y') THEN(DO)                                            /*CGP001*/
                OVRDBF     FILE(GPPRDXL0) TOFILE(GPPRODXL0)                               /*CGP001*/
                OVRDBF     FILE(GPINSXL0) TOFILE(GPINSTXL0)                               /*CGP001*/
             ENDDO                                                                        /*CGP001*/
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0030') THEN(DO)
             IF COND(&CSE028 = 'N') THEN(DO)                          /*204747*/
                OVRDBF     FILE(STDSEX) TOFILE(STDSED) SHARE(*NO)
             ENDDO                                                    /*204747*/
             IF COND(&CSE028 = 'Y') THEN(OVRDBF FILE(STDSEX) +
                          TOFILE(STDSEL1) SHARE(*NO))                 /*204747*/
                OVRDBF FILE(STDSED) SHARE(*NO)                        /*CSE028*/
                OVRDBF FILE(STDADSL2) SHARE(*NO)                      /*CSE028*/
                GOTO CALLP
             ENDDO
/*/COPY WNCPYSRC,SEC02014                                            */
/************IF COND(&PARM = 'SE0040') THEN(DO)***/                   /*CSE010*/
             IF COND((&PARM = 'SE0040') *OR (&PARM = 'SE0043')) +
                THEN(DO)                                              /*CSE010*/
/*/COPY WNCPYSRC,SEC02015                                            */
             IF &EX THEN(DO)                                          /*E17618*/
        RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&EXST)                /*S01169*/
        IF    COND((&EXST *NE 'A') *AND (&EXST *NE 'T') *AND (&EXST +
                  *NE 'C') *AND (&EXST *NE 'F'))      THEN(DO)        /*S01169*/
              SNDPGMMSG  MSG('Option unavailable - EXTEL processing +
                  not complete') TOPGMQ(*EXT) TOMSGQ(MOPERQ)          /*S01169*/
              GOTO  ENDPGM                                            /*S01169*/
              ENDDO                                                   /*S01169*/
              ENDDO                                                   /*E17618*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
             OVRDBF     FILE(SECED) SHARE(*NO)                        /*CSE007*/
             ENDDO                                                    /*CSE007*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC02003                                            */
/**/                                                                  /*S01408*/
             IF COND(&CSE010 *EQ 'N') THEN(DO)                        /*CSE010*/
                OVRDBF     FILE(SECTYX) TOFILE(SECTY) SHARE(*NO)
                OVRDBF     FILE(SEDEVX) TOFILE(SEDEV) SHARE(*NO)      /*E21717*/
/*/COPY WNCPYSRC,SEC02016                                            */
             ENDDO                                                    /*CSE010*/
                GOTO CALLP
             ENDDO
                                                                      /*CSE003*/
/* Data area SESDS used in SE0050, SE0070 and SE0170.                 **CSE003*/
/* It holds parameters returned from SE0240.                          **CSE003*/
/*/COPY WNCPYSRC,SEC02027                                            */
             IF         COND((&PARM *EQ 'SE0050') *OR (&PARM *EQ +
                          'SE0070') *OR (&PARM *EQ 'SE0170')) +
                          THEN(DO)                                    /*CSE003*/
/*/COPY WNCPYSRC,SEC02028                                            */
                CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                /*CSE003*/
                MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                             DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)) /*CSE003*/
/*/COPY WNCPYSRC,SEC02MP1                                            */
                CHGDTAARA  DTAARA(SESDS) VALUE(' ')                   /*CSE003*/
                CHGDTAARA  DTAARA(SESDS (1 8)) VALUE(&PARM)           /*CSE003*/
                CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')       /*CSE003*/
/*/COPY WNCPYSRC,SEC02MP2                                            */
              ENDDO                                                   /*CSE003*/
                                                                      /*CSE003*/
             IF         COND(&PARM = 'SE0180') THEN(DO)                                  /*213041*/
                  OVRDBF     FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)                  /*213041*/
                  GOTO       CMDLBL(CALLP)                                               /*213041*/
             ENDDO                                                                       /*213041*/
                                                                                         /*213041*/
/*/COPY WNCPYSRC,SEC02017                                            */
             IF COND(&PARM = 'SE0050') THEN(DO)
/*/COPY WNCPYSRC,SEC02018                                            */
/***************OVRDBF     FILE(TRADSX) TOFILE(TRADS) SHARE(*NO)****** E16096 */
/***************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)     * *S01117*/
                OVRDBF FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)     /*S01401*/
                OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)     /*S01401*/
/*/COPY WNCPYSRC,SEC02033                                            */
                IF         COND(&S01496 *EQ 'Y') THEN(DO)             /*S01496*/
                   OVRDBF     FILE(CPOSN) SHARE(*NO)                  /*S01496*/
                ENDDO                                                 /*S01496*/
                                                                      /*CSE003*/
/* Data area SESDS used in SE0050, SE0070 and SE0170.                 **CSE003*/
/* It holds parameters returned from SE0240.                          **CSE003*/
                CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                /*CSE003*/
                MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                             DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)) /*CSE003*/
/*/COPY WNCPYSRC,SEC02023                                            */
                CHGDTAARA  DTAARA(SESDS) VALUE(' ')                   /*CSE003*/
                CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE0050')        /*CSE003*/
                CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')       /*CSE003*/
                                                                      /*CSE003*/
/*/COPY WNCPYSRC,SEC02024                                            */
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0060') THEN(DO)
                OVRDBF     FILE(TRADSX) TOFILE(TRADS) SHARE(*NO)
                GOTO CALLP
             ENDDO
/*/COPY WNCPYSRC,SEC02029                                            */
             IF COND(&PARM = 'SE0070') THEN(DO)
/*/COPY WNCPYSRC,SEC02021                                            */
                OVRDBF     FILE(DPTMVX) TOFILE(DPTMV) SHARE(*NO)
                OVRDBF FILE(DPTMVDY1) SHARE(*NO)                      /*CSE028*/
                OVRDBF FILE(DPTMVDZ1) TOFILE(DPTMVDY1) SHARE(*NO)     /*S01401*/
                OVRDBF FILE(DPTMVDZ2) TOFILE(DPTMVDY2) SHARE(*NO)     /*S01401*/
                OVRDBF FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                         /*201230*/
/*/COPY WNCPYSRC,SEC02034                                            */
                IF         COND(&S01496 *EQ 'Y') THEN(DO)             /*S01496*/
                   OVRDBF     FILE(CPOSN) SHARE(*NO)                  /*S01496*/
                ENDDO                                                 /*S01496*/
                IF         COND(&CSE006 *EQ 'Y') THEN(DO)             /*CSE006*/
             OVRDBF     FILE(SEDPMVL1) TOFILE(SEDPMVL2) SHARE(*NO)    /*CSE006*/
                ENDDO                                                 /*CSE006*/
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0080') THEN(DO)
             IF &EX THEN(DO)                                          /*E17618*/
        RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&EXST)                /*S01169*/
        IF    COND((&EXST *NE 'A') *AND (&EXST *NE 'T') *AND (&EXST +
                  *NE 'C') *AND (&EXST *NE 'F'))      THEN(DO)        /*S01169*/
              SNDPGMMSG  MSG('Option unavailable - EXTEL processing +
                  not complete') TOPGMQ(*EXT) TOMSGQ(MOPERQ)          /*S01169*/
              GOTO  ENDPGM                                            /*S01169*/
              ENDDO                                                   /*S01169*/
              ENDDO                                                   /*E17618*/
                OVRDBF     FILE(PRICEX) TOFILE(PRICE) SHARE(*NO)
                OVRDBF     FILE(EXVALDX) TOFILE(EXVALD) SHARE(*NO)    /*S01169*/
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0090') THEN(DO)
                OVRDBF     FILE(TRADSX) TOFILE(TRADS) SHARE(*NO)
/***************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)     * *S01117*/
                GOTO CALLP
             ENDDO
/**/                                                                  /*103747*/
/** Check if file is being used by another workstation             */ /*103747*/
/**/                                                                  /*103747*/
             IF         COND(&PARM *EQ 'SE0110') THEN(DO)             /*103747*/
             ALCOBJ     OBJ((SEACKD *FILE *SHRRD)) WAIT(0)            /*103747*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))         /*103747*/
             DLCOBJ     OBJ((SEACKD *FILE *SHRRD))                    /*103747*/
             ALCOBJ     OBJ((XSEACKD *FILE *SHRRD)) WAIT(0)           /*103747*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))         /*103747*/
             DLCOBJ     OBJ((XSEACKD *FILE *SHRRD))                   /*103747*/
             GOTO       CMDLBL(CONTINUE)                              /*103747*/
 MSG:                                                                 /*103747*/
             RTVMSG     MSGID(SCM0113) MSGF(MIDASMSG) MSG(&MESSAGE)   /*103747*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)     /*103747*/
             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)   /*103747*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*103747*/
             CHGDTAARA  DTAARA(MIDASMSG (10 1)) VALUE('1')            /*103747*/
             CALL       PGM(SCC0010) PARM('SEC02  ' 'ENTER' ' ')      /*103747*/
             GOTO       CMDLBL(ENDPGM)                                /*103747*/
 CONTINUE:                                                            /*103747*/
             GOTO       CMDLBL(CALLP)                                 /*103747*/
             ENDDO                                                    /*103747*/
    /*       IF COND(&PARM = 'SE0120') THEN(DO)                  */  /*S01169*/
             IF COND(&PARM = 'SE0121') THEN(DO)                      /*S01169*/
    /*          OVRDBF     FILE(SECHGX) TOFILE(SECHG) SHARE(*NO) */  /*S01169*/
                OVRDBF     FILE(SECGTX) TOFILE(SECGT) SHARE(*NO)     /*S01169*/
                OVRDBF     FILE(SECGTX2) TOFILE(SECGT) SHARE(*NO)    /*S01446*/
/*/COPY WNCPYSRC,SEC02007                                            */
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0130') THEN(DO)
/*/COPY WNCPYSRC,SEC02008                                            */
                OVRDBF     FILE(SEDEVX) TOFILE(SEDEV) SHARE(*NO)
                GOTO CALLP
             ENDDO
 /***********IF COND(&PARM = 'SE0140') THEN(DO)                    */ /*E24417*/
 /***********   OVRDBF     FILE(SLIMDX) TOFILE(SLIMD) SHARE(*NO)   */ /*E24417*/
 /***********   GOTO CALLP                                         */ /*E24417*/
 /***********ENDDO                                                 */ /*E24417*/
             IF COND(&PARM = 'SE0141') THEN(DO)
                OVRDBF     FILE(SLIMEX) TOFILE(SLIME) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0142') THEN(DO)
                OVRDBF     FILE(SLIMFX) TOFILE(SLIMF) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0143') THEN(DO)
                OVRDBF     FILE(SLIMGX) TOFILE(SLIMG) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0144') THEN(DO)
                OVRDBF     FILE(SLIMHX) TOFILE(SLIMH) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0145') THEN(DO)
                OVRDBF     FILE(SLIMIX) TOFILE(SLIMI) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0150') THEN(DO)
                OVRDBF     FILE(FUND1) TOFILE(FUNDS) SHARE(*NO)
                GOTO CALLP
             ENDDO
             IF COND(&PARM = 'SE0160') THEN(DO)
                OVRDBF     FILE(LMTPDX) TOFILE(LMTPD) SHARE(*NO)
                GOTO CALLP
             ENDDO
/*/COPY WNCPYSRC,SEC02032                                            */
             IF COND(&PARM = 'SE0170') THEN(DO)
/*              OVRDBF     FILE(POSETX) TOFILE(POSET) SHARE(*NO) */   /*E13952*/
/***************OVRDBF     FILE(POSET) TOFILE(POSET1) SHARE(*NO) E13952 S01117*/
/*/COPY WNCPYSRC,SEC02009                                            */
             IF         COND(&CSE023 *EQ 'Y') THEN(DO)                /*186055*/
                OVRDBF     FILE(POSETX) TOFILE(POSET7) SHARE(*NO)     /*186055*/
             ENDDO                                                    /*186055*/
             ELSE       CMD(DO)                                       /*186055*/
                OVRDBF     FILE(POSETX) TOFILE(POSET1) SHARE(*NO)     /*E13952*/
             ENDDO                                                    /*186055*/
                OVRDBF     FILE(POSETDZ1) TOFILE(POSETDY1) SHARE(*NO) /*S01401*/
                OVRDBF     FILE(POSETDZ2) TOFILE(POSETDY2) SHARE(*NO) /*S01401*/
/*/COPY WNCPYSRC,SEC02013                                            */
             ENDDO
         IF COND(&PARM = 'SE0190') THEN(DO)                           /*S01269*/
/*/COPY WNCPYSRC,SEC02025                                            */
/*  CHECK IF DTAARA/SESDS EXISTS. IF NOT, CREATE IT.                    S01269*/
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                   /*S01269*/
             MONMSG     MSGID(CPF9800) EXEC(DO)                       /*S01269*/
                                                                      /*S01220*/
/************CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(36)*S01269**S01220*/
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)       /*S01220*/
                                                                      /*S01220*/
/************CHGDTAARA  DTAARA(SESDS (10 9)) VALUE('000000000')*S01269**S01117*/
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')          /*S01117*/
             ENDDO                                                    /*S01269*/
                                                                      /*S01269*/
/*  CLEAR DTAARA/SESDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.            S01269*/
/*                     AND SET ZONED FIELDS                             S01269*/
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE(&PARM)              /*S01269*/
              OVRDBF     FILE(TRAUT) SHARE(*NO)                       /*S01269*/
              OVRDBF FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)       /*S01401*/
              OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)       /*S01401*/
              OVRDBF FILE(TRADSDY1) SHARE(*NO)                        /*CSE028*/
              OVRDBF FILE(SEPCBD) SHARE(*NO)                          /*CSE028*/
              OVRDBF FILE(SEPCCD) SHARE(*NO)                          /*CSE028*/
/*/COPY WNCPYSRC,SEC02035                                            */
                IF         COND(&S01496 *EQ 'Y') THEN(DO)             /*125378*/
                   OVRDBF     FILE(CPOSN) SHARE(*NO)                  /*125378*/
                ENDDO                                                 /*125378*/
/*************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)*S01269* *S01117*/
             ENDDO                                                    /*S01269*/
/*           IF COND(&PARM = 'SE2010') THEN(DO)             S01129*/  /*S01322*/
/*              OVRDBF     FILE(SECTPX) TOFILE(SECTP) SHARE(*NO)      /*S01322*/
/*              GOTO CALLP                                  S01129*/  /*S01322*/
/*           ENDDO                                          S01129*/  /*S01322*/
/*           IF COND(&PARM = 'SE2011') THEN(DO)             S01129*/  /*S01322*/
/*              OVRDBF     FILE(TRADAX) TOFILE(TRADA) SHARE(*NO)      /*S01322*/
/*************OVRDBF     FILE(CLINTX) TOFILE(CLINT) SHARE(*NO)*S01129* *S01117*/
/*           ENDDO                                          S01129*/  /*S01322*/
/**/
CALLP:
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/*/COPY WNCPYSRC,SEC02019                                            */
/*****IF COND((&PARM='SE0050') *OR (&PARM='SE0180')) THEN(DO)*S01269****CSE010*/
/*/COPY WNCPYSRC,SEC02010                                            */
          IF COND((&PARM = 'SE0050') *OR (&PARM = 'SE0180') *OR +
             (&PARM = 'SE0043')) THEN(DO)                             /*CSE010*/
             CALL       PGM(&PARM) PARM(' ' '      ')                 /*S01269*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*S01269*/
                ROLLBACK                                              /*S01269*/
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)    /*S01269*/
                GOTO ENDPGM                                           /*S01269*/
               ENDDO                                                  /*S01269*/
/*/COPY WNCPYSRC,SEC02011                                            */
      ENDDO                                                           /*S01269*/
      ELSE       CMD(DO)                                              /*S01269*/
             IF COND(&PARM = 'SE0040') THEN(DO)                       /*CSE007*/
/******         CALL    PGM(&PARM) PARM(' ' ' ' ' ' ' ')  /*CSE007*/  /*138957*/
                CALL    PGM(&PARM) PARM(' ' ' ' ' ' ' ' ' ')          /*138957*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)    /*CSE007*/
                ROLLBACK                                              /*CSE007*/
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)    /*CSE007*/
                GOTO ENDPGM                                           /*CSE007*/
                ENDDO                                                 /*CSE007*/
/*/COPY WNCPYSRC,SEC02026                                            */
             ENDDO                                                    /*CSE007*/
             ELSE       CMD(DO)                                       /*CSE007*/
/*/COPY WNCPYSRC,SEC02012                                            */
             IF COND((%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)             /*CPB001*/
                CHGJOB SWS(XXX1XXXX)                                  /*CPB001*/
             ENDDO                                                    /*CPB001*/
             CALL       PGM(&PARM)
             CHGJOB SWS(XXX0XXXX)                                     /*CPB001*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO                                                    /*CSE007*/
/*/COPY WNCPYSRC,SEC02020                                            */
      ENDDO                                                           /*S01269*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC02004                                            */
/**/                                                                  /*S01408*/
             ENDDO
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))      */ /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01117*/
                ROLLBACK
/*/COPY WNCPYSRC,SEC02030                                            */
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,SEC02031                                            */
             ENDDO
/* */                                                                 /*S01401*/
/** else, if no errors and if Trades or Depot Movements just          /*S01401*/
/** maintained, then submit confirmations to batch.                   /*S01401*/
/* */                                                                 /*S01401*/
             ELSE (DO)                                                /*S01401*/
               IF ((&PARM *EQ 'SE0050') *OR (&PARM *EQ 'SE0070') +
                  *OR (&PARM *EQ 'SE0180') *OR (&PARM *EQ +
                  'SE0190')) THEN(DO)                                 /*S01401*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC02001                                            */
/**/                                                                  /*S01408*/
/**/                                                                  /*084923*/
                 SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)              /*084923*/
/**/                                                                  /*084923*/
/************    SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +                              /*CSC023*/
/************           RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +                            /*CSC023*/
/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                   /*S01401*/          /*CSC023*/
/************    SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                             /*CSC023*/
/************           RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                           /*CSC023*/
/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                   /*S01401*/          /*CSC023*/
                 SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
                 SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SEC02002                                            */
/**/                                                                  /*S01408*/
               ENDDO                                                  /*S01401*/
             ENDDO                                                    /*S01401*/
/**/
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('          ')                                    /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PARM *EQ 'SE0070') THEN(DO)                                 /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('SE0070')                                        /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PARM *EQ 'SE0170') THEN(DO)                                 /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('SE0170')                                        /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND((&PARM *EQ 'SE0180') *OR +
                             (&PARM *EQ 'SE0190')) THEN(DO)                               /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('SETRADUPD')                                     /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PMOD *NE '          ') THEN(DO)                             /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(''' +
                        *CAT &PMOD *CAT ''' ''SE'')')                                     /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             ENDDO                                                                        /*CRE020*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CRE020*/
ERR:                                                                                      /*CRE020*/
             RCLACTGRP  ACTGRP(*ELIGIBLE)                                                 /*CRE020*/
             RCLRSC                                                                       /*CRE020*/
                                                                                          /*CRE020*/
             RETURN                                                                       /*CRE020*/
/**/
ENDPGM:      DLTOVR     *ALL
             CHGJOB     SWS(0XXXXXXX)                                                     /*CSD031*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
