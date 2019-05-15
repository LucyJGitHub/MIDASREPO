/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Input cycle initiation')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0411 - Input Cycle Initiation                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. CMC004             Date 13Jul18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD029791           Date 25Aug14              */
/*                      MD029611           Date 08Aug14              */
/*                      MD021155           Date 11Jul13              */
/*                      CSC056             Date 06Aug12              */
/*                      CRE041             Date 28Sep12              */
/*                      CRE075             Date 06Dec10              */
/*                      BUG27831B          Date 11Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27549           Date 30Apr10              */
/*                      CAP204A            Date 05Apr10              */
/*                      CAP204             Date 15Feb10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG21251           Date 06Oct08              */
/*                      CSW208             Date 15Apr08              */
/*                      BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      237113             Date 01Dec06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      242256             Date 10Oct06              */
/*                      243009             Date 19Oct06              */
/*                      BUG9619            Date 01Feb06              */
/*                      BUG10878           Date 16Mar06              */
/*                      CRN001             Date 07Dec05              */
/*                      CSC023             Date 02Feb04              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      190797             Date 27Apr01              */
/*                      208421             Date 14Aug02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/*                      CIR007             Date 11May01              */
/*                      CDE002             Date 08Jun01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CSE009             Date 15Mar99              */
/*                      CEU009             Date 19Feb98              */
/*                      117321             Date 26FEB98              */
/*                      122890             DATE 26FEB98              */
/*                      105494             DATE 17FEB98              */
/*                      115439             DATE 30JAN98              */
/*                      105757             DATE 24SEP97              */
/*                      122096             DATE 22AUG97              */
/*                      118603             DATE 27AUG97              */
/*                      122278             DATE 27AUG97              */
/*                      CCB002             DATE 03SEP96              */
/*                      110242             DATE 07NOV96              */
/*                      S01408             DATE 03OCT96              */
/*                      CMC001             DATE 23AUG96              */
/*                      S01408             DATE 17JUN96              */
/*                      S01408             DATE 11JUN96              */
/*                      101282             DATE 26MAR96              */
/*                      S01408             DATE 01APR96              */
/*                      S01408             DATE 20FEB96              */
/*                      099264             DATE 06FEB96              */
/*                      S01408             DATE 08JAN96              */
/*                      S01408             DATE 08SEP95              */
/*                      086919             DATE 28APR95              */
/*                      CRT001             DATE 28FEB95              */
/*                      CSC001             DATE 04MAR95              */
/*                      083799             DATE 23FEB95              */
/*                      S01522             DATE 07DEC94              */
/*                      S01502             DATE 02DEC94              */
/*                      077466             DATE 17OCT94              */
/*                      S01467             DATE 28OCT94              */
/*                      S01491             DATE 01OCT94              */
/*                      S01495 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CMC004 - Update MC Control groups after FC Transfer         */
/*       MD046248 - Finastra Rebranding                              */
/*       MD029791 - Remove calling of EMC09 and move it in SCC41119  */
/*       MD029611 - EMCEXX1 Exposure Header file was corrupted       */
/*                  after COB                                        */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - SDSTAT still referenced                          */
/*       CSC056 - COB Restructure - SC COB Optimisation Phase 1      */
/*              - Physically Deleted lines (house kept)              */
/*       CRE041 - Enhancements to Customer Exchanges                 */
/*       CRE075 - Effective Date for Retail Accounts                 */
/*       BUG27831B - COB performance issue                           */
/*       BUG27549 - SCC0411 00001 errors                             */
/*       CAP204A - Teller Related APIs - Account Transfer            */
/*       CAP204 - Teller Related APIs - Account Transfer             */
/*       BUG21251 - Branch details not changed at DST change date    */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       BG18886 - Amend non-standard codes.                         */
/*       237113 - Call MMEXDEAMP drop program for UDF T_GZDEAMEX     */
/*       242256 - Same fix as 243009.                                */
/*       243009 - Reverse codes introduced by CRN001 to allow MM0102 */
/*                to run.                                            */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BUG10878 - SCC0411 00001- error in copying ACCNTAB to       */
/*                  GLACBTPD                                         */
/*       CRN001 - Temporary work around                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       190797 - Check if U7, U8 are on after call to REC4203       */
/*       208421 - Condition putback of DLOPOSPD                      */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CIR007 - Overnight Index Swaps                              */
/*     CDE002 - Send a bank message if CCRM is off and Revenue is on */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     CSE009 - Telekurs Changes                                     */
/*     CEU009 - EMU Base Currency for Dealing Conversion             */
/*     117321 - Remove the reference to removed LF HELDI             */
/*     122890 - First 40 positions corrupted if restart at h: tag    */
/*     105494 - PGM GL2551 NEVER RUN AT EOM                          */
/*     115439 - Remove parameter of FC0010.  Report sequence         */
/*               should be retrieved and updated in FC0010.          */
/*     105757 - Add recovery for FT components                       */
/*     122096 - Addition of CLRPFM for SDDELRPD.                     */
/*     118603 - Daily Teller Transaction File Creation (REC4203) is  */
/*              only executed when CRT001 is on. Hence, clients      */
/*              using Cashier Interface encounter previous day's     */
/*              teller transactions appearing next day.              */
/*     122278 - At present the SCCLR* jobs are submitted to MCOBQ    */
/*              which prevents the COB components running until      */
/*              the clears have finished.                            */
/*               - Change the submission of the file clearing jobs   */
/*                 so that they are submitted to JOBQ/BULKTJOBQ.     */
/*               - Codestripped to make the source more readable.    */
/*     CCB002 - COB Performance Enhancements                         */
/*              Access now via access object                         */
/*              Change MEMOS processing to use access objects.       */
/*     110242 - Change defaults for SBMJOB cmd to take *JOBD         */
/*     S01408 - Addition of core hook SCC0411008                     */
/*     CMC001 - Clear Real Time Postings file GERTPD if Management   */
/*              Accounts Enhancement for PCA is installed.           */
/*     S01408 - Addition of core hook SCC0411007                     */
/*     S01408 - Addition of core hook SCC0411006                     */
/*              Addition of core hook SCC0411005                     */
/*     101282 - Deal status flag not being reset on ABDEALPP. Need   */
/*              to call AB8010 after MM0102 has completed            */
/*              successfully. This is usually called by DLC6030,     */
/*              but DLC6030 is only called if TM is on, so need to   */
/*              call AB8010 if TM not installed but AB is.           */
/*     S01408 - Addition of core hook SCC0411003                     */
/*              Addition of core hook SCC0411004                     */
/*     S01408 - Addition of core hook SCC0411INT                     */
/*     099264 - Program skips processing on restart because &SDMMOD  */
/*              not set up correctly. Pgm amended to use &SDMMOD     */
/*              (&FMT is now redundant) and to set it up at the      */
/*              start of the program.                                */
/*            - Produce dump if abnormal termination                 */
/*       S01408 - Addition of core hook SCC0411002                   */
/*       S01408 - Addition of core hook SCC0411001                   */
/*       086919 - Move processing for the following into a new       */
/*                component:                                         */
/*                - Leo processing (SCC1112).                        */
/*       CRT001 - Retail Teller System                               */
/*       CSC001 - Change journal receivers by SCC1716 if installed   */
/*                Move submit of Archive and RCF monitor to new      */
/*                components                                         */
/*       083799 - Use &FMT instead of &MMOD to test module           */
/*       S01522 - User Defined Correspondence                        */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       077466 - Move some processing into separate components.     */
/*                - Move TSC8570 processing to TSC8570 component.    */
/*                - Move HAFMONITOR PROCESSING TO HFC0251 component. */
/*                - Move change of MPHAS to 'A' from this program    */
/*                  to ICIFINISH.                                    */
/*                - Move SWIFT compression startup to MSC0204        */
/*                  component.                                       */
/*                - Move Telex message conversation start to         */
/*                  MTC4011 component.                               */
/*                - Move TRAM startup to CFC0081.                    */
/*                - Move EXTEL transmission processing to SEC3109A   */
/*                  component.                                       */
/*       S01467 - If any of the Midas Leo Integration enhancement    */
/*                numbers are present (S01467, S01473, S01474,       */
/*                S01487, and S01492), save the user library list    */
/*                to a data area for use by the Leo system.          */
/*       S01491 - Autocall.                                          */
/*       S01495 - COB Enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

/* Initial processing                                              */

