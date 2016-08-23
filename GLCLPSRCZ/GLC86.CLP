/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL BSPL Reports')                               */
/********************************************************************/
/*                                                                  */
/*       Midas General Ledger Module                        */
/*                                                                  */
/*       GLC86 - Balance Sheet Profit & Loss Report (Rewritten)     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CCB016             Date  31May07            */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                       BG18886           Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      124974             Date 20May98              */
/*                      CEU011             Date 11Mar98              */
/*                      S01408             DATE  04Aug95            */
/*                      S01408             DATE  10Apr95            */
/*                      S10736             DATE  06OCT92            */
/*                      E28177             DATE  06SEP91            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       CCB016 - CoB Performance Enhancements                      */
/*                Optimize OPNQRYF command.                         */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       CEU011  - EMU Position/Risk Reporting                       */
/*       124974 - BSPL report does not have the heading for each    */
/*                stage reported, e.g. 'AFTER FINAL POST'.  Applied */
/*                fix 063148.                                       */
/*       S01408  -  CORE HOOK ADDED GLC86001                        */
/*               -  CORE HOOK ADDED GLC86002                        */
/*       S01408  -  CORE HOOK ADDED GLC86INT                        */
/*               -  CORE HOOK ADDED GLC86MP1                        */
/*               -  CORE HOOK ADDED GLC86MP2                        */
/*       S10736  -  Add processing for MC module. The bulk of the   */
/*                  processing for S10736 is between the comment    */
/*                  lines containing 'S10736 - START' and           */
/*                  'S10736 - END'. Tags NOTMC and QCMDEXC have     */
/*                  been added, and new parameters are passed to    */
/*                  GL0761. Processing to set up field GLENT2       */
/*                  has been added to existing OPNQRYF's.           */
/*                                                                  */
/*       E28177  -  Add Option to print Zero Balances,              */
/*                  Re-inserted Monitor Msg, and ACCODE 'daily'     */
/*                  option previously crashed.                      */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*/COPY WNCPYSRC,GLC86003                                            */
/*********** PGM        PARM(&RSEQ &RLEV &RENT &RPARM) ***/           /*124974*/
             PGM        PARM(&RUN &RSEQ &RLEV &RENT &RPARM)           /*124974*/
/*/COPY WNCPYSRC,GLC86004                                            */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/**/
             DCL        VAR(&LDA)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR)  LEN(50)
             DCL        VAR(&JOB)  TYPE(*CHAR)  LEN(10)
             DCL        VAR(&SWS)  TYPE(*CHAR)  LEN(8)
/**/
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSLV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRCE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ROUD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ZERO) TYPE(*CHAR) LEN(1)                /*E28177*/
/**/
             DCL        VAR(&SEL1) TYPE(*CHAR) LEN(26)
             DCL        VAR(&SEL2) TYPE(*CHAR) LEN(25)
             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEY3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&GRP1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENTY) TYPE(*CHAR) LEN(10) VALUE('''"   +
                          "''')
/************DCL********VAR(&OPQF) TYPE(*CHAR) LEN(700)*******S10736**/
             DCL        VAR(&OPQF) TYPE(*CHAR) LEN(1000)    /*S10736*/
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */                     /*CCB020*/
             DCL        VAR(&EVCD) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MCGRP) TYPE(*CHAR) LEN(2) /* S10736 +
                          Group code */
             DCL        VAR(&MCRPNC) TYPE(*CHAR) LEN(4) VALUE('    ') +
                          /* S10736 Relative period number */
             DCL        VAR(&MCRPNB) TYPE(*DEC) LEN(3) VALUE(0) +
                          /* S10736 Relative period number */
             DCL        VAR(&MCTRM) TYPE(*CHAR) LEN(1) /* S10736 +
                          Term */
             DCL        VAR(&MCTYP) TYPE(*CHAR) LEN(1) /* S10736 +
                          Type */
             DCL        VAR(&MCANL) TYPE(*CHAR) LEN(9) /* S10736 +
                          "Analysis by.." key fields */
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          S10736 Index for entity sort */
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0) /* S10736 Index +
                          for entity sort */
             DCL        VAR(&WLIST) TYPE(*CHAR) LEN(300) /* S10736 +
                          Work field to hold sorted entity keys */
             DCL        VAR(&FLAG) TYPE(*LGL) VALUE('0') /* S10736 +
                          Flag for set up of entity MAPFLD */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) /* S10736 +
                          Return Code */
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7) /* S10736 +
                          Relative Reriod Key */
             DCL        VAR(&CCCY) TYPE(*CHAR) LEN(3) /* S10736 +
                          Control Group CCy */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /* S10736 +
                          Return string */
             DCL        VAR(&DATE) TYPE(*DEC) LEN(5) /* S10736 +
                          Period End Date */
             DCL        VAR(&DATT) TYPE(*CHAR) LEN(5) /* S10736 +
                          Period To Date */
             DCL        VAR(&DATS) TYPE(*DEC) LEN(5) /* S10736 +
                          Term Start Date */
             DCL        VAR(&DATF) TYPE(*CHAR) LEN(5) /* S10736 +
                          Term From Date */
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(5)                  /*124974*/
                                                                                          /*CCB020*/
/* Parameter for call to CBC001001 */                                                     /*CCB020*/
             DCL        VAR(&WCOB) TYPE(*CHAR) LEN(4)                                     /*CCB020*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86INT                                            */
                                                                      /*S01408*/
             DCLF       FILE(GLPERDL5) /* S10736 Period file */
