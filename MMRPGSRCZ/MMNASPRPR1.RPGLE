     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased BoE Repair')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMNASPRPR1 - Window repair module                            *
      *                                                               *
      *  Function:  This function allows invalid MM NAs Purchased     *
      *             details to be 'repaired' and applied to the Midas *
      *             database                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMMINPEXL0 IF   E           K DISK    INFSR(*PSSR)
      *
      ** Display file for window
      *
     FMMNASP1RDFCF   E             WORKSTN
      *
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
      *
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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D/COPY QWINDSRC,MMNASPSDTA
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Add 1 onto elements in array for each field on window
     D @EI             S              1    DIM(60)
      *
      ** Error indicators (OK#S)
     D OkFlags       E DS                  EXTNAME(MMENASPX0)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D SCA_LCD       E                     EXTFLD(LCD)
      ** External DS for SAR Details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
      *
     D ExtData       E DS                  EXTNAME(MMNPEXPD)
      * MM Transaction Extra Data - File (D/B) format
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PACTN           S              1
     D PW8Rtn          S              7
     D PWLEN           S              3  0
     D PWWID           S              3  0
     D PSROW           S              3  0
     D PSCOL           S              3  0
     D PTITLE          S              7
     D PSPARE2         S            256
      *
     D PZAPGMQ         S             10
     D PZAPGRL         S              5
     D PZAMSID         S              7
     D PZAMSGF         S             10
     D PZAMSDA         S            132
     D PZAMSTP         S              7
      *
     D PTEXT           S            132
      *
     D P@RTCD          S              7
     D P@OPTN          S              7
      *
      ** Array Index
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
      *
      ** Standards Output parameters
     D P@INKC          S              1
     D P@INKL          S              1
      *
      ** Transaction Number / Reference
     D DDTRNN          S              6A
      *
      ** -------------------------------------------------------------------
      *
     D WKTRNN          S                   LIKE(DDTRNN)
     D WDDLNO          S              6
     D C               S              2P 0 INZ(0)
     D E               S              2P 0 INZ(0)
     D WProcess        S              1
     D ULMDAT          S              5  0
     D KFOID           S                   LIKE(BYFRNT)
     D KTMSTP          S                   LIKE(BYTIME)
      *
      ** -------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
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
      *
     C                   EXSR      SRINIT
      *
     C                   DOU       WProcess = 'N'
      *
     C                   MOVEA     OkFlags       @EI
     C                   EVAL      C     =  1
     C                   EVAL      E     = 50
      *
     C                   DOU       C > 10
     C                   IF        @EI(C) = 'N' OR
     C                             @EI(C) = 'W'
     C                   EVAL      *IN(E) = '1'
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   EVAL      E = E + 1
     C                   ENDDO
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   PZAMSID
     C                   MOVEL     MsgDtaArr(C)  PZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   ENDDO
      *
     C                   WRITE     MMNASP1RF0
     C                   IF        Idx > 0
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
      ** Display the window
      *
     C                   READ      MMNASP1RF0
     C                   EXSR      SRCLEAR
     C                   EVAL      P@INKC = *INKC
     C                   EVAL      P@INKL = *INKL
      *
     C                   EXSR      SRVCLR
      *
     C                   SELECT
     C                   WHEN      *INKC = '1'
     C                   EXSR      SREXIT
     C                   WHEN      *INKL = '1'
     C                   EXSR      SRPREV
     C                   OTHER
     C                   EXSR      SRVALID
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   EXSR      SRTERM
      *
      *****************************************************************
      *                                                               *
      ** SRVALID Validate Fields                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRVALID       BEGSR
      *
     C                   IF        PActn     = 'E'
     C                   EVAL      WProcess = 'N'
     C                   ELSE
 
     C                   EVAL      LGTEEEX  =  #0GTEE
     C                   EVAL      LQUALEX  =  #0QUAL
     C                   EVAL      LFMATEX  =  #0FMAT
     C                   EVAL      CQGTEE  =  #0GTEE
     C                   EVAL      CQQUAL  =  #0QUAL
     C                   EVAL      CQFMAT  =  #0FMAT
      *
     C                   CALLB     'MMLNASPEXV'
     C                   PARM                    ExtData
     C                   PARM                    ULMDAT
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    WDDLNO
     C                   PARM                    OkFlags
     C                   PARM                    BJDFIN
      *
     C                   IF        Idx = 0
     C                   EVAL      WProcess = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SRVCLR Clear all error indicators and variables               *
      *                                                               *
      *****************************************************************
     C     SRVCLR        BEGSR
      *
     C                   MOVEA     '000000'      *IN(50)
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   EVAL      WFldNamArr = *BLANKS
     C                   EVAL      WMsgIdArr  = *BLANKS
     C                   EVAL      WMsgDtaArr = *BLANKS
     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0
      *
     C                   IF        PActn = 'E'
     C                   EVAL      *IN20   = '1'
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ** SRCLEAR  Clear Program message Queue                         *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PsProcName    PZAPGMQ
     C                   PARM      '*SAME'       PZAPGRL
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ** SRPREV  Previous Screen                                      *
      *                                                               *
      *****************************************************************
     C     SRPREV        BEGSR
      *
     C                   EVAL      PW8rtn   = 'USR0790'
     C                   EXSR      SRCLEAR
     C                   EVAL      WProcess = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ** SREXIT  Exit Program                                         *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
      *
     C                   EVAL      PW8rtn   = 'Y2U9999'
     C                   EVAL      WProcess = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ** SRTERM  Terminate                                            *
      *                                                               *
      *****************************************************************
     C     SRTERM        BEGSR
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ** SRINIT Initial Processing                                    *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C                   EVAL      ##PGM  = PSPROCNAME
     C                   EVAL      SWROW  = PSROW
     C                   EVAL      SWCOL  = PSCOL
     C                   EVAL      PZAMSGF = 'GBBYUSRMSG'
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PTITLE
     C                   PARM                    PZAMSGF
     C                   PARM                    PTEXT
      *
     C                   MOVEL     PTEXT         STITL
      *
      ** If action code is enquire, protect screen fields
      *
     C                   IF        PActn = 'E'
     C                   EVAL      *IN20   = '1'
     C                   ENDIF
      *
      ** If action code is amend or enquire, get the invalid screen
      ** details from MMINPEXL0
      *
     C                   MOVE      BYFRNT        KFOID
     C                   MOVE      BYTIME        KTMSTP
      *
     C     K@MMIN        CHAIN     MMINPEXL0                          89
      *
      ** Populate screen fields
      *
     C                   EVAL      #0GTEE = *BLANKS
     C                   EVAL      #0QUAL = *BLANKS
     C                   EVAL      #0FMAT = *BLANKS
     C                   EVAL      WDDLNO = *BLANKS
     C     *IN89         IFEQ      *OFF
     C                   EVAL      #0GTEE = LGTEEEXINV
     C                   EVAL      #0QUAL = LQUALEXINV
     C                   EVAL      #0FMAT = LFMATEXINV
     C                   EVAL      WDDLNO  = LDLNOEXINV
     C                   ENDIF
      *
     C                   EXSR      SRVCLR
      *
     C                   IF        PActn <> 'E'
      *
     C                   EVAL      LGTEEEX = #0GTEE
     C                   EVAL      LQUALEX = #0QUAL
     C                   EVAL      LFMATEX = #0FMAT
      *
     C                   CALLB     'MMLNASPEXV'
     C                   PARM                    ExtData
     C                   PARM                    ULMDAT
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    WDDLNO
     C                   PARM                    OkFlags
     C                   PARM                    BJDFIN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      ** ZASNMS - Send to program's message queue                     *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##PGM         PZAPGMQ
     C                   PARM                    PZAPGRL
     C                   PARM                    PZAMSID
     C                   PARM                    PZAMSGF
     C                   PARM                    PZAMSDA
     C                   PARM                    PZAMSTP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Action Code
     C                   PARM                    PActn
      *
      ** Data
     C                   PARM                    Data
      *
      ** Return
     C                   PARM                    PW8rtn
      *
      ** Window Length
     C                   PARM                    PWLEN
      *
      ** Window Width
     C                   PARM                    PWWID
      *
      ** Row
     C                   PARM                    PSROW
      *
      ** Column
     C                   PARM                    PSCOL
      *
      ** Title
     C                   PARM                    PTITLE
      *
      ** Spare Parms
     C                   PARM                    PSPARE2
      *
      ** Key Lists
      *
     C     K@MMIN        KLIST
     C                   KFLD                    KFOID
     C                   KFLD                    KTMSTP
      *
     C                   EVAL      DBPGM = 'MMNASPRPR1'
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      ** Database error
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE = 1
     C                   MOVEL     P@OPTN        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
