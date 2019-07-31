     H DEBUG                                                                                  S01194
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEBNC                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Daily reporting merge')                       *
0001 H***********                                                         S01194
0002 F*****************************************************************
0004 F*                                                               *
     F*  Midas - General Ledger Module                                *
0004 F*                                                               *
0005 F*  GL0400  -  Account Postings Merge                            *
0006 F*                                                               *
      *  (c) Finastra International Limited 2001                      *
0010 F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034502           Date 25May15               *
      *                 CGL049             Date 17Feb15               *
      *                 MD022412           Date 16Sep13               *
      *                 CGL120             Date 06Aug12               *
      *                 260201A            Date 20Dec12               *
      *                 AR994643A          Date 25Nov12               *
      *                 AR994643           Date 25Nov12               *
      *                 AR317767           Date 27Jul12               *
      *                 AR910445           Date 27Feb12               *
      *                 264038             Date 19Feb10               *
      *                 AR889490           Date 06Dec10               *
      *                 CER049             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23102           Date 04Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12484           Date 26Nov06               *
      *                 BUG7004            Date 31Aug05               *
      *                 BUG10057           Date 04Feb06               *
      *                 201071             Date 23Nov05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 209670             Date 19Sep02               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 201194             Date 27Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 179146             Date 18Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU013             Date 29May98               *
      *                 S01408             Date 24Jul95               *
     F*                 CRT001             DATE 28FEB95               *
     F*                 056524             DATE 16NOV93               *
     F*                 S01340             DATE 11NOV91               *
     F*                 S01182             DATE 01/11/88              *
     F*                 E15192             DATE  1OCT90               *
     F*                 S01117             DATE 08/03/89              *
     F*                 S01194             DATE 08/03/89              *
     F*                 E16678             DATE 17/01/89              *
     F*                 S03220             DATE 10/05/88              *
     F*                 E11708             DATE 05/10/87              *
     F*                 S05452             DATE 20/08/87              *
     F*                 S01090             DATE 04/08/86              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034502 - FB Midas 2.1 SP8 Drop3 COB issues                 *
      *  CGL049   - Separate Out Processing of Spot Reval and FX Tfr  *
      *  MD022412 - Record locking in trailer file EODPOZZ            *
      *  CGL120 - GL COB Components Task Split                        *
      *         - Incorporate 261284 and CGL106                       *
      *  260201A - File control error in GL0400. Change *IN14 used    *
      *            by 260201 to *IN15 as this indicator was already   *
      *            use by enhancement ERZ122                          *
      *  AR994643A - FOOB in GLC41 (Child:AR994644)                   *
      *  AR994643 - FOOB in GLC41 (Child:AR994644)                    *
      *  AR317767 - Some fields in EODPOPD are written with replace-  *
      *             ment character '+'. Initialize fields NITMS,      *
      *             FEEVAL and SETDAT.                                *
      *  AR910445 - GLC41 FOOB in GL0400 Accounts Postings Merge      *
      *  264038 - GLC41 fails with FCOOB. Remove BUG7004. Applied fix *
      *           240977.                                             *
      *         - Applied for AR910445                                *
      *  AR889490 - Stamp Tax posting missing in APOSTPD              *
      *         - Applied for AR910445                                *
      *  CER049 - Stamp Tax                                           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23102 - FOOB when database is not empty.                  *
      *  CAP204  - Retail Account Transfer                            *
      *            Replace ACPO1 processing by GLACPML0 to include    *
      *            GLACPOL0 postings                                  *
      *  BUG12484 - Previous fixes result in FOOB in ACPO1 and ACPO4  *
      *           and probably in ACPO2/3/5 a well.                   *
      *  BUG7004- GLC41/00001 FOOB in GL0400 in 'After end of period' *
      *           count. Also remaining 201071 fix is removed.        *
      *  BUG10057 - Reinstate some coding removed by 201071.          *
      *  201071 - Amend part of core fix 179146 to avoid file out of  *
      *           balance error if LF/ACPO4 has records.              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  209670 - FIX 179146 - DO NOT CHECK THE FLAG IF ALREADY SET.  *
     F*  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
     F*           Information                                         *
      *  201194 - GLC41 failed due to FOOB in GL0400. Addendum to     *
      *           core fix 179146 if LF/ACPO4 has records.            *
     F*  179146 - If no records read from APOS4 i.e., indicator 10    *
     F*           not switched on, number of records read should be   *
     F*           zero in TRN,4.                                      *
      *  CGL007 - Account Postings Enquiry                            *
     F*  CEU013 - EMU Account Posting Narrative. Extend EODPOPD       *
     F*  S01408 - Addition of core hooks GL0400CCPG                   *
     F*  CRT001 - Retail Teller System                                *
     F*         - Extend file lengths to 316                          *
     F*  056524 - EODPOPD Missing Real time Postings                  *
     F*  S01340 - MIS GL Real time posting                            *
     F*  S01182 - Writes new account posting feilds to the            *
     F*           Generated Entries file PF/EODPOPD for MIS.          *
     F*  E15192 - ACPO3 has BCCY IN/EX Postings                       *
0011 F*  S01117 - Multibranching                                      *
     F*  S01194 - New Standing Data                                   *
0011 F*  E16678 - E11708 does not handle 'P' records with             *
0011 F*           a blank retail indicator (RIND)                     *
0011 F*  S03220 - Interface funds transfer & split off                *
     F*           trailers from ACPO9 files to ACPO9Z .               *
     F*           Trailers identified by RECI = 'T' or 'Z'.           *
     F*           ACPO3 removed (not used)                            *
     F*  E11708 - If RIND (retail indicator) blank set to 0.          *
     F*  S05452 - Inclusion of auto reconciliations.                  *
0011 F*  S01090 - Change processing to cope with beheaded ACP01       *
0011 F*                                                               *
0011 F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
0012 F*ABLE***IF* F      96 12AI     2 DISK                               S01194
0013 F*CPO1   IP  F     160  1AI     1 DISK                               S05452
0013 F*CPO1***IP* F     200  1AI     1 DISK                        S05452 S03220
0013 F*CPO1***IP* F     215  1AI     1 DISK                        S03220 S01117
0013 F*****ACPO1   IP  F     268  1AI     1 DISK                   S01117 CRT001
0013 F*****ACPO1   IP  F     316  1AI     1 DISK                   CRT001 CEU013
0013 F***ACPO1***IP  F     329  1AI     1 DISK                     CEU013 CGL007
0013 F***ACPO1   IP  F     331  1AI     1 DISK                                         CGL007 CGL020
     F/COPY WNCPYSRC,GLH00828
0013 F***ACPO1** IP  F     589  1AI     1 DISK                                         CGL020 CGL029
0013 F***ACPO1   IP  F     620  1AI     1 DISK                                         CGL029 CAP204
0013 F***GLACPML0  IP   F  620     1AIDISK    KEYLOC(1)                                CAP204 CGL120
     F/COPY WNCPYSRC,GLH00829
0013 F***ACPO1Z    IS   F  160     1AIDISK    KEYLOC(1)                                S03220 CGL120
0014 F*CPO2   IS  F     160  1AI     1 DISK                           U2  S05452
0014 F*CPO2***IS* F     200  1AI     1 DISK                    U2  S05452 S03220
0014 F*CPO2***IS* F     215  1AI     1 DISK                    U2  S03220 S01117
0014 F*****ACPO2   IS  F     268  1AI     1 DISK               U2  S01117 CRT001
0014 F*****ACPO2   IS  F     316  1AI     1 DISK               U2  CRT001 CEU013
0014 F***ACPO2***IS  F     329  1AI     1 DISK                 U2  CEU013 CGL007
0014 F***ACPO2** IS  F     331  1AI     1 DISK                        U2               CGL007 CGL020
0014 F***ACPO2** IS  F     589  1AI     1 DISK                           U2            CGL020 CGL029
     F/COPY WNCPYSRC,GLH00830
0013 FACPO2     IS   F  620     1AIDISK    KEYLOC(1)                                          CGL029
     F/COPY WNCPYSRC,GLH00831
     F                                     EXTIND(*INU2)
0014 FACPO2Z    IS   F  160     1AIDISK    KEYLOC(1)                            S03220
     F                                     EXTIND(*INU2)
0015 F*CPO3   IS  F     160  1AI     1 DISK                           U3  S05452
0015 F*CPO3***IS  F     200  1AI     1 DISK                    U3  S05452 S03220
0015 F*****ACPO3   IS  F     268  1AI     1 DISK               U3  E15192 CRT001
0015 F*****ACPO3   IS  F     316  1AI     1 DISK               U3  CRT001 CEU013
0015 F***ACPO3***IS  F     329  1AI     1 DISK                 U3  CEU013 CGL007
0015 F***ACPO3** IS  F     331  1AI     1 DISK                        U3               CGL007 CGL020
0015 F***ACPO3** IS  F     589  1AI     1 DISK                           U3            CGL020 CGL029
     F/COPY WNCPYSRC,GLH00832
0015 FACPO3     IS   F  620     1AIDISK    KEYLOC(1)                                          CGL029
     F/COPY WNCPYSRC,GLH00833
     F                                     EXTIND(*INU3)
0016 F*CPO4   IS  F     160  1AI     1 DISK                           U4  S05452
0016 F*CPO4***IS* F     200  1AI     1 DISK                    U4  S05452 S03220
0016 F*CPO4***IS* F     215  1AI     1 DISK                    U4  S03220 S01117
0016 F*****ACPO4   IS  F     268  1AI     1 DISK               U4  S01117 CRT001
0016 F*****ACPO4   IS  F     316  1AI     1 DISK               U4  CRT001 CEU013
0016 F***ACPO4***IS  F     329  1AI     1 DISK                 U4  CEU013 CGL007
0016 F***ACPO4** IS  F     331  1AI     1 DISK                        U4               CGL007 CGL020
0016 F***ACPO4** IS  F     589  1AI     1 DISK                           U4            CGL020 CGL029
     F/COPY WNCPYSRC,GLH00834
0016 FACPO4     IS   F  620     1AIDISK    KEYLOC(1)                                          CGL029
     F/COPY WNCPYSRC,GLH00835
     F                                     EXTIND(*INU4)
0016 FACPO4Z    IS   F  160     1AIDISK    KEYLOC(1)                            S03220
     F                                     EXTIND(*INU4)
0017 F*CPO5   IS  F     160  1AI     1 DISK                           U5  S05452
0017 F*CPO5***IS* F     200  1AI     1 DISK                    U5  S05452 S03220
0017 F*CPO5***IS* F     215  1AI     1 DISK                    U5  S03220 S01117
0017 F*****ACPO5   IS  F     268  1AI     1 DISK               U5  S01117 CRT001
0017 F*****ACPO5   IS  F     316  1AI     1 DISK               U5  CRT001 CEU013
0017 F***ACPO5***IS  F     329  1AI     1 DISK                 U5  CEU013 CGL007
0017 F***ACPO5** IS  F     331  1AI     1 DISK                        U5               CGL007 CGL020
0017 F***ACPO5** IS  F     589  1AI     1 DISK                           U5            CGL020 CGL029
     F/COPY WNCPYSRC,GLH00836
0017 FACPO5     IS   F  620     1AIDISK    KEYLOC(1)                                          CGL029
     F/COPY WNCPYSRC,GLH00837
     F                                     EXTIND(*INU5)
0017 FACPO5Z    IS   F  160     1AIDISK    KEYLOC(1)                            S03220
     F                                     EXTIND(*INU5)
     FACPO6     IS   F  620     1AIDISK    KEYLOC(1)                                          CGL049
     F                                     EXTIND(*INU6)                                      CGL049