/**/
/* Global monitor message */
/**/
/**/                                       /*E28177*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/                                       /*E28177*/
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,GLC86010                                            */
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&RSNO) VALUE(%SST(&RPARM 2 1))
             CHGVAR     VAR(&RSLV) VALUE(%SST(&RPARM 3 1))
             CHGVAR     VAR(&RPCD) VALUE(%SST(&RPARM 4 1))
             CHGVAR     VAR(&SRCE) VALUE(%SST(&RPARM 5 1))
             CHGVAR     VAR(&ROUD) VALUE(%SST(&RPARM 6 1))
             CHGVAR     VAR(&ZERO) VALUE(%SST(&RPARM 7 1))           /*E28177*/
 
/* *******************************************************************/
/* S10736 - START This is the main part of S10736                    */
/* *******************************************************************/
 
/*/COPY WNCPYSRC,GLC86013                                            */
/* If group code not entered, process term 'D' and type 'M' as for */
/* daily reporting */
 
             CHGVAR     VAR(&MCGRP) VALUE(%SST(&RPARM 8 2))
             CHGVAR     VAR(&MCRPNC) VALUE(%SST(&RPARM 10 4))
             CHGVAR     VAR(&MCTRM) VALUE(%SST(&RPARM 14 1))
             CHGVAR     VAR(&MCTYP) VALUE(%SST(&RPARM 15 1))
             CHGVAR     VAR(&MCANL) VALUE(%SST(&RPARM 16 9))
 
/*/COPY WNCPYSRC,GLC86014                                            */
/* If Type 'B' entered, process for AS AT BALANCE DATE  */
 
             IF         COND(&SRCE *EQ ' ') THEN(DO)
                 IF      COND(&MCTYP *EQ 'B') +
                          THEN(CHGVAR VAR(&SRCE) VALUE('Y'))
                 ELSE    CMD(CHGVAR VAR(&SRCE) VALUE('D'))
             ENDDO
 
/* If Group not entered, then process as for a non-MC system */
 
             IF         COND(&MCGRP *EQ '  ') THEN(GOTO CMDLBL(NOTMC))
/*/COPY WNCPYSRC,GLC86008                                            */
 
/* Access Term From and to Dates */
 
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &MCGRP +
                          &DSFDY)
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
             CHGVAR     VAR(&CCCY) VALUE(%SST(&DSFDY 38 3))
             CHGVAR     VAR(&MCRPNB) VALUE(&MCRPNC)
             CALL       PGM(AORPERR0) PARM(&RTCD '*SETLL' &PKEY   +
                          &MCRPNB  &DSFDY)
 
             RCVF
 
             IF         COND(&MCTRM *EQ 'Y') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTSOYD - 1))
 
             IF         COND(&MCTRM *EQ '1') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTST1D - 1))
 
             IF         COND(&MCTRM *EQ '2') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTST2D - 1))
 
             IF         COND(&MCTRM *EQ 'D') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTSPDD - 1))
 
             CHGVAR     VAR(&DATE) VALUE(&DTEPDD)
 
             CHGVAR     VAR(&DATF) VALUE(&DATS)
             CHGVAR     VAR(&DATT) VALUE(&DATE)
             CHGVAR     VAR(&EVCD) VALUE(&DATT *TCAT &DATF)
 
/* Set up OPNQRYF parameter for QCMDEXC */
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF')
 