/*/COPY WNCPYSRC,SCC0411INT                                        */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TSTATUS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
/**********  DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                            */ /*MD021155*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,SCC0411010                                          */
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)
/**********  DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                          */ /*CSE009 MD021155*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                       */ /*CSE009 MD021155*/

             DCL        VAR(&CSW208) TYPE(*CHAR) LEN(1) VALUE('N')                      /*BUG21251*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                  /*BUG21251*/
             DCL        VAR(&CRE041) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CRE041*/
/**********  DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)                      /*MD029611 MD029791*/
/*/COPY WNCPYSRC,SCC0411014                                          */

/* Global MONMSG */                                                                       /*CSC056*/
                                                                                          /*CSC056*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)

/* Reset position 60 of dtaara DLSTAT                              */
/* Reset flag used to check if cm0240 has been previously run      */
/* during this eod                                                 */

             CHGDTAARA  DTAARA(DLSTAT (60 1)) VALUE('N')

/*/COPY WNCPYSRC,SCC0411007                                          */

             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)

             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
                                                                                          /*CIR007*/
/* Send the message to MRUNQ                                       */                     /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&MSG) VALUE('Input cycle initiation +
                          executing')                                                     /*CSC056*/
             SNDPGMMSG  TOMSGQ(MOPERQ) MSG(&MSG)                                          /*CSC056*/
                                                                                          /*CSC056*/
/**Create*variable*&DPLIB*for*CPYF*at*Recovery*Point*I.*************          */ /*CIR007 MD021155*/
/**********  RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                        */ /*CIR007 MD021155*/
/**********  CHGVAR     VAR(&PRE) VALUE(%SUBSTRING(&SDSTAT 6 2))              */ /*CIR007 MD021155*/
/**********  CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')                 */ /*CIR007 MD021155*/

/*/COPY WNCPYSRC,SCC0411016                                          */

/* Skip to Treasury Management I/C updates when TSTATUS is         */
/* 'DRSRECOV'                                                      */

             RTVDTAARA  DTAARA(TSTATUS) RTNVAR(&TSTATUS)
             IF         COND(&TSTATUS *EQ 'DRSRECOV') THEN(DO)
                                                                                          /*CSC056*/
/* Call SCC041119 */                                                                      /*CSC056*/
                                                                                          /*CSC056*/
             CALL       PGM(SCC0411119)                                                   /*CSC056*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBETAG))                                                 /*CSC056*/
                                                                                          /*CSC056*/
/* Reset TSTATUS and exit the code */                                                     /*CSC056*/
                                                                                          /*CSC056*/
             CHGDTAARA  DTAARA(TSTATUS) VALUE('NORMAL  ')                                 /*CSC056*/
             GOTO       CMDLBL(THEEND)                                                    /*CSC056*/
             ENDDO

/* Check if CSW208 is switched on */                                                    /*BUG21251*/
             CALL       PGM(SWIF2008) PARM(&PRTCD)                                      /*BUG21251*/
             IF         COND(&PRTCD *EQ 'CSW2008')  THEN(DO)                            /*BUG21251*/
             CHGVAR     VAR(&CSW208) VALUE('Y')                                         /*BUG21251*/
             ENDDO                                                                      /*BUG21251*/
                                                                                        /*BUG21251*/
/*/COPY WNCPYSRC,SCC0411022                                          */
TAGI:                                                                                   /*BUG27549*/
/*/COPY WNCPYSRC,SCC0411024                                          */


/*/COPY WNCPYSRC,SCC0411029                                          */
/* If CSC001 then save in use SCC1716 always                       */

             CHGVAR     VAR(&RTN) VALUE('       ')
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CSC001')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
             IF         COND(&RTN *EQ '       ') THEN(DO)
             ENDDO
             ELSE       CMD(DO)

/* Save journal receivers - Program SDC1715                        */
/* If database backup is *DISK call SCC1716                        */

             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
             IF         COND(%SST(&CB_AUTO 88 5) *EQ '*DISK') THEN(DO)
               IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                            CMDLBL(ENDCLPGM))
               IF         COND(%SST(&JNSTAT 106 5) *NE '00000') +
                            THEN(DO)
               CALL       PGM(SDC1760)
               ENDDO
             ENDDO
             ELSE       CMD(DO)
               CALL       PGM(SDC1715) PARM('0')
             ENDDO
             ENDDO
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))

             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                /*BUG21251*/
             IF         COND(&CSW208 *EQ 'Y') THEN(DO)                                  /*BUG21251*/
             CPYF       FROMFILE(SDDSTCPD) TOFILE(QTEMP/XSDDSTCPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)                               /*BUG21251*/
             CPYF       FROMFILE(SDBRCHPD) TOFILE(QTEMP/XSDBRCHPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)                               /*BUG21251*/
             CALL       PGM(SD001007)                                                     /*CSW208*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBETAG))                                                 /*CSW208*/
             ENDDO                                                                      /*BUG21251*/
