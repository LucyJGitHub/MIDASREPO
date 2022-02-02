     H
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas EM OUTSTND DEALS AGNST SECURITY BY CUST')        *
/*OVRF*: OVRDBF TABLE TABLEIC                                       : *
0003 F********************************************************************
     F*                                                                  *
     F*  Midas EXPOSURE MANAGEMENT ENQUIRY MODULE
0005 F*                                                                  *
0006 F*      EM1102 - CUSTOMER DEALS ENQUIRY                             *
0007 F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
0009 F*                                                                  *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD058285           Date 22Jun21               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK008             Date 07Jun97               *
      *                 S01253             Date 17Apr90               *S01253
     F*                     S01199            DATE 06/11/89              *
     F*                     S01117            DATE 24/10/89              *
     F*                     S01179            DATE 04/11/88              *
     F*                     E10668            DATE 03/02/87              *E10668
     F*                     E10667            DATE 02/02/87              *E10667
     F*                     E10654            DATE 02/02/87              *E10654
0011 F*                     E81174            DATE 26/11/86              *E81174
     F*                     E81170            DATE 26/11/86              *E81170
0011 F*                                                                  *
0012 F********************************************************************
     F*                                                                  *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD058285 - Change base rate code to alphanumeric (Recompile) *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL006 - Dealing Fiduciary.                                  *
     F*      CPK008  -  Field ZZM016 (from the DSPF) has been replaced by
     F*                 ZZM017 because these names are assigned when the
     F*                 DSPF is compiled.  Program chnaged w/o annotation.
     F*      S01253  -  CHANGED FOR MULTILANGUAGE SCREENS                *
     F*      S01199  -  HELP CHANGES                                     *S01199
     F*      S01117  -  RELEASE TEN MULTIBRANCHING                       *S01117
     F*      S01179  -  AS400 CONVERSION                                 *S01179
     F*      E10668 - FOR N.As SOLD, THE TRN. IS SHOWING AS AN OS TRN  ***E10668
     F*               FOR THE BANK TO WHOM IT WAS SOLD. THIS IS NOT       E10668
     F*               CORRECT. IT SHOULD DISPLAY THE RESPECTIVE N.A       E10668
     F*               PURCHASED WITH THE SALE DATE AS THE MATURITY        E10668
     F*               DATE.                                               E10668
     F*      E10667 - IF OUTSTANDING MM DEALS IS CALLED UP FOR A       ***E10667
     F*               CUSTOMER WITH SOME TRNS., THEN CMD-5 IS TAKEN       E10667
     F*               AND A CUSTOMER WITH NO TRNS. IS SELECTED            E10667
     F*               INSTEAD OF A BLANK SCREEN LINES ARE DISPLAYED.      E10667
     F*               CHANGE DISPLAY FILE.                                E10667
     F*      E10654 - NO ACTION OCCURS FOR AN ENQUIRY REQUEST WHERE    ***E10654
     F*               A VALID SHORT NAME IS ENTERED ALTHOUGH IF THE       E10654
     F*               CORRESPONDING CUSTOMER NO. IS ENTERED, THE          E10654
     F*               CORRECT SCREEN IS DISPLAYED.                        E10654
     F*      E81170 - SCREEN DISPLAY 'CCEPT' INSTEAD 'ACCEPT'
     F*               TABDL ARRAY 'DACCEPT.' BECOMES 'DAACCEPT.'
     F*                       AND 'RAACEPT.' BECOMES 'RAACCEPT.'
     F*      E81174 - LF/EMDLS NO LONGER REQUIRED; DROPPED AS IT
     F*               HAS *IMMED ON DEALS PF
     F*
0012 F********************************************************************
0015 FEM1102FM  CF   E             WORKSTN
     F                                     SFILE(EM1102SF:RCDNBR)
0018 FCUSDE     IF   E           K DISK
     F****            DEALSDFF                          KIGNORE           E81174
     F                                     IGNORE(DEALSDBF)                     E81174
     F                                     IGNORE(DEALSDEF)                     E81174
0019 FCLINT     IF   E           K DISK
     F                                     IGNORE(CLINTCAF)
0020 FSNAME     IF   E           K DISK
     F                                     RENAME(CLINTCBF:SNAMECBF)
0021 FTABLE     IF   E           K DISK
0021 F*EMCON**** IF   E           K DISK                                                    MD058079
     F**********                           RENAME(EMCONPFF:EMCONF)                          MD058079
0021 F*EMCUP**** IF   E           K DISK                                                    MD058079
     F/COPY WNCPYSRC,EM1102F001
0023 F*
0013 F* 01            cmd/1                                               S01179
0013 F* 02            cmd/12                                              S01179
0026 F* 05            cmd/5
0027 F* 07            cmd/3                                               S01179
0027 F* 08            OUTSTANDING FX DEALS
0027 F* 09            OUTSTANDING MM LOANS
0027 F* 10            OUTSTANDING LOANS AGAINST A SECURITY
0028 F* 11            subfile end
0014 F* 14            no customer details
     F* 15            deal reversed
0029 F* 16            error messages
0031 F* 17            upper level link enquiry option
     F* 18            display subfile
0033 F**19************HELP*requested                                      S01199
     F* 20            display subfile control
0034 F*    24         cusde record fx
0035 F*    25         cusde record loans/deposits
0036 F*    26         cusde record na purchased
0037 F*    27         cusde record na sold
0042 F*       34      OPTION DEAL
0056 F*       52      deal type text
0062 F*       80      CHAIN FAILED INDICATOR
0063 F*       81      CHAIN FAILED INDICATOR
      *       82      Fiduciary transaction                               CDL006
0064 F*       83      record id CLINT/SNAME
0064 F*       84      details found
0062 F*       85      MAIN PROCESSING LOOP
0063 F*       86      DETSR - DETAILS PROCESSING LOOP
0064 F*       87      DETSR - SUBFILE PROCESSING LOOP
0064 F*       88      VALID SCREEN RESPONSE PROCESSED
     F**
0064 F*       90-99   used in standard subroutines
     F**
     F**
0066 D TXT             S             56    DIM(5) CTDATA PERRCD(1)               TEXT
0066 D ERR             S             79    DIM(9) CTDATA PERRCD(1)               MESSAGES
0069 D ZA1             S              1    DIM(16)                              ZALIGN SR. ARRAY
0070 D ZA2             S              1    DIM(16)                              ZALIGN SR. ARRAY
0071 D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
0072 D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
0073 D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
0073 D***********         TABDL   1  28  2   TABTX   7   DEAL TYPES TEXT  CDL006
     D TABDL           S              2    DIM(34) CTDATA PERRCD(1)             Add Fidu. dtyp   CDL
     D TABTX           S              7    DIM(34) ALT(TABDL)
0069 D LIN             S              1    DIM(56)                              LIN2SR SR. ARRAY
     D*    ARRAYS FOR EDITING AN AMOUNT ACCORDING TO NO. OF DPS.
     D ZEDT            S              4    DIM(5)                               EDITED AMOUNT
     D ZED2            S              3    DIM(6)                               AMT WITH NO COMMA
     D ZAMT            S              3    DIM(5)                               AMOUNT FIELD
     D Z3              S              1    DIM(3)                               DUMMY 3 CHAR FLD
     D ZCOM            S             20    DIM(4) CTDATA PERRCD(1)              EDT CHARS FOR AMT
     D OUT             S              1    DIM(12)                              EDITED AMOUNT
      *                                                                   CDL006
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CDL006
      ** First DS for access programs, short data structure               CDL006
      *                                                                   CDL006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL006
      ** External data structure for switchable features                  CDL006
      *                                                                   CDL006
     D EMCONF        E DS                  EXTNAME(EMCOFJW0)                                MD058079
     D                                     PREFIX(X)                                        MD058079
     D/COPY WNCPYSRC,EM1102I001
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              COPYRIGHT STATEMENT
     D  CPY@##                 1     20
0383 D**   DATA STRUCTURE FOR KEY TO CURRENCY TABLE.
0384 D                 DS
0385 D  XCYKEY                 1     12
0386 D  XCY1                   1      8
0387 D  XXCCY                  9     11
0388 D  XCY2                  12     12
0383 D**   DATA STRUCTURE CUSTOMER/SHORTNAME ENTERED
0384 D                 DS
0385 D  CUST                   1     10
0386 D  ICUSTN                 1      6
0383 D**   DATA STRUCTURE RATE AMOUNT
0384 D                 DS
0385 D  RAT                    1     11  0
     D                                     DIM(11)                              EDITED AMOUNT
0386 D  ZRATE                  1     11  7
0154 D*
0155 D*    EM LINK ENQUIRY CONTROL FILE
0098 D                 DS
0099 D  EMCONT                 1    140
0258 D  RECI                   1      1
0258 D  PGN1                   2      9
0258 D  PGT1                  10     69
0258 D  PGL1                  70     70
0258 D  PGO1                  71     72
0258 D  PGN2                  73     80
0258 D  PGT2                  81    140
0277 D**  LOCAL DATA AREA FOR DATABASE RECORD
0278 D LDA            UDS           256
0279 D**********                            134 138 DBFILE                S01117
0280 D**********                            139 167 DBKEY                 S01117
0281 D**********                            168 175 DBPGM                 S01117
0282 D**********                            176 1770DBASE                 S01117
     D  DBFILE               134    141                                         S01117
     D  DBKEY                142    170                                         S01117
     D  DBPGM                171    180                                         S01117
     D  DBASE                181    183  0                                      S01117
     D** LINK ENQUIRY DATA AREA
     D EMSDS         E DS                  EXTNAME(EMDTA)
0383 D**   PROGRAM STATUS DATA STRUCTURE
     D PSDS           SDS
     D  WSID                 244    246
0074 I*
0089 I*
0093 I*   CUSTOMER/DEALS FILE - DETAIL RECORD - FX SWAPS/OUTRIGHTS.
0095 IEM1102SC
0089 I*
0093 I*   CUSTOMER/DEALS FILE - DETAIL RECORD - FX SWAPS/OUTRIGHTS.
0095 I*** E81174 DEALSDBF    24
0098 I*** E81174    CNUM                            CNUMX1                E81174
0098 I*             ZZ0063                          ZZXX63                E81174
0144 I*
0145 I*    CUSDE FILE - DETAIL - TAKINGS/PLACINGS/TIME DEPOSITS/LOANS.
0147 IDEALSDCF      25
0098 I              CNUM                        CNUMX2
0098 I*             ZZ0057                          ZZXX57
0098 I*             ZZ0375                          ZZ0010
     I****          ZZ0375                          ZZX375                E10654
0219 I*
0220 I*    CUSDE FILE - DETAIL RECORD - NEGOTIABLE ASSETS PURCHASED.
0222 IDEALSDDF      26
0098 I              CNUM                        CNUMX3
0098 I*             ZZ0063                          ZZWW63
0098 I              RTSP                        RTSPWF
0098 I*             ZZ0375                          ZZ0016
0292 I*
0293 I*    CUSDE FILE - DETAIL RECORD - NEGOTIABLE ASSETS SOLD.
0295 I**** E81174 DEALSDEF    27                                          E81174
0098 I*             ZZ0063                          ZZYY63
0098 I*             ZZ0375                          ZZ0016
0098 I**** E81174   YRAT                            YRATWF                E81174
0334 I**
0292 I*
0293 I*    CLINT FILE - DETAIL RECORD
0295 ICLINTCBF      83
0098 I              CNUM                        CNUMX4
0292 I*
0293 I*    SNAME FILE - DETAIL RECORD -
0295 ISNAMECBF      83
0098 I              CNUM                        CNUMX5
0219 I*
0220 I*    TABLE FILE - CCY RECORD
0222 ITABTG10F
0098 I              CDP                         XDECP
     I/SPACE 3
     C********************************************************************S01253
      *                                                                   S01253
      * Call SDRTVTXT pgm to access appropriate text                      S01253
      *  for a field used in a SFL                                        S01253
      *                                                                   S01253
     C                   MOVEL     'ZZGBMSGF'    MSGNM                                         S0125
     C                   MOVEL     'ZZM0814'     MSGDNB                                        S0125
     C                   CALL      'SDRTVTXT'                                                  S0125
     C                   PARM                    MSGDNB            7                           S0125
     C                   PARM                    MSGNM            10                           S0125
     C                   PARM                    MSGTXT           80                           S0125
     C                   MOVEL     MSGTXT        ZZM017                                        S0125
      *                                                                   S01253
     C********************************************************************
     C                   MOVEA     CPY@          BIS@             80
     C*
     C     *DTAARA       DEFINE                  EMSDS
     C     *DTAARA       DEFINE                  LDA
     C     CLKEY         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CLKEYA
     C**
     C     EMUPKY        KLIST
     C                   KFLD                    PGN2
     C                   KFLD                    PGL1
     C**
     C     EMCNKY        KLIST
     C                   KFLD                    PGN1
     C                   KFLD                    PGO1
     C********************************************************************
     C**
0389 C*    FIRST  CYCLE CALCULATIONS.
     C*
     C*   FIRST CYCLE ONLY
     C                   EXSR      FICYC
0414 C**
0416 C     RQDTD         IFEQ      *BLANKS                                                   **
0415 C*   IF NO INITIAL CUSTOMER IN DATA AREA EMSDS THEN CALL SHORTNAME
     C*      ENQUIRY
0414 C**
     C                   EXSR      SHNSR
     C                   ELSE
0414 C**
0415 C*   ELSE ACCESS CUSTOMER DETAILS
0416 C                   MOVEL     RQDTD         CNUM                                        **
     C                   END
0414 C**
0415 C*   MAIN PROCESSING LOOP -
     C                   SETON                                        85
0416 C     *IN85         DOWEQ     '1'                                                       **
0417 C*
0417 C*      IF CMD/5 THEN CALL SHORTNAME ENQUIRY
     C   05              EXSR      SHNSR
     C*      GET DEALS FOR CUSTOMER - LOAD SUBFILE
     C                   EXSR      DETSR
     C                   END
     C***
     C********************************************************************
0486 C*
     C********************************************************************
     C**
     C**    DETSR SR TO GET DETAILS OF CUSTOMER AND WRITE TO SCREEN
     C**
     C**   CALLED FROM   MAIN PROCESSING
     C**   CALLS SR      LIN1SR,LIN2SR,CMDSR2,LEOPS2,CUSTS2 DTRQS2
     C*****CALLS*PROG.***EMC999                                           S01199
     C*This subroutine controls the detail processing for a customer.
     C*First  we clear the subfile,then access the relevant deals
     C*and load the details onto a subfile in LIN1SR and LIN2SR.
     C*If no deals are found we display the message.
     C*Then we write/read the details screen,and perform the following
     C*processing
     C****If*HELP*key*pressed*then*call*help*program                      S01199
     C*   Process command keys for ending program - in SR CMDSR2
     C*   If cmd/5 then end subroutine
     C*   If cmd/1 then call exposure enquiry - in SR LEOPS2
     C*      Check on return if the customer number has changed
     C*      If so,then display details for this customer
     C*   If program called from menu then process the upper link enquiry
     C*      option. - in LEOPS2
     C*      Check on return if the customer number has changed
     C*      If so,then display details for this customer
     C*   If new customer number/shortname entered then validate
     C*      in SR CUSTS2
     C*   If no request options or command keys then display error message
     C*   Process any requests for deals details enquiries - in SR DETRQS2
     C*   if return code = 1 then call exposure enquiry
     C*
     C*
0418 C*    Indicators used
0418 C*    05  on - call shortname enquiry
0418 C*    14  off- display customer details
0418 C*    15  on - deal reversed
0418 C*    16  off- display error messages
0418 C*    17  off- upper level link enquiry available
0418 C*    18  on - display subfile control
0418 C*****19**on*-*HELP*requested                                        S01199
0418 C*    20  on - display subfile
0418 C*    80  on - read fail
0418 C*    81  on - read fail
0418 C*    84  on - deals found
0418 C*    86  on - subroutine processing loop
0418 C*    87  on - subfile control processing loop
0418 C*    88  on - valid function processed
     C     DETSR         BEGSR                                                  *** DETSR  ***
     C**
     C**    SR PROCESSING LOOP
     C                   SETON                                        86
     C     *IN86         DOWEQ     '1'
     C                   SETON                                        16
     C*
     C**       GET CUSTOMER DETIALS
     C                   EXSR      CLCHN
0416 C                   MOVEL     CNUM          CNUMWF                                      **
0416 C                   MOVEL     *BLANKS       CUST                                        **
     C*
     C**       CLEAR SUBFILE
     C                   SETOFF                                       1820
     C                   WRITE     EM1102SC
     C**
     C**
     C*     ACCESS DEALS FOR THIS CUSTOMER
     C**
     C**********           MOVELCNUM      CUSKEY  60                                          CSD027
     C                   MOVEL     CNUM          CUSKEY            6
     C     CUSKEY        SETLL     CUSDE                                  84     RECORD FOUND
     C**
     C*     RESET SUBFILE RELATIVE RECORD NUMBER
     C                   Z-ADD     0             RCDNBR
     C**
     C*     IF NO DEALS, DISPLAY MESSAGE
     C**
     C     *IN84         IFEQ      '0'
     C                   MOVE      ERR(9)        MSG
     C                   SETOFF                                       16
     C                   ELSE
     C**
     C*     ELSE, ACCESS DEALS FOR THAT CUSTOMER,LOAD SUBFILE
     C*
     C                   SETOFF                                       81
     C     *IN81         DOWEQ     '0'
     C                   MOVEA     '0000'        *IN(24)
     C     CUSKEY        READE     CUSDE                                  81     ON=FAIL OR EOF
     C     *IN81         IFEQ      '0'
     C*                                                                   E81174
     C*  IGNORE ALL RECORDS WITH FACILITY TYPE = '0' OR BLANKS            E81174
     C*                                                                   E81174
     C                   MOVE      FACT          FACTA             3                           E8117
     C     FACTA         IFEQ      '000'                                                       E8117
     C     FACTA         OREQ      '   '                                                       E8117
     C                   ELSE
     C                   MOVE      '0'           *IN82                                         CDL00
      *                                                                   CDL006
      ** If Dealing Fiduciary is installed.                               CDL006
      *                                                                   CDL006
     C     CDL006        IFEQ      'Y'                                                         CDL00
     C     *IN25         IFEQ      *ON                                                         CDL00
      *                                                                   CDL006
     C     DTYP          IFEQ      'FL'                                                        CDL00
     C     DTYP          OREQ      'DP'                                                        CDL00
     C     DTYP          OREQ      'LP'                                                        CDL00
     C     DTYP          OREQ      'FT'                                                        CDL00
     C     DTYP          OREQ      'DT'                                                        CDL00
     C     DTYP          OREQ      'LT'                                                        CDL00
     C                   MOVE      *ON           *IN82                                         CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL006
     C                   ENDIF                                                                 CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL006
      ** If Dealing Fiduciary is not installed, or installed but the      CDL006
      ** deal type is not a fiduciary.                                    CDL006
      *                                                                   CDL006
     C     CDL006        IFEQ      'N'                                                         CDL00
     C     CDL006        OREQ      'Y'                                                         CDL00
     C     *IN82         ANDEQ     *OFF                                                        CDL00
     C/COPY WNCPYSRC,EM1102C001
     C*                                                                   E81174
     C                   ADD       1             RCDNBR                                        E8117
     C                   EXSR      LIN1SR
     C                   EXSR      LIN2SR
0615 C**
0615 C**      WRITE RECORD TO SUBFILE
0614 C                   WRITE     EM1102SF                               80
      *                                                                   CDL006
     C                   ENDIF                                                                 CDL00
     C/COPY WNCPYSRC,EM1102C002
     C*                                                                   E81174
     C                   END                                                                   E8117
     C*                                                                   E81174
     C                   END
     C                   END                                                      OF DOWEQ 0
     C                   END
     C**
     C*     OUTPUT CUSTOMER DETAILS
     C**
     C                   TIME                    MTIME
     C                   SETOFF                                       14
     C                   WRITE     EM1102F1
     C*
     C**  IND. FOR SUBFILE CONTROL RECORD
     C                   SETON                                        1820
     C*
     C**  IF NO VALID RECORDS READ THEN DISPLAY ERROR MESSAGE
     C     RCDNBR        IFEQ      0
     C                   MOVEL     ERR(9)        MSG
     C                   SETOFF                                       162084
     C                   ELSE
     C                   Z-ADD     1             RCDNBR
     C                   END
     C*
     C**   SCREEN PROCESSING VALIDITY LOOP
     C                   SETOFF                                       19
     C                   SETON                                        87
     C     *IN87         DOWEQ     '1'
     C     RCDNBR        IFEQ      0                                                           E1065
     C                   MOVEL     ERR(9)        MSG                                           E1065
     C                   SETOFF                                       16                       E1065
     C                   END                                                                   E1065
     C                   WRITE     EM1102SC
     C**
     C**    PROCESS DETAILS SCREEN
     C                   SETOFF                                       88
     C***********          SETON                     19                   S01199
     C************IN19     DOWEQ'1'                                       S01199
     C***********          SETOF                     1980                 S01199
     C                   SETOFF                                         80                     S0119
     C                   READ      EM1102SC                             8080
     C**
     C                   MOVE      *BLANKS       MSG
     C**
     C*****IF*HELP*THEN*CALL*EMC999                                       S01199
     C***19****************CALL*'EMC999'                                  S01199
     C*********************PARM***********PROGNM                          S01199
     C***********          END                                            S01199
     C***********                                                         S01199
     C*
0409 C*    CHECK COMMAND KEY RESPONSE
0411 C                   EXSR      CMDSR2
     C     MSG           COMP      *BLANKS                            878716
     C     MSG           COMP      *BLANKS                            8888
     C*
0409 C*    IF COMMAND KEY 5 THEN END SR LOOP
0411 C     *IN05         IFEQ      '1'
0411 C                   SETOFF                                       8687
     C                   SETON                                        88
     C                   END
0411 C     *IN88         IFEQ      '0'
     C*
0409 C*    CUSTOMER ENTERED - VALIDATE
     C     CUST          IFNE      *BLANKS
0411 C                   EXSR      CUSTS2
     C     MSG           COMP      *BLANKS                            878716
     C     MSG           COMP      *BLANKS                            8888
     C*
0409 C*    NEW CUSTOMER ENTERED
     C   16CNUM          IFNE      CNUMHH
     C                   SETON                                        88
     C  N17              MOVE      *BLANKS       LEOPUP
     C                   END
     C                   END
0411 C     *IN88         IFEQ      '0'
     C*
0409 C*    IF UPPER LEVEL LINK ENQUIRY REQUESTED
0411 C  N17LEOPUP        IFNE      *BLANKS
     C                   MOVEL     CNUM          CNUMDS
0411 C                   EXSR      LEOPS2
     C                   SETON                                        88
     C     CNUM          COMP      CNUMDS                                 87
     C  N87              MOVEL     CNUMDS        CNUM
     C  N87              MOVEL     CNUMDS        CUSKEY
     C                   END
0727 C*
     C*
0409 C*  NO SUBFILE AND NO CUSTOMER ENTERED
     C  N88CUST          IFEQ      *BLANKS
     C     *IN20         IFEQ      '0'
0411 C                   MOVE      ERR(1)        MSG
     C     MSG           COMP      *BLANKS                            878716
     C     MSG           COMP      *BLANKS                            8888
     C                   END
     C                   END
     C*
0409 C*    IF DETAILS REQUESTED FOR A DEAL
     C  N88*IN20         IFEQ      '1'
0411 C                   EXSR      DTRQS2
     C     MSG           COMP      *BLANKS                                16
     C*
0409 C*       IF RETURN CODE 1       THEN CALL
0411 C     RETNWF        IFEQ      '1'
     C                   MOVEL     CNUM          CNUMDS
     C                   MOVEL     '1'           LEOPUP
0411 C                   EXSR      LEOPS2
     C                   SETON                                        88
     C     CNUM          COMP      CNUMDS                                 87
     C  N87              MOVEL     CNUMDS        CNUM
     C  N87              MOVEL     CNUMDS        CUSKEY
     C                   END
     C                   END
     C*
     C                   END
     C                   END
     C*
     C                   END
     C                   END
0727 C*
0728 C                   ENDSR
0729 C*
0730 C********************************************************************
     C**
     C**
     C********************************************************************
     C/SPACE 3
     C**
     C********************************************************************
     C**
     C**   LIN1SR  SR TO FORMAT DEAL DETAILS FOR SUBFILE LINE 1
     C**
     C**   CALLED FROM   DETSR
     C**   CALLS SR      XCYCHN,ZDATE2
0418 C*    This subroutine formats the deal details for the first line
0418 C*    of the subfile record.
0418 C*    Indicators used
0418 C*    15  on - deal reversed
0418 C*    24  on - fx deal
0418 C*    25  on - mm deal
0418 C*    26  on - na purchased
0418 C*    27  on - na sold
0418 C*    34  on - option deal
0418 C*    52  on - deal type text
     C     LIN1SR        BEGSR                                                  *** LIN1SR ***
     C**
0565 C                   MOVE      *BLANKS       LEOPSF
0563 C**
0564 C**   FX - CHECK FOR OPTION.
0565 C     DTYP          COMP      'OP'                                   34
0563 C**
0564 C**   DEAL TYPE TEXT
0565 C                   MOVE      *BLANKS       DTYPWF
0565 C     DTYP          LOOKUP    TABDL         TABTX                    52
0565 C   52              MOVEL     TABTX         DTYPWF
0565 C  N52              MOVEL     DTYP          DTYPWF
0565 C                   MOVE      DLST          DTYPWF
0566 C**   GET DEAL AMOUNT.
0567 C****   24                Z-ADDPUAM      AMT1   130                  E81174
     C***25                Z-ADDPCPL      AMT1                            E81174
     C   25              Z-ADD     PCPL          AMT1             13 0                         E8117
0569 C   26              Z-ADD     FVAL          AMT1
0570 C****   27                Z-ADDSAPR      AMT1                        E81174
0571 C*    IS DEAL REVERSED
0572 C     RECI          COMP      'R'                                1515
0581 C*    FOR C1 DO NOT SHOW YIELD
0582 C     DTYP          IFEQ      'C1'
0583 C                   Z-ADD     0             YRAT
0583 C                   END
0584 C**
0585 C**   GET NO. OF DECIMAL PLACES.
0586 C****  N24                GOTO CCY1                                  E81174
0587 C****                     MOVE SLCY      XXCCY                       E81174
0588 C****                     EXSR XCYCHN                                E81174
0587 C****                     Z-ADDXDECP     XDECPX  10                  E81174
0595 C**
0596 C     CCY1          TAG                                                    ** CCY1 **
0597 C****   24                MOVE PUCY      XXCCY                       E81174
0598 C  N24              MOVE      CCY           XXCCY
0599 C                   EXSR      XCYCHN
0584 C**
0585 C**  EDIT AMOUNT
0587 C                   Z-ADD     AMT1          ZAMNT
0587 C                   MOVE      'Y'           ZCOMMA
0587 C                   MOVE      'N'           ZMINUS
0587 C                   Z-ADD     XDECP         ZCDP
0602 C                   EXSR      ZEDIT
0603 C                   MOVE      ZAMNTA        AMT1WF
0600 C**   FORMAT DATES.
0601 C                   Z-ADD     DDAT          ZDAYNO                         DEAL DATE
0602 C                   EXSR      ZDATE2
0603 C                   MOVE      ZADATE        DDATE             7
0604 C**
0605 C                   Z-ADD     VDAT          ZDAYNO                         VALUE DATE
0606 C                   EXSR      ZDATE2
0607 C                   MOVE      ZADATE        VDATE             7
0608 C**
     C     SADT          IFNE      0                                                           E1066
     C                   Z-ADD     SADT          ZDAYNO                         SALE DATE      E1066
     C                   EXSR      ZDATE2                                       OPTION TO DATE E1066
     C                   MOVE      ZADATE        MDATE             7                           E1066
     C                   ELSE                                                                  E1066
0610 C     MDAT          IFNE      0
0611 C                   Z-ADD     MDAT          ZDAYNO                         MATURITY OR
0612 C****   24                Z-ADDOTDT      ZDAYNO                      E81174
0613 C                   EXSR      ZDATE2                                       OPTION TO DATE
0614 C                   MOVE      ZADATE        MDATE             7
0610 C                   END
     C                   END                                                                   E1066
0615 C**
0615 C**  DETERMINE NARR1 FIELD
0614 C                   MOVEL     *BLANKS       NARR1
0614 C****   24                MOVEL'PURCHASE'NARR1                       E81174
0610 C   25MDAT          IFNE      0
0614 C                   MOVEL     MDATE         NARR1
0610 C                   ELSE
0614 C                   MOVEL     NOTD          NARR1
0610 C                   END
0614 C   26              MOVEL     MDATE         NARR1
0615 C**
0615 C**  DETERMINE CCY   FIELD
0614 C****   24                MOVELPUCY      CCY                         E81174
0615 C**
0615 C**  DETERMINE RDNO  FIELD
0614 C                   MOVEL     *BLANKS       RDNO
0610 C****   24      SODN      IFNE 0                                     E81174
0614 C****                     MOVELSODN      RDNO                        E81174
0610 C****                     END                                        E81174
0610 C   25RODN          IFNE      0
0614 C                   MOVEL     RODN          RDNO
0610 C                   END
0610 C   25RBDN          IFNE      0
0614 C                   MOVEL     RBDN          RDNO
0610 C                   END
0610 C   26ASDN          IFNE      0
0614 C                   MOVEL     ASDN          RDNO
0610 C                   END
0610 C****   27      RPDN      IFNE 0                                     E81174
0614 C****                     MOVELRPDN      RDNO                        E81174
0610 C****                     END                                        E81174
0615 C**
     C**
     C     ENDDET        ENDSR                                                  **ENDDET ENDSR*
     C**
     C**
0721 C********************************************************************
     C**
     C**
0721 C********************************************************************
     C**
0722 C*    LIN2SR TO FORMAT DELA DETAILS FOR LINE 2 OF SUBFILE
     C**   CALLED FROM   DETSR
     C**   CALLS SR
0418 C*    This subroutine loads a text field for the second line of the
0418 C*    subfile record with deal details.
0418 C*    Indicators used
0418 C*    34  on - option deal
0418 C*    24  on - fx deal
0418 C*    25  on - mm deal
0418 C*    26  on - na purchased
0418 C*    27  on - na sold
0723 C     LIN2SR        BEGSR                                                  ** LIN2SR  ***
0725 C                   MOVE      *BLANKS       LINE2
0725 C                   MOVEA     *BLANKS       LIN
0726 C     *IN24         IFEQ      '1'
0584 C**
0585 C**  EDIT AMOUNT
0587 C****                     Z-ADDSLAM      ZAMNT                       E81174
0587 C****                     MOVE 'Y'       ZCOMMA                      E81174
0587 C****                     MOVE 'N'       ZMINUS                      E81174
0587 C****                     Z-ADDXDECPX    ZCDP                        E81174
0602 C****                     EXSR ZEDIT                                 E81174
0603 C****                     MOVE ZAMNTA    SLAMWF 17                   E81174
0725 C****   34                MOVEATXT,1     LIN,5                       E81174
0725 C****                     MOVEATXT,2     LIN,27                      E81174
0725 C****   34                MOVEAMDATE     LIN,15                      E81174
0725 C****                     MOVEASLCY      LIN,32                      E81174
0725 C****                     MOVEASLAMWF    LIN,38                      E81174
0728 C                   ELSE
0726 C     *IN25         IFEQ      '1'
0725 C                   Z-ADD     RTSP          ZRATE
0602 C                   EXSR      RTEDIT
0603 C                   MOVE      ZRATEA        RTSPXX
0725 C                   MOVEA     TXT(3)        LIN(6)
0725 C                   MOVEA     TXT(4)        LIN(26)
0725 C                   MOVE      BRTT          BRTTWF            2
0725 C                   MOVEA     BRTTWF        LIN(17)
0725 C                   MOVEA     RTSPXX        LIN(43)
0728 C                   ELSE
0726 C     *IN26         IFEQ      '1'
0725 C                   Z-ADD     RTSPWF        ZRATE
0602 C                   EXSR      RTEDIT
0603 C                   MOVE      ZRATEA        RTSPXX           12
0725 C                   Z-ADD     YRAT          ZRATE
0602 C                   EXSR      RTEDIT
0603 C                   MOVE      ZRATEA        YRATXX           12
0725 C                   MOVEA     TXT(5)        LIN(6)
0725 C                   MOVEA     TXT(4)        LIN(26)
0725 C                   MOVEA     YRATXX        LIN(12)
0725 C                   MOVEA     RTSPXX        LIN(43)
0728 C****                     ELSE                                       E81174
0726 C****           *IN27     IFEQ '1'                                   E81174
0725 C****                     Z-ADDYRATWF    ZRATE                       E81174
0602 C****                     EXSR RTEDIT                                E81174
0603 C****                     MOVE ZRATEA    YRATXX 12                   E81174
0725 C****                     MOVEATXT,5     LIN,6                       E81174
0725 C****                     MOVEAYRATXX    LIN,12                      E81174
0728 C****                     END                                        E81174
0728 C                   END
0728 C                   END
0728 C                   END
0725 C                   MOVEA     LIN           LINE2
0727 C*
0728 C                   ENDSR
0729 C*
0730 C********************************************************************
     C**
0738 C********************************************************************
     C*
0739 C*    LEOPS2 SR VALIDATE AND PROCESS UPPER LINK ENQ. REQUEST
     C*
     C**   CALLED FROM   DETSR,
     C**   CALLS SR      EMUPS2,RETSR
     C**   CALLS PROG.   PGN1
0418 C*    This is a standard link enquiry subroutine for processing
0418 C*    request to upper link enquiries.
0418 C*    Indicators used
0418 C*    16  on  = non display error message field
0740 C     LEOPS2        BEGSR                                                  ** LEOPS2   ***
0496 C**
0375 C**  ACCESS RELEVANT EMCONPF RECORD
0376 C                   EXSR      EMUPS2
0744 C*
0496 C**
0375 C**  CLEAR ERROR MESSAGE FIELD,
0376 C                   MOVE      *BLANKS       MSG
0388 C**
0389 C** CHECK THAT VALUE IS EQUAL TO 1
0387 C     LEOPUP        IFNE      '1'
0382 C                   MOVEL     ERR(5)        MSG
0386 C                   END
0387 C     MSG           IFEQ      *BLANKS
0382 C                   MOVE      *BLANKS       LEOPUP
0391 C**
0392 C** ELSE CALL REQESTED PROGRAM
0392 C**      FIRST UPDATE DATA AREA
0391 C**
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVEL     EMCONT        EMSDS
0402 C                   MOVE      '0'           RETND
0402 C                   MOVEL     *BLANKS       RQDTD
0407 C********** CNUM      IFGT 0                                                             CSD027
0407 C     CNUM          IFNE      *BLANKS
0402 C                   MOVEL     CNUM          RQDTD
0386 C                   END
0405 C                   OUT       EMSDS
0391 C**
0392 C**      CALL PROGRAM
0405 C                   OUT       LDA
0406 C                   CALL      PGN1
0405 C     *LOCK         IN        LDA
0391 C**
0392 C**      CHECK RETURN CODE
0409 C**
0405 C     *LOCK         IN        EMSDS
0407 C     RETND         IFEQ      '7'
     C*************IF CMD/7 THEN END PROGRAM                              S01179
     C**           IF CMD/3 THEN END PROGRAM                              S01179
0407 C                   MOVEL     RETND         RETNWF
0383 C                   EXSR      RETSR                                                    D
0405 C                   ELSE
0392 C**           CHECK IF CUSTOMER CHANGED
0407 C                   MOVEL     '0'           RETNWF
0407 C     RETND         IFEQ      '9'
0407 C**********           MOVELRQDTD     CNUMDS  60                                          CSD027
0407 C                   MOVEL     RQDTD         CNUMDS            6
0405 C                   END
0405 C                   END
0405 C                   OUT       EMSDS
0405 C                   END
0426 C**  INVALID INPUT DISPLAY ERROR CODES
0428 C     MSG           COMP      *BLANKS                                16
0429 C**                                                               ***
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0846 C**
0846 C**
0738 C********************************************************************
     C*
0739 C*    DTRQS2 SR VALIDATE AND PROCESS DEALS DETAILS REQUEST
     C*
     C**   CALLED FROM   DETSR,
     C**   CALLS SR      EMCNSR,RETSR
     C**   CALLS PROG.   lower link enquiry program
0418 C*    This is a standard link enquiry subroutine for processing
0418 C*    request to lower link enquiries.
0418 C*    Indicators used
0418 C*    16  on  = non display error message field
0418 C*    17  off = upper link enquiry option available
0418 C*    80  on  = chain fail
0418 C*    81  on  = read failed to subfile
0740 C     DTRQS2        BEGSR                                                  ** DTRQS2   ***
0496 C**
0375 C**  CLEAR ERROR MESSAGE FIELD,
0376 C                   MOVE      *BLANKS       MSG
0376 C                   MOVE      *BLANKS       LEOPSF
0384 C**                                                                **
0385 C**  READ FIRST CHANGED RECORD
0387 C     LEOPSF        DOWEQ     ' '
0411 C                   READC     EM1102SF                               81
0383 C  N81              END                                                                R
0384 C**                                                                **
0385 C**  NOT FOUND THEN DISPLAY  MESSAGE 2
0387 C     *IN81         IFEQ      '1'
0382 C                   Z-ADD     1             RCDNBR
0382 C                   MOVEL     ERR(2)        MSG
0383 C                   ELSE                                                               R
0388 C**
0389 C** RESET LEOPSF TO BLANKS
0387 C                   MOVE      LEOPSF        LEOPXX            1
0382 C                   MOVE      *BLANKS       LEOPSF
0386 C                   UPDATE    EM1102SF
0388 C**
0389 C** CHECK THAT VALUE IS EQUAL TO 1
0387 C     LEOPXX        IFNE      '1'
0382 C                   MOVEL     ERR(5)        MSG
0387 C     *IN81         DOWEQ     '0'
0411 C                   READC     EM1102SF                               81
0382 C                   MOVE      *BLANKS       LEOPSF
0386 C  N81              UPDATE    EM1102SF
0383 C                   END                                                                R
0386 C                   ELSE
0384 C**                                                                **
0385 C**  SAVE KEY VALUE
0402 C                   MOVEL     DLNO          DLNOSV            6 0
0384 C**                                                                **
0385 C**  CHECK THAT ONLY ONE OPTION REQUESTED
0387 C     LEOPSF        DOWEQ     ' '
0411 C                   READC     EM1102SF                               81
0383 C  N81              END                                                                R
0387 C     *IN81         IFEQ      '0'
0382 C                   MOVEL     ERR(6)        MSG
0382 C                   MOVE      *BLANKS       LEOPSF
0386 C                   UPDATE    EM1102SF
0387 C     *IN81         DOWEQ     '0'
0411 C                   READC     EM1102SF                               81
0382 C                   MOVE      *BLANKS       LEOPSF
0386 C  N81              UPDATE    EM1102SF
0383 C                   END                                                                R
0383 C                   ELSE                                                               R
0391 C**
0392 C** CHECK THAT OPTION IS AVAILABLE
0393 C                   EXSR      EMCNSR
0405 C     *IN80         IFEQ      '1'
0382 C                   MOVEL     ERR(7)        MSG
0383 C                   END                                                                R
0405 C     MSG           IFEQ      *BLANKS
0391 C**
0392 C** ELSE CALL REQESTED PROGRAM
0391 C**
0392 C**      FIRST UPDATE DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVEL     EMCONT        EMSDS
0402 C                   MOVE      '0'           RETND
0402 C                   MOVEL     *BLANKS       RQDTD
0402 C                   MOVEL     DLNOSV        RQDTD
0405 C                   OUT       EMSDS
0391 C**
0392 C**      CALL PROGRAM
0405 C                   OUT       LDA
0406 C                   CALL      PGN2
0405 C     *LOCK         IN        LDA
0391 C**
0392 C**      CHECK RETURN CODE
0405 C     *LOCK         IN        EMSDS
0407 C     RETND         IFEQ      '7'
     C*************IF CMD/7 THEN END PROGRAM                              S01179
     C**           IF CMD/3 THEN END PROGRAM                              S01179
0407 C                   MOVEL     RETND         RETNWF
0383 C                   EXSR      RETSR                                                    D
0405 C                   ELSE
0407 C     RETND         IFEQ      '1'
0407 C                   MOVEL     RETND         RETNWF
0392 C**           IF CALLED FROM EXPOSURE ENQ THEN RETURN
0407 C     *IN17         IFEQ      '1'
0383 C                   EXSR      RETSR                                                    D
0405 C                   END
0405 C                   END
0405 C                   END
0405 C                   OUT       EMSDS
0409 C**
0405 C                   END
0405 C                   END
     C                   END
     C                   END
0426 C**  INVALID INPUT DISPLAY ERROR CODES
0428 C     MSG           COMP      *BLANKS                                16
0429 C**                                                               ***
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0846 C**
     C*
0846 C**
0738 C********************************************************************
     C*
0739 C*    SHNSR SR  PROMPT FOR CUSTOMER/SHORTNAME AND VALIDATE
     C*
     C**   CALLED FROM   DETAIL TIME PROCESSING
     C**   CALLS SR      RETSR
     C**   CALLS PROG    EMC1900 CUSTOMER SHORTNAMES ENQUIRY
0418 C*    This is a standard link enquiry subroutine for processing
0418 C*    shortname enquiry requests.
0418 C*
0740 C     SHNSR         BEGSR                                                  *** SHNSR   ***
0391 C**
0392 C** ELSE CALL REQESTED PROGRAM
0391 C**
0392 C**      FIRST UPDATE DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVEL     EMCONT        EMSDS
0402 C                   MOVE      '0'           RETND
0402 C                   MOVEL     *BLANKS       RQDTD
0405 C                   OUT       EMSDS
0391 C**
0392 C**      CALL PROGRAM
0405 C                   OUT       LDA
0406 C                   CALL      'EMC1900'
0405 C     *LOCK         IN        LDA
0391 C**
0392 C**      CHECK RETURN CODE
0405 C     *LOCK         IN        EMSDS
0407 C     RETND         IFEQ      '7'
     C*************IF CMD/7 THEN END PROGRAM                              S01179
     C**           IF CMD/3 THEN END PROGRAM                              S01179
0407 C                   MOVEL     RETND         RETNWF
0383 C                   EXSR      RETSR                                                    D
0405 C                   END
0391 C**
0392 C**      LOAD REQUEST DATA INTO CUSTOMER FIELDS
0405 C                   MOVEL     RQDTD         CNUM
0744 C*
0745 C                   ENDSR
0412 C*
0413 C********************************************************************
0418 C*
0738 C********************************************************************
0739 C*    CUSTS2 SR TO VALIDATE CUSTOMER ENTERED
0418 C*
     C**   CALLED FROM   DETSR
     C**   CALLS SR      ZALIGN,CLCHN
0418 C*
0418 C*    This is a standard link enquiry subroutine for validating
0418 C*    customer number/shortnames.
0418 C*    Indicators used
0418 C*    14  display/non display customer details
0418 C*    17  off = upper link enquiry option available
0418 C*    83  SNAME/CLINT record read
0418 C*    80  chain fail
0418 C*
0418 C*
0740 C     CUSTS2        BEGSR                                                  *** CUSTS2  ***
0741 C*
     C**
0448 C*    ERROR IF CUSTOMER NO.NOT ENTERED,
0449 C     CUST          IFEQ      *BLANKS
0450 C   17              MOVEL     ERR(1)        MSG
0450 C  N17              MOVEL     ERR(2)        MSG
0451 C                   ELSE
0452 C*
0453 C**   IS CUSTOMER NO OR SHORTNAME ENTERED.
     C*
0454 C                   Z-ADD     0             ZADEC
0455 C                   Z-ADD     6             ZADIG
0456 C                   MOVE      '        '    ZFIELD
0457 C                   MOVEL     '        '    ZFIELD
0458 C                   MOVEL     CUST          ZFIELD
0459 C                   EXSR      ZALIGN
     C**********           MOVELCNUM      CNUMHH  60                                   E10654 CSD027
     C                   MOVEL     CNUM          CNUMHH            6
0460 C     *IN99         IFEQ      '0'
     C*
0461 C*    IF CUST. NO. ENTERED, CHECK IT IS ON CLIENT FILE.
     C*
     C****                 MOVE CNUM      CNUMHH  60                      E10654
0462 C                   MOVEL     ICUSTN        CNUM
0463 C                   EXSR      CLCHN
0464 C     *IN83         IFEQ      '0'
     C                   MOVE      CNUMHH        CNUM
0465 C                   MOVE      ERR(3)        MSG
     C                   ELSE                                                                  E1065
     C                   MOVEL     CNUM          CNUMWF                                        E1065
0466 C                   END
0466 C                   ELSE
0467 C*
0468 C*       SNAME ENTERED, CHECK IT IS ON SHORT NAME FILE.
     C*
0470 C                   SETOFF                                       83
0471 C     CUST          CHAIN     SNAME                              80
0470 C   83RECI          COMP      'D'                                    83
0472 C     *IN83         IFEQ      '0'
0479 C*
0480 C*    IF NOT FOUND - SNAME ERROR MESSSAGE
0482 C                   MOVE      ERR(4)        MSG
     C                   ELSE                                                                  E1065
     C                   MOVEL     CNUMX5        CNUMWF                                        E1065
     C                   MOVEL     CNUMX5        CNUM                                          E1065
0483 C                   END
0483 C                   END
0483 C                   END
0744 C*
0744 C*  IF CUSTOMER VALID THEN MOVE INTO ICUSTS
0464 C     MSG           IFEQ      *BLANKS
0465 C                   MOVE      CUST          ICUSTS           10
     C****                 MOVELCNUM      CNUMWF                          E10654
0465 C                   SETOFF                                       14
0466 C                   END
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0418 C*
0738 C********************************************************************
0739 C*    CMDSR2 SR  COMMAND KEY VALIDATION AND RESPONSE
0418 C*
     C**   CALLED FROM   DETSR
     C**   CALLS SR      RETSR
0418 C*
0418 C*    This is a standard link enquiry subroutine for processing
0418 C*    the command keys.
0418 C*
0418 C*    Indicators used
0418 C*    07  terminate without predjudice
0418 C*    01  return to exposure enquiry
0418 C*    02  return to previous enquiry
0418 C*
0740 C     CMDSR2        BEGSR                                                  *** CMDSR2  ***
0741 C*
0419 C*    IF COMMAND 3 THEN END PROGRAM                                  S01179
0420 C     *IN07         IFEQ      '1'
0421 C                   MOVE      '7'           RETNWF            1
0421 C                   EXSR      RETSR
0421 C                   ELSE
     C**
0741 C*
0419 C*    ELSE IF UPPER LINK ENQUIRY OPTIONS - CMD/1 AND 12 INVALID      S01179
0420 C     *IN17         IFEQ      '0'
0419 C*       CMD/12 INVALID - DISPLAY MESSAGE                            S01179
0420 C     *IN02         IFEQ      '1'
0421 C                   MOVEL     ERR(8)        MSG
0421 C                   ELSE
0420 C     *IN01         IFEQ      '1'
0421 C                   MOVEL     ERR(8)        MSG
0421 C                   END
0421 C                   END
0421 C                   ELSE
0741 C*
0419 C*        ELSE IF COMMAND 1 TERMINATE THE PROGRAM                    S01179
0420 C     *IN01         IFEQ      '1'
0421 C                   MOVE      '1'           RETNWF
0421 C                   EXSR      RETSR
0421 C                   ELSE
0419 C*             IF COMMAND 12 TERMINATE THE PROGRAM                   S01179
0420 C     *IN02         IFEQ      '1'
0421 C                   MOVE      '2'           RETNWF
0421 C                   EXSR      RETSR
0421 C                   END
0421 C                   END
     C**
0421 C                   END
0421 C                   END
     C**
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0422 C*
0847 C**
0738 C********************************************************************
0739 C*    FICYC SR  FIRST CYCLE CALCULATIONS
0741 C*
     C**   CALLED FROM   MAIN PROCESSING
     C**   CALLS SR      FICEM2,TABCHN
0397 C*
0397 C*      This subroutine contains all the non-link enquiry process-
0397 C*    ing found in the original enquiry program. It calls FICEM
0397 C*    to perform the standard link enquiry initial processing.
0397 C*
0740 C     FICYC         BEGSR                                                  *** FICYC   ***
0397 C*
0398 C**   GET DATE FORMAT
0399 C                   EXSR      ZSYSTM
0397 C*
0398 C**   IF NOT FOUND -TERMINATE WITH PREDJUDICE
0399 C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8
0298 C                   MOVE      'TABLE'       DBFILE
0299 C                   MOVE      ZTABKY        DBKEY
0300 C                   MOVE      'EM1102'      DBPGM
0301 C                   Z-ADD     01            DBASE                          DATABASE 01
     C                   EXSR      RETSR
     C                   END
0400 C*    INITIALISE FIELDS.
0401 C                   MOVE      'A'           CLKEYA            1
0402 C**
0403 C**   SET UP KEY FOR CURRENCY TABLE.
0404 C                   MOVEL     '20      '    XCY1
0405 C                   MOVE      '1'           XCY2
0406 C**   TABCHN TO ACCESS USCY CURRENCY
0407 C                   EXSR      TABCHN
0397 C*
0398 C**   IF NOT FOUND -TERMINATE WITH PREDJUDICE
0399 C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8
0298 C                   MOVE      'TABLE'       DBFILE
0299 C                   MOVE      ZTABKY        DBKEY
0300 C                   MOVE      'EM1102'      DBPGM
0301 C                   Z-ADD     02            DBASE                          DATABASE 02
     C                   EXSR      RETSR
     C                   END
0391 C**
0392 C**  CALL LINK ENQUIRY FIRST CYCLE SR
0402 C                   EXSR      FICEM2
0391 C**
0392 C**  SCREEN HEADING
0402 C     PGTXT         COMP      'EMC1100 '                             08
0402 C     PGTXT         COMP      'EMC1101 '                             09
0402 C     PGTXT         COMP      'EMC1102 '                             10
      *                                                                   CDL006
      ** Access Switchable Features file to check if Dealing Fiducia      CDL006
      ** ry is installed.                                                 CDL006
      *                                                                   CDL006
     C                   MOVE      'N'           CDL006            1                           CDL00
     C                   CALL      'AOSARDR0'                                                  CDL00
     C                   PARM      *BLANKS       WRTCD             7                           CDL00
     C                   PARM      '*VERIFY'     WOPTN             7                           CDL00
     C                   PARM      'CDL006'      WSARD             6                           CDL00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CDL00
      *                                                                   CDL006
     C     WRTCD         IFNE      *BLANKS                                                     CDL00
     C     WRTCD         ANDNE     '*NRF   '                                                   CDL00
     C     *LOCK         IN        LDA                                                         CDL00
     C                   Z-ADD     003           DBASE                           ************* CDL00
     C                   MOVEL     'SCSARDPD'    DBFILE                          * DBERR 003 * CDL00
     C                   MOVEL     WRTCD         DBKEY                           ************* CDL00
     C                   OUT       LDA                                                         CDL00
     C                   EXSR      RETSR                                                       CDL00
     C                   ENDIF                                                                 CDL00
      *                                                                   CDL006
     C     WRTCD         IFEQ      *BLANK                                                      CDL00
     C                   MOVEL     'Y'           CDL006                                        CDL00
     C                   ENDIF                                                                 CDL00
     C/COPY WNCPYSRC,EM1102C003
0345 C**
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0847 C**
0738 C********************************************************************
0739 C*    FICEM2 SR  FIRST CYCLE CALCULATIONS
0741 C*
     C**   CALLED FROM   FICYC
     C**   CALLS SR
0391 C**     This program is at level 2,so we access the information
0391 C**   on emsds to find out who called this program.
0391 C**   IF PGL1 = 2 then thats us,and we must have been called from
0391 C**               the link enquiry below. We use PGN1(our name)
0391 C**               to chain to the link enquiry option above.
0391 C**   ELSE  we are the second program.
0391 C**     If PGL1 is equal to 1 then we were called from the link
0391 C**             enquiry above. seton 17 to non display the upper
0391 C**             link enquiry option.
0391 C**
0391 C**     Else we must have been called from a menu directly,so we
0391 C**   setof 17 to display the upper link enquiry option,using our
0391 C**   program name PGN2.
0391 C**
0418 C**   Indicators used
0418 C**   17  off = make upper link enquiry option available
0418 C**   Fields defined
0391 C**   PGN2DX - this program name
0391 C**   PGN1DX - calling program name
0391 C**   PGTXT  - this program title
0391 C**   LEOPTX - upper link enquiry title
0391 C*****PROGNM*-*program*name*for*help*function                        S01199
0391 C**
0391 C**
0740 C     FICEM2        BEGSR                                                  ** FICEM2   ***
0391 C**
0402 C                   MOVEL     'EM1102  '    PROGNM            8
0391 C**
0392 C**  ACCESS EM DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVEL     PGN1D         PGN1DX            8
0402 C                   MOVEL     PGN2D         PGN2DX            8
0402 C                   MOVEL     RQDTD         RQDTWF           20
0391 C**
0392 C**  CHECK IF CALLED FROM LEVEL 3 OR LEVEL 1
0402 C     PGL1D         IFEQ      '2'
0402 C                   MOVEL     PGN1D         PGTXT             8
0402 C                   SETOFF                                       17
0725 C                   MOVEL     PGN1D         PGN2DX
0725 C                   MOVEL     PGN2D         PGN1DX
0402 C                   EXSR      EMUPS2
0402 C                   MOVE      PGT1          LEOPTX
0402 C                   ELSE
0402 C                   MOVEL     PGN2D         PGTXT
0402 C     PGL1D         IFEQ      '1'
0402 C                   SETON                                        17
0402 C                   ELSE
0402 C                   SETOFF                                       17
0402 C                   EXSR      EMUPS2
0402 C                   MOVE      PGT1          LEOPTX
0402 C                   END
0402 C                   END
0744 C*
0405 C                   OUT       EMSDS
0345 C**
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
     C**
0721 C********************************************************************
     C**
0722 C*    CLCHN SR. TO CHAIN TO CLIENT FILE.
     C**   CALLED FROM   MAIN PROCESSING,CUSTS2
     C**   CALLS SR
0418 C*    This is a standard link enquiry subroutine for accessing the
0418 C*    CLINT   record for a customer.
0418 C*    Indicators used
0418 C*    80  on - chain fail
0418 C*    83  on - valid record found
0723 C     CLCHN         BEGSR                                                  *** CLCHN  ***
0725 C                   SETOFF                                       83
0726 C     CLKEY         CHAIN     CLINT                              80
0725 C   83RECI          COMP      'D'                                    83
0727 C*
0728 C                   ENDSR
0729 C*
0730 C********************************************************************
     C**
0721 C********************************************************************
     C**
0722 C*  EMUPS2  SR. TO CHAIN TO EMCUP FILE
     C**   CALLED FROM   LEOPS2,FICEM
     C**   CALLS SR
0418 C*    This is a standard link enquiry subroutine for accessing the
0418 C*    EMCONPF record for the upper link enquiry.
0418 C*    Indicators used
0418 C*    80  on - chain fail/invalid record
0723 C     EMUPS2        BEGSR                                                  *** EMUPS2 ***
0724 C*
0725 C                   MOVEL     PGN2DX        PGN2
0725 C                   MOVEL     '1'           PGL1
0726 C*****EMUPKY        CHAIN     EMCUP                              80                    MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :EMCONF                                                                        MD058079
     C+ from EMCOFJW0                                                                       MD058079
     C+ where PGN3 = :PGN2 and PGL1 = :PGL1                                                 MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       80                    MD058079
     C                   IF        SQLCODE <> 0                                             MD058079
     C                   SETON                                        80                    MD058079
     C                   ELSE                                                               MD058079
     C                   Eval      RECI = XRECI                                             MD058079
     C                   Eval      PGN1 = XPGN1                                             MD058079
     C                   Eval      PGT1 = XPGT1                                             MD058079
     C                   Eval      PGL1 = XPGL1                                             MD058079
     C                   Eval      PGO1 = XPGO1                                             MD058079
     C                   Eval      PGN2 = XPGN2                                             MD058079
     C                   Eval      PGT2 = XPGT2                                             MD058079
     C                   ENDIF                                                              MD058079
0725 C  N80RECI          COMP      'D'                                8080
0727 C*
0728 C                   ENDSR
0729 C*
0730 C********************************************************************
     C**
0721 C********************************************************************
     C**
0722 C*  EMCNSR  SR. TO CHAIN TO EMCON FILE
     C**   CALLED FROM   DTRQS2
     C**   CALLS SR
0418 C*    This is a standard link enquiry subroutine for accessing the
0418 C*    EMCONPF record for the lower link enquiry.
0418 C*    Indicators used
0418 C*    80  on - chain fail/invalid record
0723 C     EMCNSR        BEGSR                                                  *** EMCNSR ***
0724 C*
0725 C                   MOVEL     PGN2DX        PGN1
0725 C                   MOVEL     '01'          PGO1
0726 C*****EMCNKY        CHAIN     EMCON                              80                    MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :EMCONF                                                                        MD058079
     C+ from EMCOFJW0                                                                       MD058079
     C+ where PGN1 = :PGN1 and PGO1 = :PGO1                                                 MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       80                    MD058079
     C                   IF        SQLCODE <> 0                                             MD058079
     C                   SETON                                        80                    MD058079
     C                   ELSE                                                               MD058079
     C                   Eval      RECI = XRECI                                             MD058079
     C                   Eval      PGN1 = XPGN1                                             MD058079
     C                   Eval      PGT1 = XPGT1                                             MD058079
     C                   Eval      PGL1 = XPGL1                                             MD058079
     C                   Eval      PGO1 = XPGO1                                             MD058079
     C                   Eval      PGN2 = XPGN2                                             MD058079
     C                   Eval      PGT2 = XPGT2                                             MD058079
     C                   ENDIF                                                              MD058079
0725 C  N80RECI          COMP      'D'                                8080
0727 C*
0728 C                   ENDSR
0729 C*
0730 C********************************************************************
0731 C*   SR. TO CHAIN TO CURRENCY TABLE.
     C**   CALLED FROM   LIN1SR
     C**   CALLS SR
0732 C     XCYCHN        BEGSR                                                  *** XCYCHN ***
0733 C     XCYKEY        CHAIN     TABTG10F                           80
0736 C*
0737 C                   ENDSR
0418 C*
0738 C********************************************************************
0739 C*    RETSR SR END OF PROGRAM PROCESSING
     C**   CALLED FROM   CMDSR2,LEOPS2,DTRQS2
     C**   CALLS SR
0418 C*    This is a standard link enquiry subroutine for ending the
0418 C*    program.
0418 C*    Indicators used
0418 C*    LR  seton - terminate program
0740 C     RETSR         BEGSR                                                  *** RETSR   ***
0741 C*
0742 C                   SETON                                        LR
0391 C**
0392 C**  ACCESS EM DATA AREA
0405 C     *LOCK         IN        EMSDS
0402 C                   MOVE      RETNWF        RETND
0402 C                   MOVEL     RQDTWF        RQDTD
0405 C                   OUT       EMSDS
0743 C                   RETURN
0744 C*
0745 C                   ENDSR
0746 C********************************************************************
0846 C**
     C/SPACE
     C*****************************************************************
     C*
     C*  RTEDIT SR SUBROUTINE TO EDIT A RATE FIELD FOR OUTPUT
     C*
     C*  CALLED BY: LIN2SR
     C*
     C*  This subroutine converts an 11,7 rate field into a 12 alpameric
     C*  field with leading and trailing zeros deleted. If the rate is
     C*  less than 1 then a zero is placed before the decimal point.
     C*
     C*
     C*  INPUT FIELDS:
     C*                    ZRATE  11 7    AMOUNT FIELD TO BE EDITED
     C*
     C*  OUTPUT FIELDS:
     C*                    ZRATEA 12 A    EDITED AMOUNT FIELD
     C*
     C*  INDICATOR USED:
     C*                    *IN94          SETON IF NON-ZERO CHARACTER
     C*                                   FOUND IN THE AMOUNT
     C*
     C     RTEDIT        BEGSR                                                  ***  RTEDIT ***
     C*
     C                   Z-ADD     ZRATE         ZRATE            11 7          I/P FIELD
     C                   MOVE      *BLANK        ZRATEA           12            O/P FIELD
     C                   MOVE      '0'           *IN94
     C*
     C                   MOVEA     *BLANKS       OUT
     C                   Z-ADD     1             J                 2 0
     C*
     C*  CLEAR LEADING ZEROS
     C     J             DOWLE     4
     C     *IN94         IFEQ      '0'
     C     RAT(J)        IFEQ      0
     C                   MOVE      ' '           OUT(J)
     C                   ELSE
     C                   MOVE      RAT(J)        OUT(J)
     C                   SETON                                        94
     C                   END
     C                   ELSE
     C                   MOVE      RAT(J)        OUT(J)
     C                   END
     C                   ADD       1             J
     C                   END
     C*
     C*  MOVE IN DECIMAL POINT
     C     J             IFEQ      5
     C     *IN94         IFEQ      '0'
     C                   MOVE      '0'           OUT(4)
     C                   END
     C                   MOVE      '.'           OUT(J)
     C                   END
     C*
     C*  POSITION DECIMALS,DELETE TRAILING ZEROS
     C                   MOVE      '0'           *IN94
     C                   Z-ADD     11            J
     C                   Z-ADD     12            K                 2 0
     C     J             DOWGE     5
     C     *IN94         IFEQ      '0'
     C     RAT(J)        IFEQ      0
     C                   MOVE      ' '           OUT(K)
     C                   ELSE
     C                   MOVE      RAT(J)        OUT(K)
     C                   SETON                                        94
     C                   END
     C                   ELSE
     C                   MOVE      RAT(J)        OUT(K)
     C                   END
     C                   SUB       1             J
     C                   SUB       1             K
     C                   END
     C*
     C*  FINALLY MOVE  EDITED FIELD INTO O/P FIELD
     C                   MOVEA     OUT           ZRATEA
     C*
     C****
     C                   ENDSR
     C*
     C********************************************************************
0408 C**
     C/SPACE
     C*****************************************************************
     C*
     C*  ZEDIT SR. SUBROUTINE TO EDIT AN AMOUNT FIELD FOR OUTPUT
     C*
     C*  CALLED BY: BASFMT, ENQFMT
     C*
     C*  INPUT FIELDS:
     C*                    ZAMNT  15 0    AMOUNT FIELD TO BE EDITED
     C*                    ZCDP    1,0    NO. OF DECIMAL PLACES
     C*                    ZCOMMA  1 A    COMMAS WANTED ('Y' OR 'N')
     C*                    ZMINUS  1 A    MINUS SIGN WANTED ('Y' OR 'N')
     C*
     C*  OUTPUT FIELDS:
     C*                    ZAMNTA 21 A    EDITED AMOUNT FIELD
     C*
     C*  INDICATOR USED:
     C*                    *IN94          SETON IF NON-ZERO CHARACTER
     C*                                   FOUND IN THE AMOUNT
     C*
     C     ZEDIT         BEGSR                                                  ***  ZEDIT  ***
     C*
     C                   Z-ADD     ZAMNT         ZAMNT            15 0          I/P FIELD
     C                   MOVE      ZCOMMA        ZCOMMA            1            VALUE Y OR N
     C                   MOVE      ZMINUS        ZMINUS            1            VALUE Y OR N
     C                   Z-ADD     ZCDP          ZCDP              1 0          NO. OF DPs.
     C                   MOVE      *BLANK        ZAMNTA           21            O/P FIELD
     C                   MOVE      '0'           *IN94
     C*
     C                   MOVE      *BLANK        ZAMNTB           16            NON-COMMA EDIT
     C                   MOVE      *BLANK        ZAMNTC           20            NON-COMMA EDIT
     C                   MOVE      *BLANK        ZAMNTD           17            NON-COMMA EDIT
     C                   MOVE      *BLANK        ZFLD3            16            NON-COMMA EDIT
     C                   MOVE      '00000000'    ZFLD1            15
     C                   MOVEL     '0000000'     ZFLD1
     C                   MOVE      *BLANK        ZFLD2            20
     C                   MOVE      ' '           ZMINS             1            MINUS CHARCTER
     C                   MOVEA     *BLANK        ZEDT
     C                   MOVEA     *BLANK        ZED2
     C                   MOVEA     *BLANK        ZAMT
     C                   MOVEA     *BLANK        Z3
     C*
     C*  INCLUDE MINUS SIGN IF NEEDED
     C*  PROCESS AMOUNT AS A POSTIVE NUMBER EVEN IF NEGATIVE
     C     ZMINUS        IFEQ      'Y'                                          **** B1
     C     ZAMNT         IFLT      0                                            **** B2
     C                   MOVE      '-'           ZMINS
     C                   Z-SUB     ZAMNT         ZAMNT
     C                   ELSE                                                   **** X2
     C                   MOVE      ' '           ZMINS
     C                   END                                                    **** E2
     C                   ELSE                                                   **** X2
     C     ZAMNT         IFLT      0                                            **** B2
     C                   Z-SUB     ZAMNT         ZAMNT
     C                   END                                                    **** E2
     C                   END                                                    **** E1
     C*
     C*  SEPARATE INTEGER AND DECIMAL PARTS OF AMOUNT
     C*  - ZERO DECIMAL PLACES
     C     ZCDP          IFEQ      0                                            **** B1
     C                   MOVE      ZAMNT         ZFLD1
     C                   ELSE
     C*
     C*  - ONE DECIMAL PLACE
     C     ZCDP          IFEQ      1                                            **** B2
     C                   MOVE      ZAMNT         ZDEC1             1
     C                   MOVEL     ZAMNT         ZAMT1            14
     C                   MOVE      ZAMT1         ZFLD1
     C                   ELSE
     C*
     C*  - TWO DECIMAL PLACES
     C     ZCDP          IFEQ      2                                            **** B3
     C                   MOVE      ZAMNT         ZDEC2             2
     C                   MOVEL     ZAMNT         ZAMT2            13
     C                   MOVE      ZAMT2         ZFLD1
     C                   ELSE
     C*
     C*  - THREE DECIMAL PLACES
     C     ZCDP          IFEQ      3                                            **** B4
     C                   MOVE      ZAMNT         ZDEC3             3
     C                   MOVEL     ZAMNT         ZAMT3            12
     C                   MOVE      ZAMT3         ZFLD1
     C                   ELSE
     C*
     C*  - EIGHT DECIMAL PLACES
     C     ZCDP          IFEQ      8                                            **** B5
     C                   MOVE      ZAMNT         ZDEC8             8
     C                   MOVEL     ZAMNT         ZAMT8             7
     C                   MOVE      ZAMT8         ZFLD1
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C                   END                                                    **** E1
     C*
     C*  MOVE THE INTEGER FIELD INTO A 5X3 ARRAY FOR EDITING
     C                   MOVEA     ZFLD1         ZAMT
     C*
     C/SPACE 3
     C*
     C****
     C*
     C*  CHECK IF COMMAS ARE NEEDED OR NOT
     C*
     C****
     C     ZCOMMA        IFEQ      'Y'                                          **** E1
     C****
     C*
     C*  IF ZCOMMA  IS 'Y' MOVE COMMAS ETC. INTO A 5X4 EDITED ARRAY
     C*  (FOR ZERO DECIMAL PLACES DO NOT WANT A DECIMAL POINT)
     C*
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEA     ZCOM(1)       ZEDT
     C                   ELSE
     C                   MOVEA     ZCOM(2)       ZEDT
     C                   END                                                    **** E2
     C*
     C*
     C*  READ THROUGH AMOUNT ARRAY SO AS TO PLACE EDITED DIGITS
     C*  INTO ZEDT. THE ARRAY IS READ 3 CHARACTERS AT A TIME.
     C*  ALL LEADING ZEROES ARE SUPPRESSED.
     C                   DO        5             Z                 1 0          **** B2
     C*
     C     *IN94         IFEQ      '1'                                          **** B3
     C                   MOVEL     ZAMT(Z)       ZEDT(Z)
     C                   ELSE
     C*
     C*  BLANK OUT EDITED FIELD IF ZEROES ARE FOUND
     C     ZAMT(Z)       IFEQ      '000'                                        **** B4
     C     Z             IFNE      5                                            **** B5
     C                   MOVE      '    '        ZEDT(Z)
     C                   END                                                    **** E5
     C                   ELSE
     C*
     C*  WHEN FIRST NON ZERO CHARACTERS ARE REACHED REMOVE LEADING
     C*  ZEROES. READ ARRAY ELEMENT 1 CHARACTER AT A TIME.
     C                   MOVE      '1'           *IN94
     C                   Z-ADD     1             ZN                1 0
     C                   MOVEA     ZAMT(Z)       Z3
     C     Z3(ZN)        DOWEQ     '0'                                          **** B5
     C                   MOVE      ' '           Z3(ZN)
     C                   ADD       1             ZN
     C                   END                                                    **** E5
     C                   MOVEA     Z3            ZEDT(Z)
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  PLACE EDITED ARRAY INTO ALPHA FIELD TO INCLUDE DECIMALS.
     C                   MOVEA     ZEDT          ZFLD2
     C*
     C*  - ZERO DECIMAL PLACES
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEL     ZFLD2         ZAMT0            19
     C                   MOVE      ZAMT0         ZAMNTC
     C                   ELSE
     C*
     C*  - ONE DECIMAL PLACE
     C     ZCDP          IFEQ      1                                            **** B3
     C                   MOVE      ZFLD2         ZAMT1A           19
     C                   MOVEL     ZAMT1A        ZAMNTC
     C                   MOVE      ZDEC1         ZAMNTC
     C                   ELSE
     C*
     C*  - TWO DECIMAL PLACES
     C     ZCDP          IFEQ      2                                            **** B4
     C                   MOVE      ZFLD2         ZAMT2A           18
     C                   MOVEL     ZAMT2A        ZAMNTC
     C                   MOVE      ZDEC2         ZAMNTC
     C                   ELSE
     C*
     C*  - THREE DECIMAL PLACES
     C     ZCDP          IFEQ      3                                            **** B5
     C                   MOVE      ZFLD2         ZAMT3A           17
     C                   MOVEL     ZAMT3A        ZAMNTC
     C                   MOVE      ZDEC3         ZAMNTC
     C                   ELSE
     C*
     C*  - EIGHT DECIMAL PLACES
     C     ZCDP          IFEQ      8                                            **** B6
     C                   MOVE      ZFLD2         ZAMT8A           12
     C                   MOVEL     ZAMT8A        ZAMNTC
     C                   MOVE      ZDEC8         ZAMNTC
     C                   END                                                    **** E6
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  INCLUDE MINUS SIGN IF NEEDED
     C     ZMINUS        IFEQ      'Y'                                          **** B2
     C                   MOVEL     ZAMNTC        ZAMNTA
     C                   MOVE      ZMINS         ZAMNTA
     C                   ELSE                                                   **** X2
     C                   MOVE      ZAMNTC        ZAMNTA
     C                   END                                                    **** E2
     C*
     C****                                                 ****
     C*
     C                   ELSE                                                   **** X1
     C*
     C****                                                 ****
     C*
     C*  ELSE IF ZCOMMA EQUAL 'N':
     C*  MOVE FORMAT LEFT INTO A 6X3 ARRAY - 6TH ELEMENT CONTAINS D.P.
     C*  (FOR ZERO DECIMAL PLACES DO NOT WANT A DECIMAL POINT)
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEA     ZCOM(3)       ZED2
     C                   ELSE
     C                   MOVEA     ZCOM(4)       ZED2
     C                   END                                                    **** E2
     C*
     C*
     C*  READ THROUGH AMOUNT ARRAY SO AS TO PLACE EDITED DIGITS
     C*  INTO ZED2. THE ARRAY IS READ 3 CHARACTERS AT A TIME.
     C*  ALL LEADING ZEROES ARE SUPPRESSED.
     C                   DO        5             Z                 1 0          **** B2
     C*
     C     *IN94         IFEQ      '1'                                          **** B3
     C                   MOVEL     ZAMT(Z)       ZED2(Z)
     C                   ELSE
     C*
     C*  SEARCH FOR FIRST NONE-ZERO CHARACTERS
     C     ZAMT(Z)       IFNE      '000'                                        **** B4
     C*
     C*  WHEN FIRST NON ZERO CHARACTERS ARE REACHED REMOVE LEADING
     C*  ZEROES. READ ARRAY ELEMENT 1 CHARACTER AT A TIME.
     C                   MOVE      '1'           *IN94
     C                   Z-ADD     1             ZN                1 0
     C                   MOVEA     ZAMT(Z)       Z3
     C     Z3(ZN)        DOWEQ     '0'                                          **** B5
     C                   MOVE      ' '           Z3(ZN)
     C                   ADD       1             ZN
     C                   END                                                    **** E5
     C                   MOVEA     Z3            ZED2(Z)
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  PLACE EDITED ARRAY INTO ALPHA FIELD TO INCLUDE DECIMALS.
     C                   MOVEA     ZED2          ZFLD3
     C*
     C*  - ZERO DECIMAL PLACES
     C     ZCDP          IFEQ      0                                            **** B2
     C                   MOVEL     ZFLD3         ZAMT0B           15
     C                   MOVE      ZAMT0B        ZAMNTB
     C                   ELSE
     C*
     C*  - ONE DECIMAL PLACE
     C     ZCDP          IFEQ      1                                            **** B3
     C                   MOVE      ZFLD3         ZAMT1B           15
     C                   MOVEL     ZAMT1B        ZAMNTB
     C                   MOVE      ZDEC1         ZAMNTB
     C                   ELSE
     C*
     C*  - TWO DECIMAL PLACES
     C     ZCDP          IFEQ      2                                            **** B4
     C                   MOVE      ZFLD3         ZAMT2B           14
     C                   MOVEL     ZAMT2B        ZAMNTB
     C                   MOVE      ZDEC2         ZAMNTB
     C                   ELSE
     C*
     C*  - THREE DECIMAL PLACES
     C     ZCDP          IFEQ      3                                            **** B5
     C                   MOVE      ZFLD3         ZAMT3B           13
     C                   MOVEL     ZAMT3B        ZAMNTB
     C                   MOVE      ZDEC3         ZAMNTB
     C                   ELSE
     C*
     C*  - EIGHT DECIMAL PLACES
     C     ZCDP          IFEQ      8                                            **** B6
     C                   MOVE      ZFLD3         ZAMT8B            8
     C                   MOVEL     ZAMT8B        ZAMNTB
     C                   MOVE      ZDEC8         ZAMNTB
     C                   END                                                    **** E6
     C                   END                                                    **** E5
     C                   END                                                    **** E4
     C                   END                                                    **** E3
     C                   END                                                    **** E2
     C*
     C*  INCLUDE MINUS SIGN IF NEEDED
     C     ZMINUS        IFEQ      'Y'                                          **** B2
     C                   MOVEL     ZAMNTB        ZAMNTD
     C                   MOVE      ZMINS         ZAMNTD
     C                   ELSE                                                   **** X2
     C                   MOVE      ZAMNTB        ZAMNTD
     C                   END                                                    **** E2
     C*
     C*  FINALLY MOVE NON-COMMA EDITED FIELD INTO O/P FIELD
     C                   MOVE      ZAMNTD        ZAMNTA
     C*
     C****
     C                   END                                                    **** E1
     C****
     C                   ENDSR
     C*
     C********************************************************************
0408 C**
0848 C********************************************************************
0849 C**
0850 C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
0851 C**
0852 C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
0853 C**
0854 C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
0855 C**
0856 C**   CLEAR DATE FIELDS.
0857 C                   Z-ADD     0             ZDATE             6 0
0858 C                   MOVEL     '       '     ZADATE            7
0859 C**
0860 C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
0861 C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
0862 C**
0863 C**   DETERMINE YEAR NUMBER.
0864 C**
0865 C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
0866 C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
0867 C   99              GOTO      ZDEND2
0868 C**
0869 C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
0870 C     ZDAYN1        DIV       1461          ZLYR              2 0
0871 C                   MVR                     ZDAYN1                         SAVE REMAINING
0872 C**                                                   DAYS
0873 C**   CALCULATE NUMBER OF REMAINING YEARS.
0874 C                   Z-ADD     1             ZWRK2             2 0
0875 C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
0876 C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
0877 C  N90ZWRK2         ADD       1             ZWRK2
0878 C  N90              GOTO      ZDTAG1
0879 C     ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON
0880 C**
0881 C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
0882 C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
0883 C**
0884 C**   CALCULATE ACTUAL YEAR NUMBER.
0885 C     ZLYR          MULT      4             ZWRK3             3 0
0886 C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
0887 C                   Z-ADD     ZWRK3         ZYEAR             2 0
0888 C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
0889 C**
0890 C**   DETERMINE MONTH NUMBER.
0891 C**
0892 C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
0893 C                   SETOFF                                       9293
0894 C   91ZDAYN1        COMP      59                                   9293
     C   91
0895 CANN92ZDAYN1        SUB       1             ZDAYN1
0896 C**
0897 C**   CALCULATE MONTH NUMBER.
0898 C                   Z-ADD     2             ZWRK2
0899 C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
0900 C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
0901 C  N94ZWRK2         ADD       1             ZWRK2
0902 C  N94              GOTO      ZDTAG2
0903 C     ZWRK2         SUB       1             ZWRK2
0904 C**
0905 C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
0906 C**
0907 C**   DETERMINE DAY OF MONTH.
0908 C**
0909 C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
0910 C     ZDAYN1        ADD       1             ZDAYN1
0911 C**
0912 C**   CALCULATE DAY OF MONTH.
0913 C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
0914 C**
0915 C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
0916 C   93ZDAY          ADD       1             ZDAY
0917 C**
0918 C**   FORMAT DATE, DDMMYY OR MMDDYY.
0919 C  N98              MOVEL     ZDAY          ZWRK4             4 0
0920 C   98              MOVE      ZDAY          ZWRK4
0921 C  N98              MOVE      ZMTH          ZWRK4
0922 C   98              MOVEL     ZMTH          ZWRK4
0923 C                   MOVEL     ZWRK4         ZDATE
0924 C                   MOVE      ZYEAR         ZDATE
0925 C**
0926 C**   FORMAT ALPHA DATE, DDMMMYY.
0927 C     ZDAY          COMP      10                                   95
0928 C                   MOVEL     ZDAY          ZWRK5             5
0929 C   95              MOVEL     ' '           ZWRK5
0930 C                   MOVE      ZMNM(ZMTH)    ZWRK5
0931 C                   MOVEL     ZWRK5         ZADATE
0932 C                   MOVE      ZYEAR         ZADATE
0933 C**
0934 C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
0935 C**
0936 C**
0937 C********************************************************************
0747 C**
0748 C**   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
0749 C**
0750 C     ZALIGN        BEGSR                                                  *** ZALIGN ***
0751 C**
0752 C                   SETOFF                                       929399
0753 C**
0754 C**   SAVE INPUT FIELD IN ARRAY, ZA1.
0755 C                   MOVEA     ZFIELD        ZA1
0756 C**
0757 C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
0758 C                   Z-ADD     ZADIG         ZADIG             2 0
0759 C                   Z-ADD     ZADEC         ZADEC             1 0
0760 C**
0761 C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
0762 C                   MOVE      ' '           ZA2
0763 C                   MOVEA     ZA2           ZFIELD           16
0764 C                   Z-ADD     0             ZX                2 0
0765 C                   Z-ADD     0             ZY                2 0
0766 C**
0767 C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
0768 C     ZADIG         ADD       ZADEC         ZZ                2 0
0769 C     ZZ            COMP      15                                 99
0770 C   99              GOTO      ZAEND
0771 C**
0772 C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
0773 C     ZATAG1        TAG                                                    ** ZATAG1 TAG *
0774 C     ZX            ADD       1             ZX
0775 C**
0776 C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
0777 C     ZA1(ZX)       COMP      '.'                                    90
     C   90
0778 CAN 93              SETON                                        99
0779 C   99              GOTO      ZAEND
0780 C**
0781 C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER CONTENT.
0782 C     ZA1(ZX)       COMP      ' '                                    91
     C   91
0783 CAN 92
     COR 91
0784 CAN 93              GOTO      ZATAG2
0785 C**
0786 C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C  N90
0787 CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
0788 CANN99ZA1(ZX)       COMP      '9'                                99
0789 C   99              GOTO      ZAEND                                        NOT NUMERIC
0790 C**
0791 C**   STORE DIGITS IN ARRAY AND HOW MANY.
0792 C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
0793 C**   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C  N90
0794 CANN91ZY            ADD       1             ZY                   92
     C  N90
0795 CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
0796 C   90              Z-ADD     ZY            ZZ                   93  93
0797 C**
0798 C     ZX            COMP      16                                   94      CHECK IF ALL
0799 C   94              GOTO      ZATAG1
0800 C**
0801 C     ZATAG2        TAG                                                    ** ZATAG2 TAG *
0802 C**
0803 C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
0804 C  N93              Z-ADD     ZY            ZZ
0805 C**
0806 C**   CHECK FOR EMBEDDED BLANKS.
     C   91
0807 CAN 92
     COR 91
0808 CAN 93              MOVEA     ZA1(ZX)       ZFIELD
     C   91
0809 CAN 92
     COR 91
0810 CAN 93ZFIELD        COMP      ' '                                9999
0811 C   99              GOTO      ZAEND                                        EMBEDDED BLANK
0812 C**
0813 C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
0814 C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
0815 C     ZZ            COMP      ZADIG                              99
0816 C     ZY            SUB       ZZ            ZX
0817 C  N99ZADEC         SUB       ZX            ZX                     9995
0818 C   99              GOTO      ZAEND
0819 C   95              GOTO      ZATAG4                                       NO TRAILING
0820 C**                                                   BLANKS.
0821 C**   FILL THE TRAILING BLANKS WITH ZEROS.
0822 C     ZY            ADD       ZX            ZZ
0823 C     ZATAG3        TAG                                                    ** ZATAG3 TAG *
0824 C     ZY            ADD       1             ZY
0825 C                   MOVE      '0'           ZA2(ZY)
0826 C     ZY            COMP      ZZ                                   94
0827 C   94              GOTO      ZATAG3
0828 C**
0829 C**   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
0830 C     ZATAG4        TAG                                                    ** ZATAG4 TAG *
0831 C                   MOVE      '0'           ZA1
0832 C                   Z-ADD     16            ZX
0833 C     ZATAG5        TAG                                                    ** ZATAG5 TAG *
0834 C     ZY            COMP      0                                      94
0835 C   94              GOTO      ZATAG6
0836 C                   MOVE      ZA2(ZY)       ZA1(ZX)
0837 C     ZY            SUB       1             ZY
0838 C     ZX            SUB       1             ZX
0839 C                   GOTO      ZATAG5
0840 C     ZATAG6        TAG                                                    ** ZATAG6 TAG *
0841 C**
0842 C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
0843 C                   MOVEA     ZA1           ZFIELD
0844 C**
0845 C     ZAEND         ENDSR                                                  * ZAEND ENDSR *
0846 C**
0847 C**
0848 C********************************************************************
0938 C**
0939 C**   ZSYSTM SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.
0940 C**
0941 C     ZSYSTM        BEGSR                                                  *** ZSYSTM ***
0942 C**
0943 C**   SET UP KEY FOR INSTALLATION CONTROL RECORD.
0944 C                   MOVEL     '01      '    ZTABKY           12
0945 C                   MOVE      '  10'        ZTABKY
0946 C**
0947 C     ZTABKY        CHAIN     TABLE                              99        ON NOT THERE
0948 C  N99RECI          COMP      'D'                                9999      ON, IS DELETED
0949 C**
0950 C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
0951 C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
0952 C**
0953 C                   ENDSR
0954 C**
0955 C**
0956 C********************************************************************
0957 C**
0958 C**   TABCHN SR. TO CHAIN TO INSTALLATION CONTROL DATA RECORD 5
0959 C**
0960 C     TABCHN        BEGSR                                                  *** TABCHN ***
0961 C**
0962 C**   SET UP KEY FOR INSTALLATION CONTROL RECORD.
0963 C                   MOVEL     '01      '    ZTABKY           12
0964 C                   MOVE      '  40'        ZTABKY
0965 C**
0966 C     ZTABKY        CHAIN     TABTB40F                           99        ON NOT THERE
0967 C  N99RECI          COMP      'D'                                9999      ON, IS DELETED
0968 C**
0969 C                   ENDSR
0970 C********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA TXT
Option to
Sale
Base Rate
Interest/Spread
Yield
**CTDATA ERR
 ENTER A CUSTOMER NUMBER OR SHORTNAME
 ENTER A CUSTOMER,SHORTNAME,OR SELECT AN OPTION
 INVALID CUSTOMER NUMBER, PRESS F5 FOR CUSTOMER/SHORTNAME ENQUIRY
 INVALID SHORTNAME,PRESS F5 FOR CUSTOMER SHORTNAME ENQUIRY
 INVALID ENTRY - ENTER "1"
 INVALID ENTRY - ONLY ONE OPTION MAYBE SELECTED
 OPTION NOT AVAILABLE
 FUCTION  KEY INVALID
* NO DEALS ARE HELD FOR THIS CUSTOMER *
**CTDATA ZYDY
0366073110961461
**CTDATA ZMDY
000031059090120151181212243273304334365
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**CTDATA TABDL
FPSPOT
FSSPOT
PISPOT
SISPOT
CXSPOT
OPOPTION
OTOPTION
SWSWAP
PSINTERNAL
ITTAKING
IPPLACING
CDCALL TK
CLCALL PL  .
LNLOAN
BDBILL
BRBILL
TBBILL
TSBILL
DAACCEPT.                                                               **E81170
RAACCEPT.                                                               **E81170
TAACCEPT.
TRACCEPT.
BPBOND
BSBOND
C1CD PUR.
C2CD PUR.
CSCD SOLD
CICD ISS.
FLFID PL                                                                  CDL006
DPFID CPL                                                                 CDL006
LPFIL CPL                                                                 CDL006
FTFID TK                                                                  CDL006
DTFID CTK                                                                 CDL006
LTTIL CTK                                                                 CDL006
**CTDATA ZCOM
   ,   ,   ,   ,  0
   ,   ,   ,   ,  0.
              0
              0.