0017 FACPO6Z    IS   F  160     1AIDISK    KEYLOC(1)                                          CGL049
     F                                     EXTIND(*INU6)                                      CGL049
     F/COPY WNCPYSRC,GL0400F002
0018 F*L0400P1O** F     132            PRINTER                  S01124    S01117
0018 FGL0400AU  O    F  132        PRINTER                                      S01117
0019 F***EODPOHH   O    F  160        DISK                                                    CGL120
0019 F*ODPOPD O   F     160            DISK                               S05452
0019 F*ODPOPD*O** F     200            DISK                        S05452 S03220
0019 F*ODPOPD*O** F     215            DISK                        S03220 S01117
0019 F*****EODPOPD O   F     268            DISK                   S01117 CRT001
0019 F*****EODPOPD O   F     316            DISK                   CRT001 CEU013
0019 F***EODPOPD*O   F     329            DISK                     CEU013 CGL007
0019 F***EODPOPD O   F     331            DISK                                         CGL007 CGL020
0019 F***EODPOPD O   F     589            DISK                                         CGL020 CGL029
     F/COPY WNCPYSRC,GLH00838
0019 FEODPOPD   O    F  620        DISK                                                       CGL029
     F/COPY WNCPYSRC,GLH00839
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GL0400F003
0019 F***EODPORA O   F     160            DISK                                                CGL029
     FEODPORA   O    F  170        DISK                                                       CGL029
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GL0400F004
0009 F***EODPOZZ   O    F  160        DISK                                                    CGL120
     F***EODPOZZ   UF A E             DISK    COMMIT                                 CGL120 MD022412
     F***EODPOZZ   O    E             DISK    COMMIT                               MD022412 MD034502
     FEODPOZZ   UF A E             DISK    COMMIT                                           MD034502
     FGLACPSPD  IP   E             DISK                                                       CGL120
     F/COPY WNCPYSRC,GLH00840
     FGEDLPD    IF   F  620        DISK    RECNO(WKRRN)                                       CGL120
     F/COPY WNCPYSRC,GLH00841
     F                                     USROPN                                             CGL120
     FRCHGRA    IF   F  170        DISK    RECNO(WKRRN)                                       CGL120
     F                                     USROPN                                             CGL120
     F***GLGESTL2IS  F     620  1AI     1 DISK                                       CER049 AR889490
     FGLSTDTL1  IS   F  620     1AIDISK    KEYLOC(1)                                        AR889490
     F***GLSTTRL3IS  F     160  1AI     1 DISK                                       CER049 AR889490
     FGLSTTRL1  IS   F  160     1AIDISK    KEYLOC(1)                                        AR889490
     F/COPY WNCPYSRC,GL0400F001
0020 F* 01            RATE CHANGE RECORD
0021 F* 02            ITEMS IN CLEARING
0022 F* 03            ACCOUNT POSTINGS RECORD
0023 F**04************ACPO1 TRAILER                                       S03220
     F* 04            ACPO1Z TRAILER                                      S03220
0023 F**05*******     TABLE FILE I.C.D RECORD 1                           S01194
     F**05*******     ACPO2Z TRAILER                                S03220S01117
     F* 06            ACPO2Z TRAILER                                      S01117
0024 F**06************ACPO2 TRAILER                                       S03220
0027 F**07*******     TABLE FILE CATCHALL                                 S01194
0025 F**08************ACPO3 TRAILER                                       S03220
0025 F* 08            ACPO3 TRAILER                                       E15192
0027 F* 09            ACPO  CATCHALL
0026 F**10************ACPO4 TRAILER                                       S03220
     F* 10            ACPO4Z TRAILER                                      S03220
0023 F**12************ACPO5 TRAILER                                       S03220
     F* 12            ACPO5Z TRAILER                                      S03220
     F**13************POSTING*NOT*WRITTEN*TO*EOD*POSTING*MERGE*****S01340 056524
     F* 16            ACPO6Z TRAILER                                      CGL049
0028 F*       24      ACCOUNT POSTING IS DEBIT
0029 F*       25      DISCREPANCY BETWEEN INPUT AND CALC. TOTALS
0030 F*       30      TRAILER RECORD
0033 F*       33      FIRST CYCLE OVER
0034 F*       34      PRINT TITLES
     F*       36      GEFP RECORD READ SAR 3220                           S03220
     F*       41      1ST TRLR READ FOR ANY ACPO
     F*       60      No Audit report required                                                CGL120
     F*       77      Processing Mode = P                                                     CGL120
0035 F*          U2   ACPO2 EXISTS
0036 F***********U3   ACPO3 EXISTS                                        S03220
0036 F*          U3   ACPO3 EXISTS                                        E15192
0037 F*          U4   ACPO4 EXISTS
0038 F*          U5   ACPO5 EXISTS
     F***********U6   GEFPZZ RECORD READ SAR 3220                         S03220              CGL049
     F*          U6   ACPO6 EXISTS                                                            CGL049
     F*          U7U8 DATABASE ERROR                                      S01194
     D CMD             S             27    DIM(4) CTDATA PERRCD(1)                            CGL120
     D/COPY WNCPYSRC,GL0400E001
     D**********          INN         5  5 0             CALC-NO                              CER049
     D**********          INI         5 15 0             CALC-INT                             CER049
     D**********          IND         5  3 0             CALC-DEC                             CER049
     D**********          TRN         5  5 0             TRLRS-NO                             CER049
     D**********          TRI         5 15 0             TRLRS-INT                            CER049
     D**********          TRD         5  3 0             TRLRS-DEC                            CER049
     D**********          NARR    1   5 35               POST NAME                            CER049
     D*INN             S              5  0 DIM(6)                               CALC-NO       CGL049
     D*INI             S             15  0 DIM(6)                               CALC-INT      CGL049
     D*IND             S              3  0 DIM(6)                               CALC-DEC      CGL049
     D*TRN             S              5  0 DIM(6)                               TRLRS-NO      CGL049
     D*TRI             S             15  0 DIM(6)                               TRLRS-INT     CGL049
     D*TRD             S              3  0 DIM(6)                               TRLRS-DEC     CGL049
     D*NARR            S             35    DIM(6) CTDATA PERRCD(1)              POST NAME     CGL049
     D INN             S              5  0 DIM(7)                               CALC-NO       CGL049
     D INI             S             15  0 DIM(7)                               CALC-INT      CGL049
     D IND             S              3  0 DIM(7)                               CALC-DEC      CGL049
     D TRN             S              5  0 DIM(7)                               TRLRS-NO      CGL049
     D TRI             S             15  0 DIM(7)                               TRLRS-INT     CGL049
     D TRD             S              3  0 DIM(7)                               TRLRS-DEC     CGL049
     D NARR            S             35    DIM(7) CTDATA PERRCD(1)              POST NAME     CGL049
0119 D*
     D*     LOCAL DATA AREA
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
0306 D*
0108  *                                                                   E11708
      ** Check Retail Indicator (must be numeric)                         E11708
0109 D ACPREC          DS                                                       E11708
0111 D  RINDA                106    106                                         E11708
0109 D ACPRC           DS                                                       E16678
0111 D  RINDB                106    106                                         E16678
0119 D*                                                                   E16678
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION            S03220
     D CPYR@#          DS                                                       S03220
     D  CPY@                   1     80                                         S03220
     D                                     DIM(1) CTDATA PERRCD(1)                            S03220
     D  CPY@##                 1     20                                         S03220
     D*                                                                   S01194
     D*    EXTERNAL DTAARA FOR RUN-DATE                                   S01194
     D*                                                                   S01194
     D RUNDT           DS                                                       S01194
     D  RUNA                   1      7                                         S01194
     D  RUND                   8     10P 0                                      S01194
     D  SSF                   11     11                                         S01194
     D  DATF                  12     12                                         S01194
     D  MBIN                  13     13                                         S01194
     D*                                                                   S01194
     D*  DEFINE EXTERNAL DATA STRUCTURES OVER DUMMY PHYSICAL FILES        S01194
     D*                                                                   S01194
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
     D*    BANK DETAILS                                                   S01194
     D*                                                                   S01194
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01194
     D*    MIDAS MODULE FLAGS                                             S01194
     D*                                                                   S01194
     D/COPY WNCPYSRC,GL0400I011
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01194
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                AR910445
     I/COPY WNCPYSRC,GL0400E002
0039 I*****TABLE FILE - INSTALLATION CONTROL RECORD 1                     S01194
0040 I***********                                                         S01194
0041 I*ABLE***NS* 05   1 CD   2 C0   3 C1                                 S01194
0042 I*******AND*     12 C1  13 C0                                        S01194
0043 I***********                             1   1 RECI                  S01194
0044 I***********                             2   30RECT                  S01194
0045 I***********                            12  13 RCDE                  S01194
0046 I***********                            14  66 TITL                  S01194
0047 I***********                            67  67 DATF                  S01194
0048 I***********                            68  700DFBR                  S01117
0049 I***********                            74  74 MODI1                 S01194
0050 I***********                            75  75 MODI2                 S01194
0051 I***********                            76  76 MODI3                 S01194
0052 I***********                         P  77  790RUND                  S01194
0053 I***********                            80  86 RUNA                  S01194
0054 I***********                            87  870SFLG                  S01194
     I***********                            88  88 MODI4           S03220S01194
0055 I***********                         P  90  920LCD                   S01194
0056 I***********                            93  93 CHTP                  S01194
0057 I***********                         P  94  960TNLU                  S01194
0058 I***********                             1  96 LOT                   S01194
0059 I***********                                                         S01194
0060 I*****CATCHALL FOR DELETED RECORDS                                   S01194
0061 I********NS* 07                                                      S01194
0062 I*
0063 I** ACCOUNT POSTINGS FILES
0064 I*
0065 I***ACPO1   NS  01   1 CR                                                                CAP204
0065 I***GLACPML0  NS  01    1 CR                                                      CAP204 CGL120
     IRCHGRA    NS                                                                            CGL120
0066 I*******OR   03   1 CP                                               S05452
     I/COPY WNCPYSRC,GL0400I001
0067 I                             P   74   80 3PSTA
0068 I**********                              1 160 ACPREC                                    CGL029
     I                                  1  170  ACPREC                                        CGL029
     I                                  1    1  RECI                                          CGL120
0069 I                                128  128  PRIN
     I                                129  129  GETP                            S03220
     I                                131  134  PRFC                            S01182
     I                                161  170 0ACOD                                          CGL029
     I**********                            216 230 OTRF                               S01182 CGL029
     I**********                      216  230  OTRFQQ                                 CGL029 CGL120
     I**********                      231  240  OTST                                   S01182 CGL120
     I**********                      241  250  OTTP                                   S01182 CGL120
     I**********                   P  251  258 0SDCB                                   S01182 CGL120
     I**********                   P  259  266 0SDLB                                   S01182 CGL120
     I**********                      267  268  BOKC                                   S01182 CGL120
     I/COPY WNCPYSRC,GLH00842
     I**********                   P  269  271 0NITMS                                AR317767 CGL120
     I**********                      332  351  ACKEY                                  CGL020 CGL120
     I**********                      352  352  FEEFLG                                 CGL020 CGL120
     I**********                   P  353  359 0FEEVAL                                 CGL020 CGL120
     I**********                      360  364  FEEPCT                                 CGL020 CGL120
     I**********                      365  384  RORACT                                 CGL020 CGL120
     I**********                      385  386  RORCTY                                 CGL020 CGL120
     I**********                      387  406  RORBNK                                 CGL020 CGL120
     I**********                      407  417  RORCDE                                 CGL020 CGL120
     I**********                      418  437  PORACT                                 CGL020 CGL120
     I**********                      438  439  PORCTY                                 CGL020 CGL120
     I**********                      440  459  PORBNK                                 CGL020 CGL120
     I**********                      460  470  PORCDE                                 CGL020 CGL120
     I**********                      471  505  DSTACT                                 CGL020 CGL120
     I**********                      506  507  DSTCTY                                 CGL020 CGL120
     I**********                      508  527  DSTBNK                                 CGL020 CGL120
     I**********                   P  528  530 0SETDAT                                 CGL020 CGL120
     I**********                      531  540  TICKER                                 CGL020 CGL120
     I**********                      541  560  EXCHNG                                 CGL020 CGL120
     I**********                      561  573 2NOMINL                                 CGL020 CGL120
     I**********                      574  589  FDTRID                                 CGL020 CGL120
     I**********                      600  620  OTRF                                   CGL029 CGL120
