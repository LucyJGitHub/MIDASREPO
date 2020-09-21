     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calc Accr Int - Non-Shldschn Using N-T-R')    *
      *****************************************************************
      *                                                               *
      *  Midas - Common Programs                                      *
      *                                                               *
      *  ZAINSNTR - Midas ZA Calculate Accrued Interest - Non-        *
      *             Schulschein Using Net-Treasury-Rate.              *
      *                                                               *
      *  Function:  This module calculates the Accrued Interest for   *
      *             Non-Shuldschein Securities by using the Net-      *
      *             Treasury-Rate.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006   *CREATE   Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSECET     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Security Events by Type
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** Security Details Data Structure
     D SECTYD        E DS                  EXTNAME(SECTYD)
     D  PAD          E                     EXTFLD(ZZ005)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PZPAmt          S             15P 0
     D PZFrDate        S              5P 0
     D PZToDate        S              5P 0
     D PZProcTyp       S              1A
     D PZNBDP          S              1S 0
     D PDateFmt        S              1A
     D PZAIt           S             15P 0
     D PZNDt           S              5P 0
 
      ** ZRATE Parameters
     D PZCPNR          S             11P 7
     D PZPPDI          S              1A
     D PZPPCP          S             15P 0
     D PZSFPP          S             15P 0
     D PZPROT          S              1A
     D PZCFCT          S             10P 9
     D PZIntRt         S             15P 9
 
      ** ZACCR Parameters
     D PZAmt           S             15P 0
     D PZSDate         S              5P 0
     D PZEDate         S              5P 0
     D PDADJn          S              1A
     D PZCDP           S              1P 0
     D PZAccr          S             15P 0
     D PZAccx          S             15P 1
     D PZRP            S              1A
     D PZDDays         S              5P 0
     D PZIntDD         S              5P 0
 
      ** Key Fields
     D KSESN           S             10A
     D KType           S              2A
     D KFrDate         S              5P 0
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Clear all output parameters.
 
     C                   EVAL      PZAIt = *ZERO
     C                   EVAL      PZNDt = *ZERO
 
      ** Set the ZRATE input parameters.
 
     C                   EVAL      PZCPNR = CPNN
     C                   EVAL      PZPPDI = PPDI
     C                   EVAL      PZPPCP = CPDP
     C                   EVAL      PZSFPP = SFPP
     C                   EVAL      PZPROT = PZProcTyp
     C                   EVAL      PZCFCT = CFCT
 
      ** Set the ZACCR input parameters.
 
     C                   EVAL      PZAmt = PZPAmt
     C                   EVAL      PZCDP = PZNBDP
 
     C                   EVAL      KSESN = SESN
     C                   EVAL      KFrDate = PZFrDate
 
      ** Retrieve the Interest Rate at the start of the period by
      ** reading the Diary Event prior to From Date.
 
     C                   EVAL      KType = 'IR'
     C     KSECET        SETGT     SECET
     C                   READP     SECET
 
     C                   IF        NOT %EOF(SECET) AND
     C                             SDSN = KSESN    AND
     C                             SDET = KType    AND
     C                             SDED <= KFrDate
     C                   EVAL      PZCPNR = SDNN
     C                   ENDIF
 
      ** Retrieve the Partly Paid Percentage at the start of the
      ** period for Part Payments.
 
     C                   IF        PPDI = 'Y'
 
     C                   EVAL      KType = 'PP'
     C     KSECET        SETGT     SECET
     C                   READP     SECET
 
     C                   IF        NOT %EOF(SECET) AND
     C                             SDSN = KSESN    AND
     C                             SDET = KType    AND
     C                             SDED <= KFrDate
     C                   EVAL      PZPPCP = SDTP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Retrieve the Current Factor at the start of the period for
      ** Mortgage-Backed Securities.
 
     C                   IF        PZProcTyp = '8'
 
     C                   EVAL      KType = 'MP'
     C     KSECET        SETGT     SECET
     C                   READP     SECET
 
     C                   IF        NOT %EOF(SECET) AND
     C                             SDSN = KSESN    AND
     C                             SDET = KType    AND
     C                             SDED <= KFrDate
     C                   EVAL      PZCFCT = SDCP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set the Start of Interest Period Date equal to the From Date.
      ** Read through the events up to the Coupon Date.
 
     C                   EVAL      PZSDate = PZFrDate
     C                   EVAL      KType = *BLANKS
 
     C     KSECET        SETGT     SECET
     C     KSESN         READE     SECET
 
     C                   DOW       NOT %EOF(SECET) AND
     C                             SDED < PZToDate
 
     C                   IF        SDED >= PZFrDate
 
     C                   IF        SDET = 'PP' OR
     C                             SDET = 'MP' OR
     C                             SDET = 'IR'
 
      ** Set the End of Interest Period Date equal to the Event Date.
 
     C                   EVAL      PZEDate = SDED
 
      ** Calculate the Effective Interest Rate for the period.
 
     C                   EXSR      SRZRate
 
      ** Calculate the Accrued Interest for the period.
 
     C                   EXSR      SRZAccr
 
      ** Add the calculated Accr. Interest to the Total Accr. Interest.
 
     C                   EVAL      PZAIt = PZAIt + PZAccr
 
      ** Add the calculated No. of Days to the Total No. of Days.
 
     C                   EVAL      PZNDt = PZNDt + PZDDays
 
      ** Set the Start of Interest Period Date equal to the Event Date.
 
     C                   EVAL      PZSDate = SDED
 
      ** Set some ZRATE input parameters depending upon the Security
      ** Diary Event Type.
 
     C                   SELECT
 
     C                   WHEN      SDET = 'IR'
     C                   EVAL      PZCPNR = SDNN
 
     C                   WHEN      SDET = 'MP'
     C                   EVAL      PZCFCT = SDCP
 
     C                   WHEN      SDET = 'PP'
     C                   EVAL      PZPPCP = SDTP
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read the next record with the same Security Shortname.
 
     C     KSESN         READE     SECET
 
     C                   ENDDO
 
      ** Set the End of Interest Period Date equal to the To Date.
 
     C                   EVAL      PZEDate = PZToDate
 
      ** Calculate the Effective Interest Rate for the period.
 
     C                   EXSR      SRZRate
 
      ** Calculate the Accrued Interest for the period.
 
     C                   EXSR      SRZAccr
 
      ** Add the calculated Accr. Interest to the Total Accr. Interest.
 
     C                   EVAL      PZAIt = PZAIt + PZAccr
 
      ** Add the calculated No. of Days to the Total No. of Days.
 
     C                   EVAL      PZNDt = PZNDt + PZDDays
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAccr - Calculates the Accrued Interest between two dates  *
      *            via ZACCR.                                         *
      *                                                               *
      *****************************************************************
     C     SRZAccr       BEGSR
 
     C                   CALLB     'ZACCR'
     C                   PARM                    PZAmt
     C                   PARM                    PZIntRt
     C                   PARM                    PZSDate
     C                   PARM                    PZEDate
     C                   PARM                    SECTYD
     C                   PARM                    PDADJn
     C                   PARM                    NCD
     C                   PARM                    PZCDP
     C                   PARM                    PZProcTyp
     C                   PARM                    PDateFmt
     C                   PARM                    PZAccr
     C                   PARM                    PZAccx
     C                   PARM                    PZRP
     C                   PARM                    PZDDays
     C                   PARM                    PZIntDD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZRate - Calculates the Effective Interest Rate via ZRATE.  *
      *                                                               *
      *****************************************************************
     C     SRZRate       BEGSR
 
     C                   CALLB     'ZRATE'
     C                   PARM                    PZCPNR
     C                   PARM                    PZPPDI
     C                   PARM                    PZPPCP
     C                   PARM                    PZSFPP
     C                   PARM                    PZPROT
     C                   PARM                    PZCFCT
     C                   PARM                    PZIntRt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ----------------
 
      ** Principal Amount
      ** From Date
      ** To Date
      ** Processing Type
      ** Nominal Currency Decimal Places
      ** Date Format
      ** Security Details
 
     C                   PARM                    PZPAmt
     C                   PARM                    PZFrDate
     C                   PARM                    PZToDate
     C                   PARM                    PZProcTyp
     C                   PARM                    PZNBDP
     C                   PARM                    PDateFmt
     C                   PARM                    SECTYD
 
      ** Output Parameters
      ** -----------------
 
      ** Total Accrued Interest
      ** Total Number of Interest Days
 
     C                   PARM                    PZAIt
     C                   PARM                    PZNDt
 
      ** End Parameter List
      ** ==================
 
      ** Midas SE Security Events By Type Key List
 
     C     KSECET        KLIST
     C                   KFLD                    KSESN
     C                   KFLD                    KType
     C                   KFLD                    KFrDate
 
      ** If the Principal Amount is zero, then there's no point in
      ** further processing.
 
     C                   IF        PZPAmt = *ZERO
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
