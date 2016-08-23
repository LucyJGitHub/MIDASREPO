     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Default Branch')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function Module - User Maintenamce  *
      *          and Menu Items Validation                            *
      *                                                               *
      *  SFVDBRN  - Validate Default Branch                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, User Maintenance + Menu Items amendments must not be*
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 18May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
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
 
      * Multi Branching Data Area
     D RUNDAT          DS
     D MBIN                   13     13                                         *Multi-Branch
      * Array for Checking Department
     D CHK1            S              1    DIM(3)
      * Array Index for CHK1 Array
     D DIdx            S              3P 0
      * 800 byte DS for incoming data from Access Program
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * 200 byte DS for incoming data from Access Program
     D DSFDY         E DS                  EXTNAME(DSFDY)
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
     C*
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
 
      * Get Multi Branched Value from RUNDAT DTAARA                   *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MBIN          MBRIND            1
      *
      ** VALIDATION
 
      *
      ** Validate Default Branch
      *
      **   If system is Multi-Branching :-
      **
     C     MBRIND        IFEQ      'Y'
      **
      **   DEFAULT BRANCH IS MANDATORY
      **
     C     DDDBRN        IFEQ      *BLANKS
     C                   EVAL      DDDBRNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDBRN'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0462'
     C                   ELSE
      **
      **   BRANCH MUST HAVE NO EMBEDDED BLANKS
      **
     C                   EVAL      DIdx = 1
     C                   MOVEA     DDDBRN        CHK1
     C     DIdx          DOWLE     3
     C     CHK1(DIdx)    IFEQ      ' '
     C                   EVAL      DDDBRNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDBRN'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0463'
     C                   ENDIF
      *
     C                   EVAL      DIdx = DIdx + 1
     C                   ENDDO
      *
     C                   ENDIF
      **
      ** CHECK THAT BRANCH IS VALID
      **
      * CALL A/O
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM                    DDDBRN
     C                   PARM                    DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DDDBRNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDBRN'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0464'
     C                   ENDIF
      *
     C                   ENDIF
      *
 
 
 
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
     C                   PARM                    DDDBRN            3
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller
      ** Default Branch - OK
     C                   PARM                    DDDBRNOK          1
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
(c) Misys International Banking Systems Ltd. 2006