/* Set up files to use (use GLHIBLPD member for group code). Join to */
/* SDACRCL0 for report set if report set parameter is not 'C', and   */
/* to SDBRCHL1 for company if report level is 'C'.                   */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FILE((GLHIBLPD' *BCAT &MCGRP *TCAT ')')
 
             IF         COND(&RSNO *NE 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(SDACRCL0)'))
 
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(SDBRCHL1)'))
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')
 
/* Set up format to use (GLBSRPPD) */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(GLBSRPPD)')
 
/* Set up query selection string, selecting on group code and */
/*  relative period number. Work amount must be non-zero to prevent */
/*  data mapping error. */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''HBPDCT *EQ ''''' *TCAT &DTPDCT +
                          *TCAT ''''' *AND HBPDYR *EQ ''''' *TCAT +
                          &DTPDYR *TCAT ''''' *AND HBPDNY *EQ ''''' +
                          *TCAT &DTPDNY *TCAT ''''' *AND WAMT *NE 0')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86MP1                                            */
                                                                      /*S01408*/
 
/* If report set is not C, select reporting set number = parameter   */
             IF         COND(&RSNO *NE 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '*AND G6RSNO *EQ ''''' +
                          *TCAT &RSNO *TCAT ''''''))
 
/* If report level is 'B' or 'C', and entity is not blank or 'ALL'   */
/* select entity = entity parameter                                  */
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ' +
                          *AND (&RLEV *EQ 'B' *OR &RLEV *EQ 'C')) +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '*AND GLENTY *EQ ''''' *TCAT &RENT *TCAT +
                          ''''''))
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ''')')
 
/* Set up key depending on value in currency field                   */
/**********  IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +*/ /*CEU011*/
/**********               VALUE(&OPQF *BCAT 'KEYFLD((GLENTY) +     */ /*CEU011*/
/**********               (GLENT2) (GLCCY) (GLRSCD))'))            */ /*CEU011*/
             IF         COND((&CCY *EQ 'A') *OR (&CCY *EQ 'E')) +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD((GLENTY) (GLENT2) (GLCCY) +
                          (GLRSCD))'))                                /*CEU011*/
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD((GLENTY) (GLENT2) (GLRSCD) +
                          (GLCCY))'))
 
/* Join files as follows:                                            */
 
/*    If report set is not 'C', join ACOD1 to ACOD2:                 */
/*        ACOD1 = HBACCD (GLHIBLPD) + SIGN (from balance)            */
/*        ACOD2 = G6ACCD + G6DRCR (SDACRCL0)                         */
 
/*    If report level is 'C', get company from SDBRCHL1              */
/*    Branch    : HBBRCD in GLHIBLPD to A8BRCD in SDBRCHL1           */
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'JFLD(')
 
             IF         COND(&RSNO *NE 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(ACOD1 ACOD2)'))
 
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(HBBRCD A8BRCD)'))
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')
 
/* Group company, branch or entity 1 depending on value of report   */
/* level                                                            */
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'GRPFLD(A8CMCD'))
             IF         COND(&RLEV *EQ 'B') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'GRPFLD(HBBRCD'))
             IF         COND(&RLEV *NE 'B' *AND &RLEV *NE 'C') +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPFLD(GLENTY'))
 
/* Group on entity 2 and currency                                   */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'GLENT2 +
                          HBCYCD')
 
/* Group on either account code or report code depending on whether */
/* report set is 'C' or not.                                        */
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'HBACCD SIGN)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'G6RSCD SIGN)'))
 
/* Select groups with a non-zero balance */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPSLT(''GLLDBL *NE 0'')')
 
/* Set up MAPFLDs */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD(')
 
/* If report level is 'B', set entity 1 as branch code               */
/* If report level is 'C', set entity 1 as company code              */
/* Else set entity 1 to blanks                                       */
             IF         COND(&RLEV *EQ 'B') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT '(GLENTY HBBRCD)'))
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT '(GLENTY A8CMCD)'))
             IF         COND(&RLEV *NE 'B' *AND &RLEV *NE 'C') +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *TCAT +
                          '(GLENTY ''''''   '''''')'))
 
/* Set up MAPFLD for entity 2 from 'analysis' parameter - */
 
/* The 'analysis' parameter (&MCANL) refers to 'analysis' fields on */
/* GLHIBLPD in the following way- Each position in the parameter */
/* corresponds to a GLHIBLPD field, ie. 1-HBBRCD, 2-HBCUST, 3-HBACSN,*/
/* 4-HBPCCD, 5-HBBKCD, 6-HBOTTP, 7-HBTSTY, 8-HBACNB. Each position */
/* can hold a number (0-9) corresponding to the order that that */
/* field should be incorporated into the entity field (0 first), or */
/* blanks to indicate that the field is not required. */
 
/* First sort keys into order required. */
 LOOP1:      IF         COND(&I *GT 9) THEN(GOTO CMDLBL(ENDLOOP1))
             IF         COND(%SST(&MCANL &I 1) *EQ ' ') THEN(GOTO +
                          CMDLBL(NEXT))
             CHGVAR     VAR(&J) VALUE(%SST(&MCANL &I 1))
             CHGVAR     VAR(&J) VALUE((&J * 30) + 1)
             IF         COND(&I *EQ 1) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBCYCD *CAT ''''         +
                          '''''))
             IF         COND(&I *EQ 2) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBBRCD *CAT ''''         +
                          '''''))
             IF         COND(&I *EQ 3) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBCUST *CAT ''''      '''''))
             IF         COND(&I *EQ 4) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBACSN *CAT ''''          +
                          '''''))
             IF         COND(&I *EQ 5) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBPCCD *CAT +
                          ''''        '''''))
             IF         COND(&I *EQ 6) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBBKCD *CAT +
                          ''''          '''''))
             IF         COND(&I *EQ 7) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBOTTP *CAT ''''  '''''))
             IF         COND(&I *EQ 8) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBTSTY *CAT ''''  '''''))
             IF         COND(&I *EQ 9) THEN(CHGVAR VAR(%SST(&WLIST +
                          &J 30)) VALUE('HBACNB *CAT +
                          ''''      '''''))
 NEXT:       CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)
 
/* Reset index field */
 ENDLOOP1:   CHGVAR     VAR(&I) VALUE(1)
 
/* Set up MAPFLD expression */
 LOOP2:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(ENDLOOP2))
             CHGVAR     VAR(&J) VALUE(((&I - 1) * 30) + 1)
             IF         COND(%SST(&WLIST &J 30) *NE ' ') THEN(DO)
                IF         COND(*NOT &FLAG) THEN(CHGVAR VAR(&OPQF) +
                             VALUE(&OPQF *BCAT '(GLENT2 '''))
                ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                             '*CAT'))
             IF         COND(*NOT &FLAG) THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT %SST(&WLIST &J 30)))
             IF         COND(&FLAG) THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT %SST(&WLIST &J 30)))
                CHGVAR     VAR(&FLAG) VALUE('1')
                ENDDO
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP2)
 ENDLOOP2:   IF         COND(&FLAG) THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT ''')'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLENT2 '''''' '''''')'))
 
/* Report code from GLHIBLPD or SDACRCL0 depending on report set */
/**********  IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) + */                   /*CGL029*/
/**********               VALUE(&OPQF *BCAT '(GLRSCD HBACCD)'))      */                   /*CGL029*/
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLRSCD HBACCD)' *BCAT +
                          '(QQRSCD ''''''    '''''')'))                                   /*CGL029*/
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(QQRSCD ''''''    '''''')' *BCAT '(GLRSCD G6RSCD)'))           /*CGL029*/
/**********               '(GLRSCD G6RSCD)'))                        */                   /*CGL029*/
 
/* Currency from GLHIBLPD */
             IF         COND(&CCCY *EQ '   ') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLCCY HBCYCD)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLCCY ''''''' *TCAT &CCCY *TCAT ''''''')'))
 
/* If type parameter is B (balance), set work amount to closing bal */
             IF         COND(&MCTYP *EQ 'B') THEN(DO)
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(WAMT HBPDCB)')
                GOTO       CMDLBL(AMTDONE)
                ENDDO
 
/* If type parameter is A (average), set work amount to selected */
/* weighted balance divided by days from start to end of period */
             IF         COND(&MCTYP *EQ 'A') THEN(DO)
             IF         COND(&MCTRM *EQ 'D') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(WAMT HBWPBL)'))
             IF         COND(&MCTRM *EQ 'Y') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(WAMT HBWYBL)'))
             IF         COND(&MCTRM *EQ '1') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(WAMT HBWT1B)'))
             IF         COND(&MCTRM *EQ '2') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(WAMT HBWT2B)'))
                GOTO       CMDLBL(AMTDONE)
                ENDDO
 
/* If type parameter is M (movements), set work amount to selected */
/* movement field */
             IF         COND(&MCTYP *EQ 'M') THEN(DO)
                IF         COND(&MCTRM *EQ 'D') THEN(CHGVAR VAR(&OPQF) +
                             VALUE(&OPQF *BCAT '(WAMT HBPMTD)'))
                IF         COND(&MCTRM *EQ 'Y') THEN(CHGVAR VAR(&OPQF) +
                             VALUE(&OPQF *BCAT '(WAMT HBYMTD)'))
                IF         COND(&MCTRM *EQ '1') THEN(CHGVAR VAR(&OPQF) +
                             VALUE(&OPQF *BCAT '(WAMT HBT1MT)'))
                IF         COND(&MCTRM *EQ '2') THEN(CHGVAR VAR(&OPQF) +
                             VALUE(&OPQF *BCAT '(WAMT HBT2MT)'))
                GOTO       CMDLBL(AMTDONE)
                ENDDO
 
/* Amount is sum of calculated amounts */
 AMTDONE:    CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLLDBL +
                          ''%SUM(WAMT)'')')
 
/* Calculate SIGN as 0 or 1 according to sign of amount */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(SIGN +
                          ''(%ABSVAL(WAMT) / WAMT - 1) / 2'' *ZONED +
                          1 0)')
 
/* If report set is not C, ACOD1 and ACOD2 for join  */
             IF         COND(&RSNO *NE 'C') THEN(DO)
 
/* Construct ACOD1 as account code from GLHIBLPD + SIGN */
                CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(ACOD1 +
                             ''HBACCD *CAT %DIGITS(SIGN)'' *CHAR 11)')                    /*CGL029*/
/**********                  ''HBACCD *CAT %DIGITS(SIGN)'' *CHAR 5)')*/                   /*CGL029*/
 
/* Construct ACOD2 as account code and DR/CR ind. from SDACRCPD */
                CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(ACOD2 +
                             ''G6ACCD *CAT G6DRCR'' *CHAR 11)')                           /*CGL029*/
/**********                  ''G6ACCD *CAT G6DRCR'' *CHAR 5)')       */                   /*CGL029*/
 
                ENDDO
 
/* End MAPFLD string */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')
 
/* Set OPNID as ACCNTAB */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(ACCNTAB)')
 
/* Overide GLBSRPPD */
             OVRDBF     FILE(GLBSRPPD) TOFILE(GLHIBLPD) MBR(&MCGRP) +
                          SHARE(*YES)
 
/* Bypass normal processing */
             GOTO       CMDLBL(QCMDEXC)
 
/* *******************************************************************/
/* S10736 - END   End of main part of S10736                         */
/* *******************************************************************/
 
/**/
/***Retrieve*Midas*Phase**/                                                               /*CCB020*/
/**/
NOTMC:   /* S10736 */ +
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)         */                     /*CCB020*/
                                                                                          /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
/* If *NO, system is in Input Cycle */                                                    /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&WCOB)                                        /*CCB020*/
/*/COPY WNCPYSRC,GLC86005                                            */
/**/
/*  Retrieve Event Control Dates */
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/**/
/**********  IF         COND(&MPHAS *EQ 'A' *AND &SRCE *EQ 'D') +  */                     /*CCB020*/
             IF         COND(&WCOB = '*NO' *AND &SRCE *EQ 'D') +
                          THEN(CHGVAR VAR(&EVCD) VALUE(%SST(&GLSTAT +
                          79 10)))                                                        /*CCB020*/
             ELSE       CMD(CHGVAR VAR(&EVCD) VALUE(%SST(&GLSTAT 74 +
                          10)))
/**/
/* Set up Selection criteria */
/**/
 
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                                THEN(DO)
             IF         COND(&RLEV *EQ 'C' *OR &RLEV *EQ 'B') THEN(DO)
             CHGVAR     VAR(&SEL1) VALUE('GLENTY *EQ ''''' *CAT &RENT +
                          *CAT ''''' *AND ')
             ENDDO
             ENDDO
/*/COPY WNCPYSRC,GLC86006                                            */
/**/
/* Set up Sort criteria and Level break fields*/
/**/
             IF         COND(&RLEV *EQ 'C') THEN(DO)
                         CHGVAR VAR(&ENTY) VALUE('A8CMCD')
                         CHGVAR VAR(&KEY1) VALUE('(GLENTY) ')
                         CHGVAR VAR(&GRP1) VALUE('(A8CMCD) ')
             ENDDO
/**/
             IF         COND(&RLEV *EQ 'B') THEN(DO)
                         CHGVAR VAR(&ENTY) VALUE('''1/BRCA''')
                         CHGVAR VAR(&KEY1) VALUE('(GLENTY) ')
                         CHGVAR VAR(&GRP1) VALUE('(1/BRCA) ')
             ENDDO
/**/
/**********  IF         COND(&CCY *EQ 'A') THEN(DO)                   /*CEU011*/
             IF         COND((&CCY *EQ 'A') *OR (&CCY *EQ 'E')) +
                          THEN(DO)                                    /*CEU011*/
                         CHGVAR VAR(&KEY2) VALUE(' (GLCCY) ')
                         CHGVAR VAR(&KEY3) VALUE(' (GLRSCD)')
             ENDDO
             ELSE       CMD(DO)
                         CHGVAR  VAR(&KEY2) VALUE(' (GLRSCD) ')
                         CHGVAR  VAR(&KEY3) VALUE(' (GLCCY)')
             ENDDO
 
/**/
/*  Set up basic OPNQRY Commands */
/**/
/*  Depending upon the input parameters different files are used */
/**/
/*      SRCE     RSNO     MPHAS        Use files                  */
/**/
/*        -      not C      -          SDBRCHL1, SDACRCL0         */
/*        -        C        -          SDBRCHL1, SDACODL1         */
/*        Y        -        -          ACCNTAB                    */
/*        D        -        A          GLACBTPD, GLACBYL0         */
/*        D        -      Not A        ACCNTAB,  GLACBTL0         */
/**/
/**/
/*  Build the Opnqry parameters for 'Year-to-date' reporting */
/**/
             IF         COND(&SRCE *EQ 'Y') THEN(DO)
/**/
             IF         COND(&RSNO *EQ 'C') THEN(DO)
/************CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB) +
                          (SDACODL1) (SDBRCHL1)) FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 A5ACCD) (BRCA A8BRCD)) +
                          JORDER(*ANY) +
                          GRPFLD(                (CCY) (A5ACCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               )(GLCCY CCY)+
                          (SIGN ''(%ABSVAL(LDBL) / LDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(ACOD)'' +
                          *CHAR 5) +
  ****** S10736 **********(GLLDBL ''%SUM(LDBL)'') (GLRSCD A5ACCD))') */
/**********  CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB) +   */                   /*CGL029*/
/**********               (SDACODL1) (SDBRCHL1)) FORMAT(GLBSRPPD) +  */                   /*CGL029*/
/**********               QRYSLT(''                                  */                   /*CGL029*/
/**********                        '') +                             */                   /*CGL029*/
/**********               KEYFLD(                                ) + */                   /*CGL029*/
/**********               JFLD((ACOD1 A5ACCD) (BRCA A8BRCD)) +       */                   /*CGL029*/
/**********               JORDER(*ANY) +                             */                   /*CGL029*/
/**********               GRPFLD(                (CCY) (A5ACCD) +    */                   /*CGL029*/
/**********               (SIGN)) +                                  */                   /*CGL029*/
/**********               GRPSLT(''GLLDBL *NE 0'') +                 */                   /*CGL029*/
/**********               MAPFLD((GLENTY               )(GLCCY CCY)+ */                   /*CGL029*/
/**********               (GLENT2 '''''' '''''') +                   */                   /*CGL029*/
/**********               (SIGN ''(%ABSVAL(LDBL) / LDBL - 1) / +     */                   /*CGL029*/
/**********               2'' *ZONED 1 0) (ACOD1 ''%DIGITS(ACOD)'' + */                   /*CGL029*/
/**********               *CHAR 5) +                                 */                   /*CGL029*/
/**********               (GLLDBL ''%SUM(LDBL)'') (GLRSCD A5ACCD))') */                   /*CGL029*/
/**********                                                          */      /* S10736 */ /*CGL029*/
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB) +
                          (SDACODL1) (SDBRCHL1)) FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 A5ACCD) (BRCA A8BRCD)) +
                          JORDER(*ANY) +
                          GRPFLD(                (CCY) (A5ACCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               )(GLCCY CCY)+
                          (GLENT2 '''''' '''''') (QQRSCD ''''''    '''''') +
                          (SIGN ''(%ABSVAL(LDBL) / LDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(ACOD)'' +
                          *CHAR 11) +
                          (GLLDBL ''%SUM(LDBL)'') (GLRSCD A5ACCD))') +
                                                                                          /*CGL029*/
             ENDDO
/**/
             ELSE       CMD(DO)
/************CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB) +
                          (SDACRCL0) (SDBRCHL1)) FORMAT(GLBSRPPD) +
                          QRYSLT(''                                 -
                                     '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 ACOD2)  (BRCA A8BRCD)) +
                          JORDER(*ANY) +
                          GRPFLD(                (CCY) (G6RSCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               )(GLCCY CCY)+
                          (GLLDBL ''%SUM(LDBL)'') (GLRSCD G6RSCD) +
                          (SIGN ''(%ABSVAL(LDBL) / LDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(ACOD) +
                          *CAT %DIGITS(SIGN)'' *CHAR 5) +
   ******* S10736 ******* (ACOD2 ''G6ACCD *CAT G6DRCR''))') */
/**********  CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB) +   */                   /*CGL029*/
/**********               (SDACRCL1) (SDBRCHL1)) FORMAT(GLBSRPPD) +  */                   /*CGL029*/
/**********               QRYSLT(''                                 -*/                   /*CGL029*/
/**********                          '') +                           */                   /*CGL029*/
/**********               KEYFLD(                                ) + */                   /*CGL029*/
/**********               JFLD((ACOD1 ACOD2)  (BRCA A8BRCD)) +       */                   /*CGL029*/
/**********               JORDER(*ANY) +                             */                   /*CGL029*/
/**********               GRPFLD(                (CCY) (G6RSCD) +    */                   /*CGL029*/
/**********               (SIGN)) +                                  */                   /*CGL029*/
/**********               GRPSLT(''GLLDBL *NE 0'') +                 */                   /*CGL029*/
/**********               MAPFLD((GLENTY               )(GLCCY CCY)+ */                   /*CGL029*/
/**********               (GLENT2 '''''' '''''') +                   */                   /*CGL029*/
/**********               (GLLDBL ''%SUM(LDBL)'') (GLRSCD G6RSCD) +  */                   /*CGL029*/
/**********               (SIGN ''(%ABSVAL(LDBL) / LDBL - 1) / +     */                   /*CGL029*/
/**********               2'' *ZONED 1 0) (ACOD1 ''%DIGITS(ACOD) +   */                   /*CGL029*/
/**********               *CAT %DIGITS(SIGN)'' *CHAR 5) +            */                   /*CGL029*/
/**********               (ACOD2 ''G6ACCD *CAT G6DRCR''))')          */        /*S10736*/ /*CGL029*/
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB) +
                          (SDACRCL1) (SDBRCHL1)) FORMAT(GLBSRPPD) +
                          QRYSLT(''                                 -
                                     '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 ACOD2)  (BRCA A8BRCD)) +
                          JORDER(*ANY) +
                          GRPFLD(                (CCY) (G6RSCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               )(GLCCY CCY)+
                          (GLENT2 '''''' '''''') (QQRSCD ''''''    '''''') +
                          (GLLDBL ''%SUM(LDBL)'') (GLRSCD G6RSCD) +
                          (SIGN ''(%ABSVAL(LDBL) / LDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(ACOD) +
                          *CAT %DIGITS(SIGN)'' *CHAR 11) +
                          (ACOD2 ''G6ACCD *CAT G6DRCR''))')                               /*CGL029*/
/**/
             CHGVAR     VAR(&SEL2) VALUE('G6RSNO *EQ ''''' +
                         *CAT &RSNO *CAT ''''' *AND ')
             ENDDO
/**/
/*  Modify the above Opnqry variable  */
/**/
/*  Modify the QRYSLT parameters      */
/**********  CHGVAR     VAR(%SST(&OPQF 72 70)) VALUE(&SEL1 ** &SEL2 +
                          ** 'LDBL *NE 0')                                            */ /*BG18886*/
             CHGVAR     VAR(%SST(&OPQF 72 70)) VALUE(&SEL1 *CAT &SEL2 +
                          *CAT 'LDBL *NE 0')                                             /*BG18886*/
/*  Modify the KEYFLD parameters      */
/**********  CHGVAR     VAR(%SST(&OPQF 152 30)) VALUE(&KEY1 ** &KEY2 +
                          ** &KEY3)                                                   */ /*BG18886*/
             CHGVAR     VAR(%SST(&OPQF 152 30)) VALUE(&KEY1 *CAT &KEY2 +
                          *CAT &KEY3)                                                    /*BG18886*/
/*  Modify the Entity value of the GRPFLD parameter  */
             CHGVAR     VAR(%SST(&OPQF 241 10)) VALUE(&GRP1)
/*  Modify the Entity value of the MAPFLD parameter  */
             CHGVAR     VAR(%SST(&OPQF 318 10)) VALUE(&ENTY)
/**/
/*  Override Format to Database file */
/**/
             OVRDBF     FILE(GLBSRPPD) TOFILE(ACCNTAB) SHARE(*YES)
/**/
             ENDDO      /* End of SRCE = Y */
/**/
/*  Build the Opnqry parameters for 'Daily' reporting */
/**/
             IF         COND(&SRCE *EQ 'D') +
                          THEN(DO)
/**/
             IF         COND(&RSNO *EQ 'C') THEN(DO)
/************CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +
                          (GLACBTL0) (SDBRCHL1) (SDACODL1)) +
                          FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 A5ACCD) (1/BRCA   A8BRCD) +
                          (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +
                          (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +
                          (1/BRCA 2/BRCA) (ACOD1 A5ACCD)) +
                          JDFTVAL(*YES) JORDER(*ANY) +
                          GRPFLD(                  (1/CCY) (A5ACCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               ) +
                          (GLCCY ''1/CCY'') +
                          (WLDBL ''1/LDBL - 2/LDBL'') +
                          (SIGN ''(%ABSVAL(WLDBL) / WLDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(1/ACOD)'' +
                          *CHAR 5) +
                          (GLLDBL ''%SUM(WLDBL)'') (GLRSCD A5ACCD)) +
                          OPNID(ACCNTAB)')**************************/ /*E28177*/
/************CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +
                          (GLACBTL0) (SDBRCHL1) (SDACODL1)) +
                          FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 A5ACCD) (1/BRCA   A8BRCD) +
                          (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +
                          (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +
                          (1/BRCA 2/BRCA)) +
                          JDFTVAL(*YES) JORDER(*ANY) +
                          GRPFLD(                  (1/CCY) (A5ACCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               ) +
                          (GLCCY ''1/CCY'') +
                          (WLDBL ''1/LDBL - 2/LDBL'') +
                          (SIGN ''(WLDBL / %MAX(%ABSVAL(WLDBL) 0.1) +
                          - 1) / 2'' *ZONED 1 0) +
                          (ACOD1 ''%DIGITS(1/ACOD)'' *CHAR 5) +
                          (GLLDBL ''%SUM(WLDBL)'') (GLRSCD A5ACCD)) +
                          OPNID(ACCNTAB)')   *E28177* ******S10736*/
/**********  CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +  */                   /*CGL029*/
/**********               (GLACBTL0) (SDBRCHL1) (SDACODL1)) +        */                   /*CGL029*/
/**********               FORMAT(GLBSRPPD) +                         */                   /*CGL029*/
/**********               QRYSLT(''                                  */                   /*CGL029*/
/**********                        '') +                             */                   /*CGL029*/
/**********               KEYFLD(                                ) + */                   /*CGL029*/
/**********               JFLD((ACOD1 A5ACCD) (1/BRCA   A8BRCD) +    */                   /*CGL029*/
/**********               (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +          */                   /*CGL029*/
/**********               (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +          */                   /*CGL029*/
/**********               (1/BRCA 2/BRCA)) +                         */                   /*CGL029*/
/**********               JDFTVAL(*YES) JORDER(*ANY) +               */                   /*CGL029*/
/**********               GRPFLD(                  (1/CCY) (A5ACCD) +*/                   /*CGL029*/
/**********               (SIGN)) +                                  */                   /*CGL029*/
/**********               GRPSLT(''GLLDBL *NE 0'') +                 */                   /*CGL029*/
/**********               MAPFLD((GLENTY               ) +           */                   /*CGL029*/
/**********               (GLENT2 '''''' '''''') +                   */                   /*CGL029*/
/**********               (GLCCY ''1/CCY'') +                        */                   /*CGL029*/
/**********               (WLDBL ''1/LDBL - 2/LDBL'') +              */                   /*CGL029*/
/**********               (SIGN ''(WLDBL / %MAX(%ABSVAL(WLDBL) 0.1) +*/                   /*CGL029*/
/**********               - 1) / 2'' *ZONED 1 0) +                   */                   /*CGL029*/
/**********               (ACOD1 ''%DIGITS(1/ACOD)'' *CHAR 5) +      */                   /*CGL029*/
/**********               (GLLDBL ''%SUM(WLDBL)'') (GLRSCD A5ACCD)) +*/                   /*CGL029*/
/**********               OPNID(ACCNTAB)')                           */        /*S10736*/ /*CGL029*/
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +
                          (GLACBTL0) (SDBRCHL1) (SDACODL1)) +
                          FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 A5ACCD) (1/BRCA   A8BRCD) +
                          (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +
                          (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +
                          (1/BRCA 2/BRCA)) +
                          JDFTVAL(*YES) JORDER(*ANY) +
                          GRPFLD(                  (1/CCY) (A5ACCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               ) +
                          (GLENT2 '''''' '''''') (QQRSCD ''''''    '''''') +
                          (GLCCY ''1/CCY'') +
                          (WLDBL ''1/LDBL - 2/LDBL'') +
                          (SIGN ''(WLDBL / %MAX(%ABSVAL(WLDBL) 0.1) +
                          - 1) / 2'' *ZONED 1 0) +
                          (ACOD1 ''%DIGITS(1/ACOD)'' *CHAR 11) +
                          (GLLDBL ''%SUM(WLDBL)'') (GLRSCD A5ACCD)) +
                          OPNID(ACCNTAB)')                                                /*CGL029*/
             ENDDO
/**/
             ELSE       CMD(DO)
/*********** CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +
                          (GLACBTL0) (SDBRCHL1) (SDACRCL0)) +
                          FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 ACOD2) (1/BRCA   A8BRCD)  +
                          (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +
                          (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +
                          (1/BRCA 2/BRCA)) +
                          JDFTVAL(*YES) JORDER(*ANY) +
                          GRPFLD(                  (1/CCY) (G6RSCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               ) +
                          (GLCCY ''1/CCY'') +
                          (WLDBL ''1/LDBL - 2/LDBL'') +
                          (SIGN ''(%ABSVAL(WLDBL) / WLDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(1/ACOD) +
                          *CAT %DIGITS(SIGN)'' *CHAR 5) +
                          (GLLDBL ''%SUM(WLDBL)'') (GLRSCD G6RSCD) +
                          (ACOD2 ''G6ACCD *CAT G6DRCR'')) +
                          OPNID(ACCNTAB)') ******S10736********/
/**********  CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +  */                   /*CGL029*/
/**********               (GLACBTL0) (SDBRCHL1) (SDACRCL0)) +        */                   /*CGL029*/
/**********               FORMAT(GLBSRPPD) +                         */                   /*CGL029*/
/**********               QRYSLT(''                                  */                   /*CGL029*/
/**********                        '') +                             */                   /*CGL029*/
/**********               KEYFLD(                                ) + */                   /*CGL029*/
/**********               JFLD((ACOD1 ACOD2) (1/BRCA   A8BRCD)  +    */                   /*CGL029*/
/**********               (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +          */                   /*CGL029*/
/**********               (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +          */                   /*CGL029*/
/**********               (1/BRCA 2/BRCA)) +                         */                   /*CGL029*/
/**********               JDFTVAL(*YES) JORDER(*ANY) +               */                   /*CGL029*/
/**********               GRPFLD(                  (1/CCY) (G6RSCD) +*/                   /*CGL029*/
/**********               (SIGN)) +                                  */                   /*CGL029*/
/**********               GRPSLT(''GLLDBL *NE 0'') +                 */                   /*CGL029*/
/**********               MAPFLD((GLENTY               ) +           */                   /*CGL029*/
/**********               (GLCCY ''1/CCY'') +                        */                   /*CGL029*/
/**********               (GLENT2 '''''' '''''') +                   */                   /*CGL029*/
/**********               (WLDBL ''1/LDBL - 2/LDBL'') +              */                   /*CGL029*/
/**********               (SIGN ''(%ABSVAL(WLDBL) / WLDBL - 1) / +   */                   /*CGL029*/
/**********               2'' *ZONED 1 0) (ACOD1 ''%DIGITS(1/ACOD) + */                   /*CGL029*/
/**********               *CAT %DIGITS(SIGN)'' *CHAR 5) +            */                   /*CGL029*/
/**********               (GLLDBL ''%SUM(WLDBL)'') (GLRSCD G6RSCD) + */                   /*CGL029*/
/**********               (ACOD2 ''G6ACCD *CAT G6DRCR'')) +          */                   /*CGL029*/
/**********               OPNID(ACCNTAB)')                           */        /*S10736*/ /*CGL029*/
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE( (ACCNTAB) +
                          (GLACBTL0) (SDBRCHL1) (SDACRCL0)) +
                          FORMAT(GLBSRPPD) +
                          QRYSLT(''                                   -
                                   '') +
                          KEYFLD(                                ) +
                          JFLD((ACOD1 ACOD2) (1/BRCA   A8BRCD)  +
                          (1/CNUM 2/CNUM) (1/CCY  2/CCY ) +
                          (1/ACOD 2/ACOD) (1/ACSQ 2/ACSQ) +
                          (1/BRCA 2/BRCA)) +
                          JDFTVAL(*YES) JORDER(*ANY) +
                          GRPFLD(                  (1/CCY) (G6RSCD) +
                          (SIGN)) +
                          GRPSLT(''GLLDBL *NE 0'') +
                          MAPFLD((GLENTY               ) +
                          (GLCCY ''1/CCY'') +
                          (GLENT2 '''''' '''''') (QQRSCD ''''''    '''''') +
                          (WLDBL ''1/LDBL - 2/LDBL'') +
                          (SIGN ''(%ABSVAL(WLDBL) / WLDBL - 1) / +
                          2'' *ZONED 1 0) (ACOD1 ''%DIGITS(1/ACOD) +
                          *CAT %DIGITS(SIGN)'' *CHAR 11) +
                          (GLLDBL ''%SUM(WLDBL)'') (GLRSCD G6RSCD) +
                          (ACOD2 ''G6ACCD *CAT G6DRCR'')) +
                          OPNID(ACCNTAB)')                                                /*CGL029*/
/**/
             CHGVAR     VAR(&SEL2) VALUE('G6RSNO *EQ ''''' +
                         *CAT &RSNO *CAT ''''' *AND ')
             ENDDO
/**/
/*  Modify the above Opnqry variable  */
/**/
/*  Modify the File Parameter for input Cycle reporting      */
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)              */                    /*CCB020*/
             IF         COND(&WCOB = '*NO') THEN(DO)                                     /*CCB020*/
             CHGVAR     VAR(%SST(&OPQF 14 10)) VALUE('(GLACBTPD)')
             CHGVAR     VAR(%SST(&OPQF 26 08)) VALUE('GLACBYL0')
             OVRDBF     FILE(GLBSRPPD) TOFILE(GLACBTPD) SHARE(*YES)
             ENDDO
/**/
             ELSE       CMD(DO)
             OVRDBF     FILE(GLBSRPPD) TOFILE(ACCNTAB) SHARE(*YES)
             ENDDO
/**/
/*  Modify the QRYSLT parameters      */
/**********  CHGVAR     VAR(%SST(&OPQF 84 70)) VALUE(&SEL1 ** &SEL2 +
                          ** '1/LDBL *NE 2/LDBL')                                     */ /*BG18886*/
             CHGVAR     VAR(%SST(&OPQF 84 70)) VALUE(&SEL1 *CAT &SEL2 +
                          *CAT '1/LDBL *NE 2/LDBL')                                      /*BG18886*/
/*  Modify the KEYFLD parameters      */
/**********  CHGVAR     VAR(%SST(&OPQF 164 30)) VALUE(&KEY1 ** &KEY2 +
                          ** &KEY3)                                                   */ /*BG18886*/
             CHGVAR     VAR(%SST(&OPQF 164 30)) VALUE(&KEY1 *CAT &KEY2 +
                          *CAT &KEY3)                                                    /*BG18886*/
/*  Modify the Entity value of the GRPFLD parameter  */
             CHGVAR     VAR(%SST(&OPQF 353 10)) VALUE(&GRP1)
/*  Modify the Entity value of the MAPFLD parameter  */
             CHGVAR     VAR(%SST(&OPQF 436 10)) VALUE(&ENTY)
/**/
             ENDDO      /* End of SRCE = D */
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86MP2                                            */
                                                                      /*S01408*/
/**/
/*  Execute OPNQRY Command  */
/**/
/************CALL*******PGM(QCMDEXC) PARM(&OPQF 700)****S10736**/
/**MDEXC:****CALL****** PGM(QCMDEXC) PARM(&OPQF 1000)***S10736***************************** CCB016*/
 QCMDEXC:                                                                                 /*CCB016*/
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'ALWCPYDTA(*OPTIMIZE)')              /*CCB016*/
             CHGQRYA    DEGREE(*MAX)                                                      /*CCB016*/
             CALL       PGM(QCMDEXC) PARM(&OPQF 1000) /* S10736 */                        /*CCB016*/
/*/COPY WNCPYSRC,GLC86015                                            */
/**/
/*  Call Balance Sheet/Profit and Loss Report  */
/**/
/************CALL       PGM(GL0761) PARM(&RSEQ &RLEV &RENT &CCY +
                          &RSNO &RSLV &RPCD &SRCE &ROUD &EVCD)        /*E28177*/
/************CALL       PGM(GL0761) PARM(&RSEQ &RLEV &RENT &CCY +
                      &RSNO &RSLV &RPCD &SRCE &ROUD &ZERO &EVCD) E28177 S10736*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86001                                            */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86012                                            */
/*********** CALL       PGM(GL0761) PARM(&RSEQ &RLEV &RENT &CCY +
                          &RSNO &RSLV &RPCD &SRCE &ROUD &ZERO &EVCD +
                       &MCGRP &MCRPNC &MCTRM &MCTYP &MCANL) */ /*S10736 124974*/
/*/COPY WNCPYSRC,GLC86011                                            */
/**********  CALL       PGM(GL0761) PARM(&RSEQ &RLEV &RENT &CCY +  */
/**********             &RSNO &RSLV &RPCD &SRCE &ROUD &ZERO &EVCD +*/
/**********             &MCGRP &MCRPNC &MCTRM &MCTYP &MCANL &RUN)  */              /*124974 CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(GL0761) PARM(&RSEQ &RLEV &RENT &CCY +
                          &RSNO &RSLV &RPCD &SRCE &ROUD &ZERO &EVCD +
                          &MCGRP &MCRPNC &MCTRM &MCTYP &MCANL &RUN +
                          &WCOB)                                                          /*CCB020*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86002                                            */
                                                                      /*S01408*/
/**/
/*  Send Database Error Messages */
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
/**/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                        MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
/* Abnormal Termination Processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Balance Sheet/P & L Reporting ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM   /* S10736 */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) /* S10736 */
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,GLC86009                                            */
/**/
END:         CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF4520)
/*/COPY WNCPYSRC,GLC86007                                            */
             ENDPGM
