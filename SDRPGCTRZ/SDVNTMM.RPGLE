     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Net Manual Matching')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - FX Netting details data       *
      *                                                               *
      *  SDVNTMM - Validate Net Manual Matching                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, FX Netting Details amendments must not be           *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
 
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
 
      ** External DS based on Deal file
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDNTMM          S              1A
     D DDNTGP          S              4A
     D DDNET           S              1A
     D DDCUSN          S              6A
     D DDNTMMOK        S              1A
 
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
      ** Validation
 
      ** Validate Net Manual Matching
      ** DTL.Net Manual Matching is Blank
     C                   IF        DDNTMM = *BLANK
     C                   EVAL      DDNTMM = 'N'
     C                   ENDIF
      ** DTL.Netting Group is Not Blank
     C                   IF        DDNTGP <> *BLANKS
 
     C                   IF        BNNMAM = 'Y' AND
     C                             DDNTMM <> 'N'
     C                   EVAL      DDNTMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTMM'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3181'
     C                   ENDIF
 
     C                   ELSE
      ** CASE: Manual Matching is Yes
     C                   IF        BNNMAM = 'Y'
      ** CASE: DTL.Net Settlement is Yes
     C                   IF        DDNET = 'Y'
      ** Net Manual Matching is valid Values
     C                   IF        DDNTMM <> 'Y' AND
     C                             DDNTMM <> 'N'
     C                   EVAL      DDNTMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTMM'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3146'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDNTMM <> 'N'
     C                   EVAL      DDNTMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTMM'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3147'
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
     C                   PARM                    DDNTMM
     C                   PARM                    DDNTGP
     C                   PARM                    DDNET
     C                   PARM                    DDCUSN
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Net Manual Matching -      OK
     C                   PARM                    DDNTMMOK
 
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      ** Access Dealing File
     C                   CALLB     'AODEALR1'
     C
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST   '   @OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DDNTMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTMM'
     C                   EVAL      MsgIdXAr(Idx) = 'USR0205'
 
     C                   ENDIF
 
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
(c) Misys International Banking Systems Ltd. 2006
