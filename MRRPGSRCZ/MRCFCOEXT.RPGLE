     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Caps, Collars and Floors Extract')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRCFCOEXT - Caps, Collars and Floors Extract           *
      *                                                               *
      *  Function:  This module will read DEALSDG as an input primary *
      *             file.  For each required record from DEALSDG, a   *
      *             record will be written to file MRTRAPPD.          *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 BUG10240           Date 31Jan06               *
      *                 CRN001   *CREATE   Date 01Sep05               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *            (recompile)                                        *
      *  BUG10240 - Parameter error                                   *
      *  CRN001 - MidasPlus Regulatory Reporting Interface            *
      *           Enhancement                                         *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Loans and Deposits
     FDEALSDG   IF   E             DISK    INFSR(*PSSR)

      ** Deals Extension File
     FDLDEALL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DLDLDBD0)
     F                                     IGNORE(DLDLDCD0)

      ** Reporting Parameters
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)

      ** Transactions Report File
     FMRTRAPPD  O    E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0

      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)

      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC2       E                     EXTFLD(QQACCD)

      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

     D WkTAmt          S             15  0
     D WkTCcy          S              3
     D WkAmtInB        S             15  0
     D WkAmtIn1        S             15  0
     D WkAmtIn2        S             15  0
     D WkCYCDB         S              3
     D WkNBDPB         S              1  0
     D WkSPRTB         S             13P 8
     D WkMDINB         S              1
     D WkCYCD1         S              3
     D WkNBDP1         S              1  0
     D WkSPRT1         S             13P 8
     D WkMDIN1         S              1
     D WkCYCD2         S              3
     D WkNBDP2         S              1  0
     D WkSPRT2         S             13P 8
     D WkMDIN2         S              1
     D PAcKyPos01      S              2
     D PAcKyPos03      S              1
     D PAcKyPos04      S              2
     D PAcKyPos06      S              1
     D PAcKyPos07      S              1
     D PAcKyPos08      S              1
     D PAcKyPos09      S              1
     D PAcKyPos10      S              1
     D PAcKyPos11      S              4                                                     BUG10240
     D PAcCodDR1       S             10
     D PAcSecDR1       S              2
     D PPosRfDR1       S              1
     D PAcCodDR2       S             10
     D PAcSecDR2       S              2
     D PPosRfDR2       S              1
     D PAcCodDR3       S             10
     D PAcSecDR3       S              2
     D PPosRfDR3       S              1
     D PAcCodCR1       S             10
     D PAcSecCR1       S              2
     D PPosRfCR1       S              1
     D PAcCodCR2       S             10
     D PAcSecCR2       S              2
     D PPosRfCR2       S              1
     D PAcCodCR3       S             10
     D PAcSecCR3       S              2
     D PPosRfCR3       S              1
     D PRetCode        S              7
     D POption         S              7
     D PCust           S             10
     D PStKey          S              7
     D PCcy            S              3
     D WkECDat         S              5  0
     D I#ERMS          S             60

      ** Parameters for MRDATBID - Date Bucket Identification Module
     D PaDtSch         S              1  0
     D PaRepDt         S              5  0
     D PaSchDt         S              5  0
     D PaBuckCode      S              8

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

      ** Parameters for GLINTC module
     D ZIBEG           S              5  0
     D ZIEND           S              5  0
     D ZICALC          S              1  0
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTR           S             30  9

      *****************************************************************
      * BOUGHT FLOOR        BASE RATE < FLOOR RATE          WE RECEIVE
      *----------------------------------------------------------------
      * SOLD   FLOOR        BASE RATE < FLOOR RATE          WE PAY
      *----------------------------------------------------------------
      * BOUGHT CAP          BASE RATE > CELING RATE         WE RECEIVE
      *----------------------------------------------------------------
      * SOLD   CAP          BASE RATE > CELING RATE         WE PAY
      *----------------------------------------------------------------
      * BOUGHT COLLAR       BASE RATE < FLOOR RATE          WE RECEIVE
      *                  or BASE RATE > CELING RATE
      *----------------------------------------------------------------
      * SOLD   COLLAR       BASE RATE < FLOOR RATE          WE PAY
      *                  or BASE RATE > CELING RATE
      *********************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C     1             SETLL     DEALSDG

     C                   READ      DEALSDG

     C                   DOW       NOT %EOF(DEALSDG)

      ** Process live and matured records only
     C                   IF        (RECI = 'D' OR RECI = 'M') AND
     C                             (DTYP = 'RP' OR DTYP = 'RR' OR DTYP = 'RF')
     C                   EXSR      SRProcess
     C                   ENDIF

     C                   READ      DEALSDG

     C                   ENDDO

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine                                       *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
     C                   CLEAR                   MRTRAPD0

      ** Set Extract Date
     C                   EVAL      EXTDAT = BJRDNB

      ** Set Event Control Date
     C                   EVAL      EXVCD = WkECDat

      ** Set Calendar/Financial
     C                   EVAL      EXCAFI = 'C'

      ** Set Period Type
     C                   EVAL      EXPERT = 'M'

      ** Set Calendar Year/Month
     C                   EVAL      EXCY = CalendarYear
     C                   EVAL      EXCM = CalendarMonth

      ** Set Module
     C                   EVAL      EXMOD = 'DL'

      ** Set Sub-Module
     C                   EVAL      EXSUB = 'CFCO'

      ** Set Transaction Id
     C                   MOVEL     DLNO          EXTRID

      ** Set Sequence Number
     C                   EVAL      EXSEQ = 0

      ** Set Transaction Status
     C                   EXSR      SRSetTrStat

      ** Set On/Off Balance Sheet (EXBALS)
     C                   EVAL      EXBALS = '0'

      ** Set Branch Details (EXBRCH, EXBICN)
     C                   EXSR      SRSetBrcDet

      ** Set Customer Details (EXCUSN, EXCCIT, EXCLOC, EXCIND, EXCINT, EXCBNK
      ** EXCSWF)
     C                   EXSR      SRSetCusDet

      ** Set Parent Details (EXPARN, EXPCIT, EXPLOC, EXPIND, EXPINT, EXPBNK
      ** EXPSWF)
     C     BBPCNB        IFNE      *BLANK
     C                   EXSR      SRSetParDet
     C                   ENDIF

      ** Set Account Sequence, Transaction Type, Sub-Type, Profit Centre,
      ** Deal Date and Value Date
     C                   EVAL      EXACSQ = '01'
     C                   EVAL      EXACS1 = '01'
     C                   EVAL      EXTRTY = DTYP
     C                   EVAL      EXTRST = DLST
     C                   EVAL      EXCLAS = CLAS                                            BUG10240
     C                   EVAL      EXPRFC = PRFC
     C                   EVAL      EXDDAT = DDAT
     C                   EVAL      EXVDAT = VDAT

      ** Set Unrealised Profit/Loss Sign and DR/CR indicator
     C                   EVAL      EXUSGN =  1
     C                   EVAL      EXUDCI =  0

      ** Set Maturity Date - Date Schedules (EXMDT0-EXMDT9)
     C                   EXSR      SRSetMatSch

      ** Set Facility Details
     C                   MOVE      DLNO          F1DLNO
     C                   EXSR      SRSetFacDet


      ** Set Currency Details (EXCYCD, EXEBRT, EXMDIB, EXERP1, EXMDI1,
      ** EXERP2, EXMDI2)
     C                   EXSR      SRSetCurDet

      ** Set FX Contract and Valuation Rates
     C                   EVAL      EXCNRT = 0
     C                   EVAL      EXVLRT = 0

      ** Set Principal Asset/Liability Indicator, Sign and DR/CR ind
     C                   EVAL      EXPALI = BYSL
     C                   Z-ADD     1             EXPSGN
     C                   Z-ADD     0             EXPDCI

      ** Set Principal Account Key (EXPACC, EXPACS, EXPREF)
     C                   EXSR      SRSetPrAcKy

      ** Set Principal Amounts (EXPAMT, EXPMTB, EXPMT1, EXPMT2)
     C                   EXSR      SRSetPrnAmt
      * Determine Effective Rate
     C                   Z-ADD     *ZERO         EffectiveRate    11 7
     C                   EXSR      SRDetEffRate

      ** Set Accrued Interest Account Key (EXAACC, EXAACS, EXAREF,
      ** Set Interst Inc./Exp. Account Key (EXIACC, EXIACS, EXIREF)
     C                   EXSR      SRSetAIAcKy

      ** Set Accrued Interest Amounts (EXAAMT, EXAMTB, EXAMT1, EXAMT2)
     C                   EXSR      SRSetAInAmt

      ** Initialise the rest of the Interest Inc./Exp. Details
     C                   EVAL      EXIAMT = *ZEROS
     C                   EVAL      EXIMTB = *ZEROS
     C                   EVAL      EXIMT1 = *ZEROS
     C                   EVAL      EXIMT2 = *ZEROS

      ** Initialise Unearned Disc/Prem Details
     C                   EVAL      EXESGN = *ZERO
     C                   EVAL      EXEDCI = *ZERO
     C                   EVAL      EXEACC = *BLANKS
     C                   EVAL      EXEACS = *BLANKS
     C                   EVAL      EXEREF = *BLANKS
     C                   EVAL      EXEAMT = *ZEROS
     C                   EVAL      EXEMTB = *ZEROS
     C                   EVAL      EXEMT1 = *ZEROS
     C                   EVAL      EXEMT2 = *ZEROS

      ** Set Unrealised P/L  Account Key (EXUACC, EXUACS, EXUREF)
     C                   EXSR      SRSetUnAcKy

      ** Set Unrealised P/L Amounts (EXUAMT, EXUMTB, EXUMT1, EXUMT2)
     C                   EXSR      SRSetUnAmt

      ** Initialise Disc./Prem. Inc/Exp Details
     C                   EVAL      EXDACC = *BLANKS
     C                   EVAL      EXDACS = *BLANKS
     C                   EVAL      EXDREF = *BLANKS
     C                   EVAL      EXDAMT = *ZEROS
     C                   EVAL      EXDMTB = *ZEROS
     C                   EVAL      EXDMT1 = *ZEROS
     C                   EVAL      EXDMT2 = *ZEROS

      ** Initialise Realised Profit/Loss Details
     C                   EVAL      EXRACC = *BLANKS
     C                   EVAL      EXRACS = *BLANKS
     C                   EVAL      EXRREF = *BLANKS
     C                   EVAL      EXRAMT = *ZEROS
     C                   EVAL      EXRMTB = *ZEROS
     C                   EVAL      EXRMT1 = *ZEROS
     C                   EVAL      EXRMT2 = *ZEROS

      ** Set Maturity Date and Date Schedules (EXMDAT, EXMDT0 to EXMDT9)
     C                   EXSR      SRSetMatSch

      ** Set Fixed/Variable Rate indicator, Base Rate, Rate/Spread, Interest
      ** Rate, Yield Rate

      ** Use our rate for RF-Buy, RP-Sell and RR-Sell.
     C                   IF        (DTYP = 'RF' AND BYSL = 'B') OR
     C                             (DTYP = 'RP' AND BYSL = 'S') OR
     C                             (DTYP = 'RR' AND BYSL = 'S')

     C                   EVAL      EXINTR = UEINR
     C                   EVAL      EXBRTE = UBRTE
     C                   EVAL      EXRTSP = URTSP
     C                   EVAL      EXRATE = 'V'

      ** Use their rate for RF-Sell, RP-Buy and RR-Buy.
     C                   ELSE

     C                   EVAL      EXINTR = TEINR
     C                   EVAL      EXBRTE = TBRTE
     C                   EVAL      EXRTSP = TRTSP
     C                   EVAL      EXRATE = 'V'
     C                   ENDIF

     C                   EVAL      EXYLDR = EffectiveRate

      ** Set Next Interest Pay Date and Date Schedules and Amounts
     C                   IF        PayOrRec = 'R' AND TNIPD <> *ZERO
     C                   EVAL      EXNIDT = TNIPD
     C                   ELSE
     C                   IF        PayOrRec = 'P' AND UNIPD <> *ZERO
     C                   EVAL      EXNIDT = UNIPD
     C                   ELSE
     C                   EVAL      EXNIDT = MDAT
     C                   ENDIF
     C                   ENDIF

     C                   IF        EXNIDT <> *ZERO
     C                   EXSR      SRSetNInSch
     C                   IF        EXYLDR <> *ZERO
     C                   EXSR      SRSetNIPAmt
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXNIMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXNIMB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXNIM1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXNIM2 = WkAmtIn2/(10**WkNBDP2)
     C                   ENDIF
     C                   ENDIF

      ** Initialise Next Principal Pay Details
     C                   EVAL      EXNPMT = *ZEROS
     C                   EVAL      EXNPMB = *ZEROS
     C                   EVAL      EXNPM1 = *ZEROS
     C                   EVAL      EXNPM2 = *ZEROS
     C                   EVAL      EXNPDT = *ZEROS
     C                   EVAL      EXNPD0 = *BLANKS
     C                   EVAL      EXNPD1 = *BLANKS
     C                   EVAL      EXNPD2 = *BLANKS
     C                   EVAL      EXNPD3 = *BLANKS
     C                   EVAL      EXNPD4 = *BLANKS
     C                   EVAL      EXNPD5 = *BLANKS
     C                   EVAL      EXNPD6 = *BLANKS
     C                   EVAL      EXNPD7 = *BLANKS
     C                   EVAL      EXNPD8 = *BLANKS
     C                   EVAL      EXNPD9 = *BLANKS

      ** Initialise Recourse Indicator
     C                   EVAL      EXRCSI = *BLANKS
     C                   EVAL      EXBOOK = BOKC

      ** Write record to output file
     C                   WRITE     MRTRAPD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetEffRate  Subroutine that Determines Effective Rate      *
      *                                                               *
      *****************************************************************
     C     SRDetEffRate  BEGSR

      *  BLANK FIELDS CONDITIONING PROCESSING
     C                   MOVE      ' '           AVERRT            1
     C                   MOVE      ' '           USRST             1
     C                   MOVE      ' '           FLRRTF            1

      * FLOOR RATE
     C                   TESTB     '4'           UDSTI                    31
     C   31              MOVE      'Y'           FLRRTF
     C                   TESTB     '4'           TDSTI                    31
     C   31              MOVE      'Y'           FLRRTF

      * STATUS OF USER/AVERAGE RATE : USER HAS NON-ZERO BASE RATE

     C*****UBRTT         IFNE      0                                                          CSD103
     C     UBRTT         IFNE      *BLANKS                                                    CSD103
     C                   TESTB     '3'           UDSTI                    31
     C   31              MOVE      'Y'           AVERRT
     C                   MOVE      'P'           USRST
     C                   ELSE
     C                   TESTB     '3'           TDSTI                    31
     C   31              MOVE      'Y'           AVERRT
     C                   MOVE      'T'           USRST
     C                   END

      *  DETERMINE RATE

      * AVERAGE RATE
     C     AVERRT        IFEQ      'Y'
     C                   Z-ADD     AACRT         EINR             11 7
     C                   ELSE
      *  NON-AVE, PROVIDERS RATE
     C     USRST         IFEQ      'P'
     C                   Z-ADD     UEINR         EINR
     C                   ELSE
     C                   Z-ADD     TEINR         EINR
     C                   END
     C                   END

      * TOPPING UP RATE/REIMBURSEMENT RATE CALCULATIONS

     C                   Z-ADD     0             TPUPRT
     C                   Z-ADD     0             REIMRT

     C     FLRRTF        IFEQ      'Y'
     C     FLRAT         SUB       EINR          TPUPRT           11 7  31
     C   31              Z-ADD     0             TPUPRT
     C                   END
     C     EINR          SUB       CLRAT         REIMRT           11 7  31
     C   31              Z-ADD     0             REIMRT


      * GET CORRECT RATE FOR THEIR PAYMENT
      *                      -----
     C                   Z-ADD     0             SZINTR
     C                   SETOFF                                       31

      * USE TOPPING UP RATE FOR C'PARTY(TAKER)
     C     USRST         IFEQ      'P'
     C     FLRRTF        ANDEQ     'Y'
     C                   Z-ADD     TPUPRT        SZINTR           11 731
     C                   END

      * USE REIMBURSEMENT RATE FOR C'PARTY(PROVIDER)
     C     USRST         IFEQ      'T'
     C                   Z-ADD     REIMRT        SZINTR               31
     C                   END

      ** THEIR PAYMENTS

     C     *IN31         IFEQ      '1'
     C                   MOVEL     'R'           PayOrRec          1
     C                   Z-ADD     SZINTR        EffectiveRate
     C                   END

      * GET CORRECT RATE FOR OUR PAYMENT
      *                      ---

     C                   Z-ADD     0             SZINTR
     C                   SETOFF                                       31

      * USE TOPPING UP RATE FOR USER(TAKER)
     C     USRST         IFEQ      'T'
     C     FLRRTF        ANDEQ     'Y'
     C                   Z-ADD     TPUPRT        SZINTR               31
     C                   END

      * USE REIMBURSEMENT RATE FOR USER(PROVIDER)
     C     USRST         IFEQ      'P'
     C                   Z-ADD     REIMRT        SZINTR               31
     C                   END

      ** OUR PAYMENTS

     C     *IN31         IFEQ      '1'
     C                   MOVEL     'P'           PayOrRec
     C                   Z-ADD     SZINTR        EffectiveRate
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetNIPAmt - Subroutine that Sets Next Interest Pay Amount  *
      *                Fields                                         *
      *                                                               *
      *****************************************************************
     C     SRSetNIPAmt   BEGSR

     C                   IF        PayOrRec = 'R'
     C     AVERRT        IFEQ      'Y'
     C                   Z-ADD     SDCAR         ZIBEG
     C                   ELSE
     C     USRST         IFEQ      'P'
     C                   Z-ADD     UIACD         ZIBEG
     C                   ELSE
     C                   Z-ADD     TIACD         ZIBEG
     C                   END
     C                   END
     C                   Z-ADD     EXNIDT        ZIEND
     C                   Z-ADD     TICBS         ZICALC
     C                   Z-ADD     TPAMT         ZIAMT
     C                   Z-ADD     EffectiveRate ZIRATE

     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
      ** Output
     C                   PARM      *ZEROS        ZINTR

     C                   Z-ADD(H)  ZINTR         WkIntrst         15 0
     C                   EVAL      WkTAmt = WkIntrst + TAITC + TAIAP - TIPRD

     C                   ELSE

     C     AVERRT        IFEQ      'Y'
     C                   Z-ADD     SDCAR         ZIBEG
     C                   ELSE
     C     USRST         IFEQ      'P'
     C                   Z-ADD     UIACD         ZIBEG
     C                   ELSE
     C                   Z-ADD     TIACD         ZIBEG
     C                   END
     C                   END
     C                   Z-ADD     EXNIDT        ZIEND
     C                   Z-ADD     UICBS         ZICALC
     C                   Z-ADD     UPAMT         ZIAMT
     C                   Z-ADD     EffectiveRate ZIRATE

     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
      ** Output
     C                   PARM      *ZEROS        ZINTR

     C                   Z-ADD(H)  ZINTR         WkIntrst         15 0
     C                   EVAL      WkTAmt = WkIntrst + UAITC + UAIAP - UIPRD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFacDet - Subroutine that Sets Facility Details          *
      *                                                               *
      *****************************************************************
     C     SRSetFacDet   BEGSR

     C     F1DLNO        CHAIN     DLDEALL5                           32

     C                   IF        *IN32 = *OFF
     C                   MOVE      F1FCCU        EXFCUS
     C                   MOVE      F1FACT        EXFTYP
     C                   MOVE      F1FCNO        EXFCNO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetNInSch - Subroutine that Sets Next Interest Pay Date -  *
      *                Date Schedules                                 *
      *                                                               *
      *****************************************************************
     C     SRSetNInSch   BEGSR

     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = EXNIDT

      ** Set Maturity Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID0 = PaBuckCode

      ** Set Maturity Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID1 = PaBuckCode

      ** Set Maturity Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID2 = PaBuckCode

      ** Set Maturity Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID3 = PaBuckCode

      ** Set Maturity Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID4 = PaBuckCode

      ** Set Maturity Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID5 = PaBuckCode

      ** Set Maturity Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID6 = PaBuckCode

      ** Set Maturity Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID7 = PaBuckCode

      ** Set Maturity Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID8 = PaBuckCode

      ** Set Maturity Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID9 = PaBuckCode

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetMatSch - Subroutine that Sets Maturity Date - Date      *
      *                Schedules                                      *
      *                                                               *
      *****************************************************************
     C     SRSetMatSch   BEGSR

     C                   EVAL      EXMDAT = MDAT

     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = MDAT

      ** Set Maturity Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT0 = PaBuckCode

      ** Set Maturity Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT1 = PaBuckCode

      ** Set Maturity Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT2 = PaBuckCode

      ** Set Maturity Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT3 = PaBuckCode

      ** Set Maturity Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT4 = PaBuckCode

      ** Set Maturity Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT5 = PaBuckCode

      ** Set Maturity Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT6 = PaBuckCode

      ** Set Maturity Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT7 = PaBuckCode

      ** Set Maturity Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT8 = PaBuckCode

      ** Set Maturity Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT9 = PaBuckCode

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBuckCd - Subroutine that Gets Bucket Code               *
      *                                                               *
      *****************************************************************
     C     SRGetBuckCd   BEGSR

     C                   CALLB     'MRDATBID'
     C                   PARM                    PaDtSch
     C                   PARM                    PaRepDt
     C                   PARM                    PaSchDt
      ** Output
     C                   PARM                    PaBuckCode

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetAInAmt - Subroutine that Sets Accrued Interest Amounts  *
      *                                                               *
      *****************************************************************
     C     SRSetAInAmt   BEGSR

     C                   EVAL      WkTAmt = *ZEROS
     C                   IF        PayOrRec = 'P'
     C                   EVAL      WkTAmt =  UAIPD - UIPRD
     C                   EVAL      EXASGN = -1
     C                   EVAL      EXADCI =  1
     C                   ELSE
     C                   IF        PayOrRec = 'R'
     C                   EVAL      WkTAmt =  TAIPD - TIPRD
     C                   EVAL      EXASGN =  1
     C                   EVAL      EXADCI =  0
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WkTCcy = UCUCY
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXAAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXAMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXAMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXAMT2 = WkAmtIn2/(10**WkNBDP2)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetUnAmt - Subroutine that Sets Unrealized P/L Amounts     *
      *                                                               *
      *****************************************************************
     C     SRSetUnAmt    BEGSR

     C                   EVAL      WkTAmt = UNRLP
     C                   EVAL      WkTCcy = UCUCY
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXUAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXUMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXUMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXUMT2 = WkAmtIn2/(10**WkNBDP2)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmounts - Subroutine that Converts the Amount in Tran-  *
      *                 saction Ccy to be in Base Ccy, Reporting Ccy  *
      *                 1 and Reporting Ccy 2                         *
      *                                                               *
      *****************************************************************
     C     SRCvtAmounts  BEGSR

      ** Get Accrued Interest Amount in Base Currency
     C                   Z-ADD     WkTAmt        ZAMTCI
     C                   EVAL      ZEXCH = A6SPRT
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = WkTCcy
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtInB

      ** Get Principal Amount in Reporting Currency 1
     C                   EVAL      ZEXCH = EXERP1
     C                   EVAL      ZMD = EXMDI1
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtIn1

      ** Get Principal Amount in Reporting Currency 2
     C                   EVAL      ZEXCH = EXERP2
     C                   EVAL      ZMD = EXMDI2
     C                   EVAL      ZCCYO = WkCYCD2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtIn2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetPrnAmt - Subroutine that Sets Principal Amounts         *
      *                                                               *
      *****************************************************************
     C     SRSetPrnAmt   BEGSR

     C                   Z-ADD     UPAMT         WkTAmt
     C                   EVAL      WkTCcy = UCUCY
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAmount - Subroutine that Gets Converted Amount via      *
      *                ZCONVZ1                                        *
      *                                                               *
      *****************************************************************
     C     SRGetAmount   BEGSR

     C                   CALLB     'ZCONVZ1'
      ** Inputs
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
      *  SRSetCurDet - Subroutine that Sets Currency Details          *
      *                                                               *
      *****************************************************************
     C     SRSetCurDet   BEGSR

     C                   EVAL      I#LFD1 = UCUCY

     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME

     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'INVALID CURRENCY: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SDCURR = InData

     C                   EVAL      EXCYCD = UCUCY
     C                   EVAL      EXEBRT = A6SPRT
     C                   EVAL      EXMDIB = A6MDIN

      ** Retrieve Cross Rate between Transaction Currency and Reporting Ccy 1
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE2 = WkSPRT1
     C                   EVAL      ZMDI2 = WkMDIN1
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP1 = ZRATEX
     C                   EVAL      EXMDI1 = ZMDIX

      ** Retrieve Cross Rate between Transaction Currency and Reporting Ccy 2
     C                   EVAL      ZRATE2  = WkSPRT2
     C                   EVAL      ZMDI2 = WkMDIN2
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP2 = ZRATEX
     C                   EVAL      EXMDI2 = ZMDIX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetXRate - Subroutine that Retrieves Cross Currency Rate   *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR

     C                   CALLB     'ZXRATE'
      ** Inputs
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
      *  SRSetCusDet - Subroutine that Sets Customer Details          *
      *                                                               *
      *****************************************************************
     C     SRSetCusDet   BEGSR

     C                   MOVEL     CNUM          PCust

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      *BLANKS       DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      CNUM          EXCUSN
     C                   EVAL      EXCCIT = BBCNCZ
     C                   EVAL      EXCLOC = BBCOLC
     C                   EVAL      EXCIND = BBLICD
     C                   EVAL      EXCINT = BBLINC
     C                   EVAL      EXCBNK = BBBNBI
     C                   EVAL      EXCSWF = BBSWFI

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetParDet - Subroutine that Sets Parent Details            *
      *                                                               *
      *****************************************************************
     C     SRSetParDet   BEGSR

     C                   MOVEL     BBPCNB        PCust

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      *BLANKS       DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     BBCUST        EXPARN
     C                   EVAL      EXPCIT = BBCNCZ
     C                   EVAL      EXPLOC = BBCOLC
     C                   EVAL      EXPIND = BBLICD
     C                   EVAL      EXPINT = BBLINC
     C                   EVAL      EXPBNK = BBBNBI
     C                   EVAL      EXPSWF = BBSWFI

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetBrcDet - Subroutine that Sets Branch Details            *
      *                                                               *
      *****************************************************************
     C     SRSetBrcDet   BEGSR

     C                   EVAL      I#LFD1 = BRCA

     C                   CALLB     'MXACSBRCH'
      /COPY MXCPYSRC,MXACSPRME

     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'INVALID BRANCH: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SDBRCH = InData

     C                   EVAL      EXBRCH = A8BRCD
     C                   EVAL      EXBICN = A8BICN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcy
     C     SDCURR        PARM      *BLANKS       DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetRepPrm - Subroutine that Accesses Report Parameters     *
      *                                                               *
      *****************************************************************
     C     SRGetRepPrm   BEGSR

     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD

     C                   IF        %EOF(MRRPRMPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'MRRPRMPD'
     C                   EVAL      DBKEY = '*READ '
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetUnAcKy - Subroutine that Sets Unrealised P/L Account    *
      *                Key                                            *
      *                                                               *
      *****************************************************************
     C     SRSetUnAcKy   BEGSR

     C                   EVAL      EXUACC = *BLANKS
     C                   EVAL      EXUACS = *BLANKS
     C                   EVAL      EXUREF = *BLANKS
     C                   EVAL      EXDACC = *BLANKS
     C                   EVAL      EXDACS = *BLANKS
     C                   EVAL      EXDREF = *BLANKS

     C                   IF        UNRLP <> *ZERO
     C                   EVAL      PAcKyPos01 = DTYP
     C                   EVAL      PAcKyPos03 = 'A'
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                        BUG10240
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = 'U'

      ** If Unrealised P/L posted is greater than zero
     C                   IF        UNRLP > 0
     C                   EVAL      PAcKyPos10 = 'P'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXUACC = PAcCodCR1
     C                   EVAL      EXUACS = PAcSecCR1
     C                   EVAL      EXUREF = PPosRfCR1
     C                   ELSE

      ** If Unrealised P/L less than zero
     C                   IF        UNRLP < 0
     C                   EVAL      PAcKyPos10 = 'L'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXUACC = PAcCodDR1
     C                   EVAL      EXUACS = PAcSecDR1
     C                   EVAL      EXUREF = PPosRfDR1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetAIAcKy - Subroutine that Sets Accrued Interest Account  *
      *                Key                                            *
      *                                                               *
      *****************************************************************
     C     SRSetAIAcKy   BEGSR

     C                   EVAL      EXAACC = *BLANKS
     C                   EVAL      EXAACS = *BLANKS
     C                   EVAL      EXAREF = *BLANKS
     C                   EVAL      EXIACC = *BLANKS
     C                   EVAL      EXIACS = *BLANKS
     C                   EVAL      EXIREF = *BLANKS

     C                   EVAL      PAcKyPos01 = DTYP
     C                   EVAL      PAcKyPos03 = 'A'
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                        BUG10240
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = *BLANKS
     C                   EVAL      PAcKyPos10 = 'A'

     C                   IF        PayOrRec = 'P'
     C                   EVAL      PAcKyPos09 = 'P'
     C                   EXSR      SRGetAcKeyD
     C                   EVAL      EXAACC = PAcCodCR1
     C                   EVAL      EXAACS = PAcSecCR1
     C                   EVAL      EXAREF = PPosRfCR1
     C                   EVAL      EXIACC = PAcCodDR1
     C                   EVAL      EXIACS = PAcSecDR1
     C                   EVAL      EXIREF = PPosRfDR1

     C                   ELSE

     C                   IF        PayOrRec = 'R'
     C                   EVAL      PAcKyPos09 = 'R'
     C                   EXSR      SRGetAcKeyD
     C                   EVAL      EXAACC = PAcCodDR1
     C                   EVAL      EXAACS = PAcSecDR1
     C                   EVAL      EXAREF = PPosRfDR1
     C                   EVAL      EXIACC = PAcCodCR1
     C                   EVAL      EXIACS = PAcSecCR1
     C                   EVAL      EXIREF = PPosRfCR1
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetPrAcKy - Subroutine that Sets Principal Account Key     *
      *                                                               *
      *****************************************************************
     C     SRSetPrAcKy   BEGSR

     C                   EVAL      PAcKyPos01 = DTYP
     C                   EVAL      PAcKyPos03 = 'D'
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                        BUG10240
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = *BLANKS
     C                   EVAL      PAcKyPos10 = 'A'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXPACC = PAcCodDR1
     C                   EVAL      EXPACS = PAcSecDR1
     C                   EVAL      EXPREF = PPosRfDR1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcKeyD - Subroutine that Retrieves Account Key Details  *
      *                                                               *
      *****************************************************************
     C     SRGetAcKeyD   BEGSR

     C                   CALLB     'MRACSACKY'
     C                   PARM                    PAcKyPos01
     C                   PARM                    PAcKyPos03
     C                   PARM                    PAcKyPos04
     C                   PARM                    PAcKyPos06
     C                   PARM                    PAcKyPos07
     C                   PARM                    PAcKyPos08
     C                   PARM                    PAcKyPos09
     C                   PARM                    PAcKyPos10
     C                   PARM                    PAcKyPos11                                 BUG10240

     C                   PARM      *BLANKS       PAcCodDR1
     C                   PARM      *BLANKS       PAcSecDR1
     C                   PARM      *BLANKS       PPosRfDR1
     C                   PARM      *BLANKS       PAcCodDR2
     C                   PARM      *BLANKS       PAcSecDR2
     C                   PARM      *BLANKS       PPosRfDR2
     C                   PARM      *BLANKS       PAcCodDR3
     C                   PARM      *BLANKS       PAcSecDR3
     C                   PARM      *BLANKS       PPosRfDR3
     C                   PARM      *BLANKS       PAcCodCR1
     C                   PARM      *BLANKS       PAcSecCR1
     C                   PARM      *BLANKS       PPosRfCR1
     C                   PARM      *BLANKS       PAcCodCR2
     C                   PARM      *BLANKS       PAcSecCR2
     C                   PARM      *BLANKS       PPosRfCR2
     C                   PARM      *BLANKS       PAcCodCR3
     C                   PARM      *BLANKS       PAcSecCR3
     C                   PARM      *BLANKS       PPosRfCR3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetTrStat - Subroutine that Sets Transaction Status field  *
      *                                                               *
      *****************************************************************
     C     SRSetTrStat   BEGSR

      ** Set Transaction Status
     C                   IF        RECI = 'M'
     C                   EVAL      EXSTAT = 'M'
     C                   ELSE

     C                   IF        VDAT > WkECDat
     C                   EVAL      EXSTAT = 'N'
     C                   ELSE
     C                   EVAL      EXSTAT = *BLANKS
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVAL      DBPGM = 'MRCFCOEXT'

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

      ** Access General Ledger Details

     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set event control date to whichever is the lesser of the next
      ** working day and accrual profit date
     C                   EVAL      WkECDat = BJDNWD - 1
     C                   IF        BKAPDT < WkECDat
     C                   EVAL      WkECDat = BKAPDT
     C                   ENDIF

      ** Get Details of Base Currency
     C                   EVAL      PCcy = BJCYCD
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCDB = A6CYCD
     C                   EVAL      WkNBDPB = A6NBDP
     C                   EVAL      WkSPRTB = A6SPRT
     C                   EVAL      WkMDINB = A6MDIN

      ** Access Report Parameters
     C                   EXSR      SRGetRepPrm

      ** Get Details of Reporting Currency 1
     C                   EVAL      PCcy = RPCCY1
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD1 = A6CYCD
     C                   EVAL      WkNBDP1 = A6NBDP
     C                   EVAL      WkSPRT1 = A6SPRT
     C                   EVAL      WkMDIN1 = A6MDIN

      ** Get Details of Reporting Currency 2
     C                   EVAL      PCcy = RPCCY2
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD2 = A6CYCD
     C                   EVAL      WkNBDP2 = A6NBDP
     C                   EVAL      WkSPRT2 = A6SPRT
     C                   EVAL      WkMDIN2 = A6MDIN

      * Convert run date to DD/MM/YY

     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear

      * Calendar Year/Month

     C                   Z-ADD     Year          CalendarYear      2 0
     C                   Z-ADD     Month         CalendarMonth     2 0

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
