     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Alternative Names & Addresses - Validation.')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDALNAVAL - Customer Alternative Names & Addresses Details   *
      *              Validation                                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD054781           Date 24Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054781 - Defaulting of Country Location for Wholesale      *
      *              Customers Alternative Name & Address             *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDALNAV001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDALNAPD)

      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDEALNAPD)

      ** Valid Transaction Details layout
     D ValidAlna     E DS                  EXTNAME(SDVALNAPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D ZMUSER          DS            17
     D  USRBCH                11     13

     D ExtData       E DS                  EXTNAME(SDALEXPD)
      * SD Extra Data - File (D/B) format

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

     D I               S              3P 0

     D RespMode        S              1A

      ** Parameters for AOBANKR0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDALNAV002

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *inzsr is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+


      /COPY WNCPYSRC,SDALNAV003

      *
      ** Validate Name & Address 1
      /COPY WNCPYSRC,SDALNAV004
     C                   EXSR      VCNA1SR
      /COPY WNCPYSRC,SDALNAV005
      *
      ** Validate Country code
      /COPY WNCPYSRC,SDALNAV006
     C                   EXSR      VCNCOSR
      /COPY WNCPYSRC,SDALNAV007
      *

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDALNAV008

      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCNA1SR - Validate Name & Address 1
      *****************************************************************
      *
     C     VCNA1SR       BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Name & Address 1
     C                   CALLB     'SDVCNA1'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Name & Address 1
     C                   PARM                    DDCNA1
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Name & Address 1  - OK
     C                   PARM                    DDCNA1OK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCNCOSR - Validate Country Code
      *****************************************************************
      *
     C     VCNCOSR       BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Country Code
     C                   CALLB     'SDVCNCO'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Customer Number                                                                    MD054781
     C                   PARM                    DDCUST                                     MD054781
      *                                                                                     MD054781
      ** Region code
     C                   PARM                    DDCNCD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Country Code - OK
     C                   PARM                    DDCNCDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
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
      * Update error fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      * Set Warning Index
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

      * Inputs

      * Response mode
     C                   PARM                    RespMode

      ** Alt Names & Addresses Details
     C                   PARM                    TrnDets
     C                   PARM                    ExtData
      *  Outputs

      ** Alt Names & Addresses Details OK inds
     C                   PARM                    OKTrnDets

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Alt Names & Addresses details layout (DS) from/to
      * caller
     C                   PARM                    ValidALNA
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
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
      *
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDALNAV009

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
