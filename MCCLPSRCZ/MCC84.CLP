/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Management Account Balances')                */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       MCC84 - Management Account Balances                        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01416  *CREATE    Date 17May93              */
/*                                                                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       S01416 - Account Balances Report                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
/**/
             DCL        VAR(&OPQF) TYPE(*CHAR) LEN(1000)
             DCL        VAR(&EVCD) TYPE(*CHAR) LEN(15)
 
             DCL        VAR(&MCGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCRPNC) TYPE(*CHAR) LEN(4) VALUE('    ')
             DCL        VAR(&MCRPNB) TYPE(*DEC) LEN(3) VALUE(0)
             DCL        VAR(&MCTRM1) TYPE(*CHAR) LEN(1) /*       +
                          Term */
             DCL        VAR(&MCTRM2) TYPE(*CHAR) LEN(1) /*       +
                          Term */
             DCL        VAR(&MCTYP) TYPE(*CHAR) LEN(1) /*        +
                          Type */
             DCL        VAR(&MCANL) TYPE(*CHAR) LEN(9) /*        +
                          "Analysis by.." key fields */
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                                 Index for entity sort */
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0) /*        Index +
                          for entity sort */
             DCL        VAR(&WLIST) TYPE(*CHAR) LEN(300) /*        +
                          Work field to hold sorted entity keys */
             DCL        VAR(&FLAG) TYPE(*LGL) VALUE('0') /*        +
                          Flag for set up of entity MAPFLD */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) /*        +
                          Return Code */
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7) /*        +
                          Relative Reriod Key */
             DCL        VAR(&CCCY) TYPE(*CHAR) LEN(3) /*        +
                          Control Group CCy */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /*        +
                          Return string */
             DCL        VAR(&DATT) TYPE(*CHAR) LEN(5) /*        +
                          Period To Date */
             DCL        VAR(&DATS) TYPE(*DEC) LEN(5) /*        +
                          Term Start Date */
             DCL        VAR(&DATF1) TYPE(*CHAR) LEN(5) /*        +
                          Term From Date */
             DCL        VAR(&DATF2) TYPE(*CHAR) LEN(5) /*        +
                          Term From Date */
             DCL        VAR(&ENAM1) TYPE(*CHAR) LEN(10) /*       +
                          Amount's field name */
             DCL        VAR(&ENAM2) TYPE(*CHAR) LEN(10) /*       +
                          Amount's field name */
             DCLF       FILE(GLPERDL5) /*        Period file */
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
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
                          Finastra International Limited')
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&RSNO) VALUE(%SST(&RPARM 2 1))
             CHGVAR     VAR(&RSLV) VALUE(%SST(&RPARM 3 1))
             CHGVAR     VAR(&RPCD) VALUE(%SST(&RPARM 4 1))
             CHGVAR     VAR(&MCGRP) VALUE(%SST(&RPARM 5 2))
             CHGVAR     VAR(&MCRPNC) VALUE(%SST(&RPARM 7 4))
             CHGVAR     VAR(&MCTRM1) VALUE(%SST(&RPARM 11 1))
             CHGVAR     VAR(&MCTRM2) VALUE(%SST(&RPARM 12 1))
             CHGVAR     VAR(&MCTYP) VALUE(%SST(&RPARM 13 1))
             CHGVAR     VAR(&MCANL) VALUE(%SST(&RPARM 14 9))
 
