     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Facilities Extract')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRFCLTEXT - Facilities Extract                         *
      *                                                               *
      *  Function:  This module will read through file FCLTYFM and    *
      *             for each record required, will write a record     *
      *             to MRTRAPPD.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 242999             Date 12Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 CRN001  *CREATE    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  242999 - Missing parameter by CDL038.                        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *            (recompile)                                        *
      *  CRN001 - MidasPlus Regulatory Reporting Interface            *
      *           Enhancement                                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Lending Facilities
     FFCLTYFM   IF   E             DISK    INFSR(*PSSR)
 
      ** Lending Facilities detail B record
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFNF)
 
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
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Facility Type Data Structure
     D                 DS
     D FACT
     D  FactPos1                      2    Overlay( FACT )
     D  FactPos3                      1    Overlay( FACT: *NEXT )
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D WkTAmt          S             15  0
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
     D PRetCode        S              7
     D POption         S              7
     D PCust           S             10
     D PStKey          S              7
     D PCcy            S              3
     D WkECDat         S              5  0
     D WkCalendarYear  S              2  0
     D WkCalendarMnth  S              2  0
     D WkCnum          S              6
     D WkFact          S              3
     D WkFcno          S              2
 
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
 
      ** Parameters for ZDATE2 module
     D ZDAYNO          S              5  0
     D ZDATFM          S              1
     D ZDATE           S              6  0
     D ZADATE          S              7
 
      ** Parameters for MRACSACKY module
     D PAcKyPos01      S              2
     D PAcKyPos03      S              1
     D PAcKyPos04      S              2
     D PAcKyPos06      S              1
     D PAcKyPos07      S              1
     D PAcKyPos08      S              1
     D PAcKyPos09      S              1
     D PAcKyPos10      S              1
     D PAcKyPos11      S              4                                                       242999
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read through LE facilities file
      *
     C     1             SETLL     FCLTYFM
 
     C                   READ      FCLTYFM
 
     C                   DOW       NOT %EOF(FCLTYFM)
 
     C                   IF        (   RECI = 'D'
     C                             OR  RECI = 'M' )
     C                             AND TRCA <> 'CA'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   READ      FCLTYFM
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine that Processes Records to be Written  *
      *              to the Extract File                              *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
     C                   CLEAR                   MRTRAPD0
      *
      ** Set extract date
      *
     C                   EVAL      EXTDAT = BJRDNB
      *
      ** Set event control date
      *
     C                   EVAL      EXVCD = WkECDat
      *
      ** Set module
      *
     C                   EVAL      EXMOD = 'LE'
      *
      ** Set sub-module
      *
     C                   EVAL      EXSUB = 'FCLT'
      *
      ** Set transaction id
      *
     C                   MOVE      CNUM          WkCnum
     C                   MOVE      FACT          WkFact
     C                   MOVE      FCNO          WkFcno
     C                   EVAL      EXTRID = WkCnum + WkFact + WkFcno
      *
      ** Set sequence number
      *
     C                   EVAL      EXSEQ = 0
      *
      ** Set transaction status
      *
     C                   EXSR      SRSetTrStat
      *
      ** Set branch details
      *
     C                   EXSR      SRSetBrcDet
      *
      ** Set customer details
      *
     C                   EXSR      SRSetCusDet
      *
      ** Set currency details
      *
     C                   EVAL      I#LFD1 = FCCY
     C                   EXSR      SRSetCurDet
      *
      ** Retrieve Account Key details
     C                   EVAL      PackyPos01  = FactPos1
     C                   EVAL      PackyPos03  = FactPos3
     C                   EVAL      PackyPos04  = FCTI
     C                   EVAL      PackyPos10  = 'A'
     C                   EVAL      PackyPos11  = DFCL                                         242999
     C                   EXSR      SRGetAcKeyD
     C                   EVAL      EXPACC = PAcCodCR1
     C                   EVAL      EXPACS = PAcSecCR1
     C                   EVAL      EXPREF = PPosRfCR1
      *
      ** Set principal amounts
      *
     C                   EXSR      SRSetPrnAmt
      *
      ** Set deal date, value date and maturity date
      *
     C                   EVAL      EXDDAT = DTAP
     C                   EVAL      EXVDAT = COMD
     C                   EVAL      EXMDAT = DTEX
      *
      ** Set other fields
     C                   MOVEL     FACT          EXTRTY
     C                   EVAL      EXCLAS = DFCL                                              242999
 
      * Facility may be overdrawn.
     C                   IF        FAMT        < CAMD
     C                   EVAL      EXPDCI      = 0
     C                   EVAL      EXPSGN      = 1
     C                   EVAL      EXPALI      = 'A'
     C                   ELSE
     C                   EVAL      EXPDCI      = 1
     C                   EVAL      EXPSGN      = -1
     C                   EVAL      EXPALI      = 'L'
     C                   ENDIF
 
     C                   EVAL      EXCAFI      = 'C'
     C                   EVAL      EXPERT      = 'M'
     C                   EVAL      EXCY        = Year
     C                   EVAL      EXCM        = Month
      *
      ** Set credit agreement facility details
      *
     C                   IF        TRCA = 'TR'
     C                   MOVE      CANM          EXFCUS
     C                   MOVE      CAFT          EXFTYP
     C                   MOVE      CAFN          EXFCNO
     C                   ENDIF
      *
      ** Write record to output file
      *
     C                   WRITE     MRTRAPD0
 
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
      *
      ** Get principal amount in base currency
      *
     C                   EVAL      ZAMTCI = WkTAmt
     C                   EVAL      ZEXCH = A6SPRT
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = EXCYCD
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetAmount
     C                   EVAL      WkAmtInB = ZAMTCO
      *
      ** Get principal amount in reporting currency 1
      *
     C                   EVAL      ZEXCH = EXERP1
     C                   EVAL      ZMD = EXMDI1
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetAmount
     C                   EVAL      WkAmtIn1 = ZAMTCO
      *
      ** Get principal amount in reporting currency 2
      *
     C                   EVAL      ZEXCH = EXERP2
     C                   EVAL      ZMD = EXMDI2
     C                   EVAL      ZCCYO = WkCYCD2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetAmount
     C                   EVAL      WkAmtIn2 = ZAMTCO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetPrnAmt - Set Principal Amounts                          *
      *                                                               *
      *****************************************************************
     C     SRSetPrnAmt   BEGSR
      *
      ** Access corresponding FCLTYFN record
     C     KyFCLTY       Chain     FCLTY
 
     C                   IF        NOT %FOUND
     C                   EVAL      CAMD   = 0
     C                   ENDIF
      *
     C                   EVAL      WkTAmt = FAMT - CAMD
      *
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = %abs(WkTAmt/(10**A6NBDP)   )
     C                   EVAL(H)   EXPMTB = %abs(WkAmtInB/(10**WkNBDPB))
     C                   EVAL(H)   EXPMT1 = %abs(WkAmtIn1/(10**WkNBDP1))
     C                   EVAL(H)   EXPMT2 = %abs(WkAmtIn2/(10**WkNBDP2))
      *
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
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      *ZEROS        ZAMTCO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCurDet - Set Currency Details                           *
      *                                                               *
      *****************************************************************
     C     SRSetCurDet   BEGSR
      *
 
     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Currency: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
     C                   EVAL      EXCYCD = A6CYCD
     C                   EVAL      EXEBRT = A6SPRT
     C                   EVAL      EXMDIB = A6MDIN
      *
      ** Retrieve cross rate between transaction currency and reporting
      ** currency 1
      *
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE2 = WkSPRT1
     C                   EVAL      ZMDI2 = WkMDIN1
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP1 = ZRATEX
     C                   EVAL      EXMDI1 = ZMDIX
      *
      ** Retrieve cross rate between transaction currency and reporting
      ** currency 2
      *
     C                   EVAL      ZRATE2  = WkSPRT2
     C                   EVAL      ZMDI2 = WkMDIN2
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP2 = ZRATEX
     C                   EVAL      EXMDI2 = ZMDIX
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD  - Set Currency Details                           *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR
      *
     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME
      *
     C                   IF        ACS_RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      SDCURR = InData
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetXRate - Retrieve Cross Currency Rate                    *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCusDet - Set Customer Details                           *
      *                                                               *
      *****************************************************************
     C     SRSetCusDet   BEGSR
      *
     C                   MOVEL     CNUM          I#LFD1
 
     C                   CALLB     'MXACSCUST'
     C/COPY MXCPYSRC,MXACSPRMI
 
     C                   IF        I#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CUSTOMER: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      SDCUST = InData
      *
     C                   MOVE      CNUM          EXCUSN
     C                   EVAL      EXCCIT = BBCNCZ
     C                   EVAL      EXCLOC = BBCOLC
     C                   EVAL      EXCIND = BBLICD
     C                   EVAL      EXCINT = BBLINC
     C                   EVAL      EXCBNK = BBBNBI
     C                   EVAL      EXCSWF = BBSWFI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetBrcDet - Set Branch Details                             *
      *                                                               *
      *****************************************************************
     C     SRSetBrcDet   BEGSR
      *
     C                   EVAL      I#LFD1 = BRCA
      *
     C                   CALLB     'MXACSBRCH'
      /COPY MXCPYSRC,MXACSPRME
      *
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'ERROR IN FORMAT MXACSBRCH'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      SDBRCH = InData
      *
     C                   EVAL      EXBRCH = BRCA
     C                   EVAL      EXBICN = A8BICN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetRepPrm - Subroutine that Accesses Report Parameters     *
      *                                                               *
      *****************************************************************
     C     SRGetRepPrm   BEGSR
      *
     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD
      *
     C                   IF        %EOF(MRRPRMPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'MRRPRMPD'
     C                   EVAL      DBKEY = '*READ '
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetTrStat - Set Transaction Status                         *
      *                                                               *
      *****************************************************************
     C     SRSetTrStat   BEGSR
      *
     C                   IF        RECI = 'M'
     C                   EVAL      EXSTAT = 'M'
     C                   ELSE
     C                   EVAL      EXSTAT = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number to dd/mm/yy                *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      'D'           ZDATFM
     C                   PARM      *zero         ZDATE
     C                   PARM      *blank        ZADATE
      *
     C                   ENDSR
     C*****************************************************************
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
     C                   PARM                    PAcKyPos11                                   242999
 
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
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key fields for FCLTYL5
     C     KyFCLTY       KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
 
      ** Initialise LDA field.
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'MRFCLTEXT'
     C                   OUT       LDA
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set event control date to whichever is the lesser of the next
      ** working day and accrual profit date
      *
     C                   EVAL      WkECDat = BJDNWD - 1
     C                   IF        BKAPDT < WkECDat
     C                   EVAL      WkECDat = BKAPDT
     C                   ENDIF
      *
      ** Get details of base currency
      *
     C                   EVAL      I#LFD1 = BJCYCD
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCDB = A6CYCD
     C                   EVAL      WkNBDPB = A6NBDP
     C                   EVAL      WkSPRTB = A6SPRT
     C                   EVAL      WkMDINB = A6MDIN
      *
      ** Access report parameters
      *
     C                   EXSR      SRGetRepPrm
      *
      ** Get details of reporting currency 1
      *
     C                   EVAL      I#LFD1 = RPCCY1
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD1 = A6CYCD
     C                   EVAL      WkNBDP1 = A6NBDP
     C                   EVAL      WkSPRT1 = A6SPRT
     C                   EVAL      WkMDIN1 = A6MDIN
      *
      ** Get details of reporting currency 2
      *
     C                   EVAL      I#LFD1 = RPCCY2
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD2 = A6CYCD
     C                   EVAL      WkNBDP2 = A6NBDP
     C                   EVAL      WkSPRT2 = A6SPRT
     C                   EVAL      WkMDIN2 = A6MDIN
      *
      ** Convert run day number to dd/mm/yy
      *
     C                   EVAL      ZDAYNO = BJRDNB
     C                   EXSR      ZDATE2
     C                   EVAL      DayMonthYear = ZDATE
      *
      ** Calendar Year/Month
      *
     C                   EVAL      WkCalendarYear = Year
     C                   EVAL      WkCalendarMnth = Month
      *
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
      *
     C                   DUMP
      *
     C                   IF        @RUN = *Blank
     C                   EVAL      @RUN = 'Y'
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
