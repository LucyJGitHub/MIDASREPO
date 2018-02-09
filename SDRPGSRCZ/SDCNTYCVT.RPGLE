     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Country Conversion: File to Screen Format')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCNTYCVT - Country Details Transaction Details Conversion:  *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of the Country    *
      *             Details from file to screen format  ' .           *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
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
 
     D CntyFilFmt    E DS                  EXTNAME(SDCTRYPD)
      ** Country Details in File Format
     D Ctx1FilFmt    E DS                  EXTNAME(SDCTX1PD)
      ** Lux Country Details 1 in File Format
     D Ctx2FilFmt    E DS                  EXTNAME(SDCTX2PD)
      ** Lux Country Details 2 in File Format
 
     D CurTrCnty     E DS                  EXTNAME(SDCntyPD)
      ** Country Details in Screen Format
     D CurTrCnt1     E DS                  EXTNAME(SDCnt3PD)
     D                                     PREFIX(S1_)
      ** Lux Country Screen 1 format
     D CurTrCnt2     E DS                  EXTNAME(SDCnt2PD)
     D                                     PREFIX(S2_)
      ** Lux Country Screen 2 format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
      ** Parameters for ZEDIT
 
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
      ** Parameters for ZDATE2
 
     D ##ACTN          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
     C                   EXSR      INIT
 
      ** Set screen fields
     C                   EXSR      SCREEN
 
      ** Return
     C                   RETURN
 
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
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Country Details File Format
     C                   PARM                    CntyFilFmt
      * Lux Country Details 1 File Format
     C                   PARM                    Ctx1FilFmt
      * Lux Country Details 2 File Format
     C                   PARM                    Ctx2FilFmt
      *
 
      * Output Parameters
 
      * Country Details Screen Format
     C                   PARM                    CurTrCnty
      * Lux Country Screen 1 Format
     C                   PARM                    CurTrCnt1
      * Lux Country Screen 2 Format
     C                   PARM                    CurTrCnt2
 
      ** Initialise program name
     C                   EVAL      DBPGM = 'SDCNTYCVT'
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
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
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
     C                   MOVEL     DDACTN        ##ACTN
     C                   MOVEL     *BLANK        CurTrCnty
     C                   MOVEL     *BLANK        CurTrCnt1
     C                   MOVEL     *BLANK        CurTrCnt2
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      ** Country Code
     C                   EVAL      DDCNCD = A4CNCD
      ** Region Code
     C                   EVAL      DDRGCD = A4RGCD
      ** Country Name
     C                   EVAL      DDCNNM = A4CNNM
      ** ISO Country code
     C                   EVAL      DDISOC = A4ISOC
      ** BBAN total length
     C     A4BBAN        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDBBAN
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A4BBAN        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDBBAN
     C                   ENDIF
      ** BBAN bank length
     C     A4BBRL        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDBBRL
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A4BBRL        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDBBRL
     C                   ENDIF
      ** Associated currency
     C                   EVAL      DDCTAY = A4CTAY
      ** Zip code
     C                   EVAL      DDCTZP = A4CTZP
      ** Weighting code
     C     A4CTWC        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDCTWC
     C                   ELSE
     C**********         MOVE      *BLANKS       ZFIELD                                      BG12120
     C**********         MOVE      A4CTWC        ZFIELD                                      BG12120
     C**********         Z-ADD     0             ZADEC                                       BG12120
     C**********         EXSR      ZEDIT                                                     BG12120
     C**********         MOVE      ZFIELD        DDCTWC                                      BG12120
     C                   MOVE      A4CTWC        DDCTWC                                      BG12120
     C                   ENDIF
 
      ** End of Tax Year
     C     A4ETXY        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDETXY
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A4ETXY        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDETXY
     C                   ENDIF
 
      ** Reporting Frequency
     C                   EVAL      DDRPFQ = A4RPFQ
 
      ** Currency of Tax
     C                   EVAL      DDTXCY = A4TXCY
      ** Joint Account Management
     C                   EVAL      DDJAMG = A4JAMG
 
      ** Country of Tax (Y/N)
     C                   EVAL      DDCTTX = A4CTTX
 
      ** Include in EMU Zone Y/N
     C                   EVAL      S1_DDEMUZ = CTEMUZ
 
      ** Industrialised Country
     C                   EVAL      S2_DDICTR = WFICTR
 
      ** EMU Member
     C                   EVAL      S2_DDEMUM = WFEMUM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
