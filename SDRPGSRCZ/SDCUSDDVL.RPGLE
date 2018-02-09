     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Safe details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDDVL - Safe details Validation                          *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUSFV001
 
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
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCUSFPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUSFPD)
 
      ** Valid Transaction Details layout
     D ValidCUSF     E DS                  EXTNAME(SDVCUSFPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
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
 
      ** Other Fields
     D DDSFNX          S              6
     D DDSFSX          S              2
     D DDSFIX          S              6
     D FldNam1         S             10
     D FldNam2         S             10
     D FldNam3         S             10
     D DDSFNXOK        S              1
     D DDSFSXOK        S              1
     D DDSFIXOK        S              1
     D SFSFIX          S              5P 0
     D I               S              3P 0
     D RespMode        S              1
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
      /COPY WNCPYSRC,SDCUSFV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUSFV003
 
      ** Validate Safe Details 1
 
      /COPY WNCPYSRC,SDCUSFV004
     C                   EVAL      DDSFNX = DDSFN1
     C                   EVAL      DDSFSX = DDSFS1
     C                   EVAL      DDSFIX = DDSFI1
     C                   EVAL      FldNam1= 'DDSFN1   '
     C                   EVAL      FldNam2= 'DDSFS1   '
     C                   EVAL      FldNam3= 'DDSFI1   '
     C                   EVAL      DDSFNXOK = 'Y'
     C                   EVAL      DDSFSXOK = 'Y'
     C                   EVAL      DDSFIXOK = 'Y'
     C                   EXSR      VSAFESR
     C                   EVAL      SFSFI1 = SFSFIX
      /COPY WNCPYSRC,SDCUSFV005
 
      ** Validate Safe Details 2
 
      /COPY WNCPYSRC,SDCUSFV006
     C                   EVAL      DDSFNX = DDSFN2
     C                   EVAL      DDSFSX = DDSFS2
     C                   EVAL      DDSFIX = DDSFI2
     C                   EVAL      FldNam1= 'DDSFN2   '
     C                   EVAL      FldNam2= 'DDSFS2   '
     C                   EVAL      FldNam3= 'DDSFI2   '
     C                   EVAL      DDSFNXOK = 'Y'
     C                   EVAL      DDSFSXOK = 'Y'
     C                   EVAL      DDSFIXOK = 'Y'
     C                   EXSR      VSAFESR
     C                   EVAL      SFSFI2 = SFSFIX
      /COPY WNCPYSRC,SDCUSFV007
 
      ** Validate Safe Details 3
 
      /COPY WNCPYSRC,SDCUSFV008
     C                   EVAL      DDSFNX = DDSFN3
     C                   EVAL      DDSFSX = DDSFS3
     C                   EVAL      DDSFIX = DDSFI3
     C                   EVAL      FldNam1= 'DDSFN3   '
     C                   EVAL      FldNam2= 'DDSFS3   '
     C                   EVAL      FldNam3= 'DDSFI3   '
     C                   EVAL      DDSFNXOK = 'Y'
     C                   EVAL      DDSFSXOK = 'Y'
     C                   EVAL      DDSFIXOK = 'Y'
     C                   EXSR      VSAFESR
     C                   EVAL      SFSFI3 = SFSFIX
      /COPY WNCPYSRC,SDCUSFV009
 
      ** Validate Safe Details 4
 
      /COPY WNCPYSRC,SDCUSFV010
     C                   EVAL      DDSFNX = DDSFN4
     C                   EVAL      DDSFSX = DDSFS4
     C                   EVAL      DDSFIX = DDSFI4
     C                   EVAL      FldNam1= 'DDSFN4   '
     C                   EVAL      FldNam2= 'DDSFS4   '
     C                   EVAL      FldNam3= 'DDSFI4   '
     C                   EVAL      DDSFNXOK = 'Y'
     C                   EVAL      DDSFSXOK = 'Y'
     C                   EVAL      DDSFIXOK = 'Y'
     C                   EXSR      VSAFESR
     C                   EVAL      SFSFI4 = SFSFIX
      /COPY WNCPYSRC,SDCUSFV011
 
      ** Validate Safe Details 5
 
      /COPY WNCPYSRC,SDCUSFV012
     C                   EVAL      DDSFNX = DDSFN5
     C                   EVAL      DDSFSX = DDSFS5
     C                   EVAL      DDSFIX = DDSFI5
     C                   EVAL      FldNam1= 'DDSFN5   '
     C                   EVAL      FldNam2= 'DDSFS5   '
     C                   EVAL      FldNam3= 'DDSFI5   '
     C                   EVAL      DDSFNXOK = 'Y'
     C                   EVAL      DDSFSXOK = 'Y'
     C                   EVAL      DDSFIXOK = 'Y'
     C                   EXSR      VSAFESR
     C                   EVAL      SFSFI5 = SFSFIX
      /COPY WNCPYSRC,SDCUSFV013
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,SDCUSFV014
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VSAFESR - Validate Safe Details                              *
      *                                                               *
      *****************************************************************
      *
     C     VSAFESR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Safe Details
 
     C                   CALLB     'SDVSAFE'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Safe No
 
     C                   PARM                    DDSFNX
 
      ** Size
 
     C                   PARM                    DDSFSX
 
      ** Safe Rent Date
 
     C                   PARM                    DDSFIX
 
      ** Field Name 1
 
     C                   PARM                    FldNam1
 
      ** Field Name 2
 
     C                   PARM                    FldNam2
 
      ** Field Name 3
 
     C                   PARM                    FldNam3
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Safe No - OK
 
     C                   PARM                    DDSFNXOK
 
      ** Size - OK
 
     C                   PARM                    DDSFSXOK
 
      ** Safe Rent Date - OK
 
     C                   PARM                    DDSFIXOK
 
      ** Safe Rent Date
 
     C                   PARM      *Zeros        SFSFIX
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   IF        DDSFNXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNam1 = 'DDSFN1   '
     C                   EVAL      DDSFN1OK = 'N'
     C                   WHEN      FldNam1 = 'DDSFN2   '
     C                   EVAL      DDSFN2OK = 'N'
     C                   WHEN      FldNam1 = 'DDSFN3   '
     C                   EVAL      DDSFN3OK = 'N'
     C                   WHEN      FldNam1 = 'DDSFN4   '
     C                   EVAL      DDSFN4OK = 'N'
     C                   WHEN      FldNam1 = 'DDSFN5   '
     C                   EVAL      DDSFN5OK = 'N'
     C                   ENDSL
     C                   ENDIF
     C                   IF        DDSFSXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNam2 = 'DDSFS1   '
     C                   EVAL      DDSFS1OK = 'N'
     C                   WHEN      FldNam2 = 'DDSFS2   '
     C                   EVAL      DDSFS2OK = 'N'
     C                   WHEN      FldNam2 = 'DDSFS3   '
     C                   EVAL      DDSFS3OK = 'N'
     C                   WHEN      FldNam2 = 'DDSFS4   '
     C                   EVAL      DDSFS4OK = 'N'
     C                   WHEN      FldNam2 = 'DDSFS5   '
     C                   EVAL      DDSFS5OK = 'N'
     C                   ENDSL
     C                   ENDIF
     C                   IF        DDSFIXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNam3 = 'DDSFI1   '
     C                   EVAL      DDSFI1OK = 'N'
     C                   WHEN      FldNam3 = 'DDSFI2   '
     C                   EVAL      DDSFI2OK = 'N'
     C                   WHEN      FldNam3 = 'DDSFI3   '
     C                   EVAL      DDSFI3OK = 'N'
     C                   WHEN      FldNam3 = 'DDSFI4   '
     C                   EVAL      DDSFI4OK = 'N'
     C                   WHEN      FldNam3 = 'DDSFI5   '
     C                   EVAL      DDSFI5OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
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
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
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
 
     C                   PARM                    RespMode
 
      ** Safe Details
 
     C                   PARM                    TrnDets
 
      ** Outputs
      ** Safe  OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Safe (DS) from/to caller
 
     C                   PARM                    ValidCUSF
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUSFV015
 
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
**  CPY@
(c) Finastra International Limited 2007