0066 I**********NS  03    1 CP                                                         S05452 CGL120
     IGEDLPD    NS                                                                            CGL120
     I/COPY WNCPYSRC,GL0400I002
0067 I                             P   74   80 3PSTA                            S05452
     I                                  1    1  RECI                                          CGL120
0068 I***********                             1 200 ACPRC          S05452 S03220
0068 I***********                             1 215 ACPRC          S03220 S01117
0068 I***********                             1 268 ACPRC          S01117 CRT001
0068 I***********                             1 316 ACPRC          CRT001 CEU013
0068 I***********                             1 329 ACPRC          CEU013 CGL007
0068 I                                  1  331  ACPRC                           CGL007
     I                                 96  102  SPOS                                        BUG23102
     I/COPY WNCPYSRC,GL0400I013
0069 I                                128  128  PRIN                            S05452
     I                                131  134  PRFC                            S01182
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00843
     I                             P  269  271 0NITMS                                       AR317767
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                590  599 0ACOD                                          CGL029
     I                                600  620  OTRF                                          CGL029
     I/COPY WNCPYSRC,GL0400I014
0070 I***     NS  04   1 CT                                               S03220
0071 I***                                     2   60NORE                  S03220
0072 I***                                 P   7  140ZZINT                 S03220
0073 I***                                 P  15  160ZZDEC                 S03220
0074 I********* NS  09                                                                        CGL120
0075 I*
0070 I***ACPO1Z    NS  04    1 CT                                                      S03220 CGL120
     I*********OR         1 CZ                                                         S03220 CGL120
0071 I**********                        2    6 0NORE                                   S03220 CGL120
0072 I**********                   P    7   14 0ZZINT                                  S03220 CGL120
0073 I**********                   P   15   16 0ZZDEC                                  S03220 CGL120
0074 I**********NS  09                                                                 S03220 CGL120
0076 IACPO2     NS  01    1 CR
0077 I*******OR   03   1 CP                                               S05452
     I/COPY WNCPYSRC,GL0400I003
0078 I                             P   74   80 3PSTA
0079 I**********                              1 160 ACPREC                                    CGL029
     I                                  1  170  ACPREC                                        CGL029
0080 I                                128  128  PRIN
     I                                129  129  GETP                            S03220
     I                                131  134  PRFC                            S01182
     I                                161  170 0ACOD                                          CGL029
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00844
     I                             P  269  271 0NITMS                                         CGL120
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                600  620  OTRF                                          CGL029
0066 I          NS  03    1 CP                                                  S05452
     I/COPY WNCPYSRC,GL0400I004
0067 I                             P   74   80 3PSTA                            S05452
0068 I***********                             1 200 ACPRC          S05452 S03220
0068 I***********                             1 215 ACPRC          S03220 S01117
0068 I***********                             1 268 ACPRC          S01117 CRT001
0068 I***********                             1 316 ACPRC          CRT001 CEU013
0068 I***********                             1 329 ACPRC          CEU013 CGL007
0068 I                                  1  331  ACPRC                           CGL007
0069 I                                128  128  PRIN                            S05452
     I                             P  269  271 0NITMS                                       AR317767
     I                             P  353  359 0FEEVAL                                      AR317767
     I                             P  528  530 0SETDAT                                      AR317767
     I                                131  134  PRFC                            S01182
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00845
     I                             P  269  271 0NITMS                                       AR317767
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                590  599 0ACOD                                          CGL029
     I                                600  620  OTRF                                          CGL029
0070 I***     NS  06   1 CT                                               S03220
0071 I***                                     2   60NORE                  S03220
0072 I***                                 P   7  140ZZINT                 S03220
0073 I***                                 P  15  160ZZDEC                 S03220
0085 I          NS  09
0086 I*
0070 IACPO2Z    NS  06    1 CT                                                  S03220
     I         OR         1 CZ                                                  S03220
0071 I                                  2    6 0NORE                            S03220
0072 I                             P    7   14 0ZZINT                           S03220
0073 I                             P   15   16 0ZZDEC                           S03220
0074 I          NS  09                                                          S03220
0086 I*
0087 IACPO3     NS  01    1 CR                                                  E15192
     I/COPY WNCPYSRC,GL0400I005
0089 I                             P   74   80 3PSTA                            E15192
0090 I**********                              1 160 ACPREC                             E15192 CGL029
     I                                  1  170  ACPREC                                        CGL029
0091 I                                128  128  PRIN                            E15192
     I                                161  170 0ACOD                                          CGL029
0066 I          NS  03    1 CP                                                  E15192
     I/COPY WNCPYSRC,GL0400I006
0067 I                             P   74   80 3PSTA                            E15192
0068 I***********                             1 268 ACPRC          E15192 CRT001
0068 I***********                             1 316 ACPRC          CRT001 CEU013
0068 I***********                             1 329 ACPRC          CEU013 CGL007
0068 I                                  1  331  ACPRC                           CGL007
0069 I                                128  128  PRIN                            E15192
     I                                590  599 0ACOD                                          CGL029
     I                                600  620  OTRF                                          CGL029
0092 I          NS  08    1 CT                                                  E15192
0071 I                                  2    6 0NORE                            E15192
0072 I                             P    7   14 0ZZINT                           E15192
0073 I                             P   15   16 0ZZDEC                           E15192
0074 I          NS  09                                                          E15192
0087 I**ACPO3   NS  01   1 CR                                             S03220
0088 I***    OR   03   1 CP                                               S03220
0089 I***                                 P  74  803PSTA                  S03220
0090 I***                                     1 160 ACPREC                S03220
0091 I***                                   128 128 PRIN                  S03220
0092 I***     NS  08   1 CT                                               S03220
0071 I***                                     2   60NORE                  S03220
0072 I***                                 P   7  140ZZINT                 S03220
0073 I***                                 P  15  160ZZDEC                 S03220
0074 I***     NS  09                                                      S03220
0097 I*
0098 IACPO4     NS  01    1 CR
0099 I*******OR   03   1 CP                                               S05452
     I/COPY WNCPYSRC,GL0400I007
0100 I                             P   74   80 3PSTA
0101 I**********                              1 160 ACPREC                                    CGL029
     I                                  1  170  ACPREC                                        CGL029
0102 I                                128  128  PRIN
     I                                129  129  GETP                            S03220
     I                                131  134  PRFC                            S01182
     I                                161  170 0ACOD                                          CGL029
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00846
     I                             P  269  271 0NITMS                                       AR317767
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                600  620  OTRF                                          CGL029
0066 I          NS  03    1 CP                                                  S05452
     I/COPY WNCPYSRC,GL0400I008
0067 I                             P   74   80 3PSTA                            S05452
0068 I***********                             1 200 ACPRC          S05452 S03220
0068 I***********                             1 215 ACPRC          S03220 S01117
0068 I***********                             1 268 ACPRC          S01117 CRT001
0068 I***********                             1 316 ACPRC          CRT001 CEU013
0068 I***********                             1 329 ACPRC          CEU013 CGL007
0068 I                                  1  331  ACPRC                           CGL007
0069 I                                128  128  PRIN                            S05452
     I                                131  134  PRFC                            S01182
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00847
     I                             P  269  271 0NITMS                                       AR317767
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                590  599 0ACOD                                          CGL029
     I                                600  620  OTRF                                          CGL029
0103 I***     NS  10   1 CT                                               S03220
0071 I***                                     2   60NORE                  S03220
0072 I***                                 P   7  140ZZINT                 S03220
0073 I***                                 P  15  160ZZDEC                 S03220
0107 I          NS  09
0108 I*
0070 IACPO4Z    NS  10    1 CT                                                  S03220
     I         OR         1 CZ                                                  S03220
0071 I                                  2    6 0NORE                            S03220
0072 I                             P    7   14 0ZZINT                           S03220
0073 I                             P   15   16 0ZZDEC                           S03220
0074 I          NS  09                                                          S03220
0108 I*
0109 IACPO5     NS  01    1 CR
0110 I*******OR   03   1 CP                                               S05452
     I/COPY WNCPYSRC,GL0400I009
0111 I                             P   74   80 3PSTA
0112 I**********                              1 160 ACPREC                                    CGL029
     I                                  1  170  ACPREC                                        CGL029
0113 I                                128  128  PRIN
     I                                129  129  GETP                            S03220
     I                                131  134  PRFC                            S01182
     I                                161  170 0ACOD                                          CGL029
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00848
     I                             P  269  271 0NITMS                                         CGL120
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                600  620  OTRF                                          CGL029
0066 I          NS  03    1 CP                                                  S05452
     I/COPY WNCPYSRC,GL0400I010
0067 I                             P   74   80 3PSTA                            S05452
0068 I***********                             1 200 ACPRC          S05452 S03220
0068 I***********                             1 215 ACPRC          S03220 S01117
0068 I***********                             1 268 ACPRC          S01117 CRT001
0068 I***********                             1 316 ACPRC          CRT001 CEU013
0068 I***********                             1 329 ACPRC          CEU013 CGL007
0068 I                                  1  331  ACPRC                           CGL007
     I                                 96  102  SPOS                                        BUG23102
0069 I                                128  128  PRIN                            S05452
     I                                131  134  PRFC                            S01182
     I**********                            216 230 OTRF                               S01182 CGL029
     I                                216  230  OTRFQQ                                        CGL029
     I                                231  240  OTST                            S01182
     I                                241  250  OTTP                            S01182
     I                             P  251  258 0SDCB                            S01182
     I                             P  259  266 0SDLB                            S01182
     I                                267  268  BOKC                            S01182
     I/COPY WNCPYSRC,GLH00849
     I                             P  273  279  CHGA                                          CGL120
     I                             P  310  316  ORAMT                                         CGL120
     I                                332  351  ACKEY                                         CGL020
     I                                352  352  FEEFLG                                        CGL020
     I                             P  353  359 0FEEVAL                                        CGL020
     I                                360  364  FEEPCT                                        CGL020
     I                                365  384  RORACT                                        CGL020
     I                                385  386  RORCTY                                        CGL020
     I                                387  406  RORBNK                                        CGL020
     I                                407  417  RORCDE                                        CGL020
     I                                418  437  PORACT                                        CGL020
     I                                438  439  PORCTY                                        CGL020
     I                                440  459  PORBNK                                        CGL020
     I                                460  470  PORCDE                                        CGL020
     I                                471  505  DSTACT                                        CGL020
     I                                506  507  DSTCTY                                        CGL020
     I                                508  527  DSTBNK                                        CGL020
     I                             P  528  530 0SETDAT                                        CGL020
     I                                531  540  TICKER                                        CGL020
     I                                541  560  EXCHNG                                        CGL020
     I                                561  573 2NOMINL                                        CGL020
     I                                574  589  FDTRID                                        CGL020
     I                                590  599 0ACOD                                          CGL029
     I                                600  620  OTRF                                          CGL029