/* Access Term From and to Dates */
 
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &MCGRP +
                          &DSFDY)
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
             CHGVAR     VAR(&CCCY) VALUE(%SST(&DSFDY 38 3))
             CHGVAR     VAR(&MCRPNB) VALUE(&MCRPNC)
             CALL       PGM(AORPERR0) PARM(&RTCD '*SETLL' &PKEY   +
                          &MCRPNB  &DSFDY)
 
             RCVF
 
             IF         COND(&MCTRM1 *EQ 'Y') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTSOYD))
             IF         COND(&MCTRM1 *EQ '1') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTST1D))
             IF         COND(&MCTRM1 *EQ '2') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTST2D))
             IF         COND(&MCTRM1 *EQ 'P') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTSPDD))
             CHGVAR     VAR(&DATF1) VALUE(&DATS)
 
             IF         COND(&MCTRM2 *NE ' ') THEN(DO)
             IF         COND(&MCTRM2 *EQ 'Y') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTSOYD))
             IF         COND(&MCTRM2 *EQ '1') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTST1D))
             IF         COND(&MCTRM2 *EQ '2') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTST2D))
             IF         COND(&MCTRM2 *EQ 'P') THEN(CHGVAR VAR(&DATS) +
                          VALUE(&DTSPDD))
             CHGVAR     VAR(&DATF2) VALUE(&DATS)
             ENDDO
 
             CHGVAR     VAR(&DATT) VALUE(&DTEPDD)
             CHGVAR     VAR(&EVCD) VALUE(&DATT *TCAT &DATF1 *TCAT +
                          &DATF2)
 
/* If type parameter is B (balance), set field name to closing bal */
 
             IF         COND(&MCTYP *EQ 'B') THEN(CHGVAR VAR(&ENAM1) +
                          VALUE('HBPDCB'))
             ELSE       CMD(DO)
/* If type parameter is A (average), set work amount to selected */
/* weighted balance divided by days from start to end of period */
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM1 *EQ 'P') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBWPBL'))
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM1 *EQ 'Y') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBWYBL'))
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM1 *EQ '1') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBWT1B'))
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM1 *EQ '2') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBWT2B'))
 
             IF         COND(MCTRM2 *NE ' ') THEN(DO)
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM2 *EQ 'P') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBWPBL'))
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM2 *EQ 'Y') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBWYBL'))
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM2 *EQ '1') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBWT1B'))
             IF         COND(&MCTYP *EQ 'A' *AND &MCTRM2 *EQ '2') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBWT2B'))
             ENDDO
 
/* If type parameter is M (movements), set work amount to selected */
/* movement field */
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM1 *EQ 'P') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBPMTD'))
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM1 *EQ 'Y') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBYMTD'))
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM1 *EQ '1') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBT1MT'))
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM1 *EQ '2') +
                          THEN(CHGVAR VAR(&ENAM1) VALUE('HBT2MT'))
 
             IF         COND(MCTRM2 *NE ' ') THEN(DO)
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM2 *EQ 'P') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBPMTD'))
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM2 *EQ 'Y') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBYMTD'))
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM2 *EQ '1') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBT1MT'))
             IF         COND(&MCTYP *EQ 'M' *AND &MCTRM2 *EQ '2') +
                          THEN(CHGVAR VAR(&ENAM2) VALUE('HBT2MT'))
             ENDDO
             ENDDO
 
             IF         COND(&ENAM2 *EQ ' ') THEN(CHGVAR VAR(&ENAM2) +
                          VALUE('0'))
 
/* Set up OPNQRYF parameter for QCMDEXC */
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF')
 
/* Set up files to use (use GLHIBLPD member for group code). Join to */
/* SDACRCPD for report set if report set parameter is not 'C', and   */
/* to SDBRCHL1 for company if report level is 'C'.                   */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FILE((GLHIBLPD' *BCAT &MCGRP *TCAT ')')
 
             IF         COND(&RSNO *NE 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(SDACRCPD)'))
 
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(SDBRCHPD)'))
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')
 
/*/COPY WNCPYSRC,MCC84001                                            */
/* Set up format to use (MCBLRPPD) */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(MCBLRPPD)')
/*/COPY WNCPYSRC,MCC84002                                            */
 
/* Set up query selection string, selecting on group code and */
/*  relative period number. Work amount must be non-zero to prevent */
/*  data mapping error. */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''HBPDCT *EQ ''''' *TCAT &DTPDCT +
                          *TCAT ''''' *AND HBPDYR *EQ ''''' *TCAT +
                          &DTPDYR *TCAT ''''' *AND HBPDNY *EQ ''''' +
                          *TCAT &DTPDNY *TCAT ''''' *AND (' +
                          *TCAT &ENAM1 *BCAT '*NE 0  *OR ' *CAT +
                          &ENAM2 *BCAT '*NE 0)')
 
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
             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'KEYFLD((GLENTY) +
                          (GLCCY) (GLRSCD) (GLENT2))'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD((GLENTY) (GLRSCD) (GLENT2) +
                          (GLCCY))'))
 
