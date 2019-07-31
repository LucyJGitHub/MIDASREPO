     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Details Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFMPRIVAL - Midas FF Market Prices Function Code             *
      *              Details Validation                               *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFMPRIV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
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
 
      ** Market Prices Transaction Details in screen format
     D MrkDets       E DS                  EXTNAME(FFMPRIPD)
 
      ** Market Prices Transaction Details OK indicators
     D OKMrkDets     E DS                  EXTNAME(FFEMPRIPD)
 
      ** Valid Market Prices Transaction Details layout
     D ValidMPRI     E DS                  EXTNAME(FFVMPRIPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D    SARLCD     E                     EXTFLD(LCD)
 
      ** FF Extention data Market Price - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFMPEXPD)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      *
      ** Parameters for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
 
     D PRSTRP          S             15  8
     D PRYRNO          S              2S 0
     D PRMTHN          S              2S 0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Define variable for switchable CSC011.
     D CSC011          S              1A   INZ('N')
 
      ** Define parameters for AOSARDR0
     D PSARD           S              6A
 
     D PRTCD           S              7
     D POPTN           S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFMPRIV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFMPRIV003
 
      *
      ** New Price
      ** =========
      *
 
     C                   IF        OKISTC <> 'N'
     C                             AND OKSTRP <> 'N'
 
     C                   EXSR      ValNewPrice
 
      *
      ** Risk Factor
      ** ===========
      *
 
     C                   IF        DDMRKT <> *BLANKS
     C                   EXSR      ValRisk
     C                   ENDIF
 
     C                   ENDIF
      *
 
     C                   RETURN
 
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFMPRIV004
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALNEWPRICE
      *****************************************************************
     C     VALNEWPRICE   BEGSR
 
      ** +------------------------------------------+-----------------------------------------------
      ** | New/Contract price                       |
      ** +------------------------------------------+
 
      ** Don't do contract price validation if instrument type or
      ** strike price was not valid
 
      ** Reset variables updated by each module before each call
     C                   EXSR      RESETERRS
 
     C                   MOVE      DDYRNO        PRYRNO
     C                   SELECT
     C                   WHEN      DDMTHN = 'JAN'
     C                   EVAL      PRMTHN = 01
     C                   WHEN      DDMTHN = 'FEB'
     C                   EVAL      PRMTHN = 02
     C                   WHEN      DDMTHN = 'MAR'
     C                   EVAL      PRMTHN = 03
     C                   WHEN      DDMTHN = 'APR'
     C                   EVAL      PRMTHN = 04
     C                   WHEN      DDMTHN = 'MAY'
     C                   EVAL      PRMTHN = 05
     C                   WHEN      DDMTHN = 'JUN'
     C                   EVAL      PRMTHN = 06
     C                   WHEN      DDMTHN = 'JUL'
     C                   EVAL      PRMTHN = 07
     C                   WHEN      DDMTHN = 'AUG'
     C                   EVAL      PRMTHN = 08
     C                   WHEN      DDMTHN = 'SEP'
     C                   EVAL      PRMTHN = 09
     C                   WHEN      DDMTHN = 'OCT'
     C                   EVAL      PRMTHN = 10
     C                   WHEN      DDMTHN = 'NOV'
     C                   EVAL      PRMTHN = 11
     C                   WHEN      DDMTHN = 'DEC'
     C                   EVAL      PRMTHN = 12
     C                   OTHER
     C                   EVAL      PRMTHN = 0
     C                   ENDSL
 
     C                   CALLB     'FFVMPNWPR'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
      ** Field name array
      ** Error message ID array
      ** Error message data array
      ** Field name array (<WArrMax> x 10A, returned to caller)
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
      ** Numeric (file) version of price
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    DVNEWP
 
      ** Inputs to called procedure
      ** --------------------------
      ** New price (16A)
      ** Year number (2,0S)
      ** Month number (2,0S)
      ** Put call indicator
      ** Strike price (15,8P)
      ** Instrument types (DS, from INTYPD)
      ** OK flags
     C                   PARM                    DDNWPI
     C                   PARM                    PRYRNO
     C                   PARM                    PRMTHN
     C                   PARM                    DDPCAL
     C                   PARM                    PRSTRP
     C                   PARM                    InstTypes
     C                   PARM                    OKMrkDets
 
 
      ** Do the return code and error details handling
     C                   EXSR      UPDATERRS
 
     C                   IF        ReturnCode = *blanks
     C                   EVAL      OKNWPI = 'Y'
     C                   ELSE
     C                   EVAL      OKNWPI = 'N'
     C                   ENDIF
 
 
      ** -------------------------------------------------------------------------------------------
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALRISK
      *****************************************************************
     C     VALRISK       BEGSR
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Risk Factor                              |
      ** +------------------------------------------+
 
      ** Don't do risk factor validation if instrument type or
      ** strike price was not valid
 
      ** Reset variables updated by each module before each call
     C                   EXSR      RESETERRS
 
     C                   CALLB     'FFVMPRSKF'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
      ** Field name array
      ** Error message ID array
      ** Error message data array
      ** Risk Factor in Numeric Format
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DVRSKF
 
      ** Inputs to called procedure
      ** --------------------------
      ** Risk Factor in screen Format (11A)
     C                   PARM                    DDRSKF
 
      ** Do the return code and error details handling
     C                   EXSR      UPDATERRS
 
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      OKRSKF = 'N'
     C                   ELSE
     C                   EVAL      OKRSKF = 'Y'
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      ReturnCode = *Blanks
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ** Update warning fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Inputs
 
      ** Response mode
     C                   PARM                    RespMode          1
 
      ** Market Prices Transaction Details in Screen Format
     C                   PARM                    MrkDets
      ** Extension File Data
     C                   PARM                    ExtData
      ** Strike price file format
     C                   PARM                    PRSTRP
 
      ** Outputs
 
      ** Transaction Details OK indicators
     C                   PARM                    OKMrkDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidMPRI
      ** Instrument Types
     C                   PARM                    InstTypes
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *
      ** Check if switchable feature S01496 is switched on.
      ** Private Banking Securities Trading Enhancement
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'S01496'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   ENDIF
 
      ** Determine if 24x7 Midas availability is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSC011'
     C                   EVAL      DBASE = 1
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFMPRIV013
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