0114 I***     NS  12   1 CT                                               S03220
0071 I***                                     2   60NORE                  S03220
0072 I***                                 P   7  140ZZINT                 S03220
0073 I***                                 P  15  160ZZDEC                 S03220
0118 I          NS  09
0119 I*
0070 IACPO5Z    NS  12    1 CT                                                  S03220
     I         OR         1 CZ                                                  S03220
0071 I                                  2    6 0NORE                            S03220
0072 I                             P    7   14 0ZZINT                           S03220
0073 I                             P   15   16 0ZZDEC                           S03220
0074 I          NS  09                                                          S03220
0098 IACPO6     NS  01    1 CR                                                                CGL049
0100 I                             P   74   80 3PSTA                                          CGL049
     I                                  1  170  ACPREC                                        CGL049
0102 I                                128  128  PRIN                                          CGL049
     I                                129  129  GETP                                          CGL049
     I                                131  134  PRFC                                          CGL049
     I                                161  170 0ACOD                                          CGL049
     I                                216  230  OTRFQQ                                        CGL049
     I                                231  240  OTST                                          CGL049
     I                                241  250  OTTP                                          CGL049
     I                             P  251  258 0SDCB                                          CGL049
     I                             P  259  266 0SDLB                                          CGL049
     I                                267  268  BOKC                                          CGL049
     I                             P  269  271 0NITMS                                         CGL049
     I                             P  273  279  CHGA                                          CGL049
     I                             P  310  316  ORAMT                                         CGL049
     I                                332  351  ACKEY                                         CGL049
     I                                352  352  FEEFLG                                        CGL049
     I                             P  353  359 0FEEVAL                                        CGL049
     I                                360  364  FEEPCT                                        CGL049
     I                                365  384  RORACT                                        CGL049
     I                                385  386  RORCTY                                        CGL049
     I                                387  406  RORBNK                                        CGL049
     I                                407  417  RORCDE                                        CGL049
     I                                418  437  PORACT                                        CGL049
     I                                438  439  PORCTY                                        CGL049
     I                                440  459  PORBNK                                        CGL049
     I                                460  470  PORCDE                                        CGL049
     I                                471  505  DSTACT                                        CGL049
     I                                506  507  DSTCTY                                        CGL049
     I                                508  527  DSTBNK                                        CGL049
     I                             P  528  530 0SETDAT                                        CGL049
     I                                531  540  TICKER                                        CGL049
     I                                541  560  EXCHNG                                        CGL049
     I                                561  573 2NOMINL                                        CGL049
     I                                574  589  FDTRID                                        CGL049
     I                                600  620  OTRF                                          CGL049
0066 I          NS  03    1 CP                                                                CGL049
0067 I                             P   74   80 3PSTA                                          CGL049
0068 I                                  1  331  ACPRC                                         CGL049
0069 I                                128  128  PRIN                                          CGL049
     I                                131  134  PRFC                                          CGL049
     I                                216  230  OTRFQQ                                        CGL049
     I                                231  240  OTST                                          CGL049
     I                                241  250  OTTP                                          CGL049
     I                             P  251  258 0SDCB                                          CGL049
     I                             P  259  266 0SDLB                                          CGL049
     I                                267  268  BOKC                                          CGL049
     I                             P  269  271 0NITMS                                         CGL049
     I                             P  273  279  CHGA                                          CGL049
     I                             P  310  316  ORAMT                                         CGL049
     I                                332  351  ACKEY                                         CGL049
     I                                352  352  FEEFLG                                        CGL049
     I                             P  353  359 0FEEVAL                                        CGL049
     I                                360  364  FEEPCT                                        CGL049
     I                                365  384  RORACT                                        CGL049
     I                                385  386  RORCTY                                        CGL049
     I                                387  406  RORBNK                                        CGL049
     I                                407  417  RORCDE                                        CGL049
     I                                418  437  PORACT                                        CGL049
     I                                438  439  PORCTY                                        CGL049
     I                                440  459  PORBNK                                        CGL049
     I                                460  470  PORCDE                                        CGL049
     I                                471  505  DSTACT                                        CGL049
     I                                506  507  DSTCTY                                        CGL049
     I                                508  527  DSTBNK                                        CGL049
     I                             P  528  530 0SETDAT                                        CGL049
     I                                531  540  TICKER                                        CGL049
     I                                541  560  EXCHNG                                        CGL049
     I                                561  573 2NOMINL                                        CGL049
     I                                574  589  FDTRID                                        CGL049
     I                                590  599 0ACOD                                          CGL049
     I                                600  620  OTRF                                          CGL049
0107 I          NS  09                                                                        CGL049
0070 IACPO6Z    NS  16    1 CT                                                                CGL049
     I         OR         1 CZ                                                                CGL049
0071 I                                  2    6 0NORE                                          CGL049
0072 I                             P    7   14 0ZZINT                                         CGL049
0073 I                             P   15   16 0ZZDEC                                         CGL049
0074 I          NS  09                                                                        CGL049
      *                                                                                       CER049
      ** Stamp Tax                                                                            CER049
     I***GLGESTL2NS  03   1 CP                                                       CER049 AR889490
     IGLSTDTL1  NS  03    1 CP                                                              AR889490
     I                             P   74   80 3PSTA                                          CER049
     I                                  1  331  ACPRC                                         CER049
     I                                128  128  PRIN                                          CER049
     I                                131  134  PRFC                                          CER049
     I                                231  240  OTST                                          CER049
     I                                241  250  OTTP                                          CER049
     I                             P  251  258 0SDCB                                          CER049
     I                             P  259  266 0SDLB                                          CER049
     I                                267  268  BOKC                                          CER049
     I                                590  599 0ACOD                                        AR889490
     I                                600  620  OTRF                                          CER049
     I          NS  09                                                                        CER049
      *                                                                                       CER049
     I***GLSTTRL3NS  14   1 CT                                                       CER049 AR889490
     IGLSTTRL1  NS  14    1 CT                                                              AR889490
     I         OR         1 CZ                                                                CER049
     I                                  2    6 0NORE                                          CER049
     I                             P    7   14 0ZZINT                                         CER049
     I                             P   15   16 0ZZDEC                                         CER049
     I          NS  09                                                                        CER049
     I/COPY WNCPYSRC,GL0400I012
      *                                                                                     AR910445
      **  Switchable Features Details                                                       AR910445
      *                                                                                     AR910445
0120 C*
     C     *ENTRY        PLIST                                                                CGL120
     C                   PARM                    MODE              1                          CGL120
     C  N33              SETON                                        60                      CGL120
0121 C*    FIRST CYCLE CALCULATIONS.
0122 C                   SETOFF                                       343502
0123 C   33              GOTO      DETAIL
     C     MODE          IFEQ      'P'                                                        CGL120
     C                   SETON                                        77                      CGL120
     C                   ENDIF                                                                CGL120
     C                   MOVEA     CPY@          BIS@             80
     C*                                                                   S01194
     C**  SET UP DBPGM WITH PROGRAM REFERENCE                             S01194
     C                   MOVEL     'GL0400 '     DBPGM            10                          S01194
     C*                                                                   S01194
     C**  READ DTAARA 'RUNDAT'                                            S01194
     C     *DTAARA       DEFINE    RUNDAT        RUNDT                                        S01194
     C                   IN        RUNDT                                                      S01194
     C*                                                                   S01194
0125 C                   SETON                                        3334                    S01194
     C*                                                                   S01194
0124 C***********          EXSR ZSYSTM                                    S01194
     C**                                                                  S01194
     C**  USE ACCESS PROGRAM TO READ BANK DETAILS                         S01194
     C                   CALL      'AOBANKR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDBANK        PARM      SDBANK        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        U7U8LR                  S01194
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *  S0119
     C                   MOVEL     'SDBANKPD'    DBFILE                                       S01194
     C                   MOVEL     @OPTN         DBKEY            29                          S01194
     C                   MOVEL     @OPTN         DBOPTN            7                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   GOTO      END                                                        S01194
     C                   END                                                                  S01194
     C**                                                                  S01194
     C**  USE ACCESS PROGRAM TO READ MIDAS MODULE FLAGS                   S01194
     C                   CALL      'AOMMODR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        U7U8LR                  S01194
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *  S0119
     C                   MOVEL     'SDMMODPD'    DBFILE                                       S01194
     C                   MOVEL     @OPTN         DBKEY                                        S01194
     C                   MOVEL     @OPTN         DBOPTN                                       S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   GOTO      END                                                        S01194
     C                   END                                                                  S01194
      **  Check to see if CER049 is installed.                                              AR910445
     C                   CALL      'AOSARDR0'                                               AR910445
     C                   PARM      '       '     @RTCD                                      AR910445
     C                   PARM      '*VERIFY'     @OPTN                                      AR910445
     C                   PARM      'CER049'      @SARD             6                        AR910445
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR910445
      *                                                                                     AR910445
      **  If SAR CER049 is installed set up the indicating field                            AR910445
     C     @RTCD         IFEQ      *BLANKS                                                  AR910445
     C                   MOVE      '1'           *IN31                                      AR910445
     C                   ENDIF                                                              AR910445
     C/COPY WNCPYSRC,GL0400C002
     C*                                                                   S03220
     C* IF FOREIGN PAYMETS INSTALLED SETON 36                             S03220
     C***********          TESTB'4'       MODI4          36         S03220S01194
     C     BGFDTR        IFEQ      'Y'                                                        S01194
     C                   MOVE      '1'           *IN36                                        S01194
     C                   ELSE                                                                 S01194
     C                   MOVE      '0'           *IN36                                        S01194
     C                   END                                                                  S01194
     C*                                                                   S01194
0125 C***********          SETON                     3334                 S01194
0126 C**********           Z-ADD2         RECRED                                             BUG7004
     C**********           Z-ADD0         RECRED                                      BUG7004 264038
     C**********         Z-ADD     2             RECRED                              264038 AR994643
     C                   Z-ADD     0             RECRED                                     AR994643
     C                   Z-ADD     0             TINT             15 0
     C                   Z-ADD     0             TDEC              3 0
     C**********           Z-ADD2         TRN                                                BUG7004
     C**********           Z-ADD0         TRN                                         BUG7004 264038
     C**********         Z-ADD     2             TRN                                 264038 AR994643
     C                   Z-ADD     0             TRN                                        AR994643
     C                   Z-ADD     0             INN                                        BUG23102
     C                   Z-ADD     0             NOREZ             5 0