/* Join files as follows:                                            */
 
/*    If report set is not 'C', Get Report code:                     */
/*    Account Code : HBACCD in GLHIBLPD to G6ACCD in SDACRCPD        */
/*    DRCR   : Sign (of Amount) on GLHIBLPD to G6DRCR in SDACRCL0    */
 
/*    If report level is 'C', get company from SDBRCHPD              */
/*    Branch    : HBBRCD in GLHIBLPD to A8BRCD in SDBRCHPD           */
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'JFLD(')
 
             IF         COND(&RSNO *NE 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(G6ACCD HBACCD) +
                          (G6DRCR SIGNA)'))
 
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
 
/* Group on Currency if in Actual Currency                          */
             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'HBCYCD'))
 
/* Group on either account code or report code depending on whether */
/* report set is 'C' or not.                                        */
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'HBACCD GLENT2'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'G6RSCD GLENT2'))
 
/* Group on Currency if NOT in Actual Currency                      */
             IF         COND(&CCY *NE 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'HBCYCD'))
 
/* Select groups with a non-zero balance */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ') +
                          GRPSLT(''GLLDB1 *NE 0 *OR GLLDB2 *NE 0'')')
 
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
 
/* Report code from GLHIBLPD or SDACRCPD depending on report set */
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLRSCD HBACCD)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLRSCD G6RSCD)'))
 
/* Currency from GLHIBLPD */
             IF         COND(&CCCY *EQ '   ') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLCCY HBCYCD)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLCCY ''''''' *TCAT &CCCY *TCAT ''''''')'))
 
/* set work amount to event amount */
 
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(WAMT1' *BCAT +
                          &ENAM1 *TCAT ') (WAMT2' *BCAT &ENAM2 +
                          *TCAT ') (FLG ''%MIN(%ABSVAL(WAMT1) 1)'') +
                          (WAMT ''(WAMT1 * FLG) + (WAMT2 * (1 - +
                          FLG))'')')
 
/* Amount is sum of calculated amounts */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLLDB1 +
                          ''%SUM(WAMT1)'') (GLLDB2 ''%SUM(WAMT2)'')')
 
/* Calculate SIGN as 0 or 1 according to sign of amount */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(SIGN +
                          ''(%ABSVAL(WAMT) / WAMT - 1) / 2'' +
                          *ZONED 1 0) (SIGNA ''%DIGITS(SIGN)'' *CHAR)')
 
/*/COPY WNCPYSRC,MCC84003                                            */
/* End MAPFLD string */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(QQRSCD '''''' '''''')')            /*CGL029*/
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')
 
/* Set OPNID as ACCNTAB */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(ACCNTAB)')
 
/*/COPY WNCPYSRC,MCC84004                                            */
/* Overide MCBLRPPD */
             OVRDBF     FILE(MCBLRPPD) TOFILE(GLHIBLPD) MBR(&MCGRP) +
                          SHARE(*YES)
/*/COPY WNCPYSRC,MCC84005                                            */
 
/**/
/*  Execute OPNQRY Command  */
/**/
 QCMDEXC:    CALL       PGM(QCMDEXC) PARM(&OPQF 1000)
/**/
/*  Call Balance Sheet/Profit and Loss Report  */
/**/
             CALL       PGM(MC0750) PARM(&RSEQ &RLEV &RENT &CCY +
                          &RSNO &RSLV &RPCD &EVCD &MCGRP &MCRPNC +
                          &MCTRM1 &MCTRM2 &MCTYP &MCANL)
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
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF4520)
             ENDPGM
