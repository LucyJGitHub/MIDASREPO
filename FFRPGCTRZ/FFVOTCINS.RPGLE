     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate OTC instrument details')             *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVOTCINS - Validate O. T. C. Instrument Details             *
      *                                                               *
      *  Function:  This module checks the validity of the following  *
      *             fields on an FF trade :                           *
      *             SAEIN - American/European option indicator        *
      *             SCTAM - Contingent (delivery) amount              *
      *             SDCCY - Delivery currency                         *
      *             SCCAM - Other (counter) amount                    *
      *             SCTCY - Counter currency                          *
      *             SISCY - Premium currency                          *
      *             SPUPF - Premium Up Front                          *
      *             SQOTC - Quotation convention                      *
      *             SFTDT - Expiry date                               *
      *             SFTTM - Expiry time                               *
      *             SSETD - Settlement Date                           *
      *             STKVL - Tick Value                                *
      *             SMNPF - Minimum price fluctuation                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245129B            Date 12Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245129             Date 22Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8236            Date 06Sep05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245129B- Wrong premium calculated.                           *
      *  245129 - Apply fixes 231089 and 231795                       *
      *           Tick value is zero if Quotation is -2 or -3.        *
      *           Increase ZEXR decimal place from 9 to 11 to avoid   *
      *           truncation problems.                                *
      *           Minimum Price Fluctuation set to 8 Decimals         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8236 - Duplicate error in validation of fields for NAs    *
      *            and Contingent Delivery amount and Expiry time     *
      *            error message validation in Options
      *  CAP166 - API for Non-Currency OTC                            *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FFOTCC        E DS                  EXTNAME(FFOTCCPD)
      ** OTC currency transaction structure
 
     D FFEOTCC       E DS                  EXTNAME(FFEOTCCPD)
      ** Midas FF OTC currency options OK flags
 
      ** OTC non-currency transaction structure                                               CAP166
     D FFOTCO        E DS                  EXTNAME(FFOTCOPD)                                  CAP166
                                                                                              CAP166
      ** Midas FF OTC non-currency options OK flags                                           CAP166
     D FFEOTCO       E DS                  EXTNAME(FFEOTCOPD)                                 CAP166
     D                                     PREFIX(A)                                          CAP166
                                                                                              CAP166
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details
 
     D I_INTYP       E DS                  EXTNAME(INTYPD) PREFIX(IT)
      ** Midas FF Instrument types (detail) - INPUT
 
     D O_INTYP       E DS                  EXTNAME(INTYPD) PREFIX(AB)
      ** Midas FF Instrument types (detail) - OUTPUT
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
 
     D FINDET          DS
      ** File fields - O.T.C Instrument details.  This data structure
      ** holds copies of fields from the INTYPD file.  The latter are
      ** passed into this module as the INTYPD data structure, with a
      ** prefix of 'IT', and are copied to the field names below in
      ** SR/InzTran.  Note: if this data structure changes, the WINDET one
      ** will also have to be changed.
 
      ** American/European option indicator
     D  AEIN                   1      1
 
      ** Contingent (delivery) amount
     D  FFCTAM                 2     14  0
 
      ** Other currency
     D  OTHC                  15     17
 
      ** Other (counter) amount
     D  CCAM                  18     30  0
 
      ** Counter Currency
     D  CTCY                  31     33
 
      ** Instrument currency
     D  ISCY                  34     36
 
      ** Premium currency up front indicator
     D  PUPF                  37     37
 
      ** Quotation convention
     D  QOTC                  38     38  0
 
      ** Expiry Date
     D  FTDT                  39     43  0
 
      ** Expiry Time
     D  FTTM                  44     49
 
      ** Settlement date for future and options
     D  SETD                  50     54  0
 
      ** Tick Value
     D  TKVL                  55     68  5
 
      ** Minimum price fluctuation
     D  MNPF                  69     83  8
 
 
     D WINDET          DS
      ** Work fields - O.T.C Instrument details
      ** File fields - O.T.C Instrument details.  This data structure
      ** holds work fields matching some from the INTYPD file.
      ** Note: if this data structure changes, the FINDET one
      ** will also have to be changed.
 
      ** American/European option indicator
     D  WAEIN                  1      1
 
      ** Contingent (delivery) amount
     D  WCTAM                  2     14  0
 
      ** Other currency
     D  WOTHC                 15     17
 
      ** Other (counter) amount
     D  WCCAM                 18     30  0
 
      ** Counter Currency
     D  WCTCY                 31     33
 
      ** Instrument currency
     D  WISCY                 34     36
 
      ** Premium currency up front indicator
     D  WPUPF                 37     37
 
      ** Quotation convention
     D  WQOTC                 38     38  0
 
      ** Expiry Date
     D  WFTDT                 39     43  0
 
      ** Expiry Time
     D  WFTTM                 44     49
 
      ** Settlement date for future and options
     D  WSETD                 50     54  0
 
      ** Tick Value
     D  WTKVL                 55     68  5
 
      ** Minimum price fluctuation
     D  WMNPF                 69     83  8
 
 
      ** Array for powers for currency conversion
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Hours & minutes part of expiry time
     D SFTTMP          S              4A
 
      ** AM/PM part of expiry time
     D SFTTML          S              2A
 
      ** Expiry Time                                                                         BUG8236
     D WExpTime        S              8A                                                     BUG8236
                                                                                             BUG8236
      ** ZALIGN error code returned
     D ZALIGNok        S              1A
 
      **Standard data containing field for ZALIGN
     D ZFIELD          S             16A
 
      ** Date field passed to module ZDATE1
     D ZDATE           S              6A
 
      ** Midas day number for appropriate date passed back from ZDATE1
     D ZDAYNO          S              5P 0
 
      ** Error flag passed back from ZDATE1
     D ErrorFlag       S              1A
 
      ** Date format code passed to ZDATE1 as a parameter
     D  BJDFIN         S              1A
     D  PJDFIN         S                   LIKE(BJDFIN)
 
      ** Number of decimal places for currency
     D CDP             S              1S 0
     D DelCyDec        S                   LIKE(CDP)
     D CntCyDec        S                   LIKE(CDP)
     D PrmCyDec        S                   LIKE(CDP)
 
      ** Enchanced O. T. C. instrument details switchable field
     D CFF001          S              1A
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      ** Do transaction-specific initialisation
     C                   EXSR      InzTran
 
      **------------------------------------------------------------------
      **   - Record ID
     C                   MOVE      'D'           ABRECI
 
      **------------------------------------------------------------------
      **   - Instrument Type
     C                   MOVE      SISTT         ABISTT
 
      **------------------------------------------------------------------
      **   - Instrument Ind
     C                   MOVE      'Y'           ABISTI
 
      **------------------------------------------------------------------
      **   - Instrument Processing Type
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
     C                   Z-ADD     5             ABISPT
     C                   ELSE                                                                 CAP166
     C                   MOVE      SISPT         ABISPT                                       CAP166
     C                   ENDIF                                                                CAP166
 
      **------------------------------------------------------------------
      **   - Style
     C     SAEIN         IFNE      'E'
     C     SAEIN         ANDNE     'A'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SAEIN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0388'
     C                   EVAL      OKAEIN = 'N'
 
     C                   ELSE
     C                   MOVE      SAEIN         WAEIN
     C                   MOVE      SAEIN         ABAEIN
     C                   END
      **------------------------------------------------------------------
      **
      **   - Delivery Currency must be defined
     C     SDCCY         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SDCCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0389'
     C                   EVAL      OKDCCY = 'N'
 
      **   - Delivery Currency must be a valid currency
     C                   ELSE
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SDCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SDCCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0390'
     C                   EVAL      OKDCCY = 'N'
 
     C                   ELSE
 
      ** Return delivery currency as other curency
     C                   EVAL      SDCCY  = A6CYCD                                            CAP166
     C                   EVAL      ABOTHC = SDCCY
 
     C                   Z-ADD     A6NBDP        DelCyDec
     C                   END
     C                   END
      **------------------------------------------------------------------
      **
      **   - Counter Currency must be defined
      **     and not equal to delivery currency
                                                                                              CAP166
      ** Skip this validation for non-currency OTCs                                           CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
                                                                                              CAP166
     C     SCTCY         IFEQ      *BLANK
     C     SCTCY         OREQ      SDCCY
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0391'
     C                   EVAL      OKCTCY = 'N'
 
      **   - Counter Currency must be a valid currency
     C                   ELSE
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SCTCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0392'
     C                   EVAL      OKCTCY = 'N'
 
     C                   ELSE
 
      ** Return file version of field
     C                   EVAL      SCTCY  = A6CYCD                                            CAP166
     C                   EVAL      ABCTCY = SCTCY
 
     C                   Z-ADD     A6NBDP        CntCyDec
     C                   END
     C                   END
     C                   ENDIF                                                                CAP166
      **------------------------------------------------------------------
      **
      **   - For OTCs, Delivery Currency is Other Currency
      **   - (If an FX option,) update Counter Currency
      **
     C                   MOVE      SDCCY         WOTHC
     C                   IF        TransType = 'OTCC'                                         CAP166
     C                   MOVE      SCTCY         WCTCY
     C                   ENDIF                                                                CAP166
      **------------------------------------------------------------------
      **
      **   - Delivery Amount (Contingent amount) must be defined
     C     SCTAM         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTAM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0393'
     C                   EVAL      OKCTAM = 'N'
 
     C**********         ELSE                                                                BUG8236
     C                   ENDIF                                                               BUG8236
                                                                                             BUG8236
      **   - Delivery Amount must be a valid amount in delivery currency                     BUG8236
     C     OKDCCY        IFEQ      'Y'                                                       BUG8236
                                                                                             BUG8236
      **   - Delivery Amount (Contingent amount) is not blanks                               BUG8236
     C     SCTAM         IFNE      *BLANK                                                    BUG8236
      **
      **   - Delivery Amount must be a valid amount in delivery currency
     C*****OKDCCY        IFEQ      'Y'                                                       BUG8236
     C                   Z-ADD     DelCyDec      ZADEC             1 0
     C     13            SUB       DelCyDec      ZADIG             2 0
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      SCTAM         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      **
      **   - Invalid Delivery Amount
     C     ZALIGNok      IFEQ      'N'
     C     ZFIELD        OREQ      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTAM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0394'
     C                   EVAL      OKCTAM = 'N'
 
     C                   ELSE
 
      ** Return the validated field in numeric format
     C                   MOVE      ZFIELD        WCTAM
                                                                                             BUG8236
      ** Error if delivery amount is zero.                                                   BUG8236
                                                                                             BUG8236
     C                   IF        WCTAM = 0                                                 BUG8236
     C                   EVAL      ErrorFound = 'Y'                                          BUG8236
     C                   EVAL      XIdx = XIdx + 1                                           BUG8236
     C                   EVAL      FldNamXArr(XIdx) = 'SCTAM'                                BUG8236
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1227'                               BUG8236
     C                   EVAL      OKCTAM = 'N'                                              BUG8236
                                                                                             BUG8236
     C                   ELSE                                                                BUG8236
                                                                                             BUG8236
     C                   MOVE      ZFIELD        ABCTAM
 
      **   - Edit Delivery Amount For Re-Display
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCTAM
     C                   ENDIF                                                               BUG8236
     C                   END
     C                   END
     C                   END
                                                                                              CAP166
      ** Error if delivery amount is zero.                                                    CAP166
                                                                                              CAP166
     C**********         IF        WCTAM = 0 and OKCTAM = 'Y'                         CAP166 BUG8236
     C**********         EVAL      ErrorFound = 'Y'                                   CAP166 BUG8236
     C**********         EVAL      XIdx = XIdx + 1                                    CAP166 BUG8236
     C**********         EVAL      FldNamXArr(XIdx) = 'SCTAM'                         CAP166 BUG8236
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA1227'                        CAP166 BUG8236
     C**********         EVAL      OKCTAM = 'N'                                       CAP166 BUG8236
     C**********         ENDIF                                                        CAP166 BUG8236
                                                                                              CAP166
      **------------------------------------------------------------------
      **
      **   - Counter Amount must be defined
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
                                                                                              CAP166
     C     SCCAM         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCAM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0395'
     C                   EVAL      OKCCAM = 'N'
 
     C                   ELSE
      **
      **   - Counter Amount must be a valid amount in counter currency
     C     OKCTCY        IFEQ      'Y'
     C                   Z-ADD     CntCyDec      ZADEC             1 0
     C     13            SUB       CntCyDec      ZADIG             2 0
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      SCCAM         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      **
      **   - Invalid Counter Amount
     C     ZALIGNok      IFEQ      'N'
     C     ZFIELD        OREQ      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCAM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0396'
     C                   EVAL      OKCCAM = 'N'
 
     C                   ELSE
 
      ** Return numeric version of counter amount
     C                   MOVE      ZFIELD        WCCAM
     C                   MOVE      ZFIELD        ABCCAM
 
      **   - Edit Counter Amount For Re-Display
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCCAM
     C                   END
     C                   END
     C                   END
     C                   ENDIF                                                                CAP166
      *
      **------------------------------------------------------------------
      **
      **   - Premium (Instrument) Currency must be defined
     C     SISCY         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0397'
     C                   EVAL      OKISCY = 'N'
 
      **   - Premium (Instrument) Currency must be a valid currency
     C                   ELSE
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SISCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0398'
     C                   EVAL      OKISCY = 'N'
 
 
     C                   ELSE
 
     C                   EVAL      SISCY  = A6CYCD                                            CAP166
     C                   Z-ADD     A6NBDP        PrmCyDec
     C                   MOVE      SISCY         WISCY
 
      ** Return file version of field
     C                   EVAL      ABISCY = SISCY
 
     C                   END
     C                   END
      **
      ** - If Enhanced OTC not present, premium currency must be
      **   either the delivery currency or the counter currency
     C     OKISCY        IFEQ      'Y'
     C     CFF001        ANDNE     'Y'
     C     SISCY         IFNE      SDCCY
     C     SISCY         ANDNE     SCTCY
     C     TransType     ANDEQ     'OTCC'                                                     CAP166
     C     TransType     OREQ      'OTCO'                                                     CAP166
     C     SISCY         ANDNE     SDCCY                                                      CAP166
                                                                                              CAP166
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0398'
     C                   EVAL      OKISCY = 'N'
 
     C                   END
     C                   END
      **------------------------------------------------------------------
      **
      **   - Premium Up front
     C     SPUPF         IFNE      'Y'
     C     SPUPF         ANDNE     'N'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SPUPF'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0399'
     C                   EVAL      OKPUPF = 'N'
 
     C                   ELSE
     C                   MOVE      SPUPF         WPUPF
 
      ** Return file version of field
     C                   EVAL      ABPUPF = SPUPF
 
     C                   END
      **------------------------------------------------------------------
      **
      **   - Quotation Convention
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
                                                                                              CAP166
     C     SQOTC         IFNE      *BLANK
     C                   MOVE      SQOTC         QDIGT             1
     C                   MOVEL     SQOTC         QSIGN             1
      **   - Can be +/-  1-3   Only the first character can contain a sign
      **     First character is 'QSIGN', second 'QDIGT'
     C     QDIGT         IFEQ      *BLANK
      **
      **   - If second character is blank first must contain digit
     C     QSIGN         IFLT      '0'
     C     QSIGN         ORGT      '3'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SQOTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0400'
     C                   EVAL      OKQOTC = 'N'
 
     C                   ELSE
      **
      **   - Format field if not in error
     C                   MOVE      QSIGN         WQOTC
     C                   END
      **
      **   - Second character non-blank - first character must be +,-
     C                   ELSE
     C     QSIGN         IFNE      *BLANK
     C     QSIGN         ANDNE     '+'
     C     QSIGN         ANDNE     '-'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SQOTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0401'
     C                   EVAL      OKQOTC = 'N'
 
     C                   ELSE
      **
      **   - First character valid, second must be a digit
     C     QDIGT         IFLT      '0'
     C     QDIGT         ORGT      '3'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SQOTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0402'
     C                   EVAL      OKQOTC = 'N'
 
     C                   END
     C                   END
      **
      **   - Format field if not in error
     C     OKQOTC        IFEQ      'Y'
     C                   MOVE      QDIGT         WQOTC
     C     QSIGN         IFEQ      '-'
     C                   Z-SUB     WQOTC         WQOTC
     C                   END
     C                   END
     C                   END
     C                   END
      **
      **   - If blank, initialize file fields
     C     SQOTC         IFEQ      *BLANK
     C     SQOTC         OREQ      ' 0'
     C                   Z-ADD     0             WQOTC
     C                   END
 
      ** Return file version of field
     C                   EVAL      ABQOTC = WQOTC
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
 
      **------------------------------------------------------------------
      **
      **   -  Expiry Date (Final Transaction Date)
      **
      **      Test if date is numeric
      **
     C                   TESTN                   SFTDT                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
      **
      **      Valididate date format
      **
     C                   MOVE      SFTDT         ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PJDFIN
     C                   PARM                    ErrorFlag
     C                   END
      **
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SFTDT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0403'
     C                   EVAL      OKFTDT = 'N'
 
     C                   ELSE
 
     C                   Z-ADD     ZDAYNO        WFTDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO                         Value date
     C                   PARM      BJDFIN        PJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVEL     ZADATE        WFTDTA            7
 
      ** Return the file version of the field
     C                   EVAL      ABFTDT = ZDAYNO
 
     C                   END
      **------------------------------------------------------------------
      **
      **   -  Expiry Time (Final Transaction Time)
     C                   MOVE      '0'           WTSTN5
     C                   MOVEL     SFTTMP        WTSTN5            5
     C                   TESTN                   WTSTN5               75
                                                                                             BUG8236
     C                   EVAL      WExpTime = *BLANKS                                        BUG8236
     C                   EVAL      WExpTime = %Subst(SFTTMP:1:2) + ':'                       BUG8236
     C                                      + %Subst(SFTTMP:3:2) + ' '                       BUG8236
     C                                      + SFTTML                                         BUG8236
                                                                                             BUG8236
     C     *USA          TEST (E T)              WExpTime                                    BUG8236
     C                   IF        %ERROR                                                    BUG8236
      **
      **   - invalid format or not numeric
     C******IN75         IFEQ      '0'                                                       BUG8236
     C*****SFTTML        ORNE      'AM'                                                      BUG8236
     C*****SFTTML        ANDNE     'PM'                                                      BUG8236
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SFTTM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0404'
     C                   EVAL      OKFTTM = 'N'
 
     C                   ELSE
 
     C                   MOVE      SFTTM         WFTTM
 
      ** Return the file version of the field
     C                   EVAL      ABFTTM = WFTTM
 
     C                   END
      **------------------------------------------------------------------
      **
      **   -  Settlement Date
      **
      **      Test if date is numeric
      **
     C                   TESTN                   SSETD                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   MOVE      SSETD         ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PJDFIN
     C                   PARM                    ErrorFlag
     C                   END
      **
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSETD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0405'
     C                   EVAL      OKSETD = 'N'
 
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WSETD
 
      **   -  Must not be less than the expiry date (final transaction
      **      date) (only if that date is not in error)).
     C     WSETD         IFLT      WFTDT
     C     OKFTDT        ANDEQ     'Y'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSETD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0406'
     C                   EVAL      OKSETD = 'N'
 
     C                   END
     C                   END
 
      ** Return the file version of the field
     C                   IF        OKSETD = 'Y'
     C                   EVAL      ABSETD = WSETD
     C                   ENDIF
 
      **------------------------------------------------------------------
      **
      **   -  Set ticks denominator
     C                   Z-ADD     100           ABTKDM
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      **
      **      Determine minimum price fluctuation and tick value
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
                                                                                              CAP166
     C**********         Z-ADD     0.000001      WMNPF                                        245129
     C                   Z-ADD     0.00000001    WMNPF                                        245129
     C     OKCTAM        IFEQ      'Y'
     C     OKDCCY        ANDEQ     'Y'
     C     OKISCY        ANDEQ     'Y'
     C     OKQOTC        ANDEQ     'Y'
     C                   Z-ADD     WCTAM         ZAMFR
     C     4             ADD       WQOTC         Z010
     C*****6*****        ADD       WQOTC         Z010                                        245129B
     C     WMNPF         MULT      POWER(Z010)   ZEXR
     C                   Z-ADD     DelCyDec      ZFCDP
     C                   Z-ADD     PrmCyDec      ZTCDP
      **  Amount conversion
     C                   Z-ADD     ZAMFR         ZAMFR            15 0
     C**********         Z-ADD     ZEXR          ZEXR             15 9                        245129
     C     ZEXR          MULT(H)   100           ZEXR                                        245129B
     C                   Z-ADD     ZEXR          ZEXR             1511                        245129
     C                   Z-ADD     ZFCDP         ZFCDP             1 0
     C                   Z-ADD     ZTCDP         ZTCDP             1 0
     C     ZTCDP         SUB       ZFCDP         Z010              1 0
     C                   ADD       4             Z010
     C     POWER(Z010)   IFLT      1
     C     ZAMFR         MULT      POWER(Z010)   Z153             15 3
     C     Z153          MULT(H)   ZEXR          ZAMTO            20 5
     C                   ELSE
     C     ZAMFR         MULT      POWER(Z010)   Z150             15 0
     C     Z150          MULT(H)   ZEXR          ZAMTO
     C                   END
      **
     C                   Z-ADD(H)  ZAMTO         WTKVL
 
     C                   EVAL      ABMNPF = WMNPF
     C                   EVAL      ABTKVL = WTKVL
 
     C                   ELSE
     C                   MOVE      'N'           OKISTT
     C                   END
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
      **------------------------------------------------------------------
      **
      **      Check that instrument details match those input
     C     OKAEIN        IFEQ      'Y'
     C     OKCTAM        ANDEQ     'Y'
     C     OKDCCY        ANDEQ     'Y'
     C     OKCCAM        ANDEQ     'Y'
     C     OKCTCY        ANDEQ     'Y'
     C     OKISCY        ANDEQ     'Y'
     C     OKPUPF        ANDEQ     'Y'
     C     OKQOTC        ANDEQ     'Y'
     C     OKFTDT        ANDEQ     'Y'
     C     OKFTTM        ANDEQ     'Y'
     C     OKSETD        ANDEQ     'Y'
      **
      **   -  If instrument type exists
     C     ITISTI        IFEQ      'Y'
     C     FINDET        IFNE      WINDET
     C     AEIN          IFNE      WAEIN
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SAEIN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKAEIN = 'N'
 
     C                   END
     C     FFCTAM        IFNE      WCTAM
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTAM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKCTAM = 'N'
 
     C                   END
     C     OTHC          IFNE      WOTHC
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SDCCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKDCCY = 'N'
 
     C                   END
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
                                                                                              CAP166
     C     CCAM          IFNE      WCCAM
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCAM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKCCAM = 'N'
 
     C                   END
     C     CTCY          IFNE      WCTCY
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKCTCY = 'N'
 
     C                   END
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
     C     ISCY          IFNE      WISCY
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKISCY = 'N'
 
     C                   END
     C     PUPF          IFNE      WPUPF
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SPUPF'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKPUPF = 'N'
 
     C                   END
                                                                                              CAP166
     C                   IF        TransType = 'OTCC'                                         CAP166
                                                                                              CAP166
     C     QOTC          IFNE      WQOTC
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SQOTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKQOTC = 'N'
 
     C                   END
                                                                                              CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
     C     FTDT          IFNE      WFTDT
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SFTDT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKFTDT = 'N'
 
     C                   END
     C     FTTM          IFNE      WFTTM
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SFTTM'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKFTTM = 'N'
 
     C                   END
 
     C     SETD          IFNE      WSETD
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSETD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0411'
     C                   EVAL      OKSETD = 'N'
 
     C                   END
     C                   MOVE      'N'           OKISTT
     C                   END
     C                   ELSE
     C                   MOVEL     WINDET        FINDET
     C                   END
     C                   END
      **------------------------------------------------------------------
 
      ** Move Ok flags from OTCC to OTCO if OTCO transaction                                  CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCO'                                         CAP166
     C                   EVAL      AOKAEIN = OKAEIN                                           CAP166
     C                   EVAL      AOKDCCY = OKDCCY                                           CAP166
     C                   EVAL      AOKCTAM = OKCTAM                                           CAP166
     C                   EVAL      AOKISCY = OKISCY                                           CAP166
     C                   EVAL      AOKPUPF = OKPUPF                                           CAP166
     C                   EVAL      AOKFTDT = OKFTDT                                           CAP166
     C                   EVAL      AOKFTTM = OKFTTM                                           CAP166
     C                   EVAL      AOKSETD = OKSETD                                           CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** Move data from FFOTCCPD to FFOTCOPD fields if OTCO transaction                       CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCO'                                         CAP166
     C                   EVAL      NISTT = SISTT                                              CAP166
     C                   EVAL      NISPT = SISPT                                              CAP166
     C                   EVAL      NAEIN = SAEIN                                              CAP166
     C                   EVAL      NDCCY = SDCCY                                              CAP166
     C                   EVAL      NCTAM = SCTAM                                              CAP166
     C                   EVAL      NISCY = SISCY                                              CAP166
     C                   EVAL      NPUPF = SPUPF                                              CAP166
     C                   EVAL      NFTDT = SFTDT                                              CAP166
     C                   EVAL      NFTTM = SFTTM                                              CAP166
     C                   EVAL      NSETD = SSETD                                              CAP166
     C                   ENDIF                                                                CAP166
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InzTran - Transaction-specific intialisation                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     InzTran       BEGSR
 
      ** Load data from format I_INTYP to data structure FINDET
     C                   EVAL      AEIN   =   ITAEIN
     C                   EVAL      FFCTAM =   ITCTAM
     C                   EVAL      OTHC   =   ITOTHC
     C                   EVAL      CCAM   =   ITCCAM
     C                   EVAL      CTCY   =   ITCTCY
     C                   EVAL      ISCY   =   ITISCY
     C                   EVAL      PUPF   =   ITPUPF
     C                   EVAL      QOTC   =   ITQOTC
     C                   EVAL      FTDT   =   ITFTDT
     C                   EVAL      FTTM   =   ITFTTM
     C                   EVAL      SETD   =   ITSETD
     C                   EVAL      TKVL   =   ITTKVL
     C                   EVAL      MNPF   =   ITMNPF
 
      ** Load data from FFOTCOPD to FFOTCCPD fields if OTCO transaction                       CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCO'                                         CAP166
     C                   EVAL      SISTT = NISTT                                              CAP166
     C                   EVAL      SISPT = NISPT                                              CAP166
     C                   EVAL      SAEIN = NAEIN                                              CAP166
     C                   EVAL      SDCCY = NDCCY                                              CAP166
     C                   EVAL      SCTAM = NCTAM                                              CAP166
     C                   EVAL      SISCY = NISCY                                              CAP166
     C                   EVAL      SPUPF = NPUPF                                              CAP166
     C                   EVAL      SFTDT = NFTDT                                              CAP166
     C                   EVAL      SFTTM = NFTTM                                              CAP166
     C                   EVAL      SSETD = NSETD                                              CAP166
     C                   ENDIF                                                                CAP166
 
      ** Split up expiry time into its hours and minutes part, and its
      ** AM/PM part
     C                   EVAL      SFTTMP = %subst(SFTTM : 1 : 4)
     C                   EVAL      SFTTML = %subst(SFTTM : 5 : 2)
 
     C                   EVAL      WINDET = FINDET
 
      ** Clear output instrument type details
 
     C                   CLEAR                   O_INTYP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** FF OTC currency options OK flags
      ** FF OTC non-currency options OK flags                                                 CAP166
     C                   PARM                    FFEOTCC
     C                   PARM                    FFEOTCO                                      CAP166
      ** Midas FF instrument types (detail) format - OUTPUT
     C                   PARM                    O_INTYP
      ** Counter currency decimal places
     C                   PARM                    CntCyDec
      ** Delivery currency decimal places
     C                   PARM                    DelCyDec
      ** Premium currency decimal places
     C                   PARM                    PrmCyDec
 
      ** Parameters received from caller
      ** -------------------------------
      ** Entire transaction data structure (based on FFOTCCPD)
      ** Entire transaction data structure (based on FFOTCOPD)                                CAP166
     C                   PARM                    FFOTCC
     C                   PARM                    FFOTCO                                       CAP166
      ** Midas FF instrument types (detail) format - INPUT
     C                   PARM                    I_INTYP
      ** O.T.C. instrument switchable field (1A, from transaction)
     C                   PARM                    CFF001
      ** Date format indicator (1A, from SDBANKPD)
     C                   PARM                    BJDFIN
      ** Transaction type                                                                     CAP166
     C                   PARM                    TransType                                    CAP166
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
