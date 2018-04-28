     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-Sell Backs Validate Book')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVBSBK02 - Validate Buy-Sell Backs Book.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CSE006  *CREATE    Date 02Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *                                                               *
      *****************************************************************
 
     FPMPORTPD  IF   E           K DISK
 
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
 
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR1
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
 
      ** Book details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** Portfolio Customer Details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*TCNR*******     S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
      ** Clear output book portfolio details
 
     C**********         Z-ADD     *ZERO         PNCNUM                                       CSD027
     C                   MOVE      *BLANKS       PNCNUM                                       CSD027
     C                   MOVEL     *BLANK        PNPTFR
     C                   MOVEL     *BLANK        PNPTCY
     C                   Z-ADD     *ZERO         PNPCDP
 
      ** Clear output trade fields
 
     C                   MOVEL     *BLANK        TDBK
      *
      ** VALIDATION - BOOK
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      BPBKV
     C                   ENDIF
      *
      ** VALIDATION - BOOK/PORTFOLIO
      *
     C     Validate      IFEQ      'Y'
     C     BGPFMG        ANDEQ     'Y'
     C     FCPORS        ANDEQ     'B'
     C     ddBPBKok      ANDNE     'N'
     C                   EXSR      BPBK_PORTV
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBPBKOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     BPBKV         BEGSR
      *
      * Book
      *
      *  .. It must reference an active record on SDBOOKPD
      *     & can't trade on amortising book if day basis '4' on SECTY
      *
     C                   EXSR      AOBOOK
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0495'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      BDBKCD        DDBPBK
     C                   END
      *
     C     BDSTAM        IFEQ      'Y'
     C     DYBS          ANDEQ     '4'
     C                   MOVEL     'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0496'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      * The Book must have a Buy-Sell Back indicator equal to 'Y'
     C                   IF        BDBYSL <> 'Y'
     C                   MOVEL     'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0725'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      * Update trade
      *
     C                   MOVE      DDBPBK        TDBK
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - BOOK/PORTFOLIO
      *****************************************************************
     C     BPBK_PORTV    BEGSR
      *
      ** Get portfolio details for book
      *
     C                   EXSR      AOPLCS
      *
      ** Portfolio Reference must exist for book.
      *
     C     ERPLCS        IFEQ      'PMA0011'
     C                   MOVE      'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0497'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Associated portfolio reference must exist for branch
      ** internal customer number in Portfolio  Definition Details
      ** File (PMPORTPD)
      *
     C     ERPLCS        IFEQ      *BLANKS
      *
     C                   MOVEL     QBCUST        PNCNUM
     C                   MOVEL     O#PTFR        PNPTFR
      *
     C     O#PTFR        IFNE      FCR997
      *
     C     PORTKY        CHAIN     PMPORTPD                           44
      *
     C                   SELECT
     C     *IN44         WHENEQ    *ON
     C     *IN44         OREQ      *OFF
     C     PNRECI        ANDNE     'D'
     C                   MOVE      'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0498'     MsgIdXAr(Idx)
      *
      ** Portfolio must not be flagged for closure
      *
     C     *IN44         WHENEQ    *OFF
     C     PNDPCL        ANDGT     0
     C                   MOVE      'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0499'     MsgIdXAr(Idx)
     C                   ENDSL
      *
     C                   ELSE
     C                   MOVEL     QBCSBY        PNPTCY
     C                   MOVEL     QBBYDP        PNPCDP
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      *
      * AOBOOK - Subroutine to call access object : Book details
      *
      ********************************************************************
     C     AOBOOK        BEGSR
      *
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBPBK        @BOOK             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      * AOPLCS - Subroutine to call access object : portfolio customers
      *
      ********************************************************************
     C     AOPLCS        BEGSR
 
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     TCNR          I#CUST
     C                   MOVEL     DDBRCD        I#BRCA
     C                   MOVEL     DDBPBK        I#BOOK
     C                   MOVEL     *BLANK        I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
 
     C                   CALL      'AOPLCSR1'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
 
     C                   MOVEL     P@RTCD        ERPLCS            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDACTN            1
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDBRCD            3
      *
      ** Trade details
     C                   PARM                    TCNR
      *
      ** Security Day Basis
     C                   PARM                    DYBS              1
      *
      ** ICD
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BVATBK            2
     C                   PARM                    BVDMBC            2
     C                   PARM                    BVDPBC            2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Book portfolio details
     C                   PARM                    PNCNUM
     C                   PARM                    PNPTFR
     C                   PARM                    PNPTCY
     C                   PARM                    PNPCDP
      *
      ** Book - OK
     C                   PARM                    DDBPBKOK          1
      *
      ** Trade Book
      *
     C                   PARM                    TDBK              2
 
     C     PORTKY        KLIST
     C                   KFLD                    PNCNUM
     C                   KFLD                    PNPTFR
 
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
(c) Misys International Banking Systems Ltd. 2001
