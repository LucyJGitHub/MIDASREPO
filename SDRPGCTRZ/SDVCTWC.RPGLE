     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Weighting code')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Country Details Validation    *
      *                                                               *
      *  SDVCTWC  - Validate the Weighting code                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG12120            Date 04Oct06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG12120 -  Error generated on field weighting code and       *
      *             End of Year Tax.                                  *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** EXTERNAL DS FOR WEIGHTING CODE DETAILS
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)
      ** DS for access programs - Long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      *
      ** VALIDATION
 
      ** Validate  Weighting Code                                                            BG12120
      *                                                                                      BG12120
     C                   IF        DDCTWC <> *BLANKS                                         BG12120
      *                                                                                      BG12120
     C                   EVAL      ZFIELD = *BLANKS                                          BG12120
     C                   EVAL      ZFIELD = DDCTWC                                           BG12120
     C                   Z-ADD     0             ZADEC                                       BG12120
     C                   Z-ADD     2             ZADIG                                       BG12120
      * Call the ZALIGN MODULE with four parms,                                              BG12120
     C                   CALLB     'ZALIGN'                                                  BG12120
     C                   PARM                    ZAlignOK          1                         BG12120
     C                   PARM                    ZFIELD           16                         BG12120
     C                   PARM                    ZADEC             1 0                       BG12120
     C                   PARM                    ZADIG             2 0                       BG12120
                                                                                             BG12120
      *                                                                                      BG12120
     C                   IF        ZAlignOK = 'N'                                            BG12120
     C                   EVAL      DDCTWCOK = 'N'                                            BG12120
     C                   EVAL      Idx = Idx + 1                                             BG12120
     C                   EVAL      FldNamXAr(Idx) = 'DDCTWC   '                              BG12120
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0060'                                BG12120
     C                   ENDIF                                                               BG12120
      *                                                                                      BG12120
     C                   MOVE      ZFIELD        DDCTWC                                      BG12120
      *                                                                                      BG12120
     C                   ENDIF                                                               BG12120
                                                                                             BG12120
      ** Weighting code if not blank must exist on Weighting file
     C     DDCTWC        IFNE      *BLANKS                                      - B1
     C     DDCTWC        ANDNE     *ZEROS
     C                   MOVEL     'GP'          AOPGM            10
     C                   MOVE      'AOWEIGR0'    AOPGM
     C                   CALL      AOPGM
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    DDCTWC
     C     GPWEIG        PARM      GPWEIG        DSFDY
     C                   IF        @RTCD <> *BLANK
 
     C                   EVAL      DDCTWCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCTWC    '
     C                   EVAL      MsgIdXAr(Idx) = 'Y2U0060'
     C                   ENDIF
     C                   ENDIF
 
 
      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Field(s) requiring validation
     C                   PARM                    DDCTWC            2
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Weighting Code      - OK
     C                   PARM                    DDCTWCOK          1
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
