     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Calculate Next Interest Due Date')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE001113 - Midas LE Calculate Next Interest Due Date         *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Function: This program will calculate the next future        *
      *            interest due date based on current loan details    *
      *            at the time when procedure is called.              *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. 249385             Date 01Aug22               *
      *  Prev Amend No. MD059190 *CREATE   Date 08Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249385 - Ensure input fields ZDAYNO keeps original value     *
      *            (Recompiled due to changes in ZBKDT_ILE)           *
      *  MD059190 - Create generic program to calculate loan          *
      *             next future interest due date.                    *
      *                                                               *
      *****************************************************************

     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     PREFIX(L2_)

      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Standard Subroutine Variables
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZFREQBZ1LE
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Sructure for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Data Sructure for switchable feature details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Data Sructure for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  ACCDBK       E                     EXTFLD(QQACCD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for CLE141 Interest and Principal currencies
     D                 DS
     D CCYPI                   1     30
     D L2_C1PI                 1      3
     D L2_C2PI                 4      6
     D L2_C3PI                 7      9
     D L2_C4PI                10     12
     D L2_C5PI                13     15
     D L2_C6PI                16     18
     D L2_C7PI                19     21
     D L2_C8PI                22     24
     D L2_C9PI                25     27
     D L2_C0PI                28     30

      ** Data Structure for CLE141 Interest and Principal locations
     D                 DS
     D LOCPI                   1     30
     D L2_L1PI                 1      3
     D L2_L2PI                 4      6
     D L2_L3PI                 7      9
     D L2_L4PI                10     12
     D L2_L5PI                13     15
     D L2_L6PI                16     18
     D L2_L7PI                19     21
     D L2_L8PI                22     24
     D L2_L9PI                25     27
     D L2_L0PI                28     30

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A

      ** Program Variables
     D CLE141          S              1A
     D WRUN            S              1A
     D PCallMode       S              1A
     D PLoanRef        S              6A
     D PNextDate       S              5P 0
     D PBaseDate       S              5P 0
     D WBSDT           S              5P 0


      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING

     C                   EVAL      PNextDate = 0
     C                   EVAL      PBaseDate = 0

     C     PLoanRef      CHAIN     LECLIPL2

     C                   SELECT
     C                   WHEN      L2_RLDT > 0 AND L2_NIPD > 0
     C                             AND L2_REPT = 2 AND L2_IPFR = ' '
     C                   EVAL      PNextDate = L2_NIPD
     C                   EVAL      PBaseDate = L2_NIPD

     C                   WHEN      L2_IPFR = ' ' AND L2_REPT = 2
     C                             AND L2_MDAT = 0 AND PCallMode = 'L'
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1

     C                   WHEN      L2_RFRQ = ' ' AND L2_REPT <> 2
     C                             AND L2_MDAT = 0 AND PCallMode = 'L'
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1

     C                   WHEN      L2_IPFR = ' ' AND L2_REPT = 2
     C                             AND L2_MDAT > 0
     C                   EVAL      PNextDate = L2_MDAT
     C                   EVAL      PBaseDate = L2_MDAT

     C                   WHEN      L2_RFRQ = ' ' AND L2_REPT <> 2
     C                             AND L2_MDAT > 0
     C                   EVAL      PNextDate = L2_MDAT
     C                   EVAL      PBaseDate = L2_MDAT

     C                   WHEN      (L2_NIDT > 0 AND L2_REPT = 2
     C                             AND L2_IPFR <> ' ')
     C                             OR (L2_NRPD > 0 AND L2_REPT <> 2
     C                             AND L2_RFRQ <> ' ')
     C                   EXSR      SRCalcNext
     C                   IF        PCallMode = 'L' AND
     C                             ((PNextDate <= L2_NIDT AND L2_REPT = 2)
     C                             OR (PNextDate <= L2_NRPD AND L2_REPT <>2 ))
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1
     C                   ENDIF

     C                   OTHER
     C                   IF        PCallMode = 'L'
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1
     C                   ENDIF
     C                   ENDSL

      ** End program
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcNext - Calculate next date based on loan frequency      *
      * Calls: SRSetLoc
      *                                                               *
      *****************************************************************
     C     SRCalcNext    BEGSR

     C                   IF        L2_REPT = 2
     C                   EVAL      ZDAYNO = L2_IBDT
     C                   EVAL      ZMDAY = L2_IFDY
     C                   EVAL      ZFREQ = L2_IPFR
     C                   IF        L2_IPFR = 'R'
     C                   EVAL      ZMDAY = L2_RLDY
     C                   EVAL      ZFREQ = L2_RLFQ
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ZDAYNO = L2_RBDT
     C                   EVAL      ZMDAY = L2_RDYN
     C                   EVAL      ZFREQ = L2_RFRQ
     C                   ENDIF

     C                   IF        ZFREQ = ' '
     C                   EVAL      ZDYNBR = 0
     C                   EVAL      ZDAYNO = 0
     C                   EVAL      ZMDAY = 0
     C                   EVAL      ZFREQ = ' '
     C                   IF        PCallMode = 'L'
     C                   EVAL      PNextDate = BJDNWD - 1
     C                   EVAL      PBaseDate = BJDNWD - 1
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF

     C                   IF        L2_MDST = 01 OR L2_MDST = 02
     C                             OR L2_MDST = 07 OR L2_MDST = 08
     C                             OR L2_MDST = 12
     C                   EVAL      ZCCY = L2_CCY
     C                   ELSE
     C                   EVAL      ZCCY = BJLCCY
     C                   ENDIF

     C                   EXSR      SRSetLoc

     C                   EVAL      WBSDT = ZDAYNO
     C                   EXSR      ZFRQB3
     C                   EVAL      ZNRDYS = *ZERO

      ** If CLE141 is ON, determine the next date considering
      ** Business Day Convention

     C                   IF        CLE141 = 'Y'

     C                   IF        L2_PDDI = 'A'
     C                   Z-ADD     ZDAYNO        ZDYNBR
     C                   ELSE
     C                   CALL      'LEZBDYCD'
     C                   PARM                    ZDAYNO
     C                   PARM      CCYPI         PCURR            30
     C                   PARM      LOCPI         PLOCN            30
     C                   PARM      L2_PDDI       PPAYC             1
     C                   PARM      BJDFIN        PDFIN             1
     C                   PARM      ZCCY          PCCY              3
     C                   PARM      ZLOC          PLOC              3
     C                   PARM      *ZEROS        PAJDT             5 0
     C                   Z-ADD     PAJDT         ZDYNBR

      ** Do not return adjusted date if it is equal to or earlier than
      ** previous date (only happens for 'previous' date calculations);
      ** instead use the base date

     C                   IF        WBSDT >= ZDYNBR
     C                   EVAL      ZDYNBR = ZDAYNO
     C                   ENDIF
     C                   ENDIF

      ** CLE141 is OFF
     C                   ELSE
     C                   SELECT
     C     L2_PDDI       WHENEQ    'A'
     C                   Z-ADD     ZDAYNO        ZDYNBR
     C     L2_PDDI       WHENEQ    'P'
     C                   EXSR      ZBKDT
     C     L2_PDDI       WHENEQ    'N'
     C     L2_PDDI       OREQ      *BLANK
     C                   EXSR      ZFWDT
     C     L2_PDDI       WHENEQ    'M'
     C                   EXSR      ZDATE2
     C     *IN98         IFEQ      *OFF
     C                   MOVE(P)   ZDATE         MMYY              4 0
     C                   MOVEL(P)  MMYY          MMNLCD            2 0
     C                   ELSE
     C                   MOVEL(P)  ZDATE         MMNLCD
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        @DAYNO            5 0
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   EXSR      ZDATE2
     C     *IN98         IFEQ      *OFF
     C                   MOVE(P)   ZDATE         MMYY
     C                   MOVEL(P)  MMYY          MMNWKD            2 0
     C                   ELSE
     C                   MOVEL(P)  ZDATE         MMNWKD
     C                   ENDIF
     C     MMNLCD        IFNE      MMNWKD
     C                   Z-ADD     @DAYNO        ZDAYNO
     C                   EXSR      ZBKDT
     C                   ENDIF
     C                   ENDSL

     C                   ENDIF

     C                   IF        ZDYNBR >= L2_MDAT
     C                   EVAL      PNextDate = L2_MDAT
     C                   EVAL      PBaseDate = L2_MDAT
     C                   ELSE
     C                   EVAL      PNextDate = ZDYNBR
     C                   EVAL      PBaseDate = ZDAYNO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetLoc - Determine settlement location                      *
      *                                                               *
      *****************************************************************
     C     SRSetLoc      BEGSR

     C                   EVAL      ZLOC = *BLANKS

     C                   IF        L2_MDST = 01 OR L2_MDST = 02
     C                             OR L2_MDST = 07 OR L2_MDST = 08
     C                             OR L2_MDST = 12
     C                   MOVEL     L2_OMDA       PKeyE             2

     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PKeyA             6
     C                   PARM      ZCCY          PKeyB             3
     C                   PARM      *BLANKS       PKeyC            10
     C                   PARM      *BLANKS       PKeyD             2
     C                   PARM                    PKeyE
     C                   PARM      *BLANKS       PKeyF             3
     C                   PARM      *BLANKS       PKeyG            10
     C                   PARM      *BLANKS       PKeyH             1
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      ZLOC = %SUBST(A7NOSN:8:3)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ZLOC = BJSLCD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PCallMode
     C                   PARM                    PLoanRef
     C                   PARM                    PNextDate
     C                   PARM                    PBaseDate

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'LE000113'

      ** Get the Bank details via access program
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *IN98 = *OFF
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

      ** Determine if CLE141 is installed
     C                   MOVE      'N'           CLE141
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CLE141'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRtCd         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE141
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZFWDT_ILE
     C/COPY ZSRSRC,ZDATE2Z4LE
     C/COPY ZSRSRC,ZDATE1Z2LE
     C/COPY ZSRSRC,ZFRQB3_ILE
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZCHKHLE
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
