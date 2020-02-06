     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Fmt amt 18,3 depending on ccy dec place')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  ZACVTAMT - Convert amounts to 18,3 numeric value             *
      *                                                               *
      *  Function:  This module accepts zero decimal amount and       *
      *             converts it to 18,3 decimal value, depending on   *
      *             currency decimal place.                           *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
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
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     ** input parameters
     D ReturnCode      S             10A
     DCurrency         S              3A
     DNativeAmount     S             15A
     DConvertedAmt     S             16A
     DWAmntNum         S             18  3
 
      ** Working variables
     DOption           S              7A
     DNbDecPos         S              1  0
     DAlphaAmt         S             15
     DNumericDec0      S             15  0
     DNumericDec1      S             15  1
     DNumericDec2      S             15  2
     DNumericDec3      S             15  3
 
      **  Get currency number of decimal position
     DGetDecPos        PR             1  0
     D  Currency                      3    VALUE
 
      ** Format the amount depending the number of decimal positions
     DFmtAmt           PR            16
     D  DecPos                        1  0 VALUE
     D  Amount                       15    VALUE
 
      ** Adjust characters to the right
     DRightAdjust      PR            15
     D  NumberAlph                   15    VALUE
 
      *****************************************************************
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
 
      ** Amount
     C                   IF        NativeAmount <> *blanks
     C                   EVAL      AlphaAmt = NativeAmount
     C                   EVAL      AlphaAmt = RightAdjust(AlphaAmt)
 
      ** If currency is blanks, amount is nominal, default number of
      ** decimal position to zero.
 
     C                   IF        Currency <> *BLANKS
     C                   EVAL      NbDecPos = getDecPos(Currency)
     C                   ELSE
     C                   EVAL      NBDecPos = 0
     C                   ENDIF
 
     C                   IF        NbDecPos <> -1
     C                   EVAL      ConvertedAmt   = FmtAmt(NbDecPos:AlphaAmt)
 
     C                   SELECT
     C                   WHEN      NbDecPos = 0
     C                   MOVEL     AlphaAmt      NumericDec0
     C                   EVAL      WAmntNum = NumericDec0
     C                   WHEN      NbDecPos = 1
     C                   MOVEL     AlphaAmt      NumericDec1
     C                   EVAL      WAmntNum = NumericDec1
     C                   WHEN      NbDecPos = 2
     C                   MOVEL     AlphaAmt      NumericDec2
     C                   EVAL      WAmntNum = NumericDec2
     C                   WHEN      NbDecPos = 3
     C                   MOVEL     AlphaAmt      NumericDec3
     C                   EVAL      WAmntNum = NumericDec3
     C                   ENDSL
 
     C                   ELSE
 
     C                   EVAL      ConvertedAmt   = '*ERROR'
     C                   EVAL      ReturnCode = ConvertedAmt
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     *ON           *INLR
 
     C                   RETURN
 
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Currency
     C                   PARM                    NativeAmount
     C                   PARM                    WAmntNum
     C                   PARM                    ConvertedAmt
 
     C                   ENDSR
      **********************************************************************
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
      **********************************************************************
      /EJECT
      **********************************************************************
      * Get currency number of decimal position
      **********************************************************************
     PGetDecPos        B
     DGetDecPos        PI             1  0
     D  Currency                      3    VALUE
      *
     DPmRetn           S              7
     DPmOption         S              7
     DPmCcy            S                   LIKE(Currency)
     DNbDecPos         S                   LIKE(A6NBDP)
     DPmFmt          E DS                  EXTNAME(DSSDY)
     DSDCURR         E DS                  EXTNAME(SDCURRPD)
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PmRetn
     C                   PARM      '*KEY'        PmOption
     C                   PARM      Currency      PmCcy
     C     SDCURR        PARM                    PmFmt
      *
     C                   IF        PmRetn = *BLANK
     C                   EVAL      NbDecPos = A6NBDP
     C                   ELSE
     C                   EVAL      NbDecPos = -1
     C                   ENDIF
     C                   RETURN    NbDecPos
      *
     P                 E
      **********************************************************************
      * Format the amount depending the number of decimal positions
      **********************************************************************
     PFmtAmt           B
     DFmtAmt           PI            16
     D  DecPos                        1  0 VALUE
     D  Amount                       15    VALUE
      *
     DDIGITS           C                         CONST(' 0123456789')
     DZfield           S             16
     DOutAmt           S                         LIKE(Zfield)
     DZaDec            S              1  0
     DStart            S              3  0
     DAmtErr           S              3  0
      *
      ** Amount must be numeric
     C     DIGITS        CHECK     Amount        AmtErr
     C                   IF        AmtErr = 0
     C                   MOVE      Amount        Zfield
     C                   CALLB     'ZEDIT'
     C                   PARM                    Zfield
     C                   PARM      DecPos        ZaDec
      *
     C                   IF        Zfield = *BLANK
     C                   EVAL      OutAmt = '*ERROR'
     C                   ELSE
      ** Left adjust the result
     C                   EVAL      OutAmt = Zfield
     C     ' '           CHECK     OutAmt        Start
     C                   EVAL      OutAmt = %SUBST(OutAmt:Start)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OutAmt = '*ERROR'
     C                   ENDIF
     C                   RETURN    OutAmt
      *
     P                 E
      **********************************************************************
      * Adjust characters to the right
      **********************************************************************
     PRightAdjust      B
     DRightAdjust      PI            15
     D  NumberAlph                   15    VALUE
      *
     DWrkArr           S              1    DIM(15)
     DRightValue       S             15
     Di                S              2  0
     Dj                S              2  0
     Dlen              S              2  0
      *
     C     ' '           CHECKR    NumberAlph    Len
      ** No need to right adjust if the lengh is maximum
     C                   IF        Len = %ELEM(WrkArr)
     C                   EVAL      RightValue = NumberAlph
     C                   ELSE
     C                   MOVEA     NumberAlph    WrkArr
     C                   EVAL      j = %ELEM(WrkArr)
     C                   EVAL      i = Len
 
     C                   DOW       i >= 1
     C                   EVAL      WrkArr(j) = WrkArr(i)
     C                   EVAL      WrkArr(i) = *BLANK
     C                   EVAL      i = i - 1
     C                   EVAL      j = j - 1
     C                   ENDDO
 
     C                   MOVEA     WrkArr        RightValue
     C                   ENDIF
      *
     C                   RETURN    RightValue
     P                 E
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2002