/**********                                                                    /*MD029611 MD029791*/
/***Exposure Management                                              */        /*MD029611 MD029791*/
/**********                                                                    /*MD029611 MD029791*/
/**********  IF         COND(%SST(&MMOD 7 1) *EQ 'Y') THEN(DO)                 /*MD029611 MD029791*/
/**********  RTVDTAARA  DTAARA(EMSTAT *ALL) RTNVAR(&EMSTAT)                    /*MD029611 MD029791*/
/**********  IF         COND(%SST(&EMSTAT 2 1) *EQ 'N') THEN(DO)               /*MD029611 MD029791*/
/**********  CALL       PGM(EMC09)                                             /*MD029611 MD029791*/
/**********  ENDDO                                                             /*MD029611 MD029791*/
/**********  ENDDO                                                             /*MD029611 MD029791*/
                                                                                          /*CMC004*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*CMC004*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CMC004*/
             CHGVAR     VAR(&SARD) VALUE('CMC004')                                        /*CMC004*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CMC004*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*CMC004*/
             CPYF       FROMFILE(GEAA2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GECL2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEDL2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEFF2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEIC2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEIER2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)     /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GELE2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEPC2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GESF2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GESP2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(CLEAR2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)     /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEFP2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEST1PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEHM2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GENA2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GESC1PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEPM2PD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)      /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             CPYF       FROMFILE(GEXBPD) TOFILE(GLEODPTD) MBROPT(*ADD) FMTOPT(*MAP)       /*CMC004*/
             MONMSG     MSGID(CPF2817 CPF2972)                                            /*CMC004*/
             ENDDO                                                                        /*CMC004*/
                                                                                          /*CMC004*/

