     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS pay-in schedule validation')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPVAL - CLS Pay-in Schedule Validation                   *
      *                                                               *
      *  Function: This Program Validates local time and amount       *
      *            fields in the Pay-in schedule.  It will also       *
      *            validate the total amount calculated against the   *
      *            nostro balance total.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055356           Date 27Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG5671            Date 31Jan05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189658             Date 06Feb01               *
      *                 187923             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186669             Date 20Nov00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055356 - CLS Pay in Schedule missing warning message       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG5671- Add Sequence number to detail record                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  189658 - CLS pay-in schedule can be input without a time     *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *           (Recompiled)                                        *
      *  186669 - Last digit/s are erroneously truncated;             *
      *           incorrect value for Number of decimal places        *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************


      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FXCLSPV001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Dealing Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long data structure

     D CLSHed        E DS                  EXTNAME(FXCLSPSH)
     D                                     PREFIX(H_)
      ** Details of Pay-in schedule - Header

     D NwCLSHed      E DS                  EXTNAME(FXVCLSPHPD)
     D                                     PREFIX(H_)
      * FX CLS Pay-in schedule in file format

     D NwCLSDet      E DS                  EXTNAME(FXVCLSPDPD)
     D                                     PREFIX(D_)
      * FX CLS Pay-in schedule in file format

     D OKFlHedDS     E DS                  EXTNAME(FXECLSPHPD)
     D                                     PREFIX(H_)
      * DS for error indicators flags

     D OKFlDetDS     E DS                  EXTNAME(FXECLSPDPD)
     D                                     PREFIX(D_)
      * DS for error indicators flags

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXCLSPV002

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,FXCLSPV003

      ** Call access object to retrieve Number of decimal places                              186669
                                                                                              186669
     C                   EXSR      CCYNDP                                                     186669
      *
      ** If Pay details inserted, validate time (CET) and amount fields
      ** for all the records in subfile
      *
     C                   SELECT
     C                   WHEN      @PayRcv = 'P' AND
     C                             WVLDCNF = 'V'
      *
      ** Validate CLS time
      *
      /COPY WNCPYSRC,FXCLSPV004
      *
     C                   EXSR      VLCLTM
      *
      /COPY WNCPYSRC,FXCLSPV005
      *
      ** Validate Pay amount
      *
      /COPY WNCPYSRC,FXCLSPV006
      *
     C                   EXSR      VLPYAM
      *
      /COPY WNCPYSRC,FXCLSPV007
      *
     C                   WHEN      @PayRcv = 'P'  AND
     C                             WVLDCNF = 'C'
      *
      ** Validate Total Pay amount
      *
      /COPY WNCPYSRC,FXCLSPV008
      *
     C                   EXSR      VLTOTP
      *
      /COPY WNCPYSRC,FXCLSPV009
      *
      ** Validate Total Receive amount
      *
     C                   WHEN      @PayRcv = 'R' AND
     C                             WVLDCNF = 'V' OR
     C                             @PayRcv = 'R' AND
     C                             WVLDCNF = 'C'
      *
      /COPY WNCPYSRC,FXCLSPV010
      *
     C                   EXSR      VLTOTR
      *
      /COPY WNCPYSRC,FXCLSPV011
      *
     C                   ENDSL
      *

      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
      /COPY WNCPYSRC,FXCLSPV012
      *
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXCLSPV013

      *****************************************************************
      ** VLCLTM - Validate CLS Pay-in Time
      *****************************************************************
     C     VLCLTM        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate CLS Pay in Time
      *
     C                   CALLB     'FXVCLSTIM'
      *
      ** Inputs
      ** Return Code
      *
     C                   PARM                    RetCodeOut
      *
      ** CLS Pay Time screen fields
      *
     C                   PARM                    @Paytime
      *
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Time - OK
      *
     C                   PARM                    D_CLLTIM
     C                   PARM                    D_CLSTIMOK
                                                                                              189658
     C     RetCodeOut    IFEQ      'NoTime'                                                   189658
     C                   EVAL      @NoTime = 'Y'                                              189658
     C                   ELSE                                                                 189658
     C                   EVAL      @NoTime = 'N'                                              189658
     C                   ENDIF                                                                189658
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLPYAM - Validate Pay-in Amount for CLS
      *****************************************************************
     C     VLPYAM        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      ** Validate Pay-in amount
      *
     C                   CALLB     'FXVCLSAMT'
      *
      ** Input
      *
     C                   PARM                    RetCodeOut
      *
      ** CLS Pay-in Amount
      *
     C                   PARM                    @PayAmt
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
      *
      ** Outputs
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Amount - file field
      *
     C                   PARM                    D_CLAMT
      *
      ** CLS Amount - OK
      *
     C                   PARM                    D_CLSAMTOK
      *
      ** If action is insert, reinitialise total amount to zero if top
      ** of subfile is being process
      *
     C                   IF        @CLSACT = 'I' AND
     C                             @SFLACTION = 'RC' OR
     C                             @CLSACT = 'A' AND
     C                             @SFLACTION = 'RC'
     C                   EVAL      H_PYTOTP = 0
     C                   ENDIF
      *
      ** If pay-in amount is okay, compute for total amount
      *
     C                   IF        D_CLSAMTOK = 'Y'
     C                   ADD       D_CLAMT       H_PYTOTP
     C                   ENDIF
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLTOTR - Validate total amount for Receive details
      *****************************************************************
     C     VLTOTR        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      ** Validate CLS Total Receive
      *
     C     WVLDCNF       IFEQ      'V'
     C                   CALLB     'FXVCLSTOR'
      *
      ** Input
      *
     C                   PARM                    RetCodeOut
      *
      ** CLS Total Amount Receive
      *
     C                   PARM                    @RcvTot
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
      *
      ** Outputs
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Total Receive Amount - file field
      *
     C                   PARM                    H_PYTOTR
      *
      ** CLS Total Receive Amount - OK
      *
     C                   PARM                    H_CLSTOROK
      *
      ** Validate Total amount receive against nostro balance total
      *
     C                   ELSE
     C                   IF        H_PYTOTR <> H_PYNSBR
     C                   ADD       1             WIx
     C**********         MOVE      'PYTOTR'      WFldNmXAr(WIx)                             MD055356
     C**********         MOVE      'FXM3029'     WMsgIdXAr(WIx)                             MD055356
     C                   MOVEL     'PYTOTR'      WFldNmXAr(WIx)                             MD055356
     C                   MOVEL     'FXM3029'     WMsgIdXAr(WIx)                             MD055356
     C                   ENDIF
     C                   ENDIF
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLTOTP - Validate total amount for Pay
      *****************************************************************
     C     VLTOTP        BEGSR

     C                   EXSR      RESETERRS
      *
      ** Validate total amount pay agains nostro balance
      *
     C                   IF        H_PYTOTP <> H_PYNSBP
     C                   ADD       1             WIx
     C**********         MOVE      'PYTOTP'      WFldNmXAr(WIx)                             MD055356
     C**********         MOVE      'FXM3026'     WMsgIdXAr(WIx)                             MD055356
     C                   MOVEL     'PYTOTP'      WFldNmXAr(WIx)                             MD055356
     C                   MOVEL     'FXM3026'     WMsgIdXAr(WIx)                             MD055356
     C                   ENDIF
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  186669
      *****************************************************************                       186669
      * CCYNDP - Get Number of decimal places for the Currency        *                       186669
      *****************************************************************                       186669
                                                                                              186669
     C     CCYNDP        BEGSR                                                                186669
                                                                                              186669
     C                   CALL      'AOCURRR0'                                                 186669
     C                   PARM      '*DBERR '     @RTCD                                        186669
     C                   PARM      '*KEY   '     @OPTN                                        186669
     C                   PARM      H_PYCCY       @AJCD             3                          186669
     C     SDCURR        PARM      SDCURR        DSSDY                                        186669
                                                                                              186669
     C                   ENDSR                                                                186669
      *****************************************************************                       186669
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      * CLS Action
     C                   PARM                    @CLSACT           1
      *
      * Pay/Receive indicator
     C                   PARM                    @PayRcv           1
     C                   PARM                    WVLDCNF           1
      *
      * Details of Pay-in schedule - Header
     C                   PARM                    CLSHed
      *
     C                   PARM                    @PayTime          4
     C                   PARM                    @PayAmt          18
     C                   PARM                    @RcvTot          18
     C                   PARM                    @SflAction        2
      *
      * Outputs
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlHedDS
     C                   PARM                    OKFlDetDS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    WIx
      *
      ** Valid CLS Pay-in schedule in file format
      *
     C                   PARM                    NwCLSHed
     C                   PARM                    NwCLSDet
      *                                                                                       189658
      ** Indicator for blank CLS time                                                         189658
      *                                                                                       189658
     C                   PARM                    @NoTime           1                          189658
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'FXCLSPVAL'   DBPGM
     C                   OUT       LDA
      *
     C***********        CALLB     'AOCURRR0'                                                 186669
     C***********        PARM      '*DBERR '     @RTCD                                        186669
     C***********        PARM      '*KEY   '     @OPTN                                        186669
     C***********        PARM      H_PYCCY       @AJCD             3                          186669
     C*****SDCURR        PARM      SDCURR        DSSDY                                        186669
      *
      ** Access Dealing Details
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FXCLSPV014

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

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
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
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
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      ** Header details
      *
     C                   EVAL      H_CLCCY = H_PYCCY
     C                   EVAL      H_CLNOST = H_PYNOST
     C                   EVAL      H_CLVALD = H_PYVALD
     C                   EVAL      H_CLSEQN = H_PYSEQN
     C                   EVAL      H_CLTIMD = H_PYTIMD
     C                   EVAL      H_CLPRFC = H_PYPRFC
     C                   EVAL      H_CLTIMS = H_PYTIMS
     C                   EVAL      H_CLTOTP = H_PYTOTP
     C                   EVAL      H_CLTOTR = H_PYTOTR
     C                   EVAL      H_CLNSBP = H_PYNSBP
     C                   EVAL      H_CLNSBR = H_PYNSBR
      *
      ** Detail fields
      *
     C                   EVAL      D_CLCCY = H_PYCCY
     C                   EVAL      D_CLNOST = H_PYNOST
     C                   EVAL      D_CLVDAT = H_PYVALD
     C                   EVAL      D_CLSEQN = H_PYSEQN
     C                   EVAL      D_CLPRFC = H_PYPRFC
     C                   EVAL      D_CLSTIM = H_PYTIMD
     C                   EVAL      D_CLTIMS = H_PYTIMS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