0127 C*********************GOTO END                                       S01090
0128 C*
0129 C*    DETAIL CALCULATIONS.
0130 C     DETAIL        TAG                                                    ** DETAIL TAG *
      *                                                                                       CGL120
      ** Initialise fields with Invalid Data                                                  CGL120
      *                                                                                       CGL120
     C     NITMS         IFEQ      0                                                          CGL120
     C                   Z-ADD     0             NITMS                                        CGL120
     C                   ENDIF                                                                CGL120
     C     CHGA          IFEQ      0                                                          CGL120
     C                   Z-ADD     0             CHGA                                         CGL120
     C                   ENDIF                                                                CGL120
     C     ORAMT         IFEQ      0                                                          CGL120
     C                   Z-ADD     0             ORAMT                                        CGL120
     C                   ENDIF                                                                CGL120
      *                                                                                     AR317767
      ** Initialize blank numeric fields to zero.                                           AR317767
      *                                                                                     AR317767
     C                   MOVE      *BLANKS       CNITMS            5                        AR317767
     C                   MOVE      NITMS         CNITMS                                     AR317767
     C     CNITMS        IFEQ      *BLANKS                                                  AR317767
     C                   Z-ADD     0             NITMS                                      AR317767
     C                   ENDIF                                                              AR317767
     C                   MOVE      *BLANKS       CFEEVA           13                        AR317767
     C                   MOVE      FEEVAL        CFEEVA                                     AR317767
     C     CFEEVA        IFEQ      *BLANKS                                                  AR317767
     C                   Z-ADD     0             FEEVAL                                     AR317767
     C                   ENDIF                                                              AR317767
     C                   MOVE      *BLANKS       CSETDA            5                        AR317767
     C                   MOVE      SETDAT        CSETDA                                     AR317767
     C     CSETDA        IFEQ      *BLANKS                                                  AR317767
     C                   Z-ADD     0             SETDAT                                     AR317767
     C                   ENDIF                                                              AR317767
      *                                                                                     AR317767
      *                                                                                     BUG23102
      ** Set flag if FT transactions exist                                                  BUG23102
      *                                                                                     BUG23102
     C     *IN03         IFEQ      *ON                                                      BUG23102
     C     SPOS          ANDEQ     '  GE-FT'                                                BUG23102
     C**********         MOVE      *ON           *IN14                              BUG23102 260201A
     C                   MOVE      *ON           *IN15                                       260201A
      *                                                                                    AR994643A
      ** If FT transaction exist, adjust trailer file by subtracting 2                     AR994643A
      *                                                                                    AR994643A
     C     WFTFLD        IFEQ      ' '                                                     AR994643A
     C                   SUB       2             RECRED                                    AR994643A
     C                   MOVE      'Y'           WFTFLD            1                       AR994643A
     C                   ENDIF                                                             AR994643A
     C                   ENDIF                                                              BUG23102
      *                                                                                       CER049
      ***If*GLSTTRL3*record*read*-*set*flag****************************              CER049 AR889490
      ** If GLSTTRL1 record read - set flag                                                 AR889490
      *                                                                                       CER049
     C     *IN14         IFEQ      '1'                                                        CER049
      ** Bypass printing of Stamp Tax Posting                                               AR910445
      **  If CER049 is switched off                                                         AR910445
     C     *IN31         ANDEQ     '1'                                                      AR910445
     C                   MOVE      'Y'           @FLG1             1                          CER049
     C                   END                                                                  CER049
      *                                                                                       CGL120
     C     MODE          IFEQ      'P'                                                        CGL120
     C     GLFRFM        CASEQ     'APOSTPDF'    POSTNG                                       CGL120
     C     GLFRFM        CASEQ     'APOSTRAF'    RATCHG                                       CGL120
     C                   ENDCS                                                                CGL120
     C                   GOTO      ENDDTL                                                     CGL120
     C                   ENDIF                                                                CGL120
     C*
     C*    IF END OF SET OF ACPO TRAILERS
     C/COPY WNCPYSRC,GL0400C003
     C***41*****                                                                              CGL120
     C***ANN04**                                                                              CGL120
     C***ANN06**                                                                              CGL120
     C   41                                                                                   CGL120
     CANN06                                                                                   CGL120
     C*NN08N10N12          SETOF                         41               S03220
     C*N***N10N12**********SETOF                         41        S03220 E15192
     C/COPY WNCPYSRC,GL0400C009
     C***ANN08N10N12          SETOF                         41                         E15192 CER049
     CANN08
     CANN10
     CANN12                                                                                   CER049
     CANN14              SETOFF                                           41                  CER049
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0400CCPG                                           S01408
     C*                                                                   S01408
0131 C   01
     COR 03RECRED        ADD       1             RECRED            5 0
0133 C* DETERMINE IF CLEARING ITEM
0134 C                   SETOFF                                       02
0135 C  N01              TESTB     '4'           PRIN                     02
0133 C***********                                                  S01340 056524
0133 C**DETERMINE*IF*POSTING*TO*BE*INCLUDED*IN*EOD*MERGE***********S01340 056524
0133 C***********                                                  S01340 056524
0134 C***********          SETOF                     13            S01340 056524
0135 C***********          TESTB'6'       PRIN           13        S01340 056524
0133 C***********                                                  S01340 056524
     C/COPY WNCPYSRC,GL0400C007
0136 C   01
0137 C*OR*03N02**TOTACP****ADD  1         TOTACP  50                      S01340
0137 C*OR03N02N13TOTACP****ADD  1         TOTACP  50               S01340 056524
     COR 03
0137 CANN02TOTACP        ADD       1             TOTACP            5 0                        056524
     C/COPY WNCPYSRC,GL0400C008
0138 C*
0139 C*    IF DETAIL RECORD, ADD POSTING AMOUNT
0140 C*    TO HASH TOTAL.
     C  N01
     CANN03
0141 CANN09              GOTO      TOTAL
     C   01
0142 COR 09              GOTO      END
0143 C*
0144 C*    ACCUMULATE OVERALL HASH TOTALS
     C                   Z-ADD     PSTA          ZZAMT            15 3
0145 C**N02*********       Z-ADDPSTORI    ZZTOTI                          S01340
0146 C**N02*********       Z-ADDPSTORD    ZZTOTD                          S01340
0147 C**N02*********       EXSR GLZADD                                    S01340
0148 C**N02*********       Z-ADDZZTOTI    PSTORI 150                      S01340
0149 C**N02*********       Z-ADDZZTOTD    PSTORD  30   27                 S01340
0145 C**N02N13***          Z-ADDPSTORI    ZZTOTI                   S01340 056524
0146 C**N02N13***          Z-ADDPSTORD    ZZTOTD                   S01340 056524
0147 C**N02N13***          EXSR GLZADD                             S01340 056524
0148 C**N02N13***          Z-ADDZZTOTI    PSTORI 150               S01340 056524
0149 C**N02N13***          Z-ADDZZTOTD    PSTORD  30   27          S01340 056524
0145 C  N02              Z-ADD     PSTORI        ZZTOTI                                       056524
0146 C  N02              Z-ADD     PSTORD        ZZTOTD                                       056524
0147 C  N02              EXSR      GLZADD                                                     056524
0148 C  N02              Z-ADD     ZZTOTI        PSTORI           15 0                        056524
0149 C  N02              Z-ADD     ZZTOTD        PSTORD            3 0  27                    056524
0150 C*
0151 C*    ACCUMULATE HASH TOTALS FOR EACH FILE
0152 C                   Z-ADD     PISTRI        ZZTOTI
0153 C                   Z-ADD     PISTRD        ZZTOTD
0154 C                   EXSR      GLZADD
0155 C                   Z-ADD     ZZTOTI        PISTRI           15 0
0156 C                   Z-ADD     ZZTOTD        PISTRD            3 0
0157 C                   GOTO      END
0184 C*
0176 C*
     C* IF TRAILER RECORD,MAINTAIN TOTALS FOR EACH ACPO FILE
     C*       - CALC VALUES - SAVE FOR EACH ACPO IN INN,I,D
     C*       - FILE VALUES - ACCUM.FROM TRLRS FOR EACH ACPO IN TRN,I,D
     C*
0161 C     TOTAL         TAG                                                    ** TOTAL TAG **
     C*
     C***04*****         Z-ADD     1             P                 1 0                        CGL120
     C***06*****         Z-ADD     2             P                                            CGL120
     C   06              Z-ADD     2             P                 1 0                        CGL120
     C** 08                Z-ADD3         P                               S03320
     C   08              Z-ADD     3             P                                            E15192
     C   10              Z-ADD     4             P
     C   16              Z-ADD     7             P                                            CGL049
     C********** TEST10    IFNE 'Y'                                       209670              201071
     C     TEST10        IFNE      'Y'                                                      BUG10057
     C     *IN12         IFNE      '1'                                                        201194
     C     *IN10         IFEQ      '1'                                                        179146
     C                   MOVE      'Y'           TEST10            1                          179146
     C                   ELSE                                                                 179146
     C                   MOVE      ' '           TEST10                                       179146
     C                   END                                                                  179146
     C                   ENDIF                                                                201194
     C**********           END                                            209670              201071
     C                   ENDIF                                                              BUG10057
     C   12              Z-ADD     5             P
     C   14              Z-ADD     6             P                                            CER049
     C/COPY WNCPYSRC,GL0400C004
0158 C*
      *                                                                                     BUG23102
      ** Add/Deduct to/from INPUT only if not zero and put back                             BUG23102
      ** what was deducted if Funds Transfer transactions exist,                            BUG23102
      ** i.e. GEFPPD has records and GEFPZZ.NORE1>0                                         BUG23102
      *                                                                                     BUG23102
     C     NORE          IFGT      0                                                        BUG23102
     C                   ADD       NORE          TRN(P)            5 0
     C                   Z-ADD     ZZINT         ZZTOTI
     C********** TRN,P     SUB  2         TRN,P                                              BUG7004
     C     TRN(P)        SUB       2             TRN(P)                                     BUG12484
      *                                                                                     BUG23102
     C******IN36         IFEQ      '1'                                               BUG23102 CGL049
     C******INU6         ANDEQ     '1'                                               BUG23102 CGL049
     C******IN14         ANDEQ     '1'                                              BUG23102 260201A
     C******IN15         ANDEQ     '1'                                                260201A CGL049
     C******             ADD       2             TRN(P)                              BUG23102 CGL049
     C******             MOVE      *BLANKS       SPOS                                BUG23102 CGL049
     C**********         MOVE      *OFF          *IN14                              BUG23102 260201A
     C******             MOVE      *OFF          *IN15                                260201A CGL049
     C******             ENDIF                                                       BUG23102 CGL049
      *                                                                                     BUG23102
     C                   Z-ADD     ZZDEC         ZZTOTD
     C                   Z-ADD     TRI(P)        ZZAMTI
     C                   Z-ADD     TRD(P)        ZZAMTD
     C                   EXSR      GLZSUM
     C                   Z-ADD     ZZTOTI        TRI(P)
     C                   Z-ADD     ZZTOTD        TRD(P)
     C                   ENDIF                                                              BUG23102
0166 C*
0175 C*
0177 C*
     C*
     C*    1ST TRLR FOR ANY ACPO-SAVE CALC VALUES
     C*    41 RESET WHEN NEXT HDR OR DET READ
     C     *IN41         IFEQ      '0'
     C                   Z-ADD     RECRED        INN(P)
     C                   Z-ADD     PISTRI        INI(P)
     C                   Z-ADD     PISTRD        IND(P)
     C**********           Z-ADD2         RECRED                                             BUG7004
     C**********           Z-ADD0         RECRED                                      BUG7004 264038
     C**********         Z-ADD     2             RECRED                              264038 AR994643
     C                   Z-ADD     0             RECRED                                     AR994643
     C                   Z-ADD     0             PISTRI
     C                   Z-ADD     0             PISTRD
     C                   SETON                                        41
     C                   END
     C*
     C/COPY WNCPYSRC,GL0400C010
0185 C     END           TAG                                                    ** END TAG   **
0187 C*
0108  *                                                                   E11708
      ** Check Retail Indicator (must be numeric)                         E11708
     C     RINDA         IFEQ      *BLANK                                                     E11708
     C                   MOVE      '0'           RINDA                                        E11708
     C                   END                                                                  E11708
     C     RINDB         IFEQ      *BLANK                                                     E16678
     C                   MOVE      '0'           RINDB                                        E16678
     C                   END                                                                  E16678
     C     ENDDTL        TAG                                                                  CGL120
      * No Audit reort required                                                               CGL120
     C                   SETOFF                                       34                      CGL120
