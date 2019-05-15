     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Account Officer')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function Module - User Maintenamce  *
      *          and Menu Items Validation                            *
      *                                                               *
      *  SFVACFA  - Validate Account Officer                          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, User Maintenance + Menu Items amendments must not be*
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 18May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      * 800 byte DS for incoming data from Access Program
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * 200 byte DS for incoming data from Access Program
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Module Detail DS for incoming data from Access Program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * Midas SD Account Officers Detail DS for incoming data from
      * Access Program
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
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
 
      *
      ** VALIDATION
 
      ** Validate Account Officer
     C     BGPFMG        IFEQ      'Y'
     C     BGLMCR        OREQ      'Y'
      *
     C     DDACFA        IFNE      *BLANKS
     C     DDACFA        ANDNE     'ALL'
     C                   MOVEL     DDACFA        PACOF             2
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    PACOF
     C     SDACOF        PARM      SDACOF        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       DDACFA
     C                   MOVEL     AZACOC        DDACFA
     C                   ELSE
      *
      ** Check if Right Aligned
      *
     C                   MOVEL     DDACFA        PFIRST            1
     C     PFIRST        IFEQ      *BLANKS
     C                   MOVE      DDACFA        PACOF
      *
      ** Validate Input Account Officer
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    PACOF
     C     SDACOF        PARM      SDACOF        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       DDACFA
     C                   MOVEL     AZACOC        DDACFA
     C                   ELSE
      *
     C                   EVAL      DDACFAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACFA'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0458'
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      DDACFAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACFA'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0458'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check department and account officer if Portfolio Management
      ** or Portfolio Lending is switched on
      *
     C     BGPFMG        IFEQ      'Y'
     C     BGLMCR        OREQ      'Y'
      *
     C     DDACFA        IFEQ      *BLANKS
     C     DDDPPT        ANDEQ     *BLANKS
     C                   EVAL      DDACFAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACFA'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0459'
     C                   ENDIF
      *
     C     DDACFA        IFNE      *BLANKS
     C     DDDPPT        ANDNE     *BLANKS
     C                   EVAL      DDACFAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACFA'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0460'
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDACFA        IFEQ      'ALL'
     C                   EVAL      DDACFAOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDACFA'
     C                   EVAL      MsgIdXAr(Idx) = 'SFM0461'
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
     C                   PARM                    DDACFA            3
     C                   PARM                    DDDPPT            3
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Account Officer - OK
     C                   PARM                    DDACFAOK          1
      *
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     901           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
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
