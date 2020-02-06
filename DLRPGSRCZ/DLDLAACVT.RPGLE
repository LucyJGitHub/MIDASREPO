     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('DL Adjustment Accrued Int File to Screen Format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAACVT - Midas DL Adjustment to Accrued Interest          *
      *              Details Conversion:                              *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a STRANSF      *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1096788          Date 18Mar13               *
      *                 CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      *
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** STRANF Transaction Details in File Format
     D*TranFilFmt    E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D TranFilFmt    E DS                  EXTNAME(STRANF)                                 AR1096788
      ** DLDLAAPD Transaction Details in Screen Format
     D TrnDets       E DS                  EXTNAME(DLDLAAPD)
      ** External DS For Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS For Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS For SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D @CURR         E DS                  EXTNAME(SDCURRPD)
      ** First DS For Access Programs, Shirt Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS For Acess Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Set screen fields
      *
     C                   EXSR      SCREEN
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
      ** Action Type
     C                   MOVEL     FLTYLC        DDACTN
      ** Transaction Number 1
     C                   MOVEL     FLTRNN        DDTRNN
      ** Deal Number 2
     C                   MOVEL     DLNO          DDDLNO
      ** Customer Number 3
     C                   MOVEL     CNUM          DDCNUM
      ** Adjustment 4
     C     MAAM          IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDMAAM
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     MAAM          @@AMTW
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDMAAM
     C                   ENDIF
      ** Sign 5
     C                   EVAL      DDSIGN = SIGN
      ** Currency 6
     C                   EVAL      DDCCY  = CCY
      ** Ours/Theirs 7
     C                   EVAL      DDINIRS = INIRS
      ** Unsetteled Interest 8
     C     USIT          IFEQ      *ZERO
     C                   MOVEL     *BLANKS       USIT
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      USIT          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDUSIT
     C                   ENDIF
      ** Unsettled Interest Sign 10
     C                   EVAL      DDUSGN = FLUSGN
      ** Cost Of Funds Accrual Adjustment 11
     C     AACF          IFEQ      *ZERO
     C                   MOVEL     *BLANKS       AACF
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      AACF          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDAACF
     C                   ENDIF
      ** Funding Sign
     C                   EVAL      DDFSGN = FSGN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM      A6NBDP        @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization
      *****************************************************************
     C     INIT          BEGSR
      ** Blank outputs (EXCEPT FOR ACTION CODE)
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     ##ACTN        DDACTN
      *
      ** Call Access Program for Currency Details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    CCY
     C     @CURR         PARM      @CURR         DSSDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** TrnFilFmt  Transaction Details File Format
      *
     C                   PARM                    TranFilFmt
      *
      ** Output Parameters
      *
      ** TrnDets    Transaction Details Screen Format
      *
     C                   PARM                    TrnDets
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'DLDLAACVT'
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Dealing Details
      *
     C                   CALL      'AODEALR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDDEAL        PARM      SDDEAL        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