0187 C*
0188 C*    TOTAL TIME CALCULATIONS.
0164 C***LR*****            SETON                                        35                   CGL120
     C*    COMPARE AND PRINT CALC/TRLR CONTROLS FOR EACH ACPO
     C***LR*****            Z-ADD     1             P                                         CGL120
     C***LR*****            EXSR      COMP                                                    CGL120
     CLR U1              Z-ADD     1             P                                            CGL120
     CLR U1              EXSR      COMP                                                       CGL120
     CLR U2              Z-ADD     2             P
     CLR U2              EXSR      COMP
     C*LR U3                Z-ADD3         P                              S03220
     C*LR U3                EXSR COMP                                     S03220
     CLR U3              Z-ADD     3             P                                            E15192
     CLR U3              EXSR      COMP                                                       E15192
     CLR U4              Z-ADD     4             P
     CLR U4              EXSR      COMP
     CLR U5              Z-ADD     5             P
     CLR U5              EXSR      COMP
     CLR U6              Z-ADD     7             P                                            CGL049
     CLR U6              EXSR      COMP                                                       CGL049
      *                                                                                       CER049
      ***Process*trailer*GLSTTRL3**************************************              CER049 AR889490
      ** Process trailer GLSTTRL1                                                           AR889490
      *                                                                                       CER049
     CLR   @FLG1         IFEQ      'Y'                                                        CER049
     CLR                 Z-ADD     6             P                                            CER049
     CLR                 EXSR      COMP                                                       CER049
     CLR                 END                                                                  CER049
      *                                                                                       CER049
                                                                                            MD022412
      ** Write to EODPOZZ trailer file                                                      MD022412
                                                                                            MD022412
     CLR   MODE          IFNE      'S'                                                      MD034502
     CLR                 MOVE      'T'           RECI                                       MD022412
     CLR                 Z-ADD     TOTACP        NORE1                                      MD022412
     CLR                 Z-ADD     PSTORI        HRWN                                       MD022412
     CLR                 Z-ADD     PSTORD        HRDC                                       MD022412
     CLR                 WRITE     APOSTZZF                                                 MD022412
     CLR                 ENDIF                                                              MD034502
                                                                                            MD022412
     C/COPY WNCPYSRC,GL0400C005
0189 C***LR***TOTACP        ADD       2             TOTREC            5 0                     CGL120
     C***LR                 READ      APOSTZZF                               61      CGL120 MD022412
     C***LR 61              MOVE      'T'           RECI                             CGL120 MD022412
     C***LR 61              Z-ADD     TOTACP        NORE1                            CGL120 MD022412
     C***LR 61              Z-ADD     PSTORI        HRWN                             CGL120 MD022412
     C***LR 61              Z-ADD     PSTORD        HRDC                             CGL120 MD022412
     C***LR 61              WRITE     APOSTZZF                                       CGL120 MD022412
     C***LRN61              ADD       TOTACP        NORE1                            CGL120 MD022412
     C***LRN61PSTORD        ADD       HRDC          WKN40             4 0            CGL120 MD022412
     C***LRN61WKN40         IFLT      1000                                           CGL120 MD022412
     C***LRN61              ADD       PSTORI        HRWN                             CGL120 MD022412
     C***LRN61              ADD       PSTORD        HRDC                             CGL120 MD022412
     C***LR                 ELSE                                                     CGL120 MD022412
     C***LRN61WKN40         SUB       1000          WKN40                            CGL120 MD022412
     C***LRN61              ADD       PSTORI        HRWN                             CGL120 MD022412
     C***LRN61              ADD       1             HRWN                             CGL120 MD022412
     C***LRN61              Z-ADD     WKN40         HRDC                             CGL120 MD022412
     C***LR                 ENDIF                                                    CGL120 MD022412
     C***LRN61              UPDATE    APOSTZZF                                       CGL120 MD022412
     C*                                                                   S01117
     CLR   MODE          IFEQ      'S'                                                      MD034502
     CLR                 READ      APOSTZZF                               61                MD034502
     CLR   *IN61         IFEQ      *ON                                                      MD034502
     CLR                 MOVE      'T'           RECI                                       MD034502
     CLR                 Z-ADD     TOTACP        NORE1                                      MD034502
     CLR                 Z-ADD     PSTORI        HRWN                                       MD034502
     CLR                 Z-ADD     PSTORD        HRDC                                       MD034502
     CLR                 WRITE     APOSTZZF                                                 MD034502
     CLR                 ENDIF                                                              MD034502
     CLR   *IN61         IFEQ      *OFF                                                     MD034502
     CLR                 ADD       TOTACP        NORE1                                      MD034502
     CLR   PSTORD        ADD       HRDC          WKN40             4 0                      MD034502
     CLR   WKN40         IFLT      1000                                                     MD034502
     CLR                 ADD       PSTORI        HRWN                                       MD034502
     CLR                 ADD       PSTORD        HRDC                                       MD034502
     CLR                 ELSE                                                               MD034502
     CLR   WKN40         SUB       1000          WKN40                                      MD034502
     CLR                 ADD       PSTORI        HRWN                                       MD034502
     CLR                 ADD       1             HRWN                                       MD034502
     CLR                 Z-ADD     WKN40         HRDC                                       MD034502
     CLR                 ENDIF                                                              MD034502
     CLR                 UPDATE    APOSTZZF                                                 MD034502
     CLR                 ENDIF                                                              MD034502
     CLR                 ENDIF                                                              MD034502
     C*****************************************************************
     C*    COMP SR  TO COMPARE AND PRINT CALC/TRLR CONTROLS FOR EACH ACPO
     C     COMP          BEGSR                                                  ** COMP SR   **
     C**IF*ACPO1*BEING*PROCESSED*ADJUST*BY*2*FOR*GEFPPD,ZZ*************                S03220 CAP204
     C**IF*GLACPML0*BEING*PROCESSED*ADJUST*BY*2*FOR*GEFPPD,ZZ**********        S03220 CAP204BUG23102
      *                                                                                     BUG23102
      ** Not necessary, the 2 deducted from TRN was put back                                BUG23102
      *                                                                                     BUG23102
     C********** P         IFEQ 1                                                    S03220 BUG23102
     C***36 U6             SUB  2         INN,P                           S03220
     C***36 U6             SUB  1         INN,P                           S03220
     C***36*U6**           SUB  2         INN,P                                       S03220 BUG7004
     C**********           END                                                       S03220 BUG23102
     C*****P****         IFEQ      1                                                 264038 AR994643
     C***36*****                                                                     264038 AR994643
     C***AN*U6**            SUB       2             INN(P)                           264038 AR994643
     C**********         END                                                         264038 AR994643
     C**IF*ACPO5*BEING*PROCESSED*ADJUST*BY*2*FOR*GEFP2PD,ZZ**********                S03220 BUG23102
      *                                                                                     BUG23102
      ** Not necessary, the 2 deducted from TRN was put back                                BUG23102
      *                                                                                     BUG23102
     C********** P         IFEQ 5                                                    S03220 BUG23102
     C***36 U6             SUB  2         INN,P                           S03220
     C***36 U6             SUB  1         INN,P                           S03220
     C***36*U6**           SUB  2         INN,P                                       S03220 BUG7004
     C**********           END                                                       S03220 BUG23102
     C*****P****         IFEQ      5                                                 264038 AR994643
     C***36*****                                                                     264038 AR994643
     C***AN*U6**            SUB       2             INN(P)                           264038 AR994643
     C**********         END                                                         264038 AR994643
     C/COPY WNCPYSRC,GL0400C006
      **If GLGESTL2 being processed adjust by 2 for GLGESTPD,ZZ                               CER049
     C     P             IFEQ      6                                                          CER049
     C     INN(P)        ANDEQ     0                                                          CER049
     C                   ADD       2             INN(P)                                       CER049
     C                   END                                                                  CER049
      *                                                                   179146
     C**IF*ACPO4*NOT*READ,*TRN,P*SHOULD*BE*ZERO**********************                179146 BUG23102
      *                                                                                     BUG23102
      ** TRN is already initialized to 0 at the start                                       BUG23102
      *                                                                                     BUG23102
     C********** P         IFEQ 4                                                     179146 BUG7004
     C********** TEST10    ANDNE'Y'                                                   179146 BUG7004
     C********** TRN,P     ANDNE0                                                     201071 BUG7004
     C**********           SUB  2         TRN,P                                       179146 BUG7004
     C********** INN,P     IFNE 0                                                     201071 BUG7004
     C**********           SUB  2         INN,P                                       201071 BUG7004
     C**********           END                                                        201071 BUG7004
     C**********           END                                                        179146 BUG7004
     C*****P****         IFEQ      4                                                 264038 AR994643
     C*****TEST10        ANDNE     'Y'                                               264038 AR994643
     C**********         SUB       2             TRN(P)                              264038 AR994643
     C**********         END                                                         264038 AR994643
      *                                                                   179146
     C     INN(P)        COMP      TRN(P)                             2525
     C  N25INI(P)        COMP      TRI(P)                             2525
     C  N25IND(P)        COMP      TRD(P)                             2525
     C***25*****         SETON                                        U8                      CGL120
     C**********         EXCEPT                                                             MD022412
     C                   ENDSR                                                  ** ENDSR     **
0191 C********************************************************************
0191 C********************************************************************S01194
0192 C***********                                                         S01194
0193 C*****ZSYSTM*SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.   S01194
0194 C***********                                                         S01194
0195 C***********ZSYSTM    BEGSR                           *** ZSYSTM *** S01194
0196 C***********                                                         S01194
0197 C*****SET*UP KEY FOR INSTALLATION CONTROL RECORD.                    S01194
0198 C***********          MOVEL'01      'ZTABKY 12                       S01194
0199 C***********          MOVE '  10'    ZTABKY                          S01194
0200 C***********                                                         S01194
0201 C***********ZTABKY    CHAINTABLE                99    ON NOT THERE   S01194
0202 C**N99******RECI      COMP 'D'                  9999  ON, IS DELETED S01194
0203 C***********                                                         S01194
0204 C*****CHECK*SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.                    S01194
0205 C***********DATF      COMP 'M'                      98MMDDYY, 98 ON  S01194
0206 C***********                                                         S01194
0207 C***********          ENDSR                                          S01194
0208 C***********                                                         S01194
0209 C***********                                                         S01194
0210 C********************************************************************
0211 C********************************************************************
0212 C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
0213 C*   IND '99' IS SET BY AN OVERFLOW ERROR
0214 C*
0215 CSR   GLZADD        BEGSR                                                  *** GLZADD ****
0216 C*
0217 CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
0218 CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
0219 C*
0220 C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
0221 CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
0222 CSR                 Z-ADD     ZZAMT         ZZWK1             3 3
0223 CSR                 MOVE      ZZWK1         ZZAMTD            3 0          DECIMAL FIELD
0224 C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
0225 C*
0226 CSR                 EXSR      GLZSUM
0227 CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
0228 C*
0229 C********************************************************************
0315 C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
0316 C*                        GLZADD, GLZSUB, GLZCMP.
0317 C*          PARAMETERS PASSED -
0318 C*                     I/P ZZAMTI ZZAMTD
0319 C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
0320 C*
0321 CSR   GLZSUM        BEGSR                                                  *** GLZSUM ****
0322 C*
0323 CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
0324 CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
0325 CSR                 SETOFF                                       919293
0326 CSR                 SETOFF                                       949599
0327 C*
0328 C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
0329 CSR   ZZAMTI        COMP      0                                    9293
0330 CSR 93ZZAMTD        COMP      0                                    9293
0331 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
0332 C*
0333 C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
0334 CSR   ZZTOTI        COMP      0                                    9193
0335 CSR 93ZZTOTD        COMP      0                                    9193
0336 C*
0337 C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
0338 CSR 93              Z-ADD     ZZAMTI        ZZTOTI
0339 CSR 93              Z-ADD     ZZAMTD        ZZTOTD
0340 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
0341 C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
0342 CANN92
     CORN91
