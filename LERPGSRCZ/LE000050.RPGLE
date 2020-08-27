     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE CoB Aggregated Facility Updates')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000050 - Close of Business Aggregated Facility Updates     *
      *                                                               *
      *  Function:  This program will update availability dates,      *
      *  (CoB)      exposures, offsets, collateral lending values and *
      *             FX margin requirements of aggregate facilities    *
      *             based on the underlying tranches.                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE147             Date 28Sep11               *
      *                 CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE147 - Aggregate Facility                                  *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FFCLTYL5   IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Facilities detail B record

     FLEFCLTLG  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Facilities extension record

     FLEFCLTJ0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Joined Logical File of FCLTYFM and FCLTYFN

     FLETRAGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Aggregate Facilities Relationship by Tranche

     FLEAGFYL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FCLTYFMF:AGFCLTYA)
     F                                     PREFIX(AA)
      ** Midas LE Facilities Aggregate Facilities detail A file

     FLEAGFYL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFNF:AGFCLTYB)
     F                                     PREFIX(AB)
      ** Midas LE Facilities Aggregate Facilities detail B file

     FLEAGFYL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCLTD0:AGFCLTYX)
     F                                     PREFIX(AX)
      ** Midas LE Facilities Aggregate Facilities extension file
                                                                                              CLE147
     FLEAGHSL0  IF   E           K DISK    INFSR(*PSSR)                                       CLE147
      ** Midas LE Aggregate Facility History file                                             CLE147

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE147
      ** SAR Details Data Structure                                                           CLE147
                                                                                              CLE147
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D KCNum           S              6  0
     D KFacT           S              3  0
     D KFcNo           S              2  0
     D KBrcA           S              3
     D KCNumA          S              6
     D KFacTA          S              3
     D KFcNoA          S              2
     D WBrcA           S              3
     D WCNumA          S              6
     D WFacTA          S              3
     D WFcNoA          S              2
     D WRun            S              1A
     D PRetCode        S              7
     D POption         S              7
     D PSard           S              6                                                       CLE147
     D WWAFAM          S             15P 0                                                    CLE147
     D KBranch         S                   LIKE(BRCA)                                         CLE147
     D KCust           S                   LIKE(CNUM)                                         CLE147
     D KFclty          S                   LIKE(AIFCTY)                                       CLE147
     D CLE147          S              1                                                       CLE147

      ** Parameters for ZXRATE module
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1

      ** Parameters for ZCONVZ1 module
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** The main subroutine is comprised of 2 looping processes:
      ** 1st, to initialise dates and amounts in LEAGFMPD/LEAGFNPD/LEAGFTQD
      ** 2nd, to update amounts in LEAGFMPD/LEAGFNPD/LEAGFTQD with the
      **  corresponding aggregate facilities found in FCLTYFM/FCLTYFN/LEFCLTQD

      ** Access the first record from the Facilities detail B table to get
      ** the availability dates
     C     *LOVAL        SETLL     FCLTYL5
     C                   READ      FCLTYL5

      ** If no record is found, initialise all rundates to zeros
     C                   IF        %EOF(FCLTYL5)
     C                   EVAL      RUN0 = *ZEROS
     C                   EVAL      RUN1 = *ZEROS
     C                   EVAL      RUN2 = *ZEROS
     C                   EVAL      RUN3 = *ZEROS
     C                   EVAL      RUN4 = *ZEROS
     C                   EVAL      RUN5 = *ZEROS
     C                   EVAL      RUN6 = *ZEROS
     C                   EVAL      RUN7 = *ZEROS
     C                   EVAL      RUN8 = *ZEROS
     C                   EVAL      RUN9 = *ZEROS
     C                   ENDIF

      ** Read all records from the Aggregate Facilities detail A table
     C     *LOVAL        SETLL     LEAGFYL1
     C                   READ      LEAGFYL1                               10

     C                   DOW       *IN10 = *OFF

      ** Process only live facilities
     C                   IF        AARECI = 'D'
     C                   EXSR      SRInitAGRecB
     C                   EXSR      SRInitAGRecX
     C                   ENDIF

      ** Read next record
     C                   READ      LEAGFYL1                               10

     C                   ENDDO

      ** Read all records from the joined tables FCLTYFM/FCLTYFN, process live
      ** tranches only
     C     *LOVAL        SETLL     LEFCLTJ0
     C                   READ      LEFCLTJ0                               10

     C                   DOW       *IN10 = *OFF

      ** Position to corresponding record in extension file
     C                   EXSR      SRPosToRecX

      ** Update Aggregated Facilities
     C                   EXSR      SRUpdAggFac

     C                   READ      LEFCLTJ0                               10
     C                   ENDDO

      ** Terminate Program

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmount - Subroutine that Converts Amount via            *
      *                *MODULE/ZCONVZ1                                *
      *                                                               *
      *****************************************************************
     C     SRCvtAmount   BEGSR

     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ** Output
     C                   PARM      *ZEROS        ZAMTCO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurDet - Subroutine that Retrieves Currency Details via *
      *                *MODULE/MXACSCURR                              *
      *                                                               *
      *****************************************************************
     C     SRGetCurDet   BEGSR

     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME

     C                   IF        ACS_RTCD = '*ERROR '
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = I#LFD1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SDCURR = InData

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdtAGRecB - Subroutine to Update Fields in Aggregate      *
      *                 Facilities Detail B File                      *
      *                                                               *
      *****************************************************************
     C     SrUpdtAGRecB  BEGSR

     C     KFclt2        CHAIN     LEAGFYL2                           11

      ** If not found, database error
     C                   IF        *IN11 = *ON
     C                   MOVE      AACNUM        WCNumA
     C                   MOVE      AAFACT        WFacTA
     C                   MOVE      AAFCNO        WFcNoA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'LEAGFYL2'
     C                   EVAL      DBKEY = WCNumA + WFacTA + WFcNoA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get the cross rate between the tranche's ccy & aggregate facility's ccy
     C                   EVAL      ZCCYI = FCCY
     C                   EVAL      ZCCYO = AAFCCY
     C                   EXSR      SRGetXRate

     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX

      ** Convert Tranche's Exposure Amounts to aggregate facility's currency
     C                   EVAL      ZAMTCI = CAMD
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABCAMD = ABCAMD + ZAMTCO

     C                   EVAL      ZAMTCI = OAM1
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM1 = ABOAM1 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM2
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM2 = ABOAM2 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM3
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM3 = ABOAM3 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM4
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM4 = ABOAM4 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM5
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM5 = ABOAM5 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM6
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM6 = ABOAM6 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM7
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM7 = ABOAM7 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM8
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM8 = ABOAM8 + ZAMTCO

     C                   EVAL      ZAMTCI = OAM9
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOAM9 = ABOAM9 + ZAMTCO

     C                   EVAL      ZAMTCI = OA10
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABOA10 = ABOA10 + ZAMTCO

     C                   EVAL      ZAMTCI = CEXP
     C                   EXSR      SRCvtAmount

     C                   EVAL      ABCEXP = ABCEXP + ZAMTCO

     C                   UPDATE    AGFCLTYB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdtAGRecX - Subroutine to Update Fields in Aggregate      *
      *                 Facilities Extension File                     *
      *                                                               *
      *****************************************************************
     C     SrUpdtAGRecX  BEGSR

     C                   MOVE      AABRCA        KBrcA
     C                   MOVE      AACNUM        KCNumA
     C                   MOVE      AAFACT        KFacTA
     C                   MOVE      AAFCNO        KFcNoA

     C     KFcltX        CHAIN     LEAGFYL3                           11

      ** If not found, database error
     C                   IF        *IN11 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'LEAGFYL3'
     C                   EVAL      DBKEY = KBrcA + KCNumA + KFacTA + KFcNoA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Since Cross Rate is already determined previously during update of
      ** aggr. facilities detail B file, just carry on with offset amount
      ** conversions

     C                   EVAL      ZAMTCI = FCXCOF
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCOF = AXFCXCOF + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF1
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF1 = AXFCXOF1 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF2
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF2 = AXFCXOF2 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF3
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF3 = AXFCXOF3 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF4
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF4 = AXFCXOF4 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF5
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF5 = AXFCXOF5 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF6
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF6 = AXFCXOF6 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF7
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF7 = AXFCXOF7 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF8
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF8 = AXFCXOF8 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXOF9
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXOF9 = AXFCXOF9 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXO10
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXO10 = AXFCXO10 + ZAMTCO

      ** Convert Tranche's Collateral Lending Values Day 1 to 10
     C                   EVAL      ZAMTCI = FCXCV1
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV1 = AXFCXCV1 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV2
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV2 = AXFCXCV2 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV3
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV3 = AXFCXCV3 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV4
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV4 = AXFCXCV4 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV5
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV5 = AXFCXCV5 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV6
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV6 = AXFCXCV6 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV7
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV7 = AXFCXCV7 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV8
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV8 = AXFCXCV8 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXCV9
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXCV9 = AXFCXCV9 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXC10
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXC10 = AXFCXC10 + ZAMTCO

      ** Convert Tranche's Margin Requirement Values Day 1 to 10
     C                   EVAL      ZAMTCI = FCXMR1
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR1 = AXFCXMR1 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR2
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR2 = AXFCXMR2 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR3
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR3 = AXFCXMR3 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR4
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR4 = AXFCXMR4 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR5
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR5 = AXFCXMR5 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR6
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR6 = AXFCXMR6 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR7
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR7 = AXFCXMR7 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR8
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR8 = AXFCXMR8 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXMR9
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXMR9 = AXFCXMR9 + ZAMTCO

     C                   EVAL      ZAMTCI = FCXM10
     C                   EXSR      SRCvtAmount

     C                   EVAL      AXFCXM10 = AXFCXM10 + ZAMTCO

     C                   UPDATE    AGFCLTYX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetXRate - Subroutine to Get the Cross Rate between Two    *
      *               Currencies                                      *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR

     C                   EVAL      I#LFD1 = ZCCYI
     C                   EXSR      SRGetCurDet
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCDPI = A6NBDP

     C                   EVAL      I#LFD1 = ZCCYO
     C                   EXSR      SRGetCurDet
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2 = A6MDIN
     C                   EVAL      ZCDPO = A6NBDP

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
      ** Outputs
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccsAGRecA - Subroutine to Access Fields in Aggregate      *
      *                 Facilities Detail A File                      *
      *                                                               *
      *****************************************************************
     C     SrAccsAGRecA  BEGSR

     C     KFclt1        CHAIN     LEAGFYL1                           11

      ** If not found, database error
     C                   IF        *IN11 = *ON
     C                   MOVE      AGAGBR        WBrcA
     C                   MOVE      AGAGNM        WCNumA
     C                   MOVE      AGAGFT        WFacTA
     C                   MOVE      AGAGFN        WFcNoA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'LEAGFYL1'
     C                   EVAL      DBKEY = WBrcA + WCNumA + WFacTA + WFcNoA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE147
      ** If record found, recalculate Facility Amount                                         CLE147
     C                   IF        CLE147 = 'Y'                                               CLE147
     C                   EVAL      AAFAMT = *ZERO                                             CLE147
     C                   EVAL      WWAFAM = 0                                                 CLE147
                                                                                              CLE147
     C                   MOVE      AGAGBR        KBranch                                      CLE147
     C                   MOVE      AGAGNM        KCust                                        CLE147
     C                   MOVE      AGAGFN        KFclty                                       CLE147
     C                   MOVEL     AGAGFT        KFclty                                       CLE147
                                                                                              CLE147
     C     KLEAGHS       SETLL     LEAGHSL0                                                   CLE147
     C     KLEAGHS       READE     LEAGHSL0                                                   CLE147
     C                   DOW       NOT %EOF(LEAGHSL0)                                         CLE147
     C                   SELECT                                                               CLE147
                                                                                              CLE147
      ** Facility Start                                                                       CLE147
     C                   WHEN      AIACTN = 'FS'                                              CLE147
     C                   EVAL      WWAFAM = WWAFAM + AIAAMT                                   CLE147
                                                                                              CLE147
      ** Facility Increase                                                                    CLE147
     C                   WHEN      AIACTN = 'FI'                                              CLE147
     C                   EVAL      WWAFAM = WWAFAM + AIAAMT                                   CLE147
                                                                                              CLE147
      ** Facility Decrease                                                                    CLE147
     C                   WHEN      AIACTN = 'FD'                                              CLE147
     C                   EVAL      WWAFAM = WWAFAM - AIAAMT                                   CLE147
                                                                                              CLE147
      ** Facility Reactivation                                                                CLE147
     C                   WHEN      AIACTN = 'FR'                                              CLE147
     C                   EVAL      WWAFAM = AIAAMT                                            CLE147
                                                                                              CLE147
      ** Others                                                                               CLE147
     C                   WHEN      AIACTN = 'MR' OR AIACTN = 'RE' OR                          CLE147
     C                             AIACTN = 'MA' OR AIACTN = 'MC' OR                          CLE147
     C                             AIACTN = 'M1' OR AIACTN = 'UE' OR                          CLE147
     C                             AIACTN = 'UD' OR AIACTN = 'MT'                             CLE147
                                                                                              CLE147
     C                   EVAL      WWAFAM = WWAFAM - AIAAMT                                   CLE147
                                                                                              CLE147
     C                   ENDSL                                                                CLE147
     C     KLEAGHS       READE     LEAGHSL0                                                   CLE147
     C                   ENDDO                                                                CLE147
                                                                                              CLE147
     C                   EVAL      AAFAMT = WWAFAM                                            CLE147
     C                   UPDATE    AGFCLTYA                                                   CLE147
     C                   ENDIF                                                                CLE147

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdAggFac - Subroutine to Update Aggregate Facilities      *
      *                Files as Determined in Tranche Table           *
      *                                                               *
      *****************************************************************
     C     SrUpdAggFac   BEGSR

      ** Access the corresponding records from the Tranche - Aggregate
      ** Facilities Relationship by Tranche Table
     C     KFcltB        SETLL     LETRAGL0
     C     KFcltB        READE     LETRAGL0                               12

     C                   DOW       *IN12 = *OFF
     C                   EXSR      SRAccsAGRecA
     C                   EXSR      SRUpdtAGRecB
     C                   EXSR      SRUpdtAGRecX
     C     KFcltB        READE     LETRAGL0                               12
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPosToRecX - Subroutine that Positions Pointer to Corres-   *
      *                ponding Record in the Extension File           *
      *                                                               *
      *****************************************************************
     C     SRPosToRecX   BEGSR

     C                   MOVE      BRCA          KBrcA
     C                   MOVE      CNUM          KCNumA
     C                   MOVE      FACT          KFacTA
     C                   MOVE      FCNO          KFcNoA

     C     KFcltX        CHAIN     LEFCLTLG                           11

      ** If not found, database error
     C                   IF        *IN11 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'LEFCLTLG'
     C                   EVAL      DBKEY = KBrcA + KCNumA + KFacTA + KFcNoA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitAGRecX - Subroutine to Initialise Fields in Aggregate  *
      *                 Facilities Extension File                     *
      *                                                               *
      *****************************************************************
     C     SrInitAGRecX  BEGSR

     C                   MOVE      AABRCA        KBrcA
     C                   MOVE      AACNUM        KCNumA
     C                   MOVE      AAFACT        KFacTA
     C                   MOVE      AAFCNO        KFcNoA

     C     KFcltX        CHAIN     LEAGFYL3                           11

      ** If not found, database error
     C                   IF        *IN11 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'LEAGFYL3'
     C                   EVAL      DBKEY = KBrcA + KCNumA + KFacTA + KFcNoA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      AXFCXCOF = *ZEROS
     C                   EVAL      AXFCXOF1 = *ZEROS
     C                   EVAL      AXFCXOF2 = *ZEROS
     C                   EVAL      AXFCXOF3 = *ZEROS
     C                   EVAL      AXFCXOF4 = *ZEROS
     C                   EVAL      AXFCXOF5 = *ZEROS
     C                   EVAL      AXFCXOF6 = *ZEROS
     C                   EVAL      AXFCXOF7 = *ZEROS
     C                   EVAL      AXFCXOF8 = *ZEROS
     C                   EVAL      AXFCXOF9 = *ZEROS
     C                   EVAL      AXFCXO10 = *ZEROS
     C                   EVAL      AXFCXCV1 = *ZEROS
     C                   EVAL      AXFCXCV2 = *ZEROS
     C                   EVAL      AXFCXCV3 = *ZEROS
     C                   EVAL      AXFCXCV4 = *ZEROS
     C                   EVAL      AXFCXCV5 = *ZEROS
     C                   EVAL      AXFCXCV6 = *ZEROS
     C                   EVAL      AXFCXCV7 = *ZEROS
     C                   EVAL      AXFCXCV8 = *ZEROS
     C                   EVAL      AXFCXCV9 = *ZEROS
     C                   EVAL      AXFCXC10 = *ZEROS
     C                   EVAL      AXFCXMR1 = *ZEROS
     C                   EVAL      AXFCXMR2 = *ZEROS
     C                   EVAL      AXFCXMR3 = *ZEROS
     C                   EVAL      AXFCXMR4 = *ZEROS
     C                   EVAL      AXFCXMR5 = *ZEROS
     C                   EVAL      AXFCXMR6 = *ZEROS
     C                   EVAL      AXFCXMR7 = *ZEROS
     C                   EVAL      AXFCXMR8 = *ZEROS
     C                   EVAL      AXFCXMR9 = *ZEROS
     C                   EVAL      AXFCXM10 = *ZEROS

     C                   UPDATE    AGFCLTYX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitAGRecB - Subroutine to Initialise Fields in Aggregate  *
      *                 Facilities Detail B File                      *
      *                                                               *
      *****************************************************************
     C     SrInitAGRecB  BEGSR

     C     KFclt2        CHAIN     LEAGFYL2                           11

      ** If not found, database error
     C                   IF        *IN11 = *ON
     C                   MOVE      AACNUM        WCNumA
     C                   MOVE      AAFACT        WFacTA
     C                   MOVE      AAFCNO        WFcNoA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'LEAGFYL2'
     C                   EVAL      DBKEY = WCNumA + WFacTA + WFcNoA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      ABRUN0 = RUN0
     C                   EVAL      ABRUN1 = RUN1
     C                   EVAL      ABRUN2 = RUN2
     C                   EVAL      ABRUN3 = RUN3
     C                   EVAL      ABRUN4 = RUN4
     C                   EVAL      ABRUN5 = RUN5
     C                   EVAL      ABRUN6 = RUN6
     C                   EVAL      ABRUN7 = RUN7
     C                   EVAL      ABRUN8 = RUN8
     C                   EVAL      ABRUN9 = RUN9
     C                   EVAL      ABPEXP = ABCAMD
     C                   EVAL      ABCAMD = *ZERO
     C                   EVAL      ABOAM1 = *ZERO
     C                   EVAL      ABOAM2 = *ZERO
     C                   EVAL      ABOAM3 = *ZERO
     C                   EVAL      ABOAM4 = *ZERO
     C                   EVAL      ABOAM5 = *ZERO
     C                   EVAL      ABOAM6 = *ZERO
     C                   EVAL      ABOAM7 = *ZERO
     C                   EVAL      ABOAM8 = *ZERO
     C                   EVAL      ABOAM9 = *ZERO
     C                   EVAL      ABOA10 = *ZERO
     C                   EVAL      ABCEXP = *ZERO

     C                   UPDATE    AGFCLTYB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'LE000050'
     C                   EVAL      DBMOD = 'LE000050'
     C                   EVAL      DBASE = *ZEROS
     C                   OUT       LDA

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if SAR CLE147 is switched *ON                                                  CLE147
     C                   CALL      'AOSARDR0'                                                 CLE147
     C                   PARM      *BLANKS       PRetCode                                     CLE147
     C                   PARM      '*KEY   '     POption                                      CLE147
     C                   PARM      'CLE147 '     PSard                                        CLE147
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE147
                                                                                              CLE147
     C                   IF        PRetCode = *BLANKS                                         CLE147
     C                   EVAL      CLE147 = 'Y'                                               CLE147
     C                   ELSE                                                                 CLE147
     C                   EVAL      CLE147 = 'N'                                               CLE147
     C                   IF        PRetCode <> '*NRF    '                                     CLE147
     C     *LOCK         IN        LDA                                                        CLE147
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE147
     C                   EVAL      DBKEY = 'CLE147'                                           CLE147
     C                   EVAL      DBASE = 2                                                  CLE147
     C                   OUT       LDA                                                        CLE147
     C                   EXSR      *PSSR                                                      CLE147
     C                   ENDIF                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
      ** Key list for Facility record B file
     C     KFcltB        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO

      ** Key list for Facility extension record file
     C     KFcltX        KLIST
     C                   KFLD                    KBrcA
     C                   KFLD                    KCNumA
     C                   KFLD                    KFacTA
     C                   KFLD                    KFcNoA

      ** Key list for Facility extension record file
     C     KFclt1        KLIST
     C                   KFLD                    AGAGBR
     C                   KFLD                    AGAGNM
     C                   KFLD                    AGAGFT
     C                   KFLD                    AGAGFN

      ** Key list for Facility record A file
     C     KFclt2        KLIST
     C                   KFLD                    AACNUM
     C                   KFLD                    AAFACT
     C                   KFLD                    AAFCNO

      ** Key list for Facility Aggregate History file                                         CLE147
     C     KLEAGHS       KLIST                                                                CLE147
     C                   KFLD                    KBranch                                      CLE147
     C                   KFLD                    KCust                                        CLE147
     C                   KFLD                    KFclty                                       CLE147
                                                                                              CLE147
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