/*/COPY WNCPYSRC,SCH00043                                            */
/*/COPY WNCPYSRC,SCC0411030                                          */
/*/COPY WNCPYSRC,SCH00047                                            */
/*/COPY WNCPYSRC,SCH00048                                            */
/*/COPY WNCPYSRC,SCH00044                                            */
/*/COPY WNCPYSRC,SCH00042                                            */
/*/COPY WNCPYSRC,SCH00045                                            */

             GOTO       ENDCLPGM

DBETAG:

/* Retrieve database error information from LDA                    */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             IF         COND(&CSW208 *EQ 'Y') THEN(DO)                                  /*BUG21251*/
             CPYF       FROMFILE(XSDDSTCPD) TOFILE(SDDSTCPD) +
                           MBROPT(*REPLACE)                                             /*BUG21251*/
             CPYF       FROMFILE(XSDBRCHPD) TOFILE(SDBRCHPD) +
                           MBROPT(*REPLACE)                                             /*BUG21251*/
             ENDDO                                                                      /*BUG21251*/
             ENDDO

ABNOR:
             CHGJOB     SWS(XXXXXX11)

/*/COPY WNCPYSRC,SCC0411005                                          */

             SNDPGMMSG  MSG('I/C Initiation  ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)

/*/COPY WNCPYSRC,SCC0411006                                          */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

/* If front office DRS installed, call CA0080 to ensure that the   */
/* after hours flag is set in CAAHFDPP so that PCS can continue    */

             IF         COND(%SST(&MMOD 12 1) *EQ 'Y') THEN(DO)
               CHGJOB     SWS(00000000)
               MONMSG     MSGID(CPF0000)
               CALL       PGM(CA0080) PARM(' ')
               MONMSG     MSGID(CPF0000)
             ENDDO

             GOTO       THEEND
                                                                                          /*CRE041*/
ENDCLPGM:                                                                                 /*CSC056*/
/*/COPY WNCPYSRC,SCH00049                                            */

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
THEEND:      ENDPGM