0343 CAN 92              GOTO      ZZOFPS
0344 C*
0345 CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
0346 CSR   ZZWK2         COMP      999                                93        '93' = CARRY
0347 CSRN93ZZWK2         COMP      -999                                 93             INTO INTEGER.
0348 C*
     CSR 93
0349 CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
0350 CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
0351 CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
0352 CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
0353 C*
0354 C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
0355 CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
0356 CSR 92ZZWK3         COMP      ZZTOTI                             99                    NEGATIVE
0357 CSRN99              Z-ADD     ZZWK2         ZZTOTD
0358 CSRN99              Z-ADD     ZZWK3         ZZTOTI
0359 C*
0360 C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
0361 CSR 99              Z-ADD     0             ZZAMT            15 3
0362 CSR                 GOTO      ZZSEND
0363 C*
0364 C* THE 'SIGNS' ARE DIFFERENT
0365 CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
0366 C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
0367 C*
0368 CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
0369 CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
0370 C*
0371 C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
0372 C*
0373 CSR 91              Z-SUB     ZZTOTI        ZZTOTI
0374 CSR 91              Z-SUB     ZZTOTD        ZZTOTD
0375 C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
0376 C*
0377 CSR   ZZTOTI        COMP      ZZAMTI                             93  95
0378 CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
0379 C*
0380 C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
0381 CSR 95              Z-ADD     0             ZZTOTI
0382 CSR 95              Z-ADD     0             ZZTOTD
0383 CSR 95              GOTO      ZZSEND
0384 C*
0385 C* IF ZZTOT GT. ZZAMT.
0386 CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
0387 CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
0388 CAN 94ZZTOTD        ADD       1000          ZZWK2
0389 CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
0390 CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
0391 CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
0392 C*
0393 C*
0394 C* IF ZZAMT GT. ZZTOT.
0395 CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
0396 CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
0397 CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
0398 CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
0399 CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
0400 CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
0401 CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
0402 C*
0403 C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
0404 CSR                 SETOFF                                       94
     CSR 93
0405 CAN 91
     CORN93
0406 CAN 92              SETON                                        94
0407 CSR 94              Z-SUB     ZZTOTI        ZZTOTI
0408 CSR 94              Z-SUB     ZZTOTD        ZZTOTD
0409 C**
0410 C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
0411 CSR 92              Z-SUB     ZZAMTI        ZZAMTI
0412 CSR 92              Z-SUB     ZZAMTD        ZZAMTD
0413 CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
0414 C**
0415 C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
0416 CSR                 SETOFF                                       96
0417 CSR   ZZTOTD        COMP      0                                      91
0418 CSR 91ZZTOTI        COMP      0                                    96
0419 CSR 96              MOVE      '.000-'       ZZNEGD            5
0420 CSR                 ENDSR                                                    ** ENDSR **
0421 C********************************************************************
     C**                                                                  S01194
     C**   *PSSR  SR TO DUMP PROGRAM WHEN DATABASE ERROR OCCURS           S01194
     C**                                                                  S01194
     C     *PSSR         BEGSR                                                                S01194
     C     @RUN          IFEQ      *BLANKS                                                    S01194
     C                   MOVE      'Y'           @RUN              1                          S01194
     C                   DUMP                                                                 S01194
     C                   END                                                                  S01194
     C                   ENDSR                                                                S01194
     C**                                                                  S01194
     C/COPY WNCPYSRC,GL0400C001
     C*****************************************************************   S01194
      ********************************************************************                    CGL120
      *                                                                  *                    CGL120
      * SR/POSTNG - Process Account Postings                             *                    CGL120
      *                                                                  *                    CGL120
      ********************************************************************                    CGL120
     C     POSTNG        BEGSR                                                                CGL120
     C     GLFRFL        IFNE      'GEDLPD'                                                   CGL120
      *                                                                                       CGL120
      ** Overide to  the file that is to be processed                                         CGL120
      *                                                                                       CGL120
     C     CMD(1)        CAT       GLFRFL        WKCMD            37                          CGL120
     C     WKCMD         CAT       ')'           WKCMDO           38                          CGL120
     C                   Z-ADD     38            WKSZE                                        CGL120
     C                   CALL      'QCMDEXC'                                                  CGL120
     C                   PARM                    WKCMDO           38                          CGL120
     C                   PARM                    WKSZE            15 5                        CGL120
     C                   ENDIF                                                                CGL120
      *                                                                                       CGL120
      ** Open file                                                                            CGL120
      *                                                                                       CGL120
     C                   OPEN      GEDLPD                                                     CGL120
      *                                                                                       CGL120
      ** Set file position                                                                    CGL120
      *                                                                                       CGL120
     C                   Z-ADD     GLFRRN        WKRRN            10 0                        CGL120
     C     WKRRN         SETLL     GEDLPD                             90                      CGL120
     C                   READ      GEDLPD                                 90                  CGL120
      *                                                                                       CGL120
      ** Read first record in block                                                           CGL120
      ** Check if current RRN is LE the TO RRN and NOT EOF                                    CGL120
      *                                                                                       CGL120
     C     WKRRN         DOWLE     GLTRRN                                                     CGL120
     C     *IN90         ANDEQ     *OFF                                                       CGL120
      *                                                                                       CGL120
      ** Current RRN is LE the TO RRN and NOT EOF: Process                                    CGL120
      *                                                                                       CGL120
     C     RECI          IFEQ      'P'                                                        CGL120
     C                   EXSR      PROC1A                                                     CGL120
     C                   EXSR      PROC02                                                     CGL120
     C  N02              EXCEPT    EODPOP                                                     CGL120
     C                   ENDIF                                                                CGL120
     C                   READ      GEDLPD                                 90                  CGL120
     C                   ENDDO                                                                CGL120
      *                                                                                       CGL120
      ** Close file                                                                           CGL120
      *                                                                                       CGL120
     C                   CLOSE     GEDLPD                                                     CGL120
     C     GLFRFL        IFNE      'GEDLPD'                                                   CGL120
      *                                                                                       CGL120
      ** Remove override                                                                      CGL120
      *                                                                                       CGL120
     C                   MOVEL     CMD(2)        WKCMDD                                       CGL120
     C********           Z-ADD     26            WKSZE                                        CGL120
     C                   Z-ADD     19            WKSZE                                        CGL120
     C                   CALL      'QCMDEXC'                                                  CGL120
     C                   PARM                    WKCMDD           26                          CGL120
     C                   PARM                    WKSZE                                        CGL120
     C                   ENDIF                                                                CGL120
     CSR   ENDPST        ENDSR                                                                CGL120
      ********************************************************************                    CGL120
      ********************************************************************                    CGL120
      *                                                                  *                    CGL120
      *    PROC1A                                                        *                    CGL120
      *                                                                  *                    CGL120
      ********************************************************************                    CGL120
     C     PROC1A        BEGSR                                                                CGL120
      *                                                                                       CGL120
     C     RECRED        ADD       1             RECRED            5 0                        CGL120
      *                                                                                       CGL120
      ** Determine if clearing item                                                           CGL120
      *                                                                                       CGL120
     C                   SETOFF                                       02                      CGL120
     C                   TESTB     '4'           PRIN                     02                  CGL120
     C  N02TOTACP        ADD       1             TOTACP            5 0                        CGL120
     C  N02RINDB         IFEQ      *BLANK                                                     CGL120
     C                   MOVE      '0'           RINDB                                        CGL120
     C                   ENDIF                                                                CGL120
     C                   ENDSR                                                                CGL120
      ********************************************************************                    CGL120
      *                                                                  *                    CGL120
      *    PROC02                                                        *                    CGL120
      *                                                                  *                    CGL120
      ********************************************************************                    CGL120
     C     PROC02        BEGSR                                                                CGL120
      *                                                                                       CGL120
      ** Accumulate overall hash totals                                                       CGL120
      *                                                                                       CGL120
     C                   Z-ADD     PSTA          ZZAMT            15 3                        CGL120
     C  N02              Z-ADD     PSTORI        ZZTOTI                                       CGL120
     C  N02              Z-ADD     PSTORD        ZZTOTD                                       CGL120
     C  N02              EXSR      GLZADD                                                     CGL120
     C  N02              Z-ADD     ZZTOTI        PSTORI           15 0                        CGL120
     C  N02              Z-ADD     ZZTOTD        PSTORD            3 0  27                    CGL120
      *                                                                                       CGL120
      ** Accumulate hash totals for each file                                                 CGL120
      *                                                                                       CGL120
     C                   Z-ADD     PISTRI        ZZTOTI                                       CGL120
     C                   Z-ADD     PISTRD        ZZTOTD                                       CGL120
     C                   EXSR      GLZADD                                                     CGL120
     C                   Z-ADD     ZZTOTI        PISTRI           15 0                        CGL120
     C                   Z-ADD     ZZTOTD        PISTRD            3 0                        CGL120
     C     ENDPC2        ENDSR                                                                CGL120
      ********************************************************************                    CGL120
      ********************************************************************                    CGL120
      *                                                                  *                    CGL120
      *    SR/RATCHG - Process Rate Change Postings                      *                    CGL120
      *                                                                  *                    CGL120
      ********************************************************************                    CGL120
     C     RATCHG        BEGSR                                                                CGL120
      *                                                                                       CGL120
      ** Check if file is not RCHGRA                                                          CGL120
      *                                                                                       CGL120
     C     GLFRFL        IFNE      'RCHGRA'                                                   CGL120
      *                                                                                       CGL120
      ** File is not RCHGRA: Overide to the file that is to be processed                      CGL120
      *                                                                                       CGL120
     C     CMD(3)        CAT       GLFRFL        WKCMD            37                          CGL120
     C     WKCMD         CAT       ')'           WKCMDO           38                          CGL120
     C                   Z-ADD     38            WKSZE                                        CGL120
     C                   CALL      'QCMDEXC'                                                  CGL120
     C                   PARM                    WKCMDO           38                          CGL120
     C                   PARM                    WKSZE            15 5                        CGL120
     C                   ENDIF                                                                CGL120
      *                                                                                       CGL120
      ** Open file                                                                            CGL120
      *                                                                                       CGL120
     C                   OPEN      RCHGRA                                                     CGL120
      *                                                                                       CGL120
      ** Set file position                                                                    CGL120
      *                                                                                       CGL120
     C                   Z-ADD     GLFRRN        WKRRN                                        CGL120
     C     WKRRN         SETLL     RCHGRA                                                     CGL120
      *                                                                                       CGL120
      ** Read first record in block                                                           CGL120
      *                                                                                       CGL120
     C                   READ      RCHGRA                                 90                  CGL120
      *                                                                                       CGL120
      ** Check if current RRN is LE the TO RRN and NOT EOF                                    CGL120
      *                                                                                       CGL120
     C     WKRRN         DOWLE     GLTRRN                                                     CGL120
     C     *IN90         ANDEQ     *OFF                                                       CGL120
      *                                                                                       CGL120
      ** Current RRN is LE the TO RRN and NOT EOF: Process                                    CGL120
      *                                                                                       CGL120
     C     RECI          IFEQ      'R'                                                        CGL120
     C                   EXSR      PROC1B                                                     CGL120
     C                   EXCEPT    EODPOR                                                     CGL120
     C                   ENDIF                                                                CGL120
     C                   READ      RCHGRA                                 90                  CGL120
     C                   ENDDO                                                                CGL120
      *                                                                                       CGL120
      ** Close file                                                                           CGL120
      *                                                                                       CGL120
     C                   CLOSE     RCHGRA                                                     CGL120
      *                                                                                       CGL120
      ** Check if file is not RCHGRA                                                          CGL120
      *                                                                                       CGL120
     C     GLFRFL        IFNE      'RCHGRA'                                                   CGL120
      *                                                                                       CGL120
      ** File is not RCHGRA: Remove ovrride                                                   CGL120
      *                                                                                       CGL120
     C                   MOVEL     CMD(4)        WKCMDD                                       CGL120
     C********           Z-ADD     26            WKSZE                                        CGL120
     C                   Z-ADD     19            WKSZE                                        CGL120
     C                   CALL      'QCMDEXC'                                                  CGL120
     C                   PARM                    WKCMDD           26                          CGL120
     C                   PARM                    WKSZE                                        CGL120
     C                   ENDIF                                                                CGL120
     C     ENDRCH        ENDSR                                                                CGL120
      ********************************************************************                    CGL120
      *                                                                  *                    CGL120
      *    PROC1B                                                        *                    CGL120
      *                                                                  *                    CGL120
      ********************************************************************                    CGL120
     C     PROC1B        BEGSR                                                                CGL120
      *                                                                                       CGL120
     C     RECRED        ADD       1             RECRED            5 0                        CGL120
     C     TOTACP        ADD       1             TOTACP            5 0                        CGL120
     C     RINDA         IFEQ      *BLANK                                                     CGL120
     C                   MOVE      '0'           RINDA                                        CGL120
     C                   ENDIF                                                                CGL120
     C                   ENDSR                                                                CGL120
      ********************************************************************                    CGL120
0422 O***EODPOHH   D    34                                                                    CGL120
0423 O**********                                  1 'H'                                       CGL120
0424 O*EODPOPD*D*******03N02                                              S01340
0424 O***EODPOPD*D********03N02N13*******                          S01340 056524
0424 O***EODPOPD   D    03N02                                                          056524 CGL120
     OEODPOPD   D    03N02N77                                                                 CGL120
0426 O* POSTINGS RECORD
0427 O*************************ACPREC   160                               S05452
0427 O***********              ACPRC    200                        S05452 S03220
0427 O***********              ACPRC    215                        S03220 S01117
     O/COPY WNCPYSRC,GL0400O001
     O                       PRFC               134                             S01182
     O**********               OTRF     230                                            S01182 CGL029
     O                       OTRFQQ             230                                           CGL029
     O                       OTST               240                             S01182
     O                       OTTP               250                             S01182
     O                       SDCB               258P                            S01182
     O                       SDLB               266P                            S01182
     O                       BOKC               268                             S01182
     O/COPY WNCPYSRC,GL0400O002
0427 O***********              ACPRC    268                        S01117 CRT001
0427 O***********              ACPRC    316                        CRT001 CEU013
0427 O***********              ACPRC    329                        CEU013 CGL007
     O                       NITMS              271P                                        AR317767
     O                       CHGA               279P                                          CGL120
     O                       ORAMT              216P                                          CGL120
0427 O                       ACPRC              331                             CGL007
     O                       ACKEY              351                                           CGL020
     O                       FEEFLG             352                                           CGL020
     O                       FEEVAL             359P                                          CGL020
     O                       FEEPCT             364                                           CGL020
     O                       RORACT             384                                           CGL020
     O                       RORCTY             386                                           CGL020
     O                       RORBNK             406                                           CGL020
     O                       RORCDE             417                                           CGL020
     O                       PORACT             437                                           CGL020
     O                       PORCTY             439                                           CGL020
     O                       PORBNK             459                                           CGL020
     O                       PORCDE             470                                           CGL020
     O                       DSTACT             505                                           CGL020
     O                       DSTCTY             507                                           CGL020
     O                       DSTBNK             527                                           CGL020
     O                       SETDAT             530P                                          CGL020
     O                       TICKER             540                                           CGL020
     O                       EXCHNG             560                                           CGL020
     O                       NOMINL             573                                           CGL020
     O                       FDTRID             589                                           CGL020
     O                       ACOD               599                                           CGL029
     O                       OTRF               620                                           CGL029
     O/COPY WNCPYSRC,GL0400O003
     OEODPOPD   E            EODPOP                                                           CGL120
     O/COPY WNCPYSRC,GL0400O001                                                               CGL120
     O                       PRFC               134                                           CGL120
     O                       OTRFQQ             230                                           CGL120
     O                       OTST               240                                           CGL120
     O                       OTTP               250                                           CGL120
     O                       SDCB               258P                                          CGL120
     O                       SDLB               266P                                          CGL120
     O                       BOKC               268                                           CGL120
     O/COPY WNCPYSRC,GL0400O002                                                               CGL120
     O                       NITMS              271P                                          CGL120
     O                       CHGA               279P                                          CGL120
     O                       ORAMT              216P                                          CGL120
     O                       ACPRC              331                                           CGL120
     O                       ACKEY              351                                           CGL120
     O                       FEEFLG             352                                           CGL120
     O                       FEEVAL             359P                                          CGL120
     O                       FEEPCT             364                                           CGL120
     O                       RORACT             384                                           CGL120
     O                       RORCTY             386                                           CGL120
     O                       RORBNK             406                                           CGL120
     O                       RORCDE             417                                           CGL120
     O                       PORACT             437                                           CGL120
     O                       PORCTY             439                                           CGL120
     O                       PORBNK             459                                           CGL120
     O                       PORCDE             470                                           CGL120
     O                       DSTACT             505                                           CGL120
     O                       DSTCTY             507                                           CGL120
     O                       DSTBNK             527                                           CGL120
     O                       SETDAT             530P                                          CGL120
     O                       TICKER             540                                           CGL120
     O                       EXCHNG             560                                           CGL120
     O                       NOMINL             573                                           CGL120
     O                       FDTRID             589                                           CGL120
     O                       ACOD               599                                           CGL120
     O                       OTRF               620                                           CGL120
     O/COPY WNCPYSRC,GL0400O003                                                               CGL120
     OEODPORA   E            EODPOR                                                           CGL120
     O                       ACPREC             170                                           CGL120
     O***EODPORA   D    01                                                                    CGL120
     OEODPORA   D    01N77                                                                    CGL120
     O**********               ACPREC   160                                                   CGL029
     O                       ACPREC             170                                           CGL029
     O/COPY WNCPYSRC,GL0400O004
0428 O*
0429 O***EODPOZZ   T    LR                                                                    CGL120
0430 O**********                                  1 'T'                                       CGL120
0431 O**********             TOTREC               6                                           CGL120
0432 O**********             PSTORI              14P                                          CGL120
0433 O**********             PSTORD              16P                                          CGL120
0434 O* CONTROL TOTALS OF NUMBER OF RECORDS READ FROM EACH INPUT FILE
0435 O* AND NUMBER OF RECORDS WRITTEN TO OUTPUT FILE
0436 O*
0437 O*L0400P1D**203   34                                       S01124    S01117
0437 O***GL0400AU  D    34                     2 03                                    S01117 CGL120
     O***GL0400AU  H    1P                     2 03                                  CGL120 MD022412
     OGL0400AU  H    1P U7 60               2 03                                            MD022412
0438 O***********                        22 'REFERENCE GL0400'            S01117
0438 O                                           24 'REFERENCE GL0400AU'        S01117
0439 O***********              TITL      89                               S01194
0439 O                       BJURPT              89                             S01194
0440 O                                          104 'DATE'
0441 O                       RUNA               113
0442 O                                          122 'PAGE'
0443 O                       PAGE          Z    127
0444 O**********D    34                     1                                                 CGL120
     O**********H    1P                     1                                        CGL120 MD022412
0445 O***********                        60 'ACCOUNTS POSTING MERGE'      S01117
0446 O***********                        84 '-  FILE CONTROL REPORT'      S01117
0445 O**********                                 69 'ACCOUNTS POSTING MERGE'         S01117 MD022412
     O**********                                 85 '    RUN CONTROLS'               S01117 MD022412
0447 O**********D    34                     2                                                 CGL120
     O**********H    1P                     2                                        CGL120 MD022412
0448 O***********                        62 '------------------------'    S01117
0449 O***********                        84 '----------------------'      S01117
     O**********                                 69 '----------------------'         S01117 MD022412
0450 O**********D    34                     1                                               MD022412
0451 O**********                                 50 'INPUT'                                 MD022412
0452 O**********                                 96 'CALCULATED'                            MD022412
0453 O**********D    34                     2                                               MD022412
0454 O**********                                 41 'READ'                                  MD022412
0455 O**********                                 63 'VALUE'                                 MD022412
0456 O**********                                 84 'READ'                                  MD022412
0457 O**********                                106 'VALUE'                                 MD022412
0460 O**********E    35                  1  1                                               MD022412
0461 O**********             NARR(P)             35                                         MD022412
0468 O**********             TRN(P)        3     41                                         MD022412
0469 O**********             TRI(P)        Z     60                                         MD022412
0470 O**********             TRD(P)              63                                         MD022412
0474 O**********             INN(P)        3     84                                         MD022412
0475 O**********             INI(P)        Z    103                                         MD022412
0476 O**********             IND(P)             106                                         MD022412
0480 O**********     25                         126 '** DISCREPANCY **'                     MD022412
0481 O**********T    LR                  2  2                                                 CGL120
     O**********T    LR 60               2  2                                        CGL120 MD022412
0482 O**********                                 29 'NUMBER OF ACCOUNT PO'                  MD022412
0483 O**********                                 43 'STINGS WRITTEN'                        MD022412
0484 O**********             TOTACP        3     67                                         MD022412
0485 O**********T    LR                     2                                                 CGL120
     O**********T    LR 60                  2                                        CGL120 MD022412
0486 O**********                                 29 'VALUE OF ACCOUNT PO'                   MD022412
0487 O**********                                 43 'STINGS WRITTEN'                        MD022412
0488 O**********             PSTORI        Z     64                                         MD022412
0489 O**********             PSTORD              67                                         MD022412
0375 O**********T    U7 U8 LR            2  1                                          S01194 CGL120
     O          T    U7 60 LR            2  1                                                 CGL120
0376 O                                           42 '*** REFERENCE'             S01194
0377 O                       DBPGM               53                             S01194
0378 O                                           73 '-DATABASE ERROR AT'        S01194
0379 O                       DBASE               77                             S01194
0380 O**********T    U7 U8 LR               1                                          S01194 CGL120
     O          T    U7 60 LR               1                                                 CGL120
0381 O                                           37 'FILE NAME'                 S01194
0382 O                       DBFILE              48                             S01194
0383 O                                           53 'KEY'                       S01194
0384 O                       DBKEY               83                             S01194
0493 O********T*2      LR                                                 S01117
0494 O***********                        67 '*** END OF REPORT ***'       S01117
**CTDATA CMD                                                                                  CGL120
OVRDBF FILE(GEDLPD) TOFILE(                                                                   CGL120
DLTOVR FILE(GEDLPD)                                                                           CGL120
OVRDBF FILE(RCHGRA) TOFILE(                                                                   CGL120
DLTOVR FILE(RCHGRA)                                                                           CGL120
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA NARR
DAILY ACCOUNT POST
SPOT REVALUATIONS
TRANSFER BCCY IN/EXP TO PROFIT/LOSS
TRANSFER F/C INCOME AND EXPENSE
AFTER END OF PERIOD
STAMP TAX POST                                                                                CER049
TRANSFER F/C INCOME AND EXPENSE                                                               CGL049
     X/COPY WNCPYSRC,GL0400X001
