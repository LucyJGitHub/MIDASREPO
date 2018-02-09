     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate buy-sell book')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVBSBK01 - Validate Buy-Sell Book.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 193462             Date 30May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 07Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  222727 - Release 5.0 errors ('Warning' errors block input)   *
      *  CAP067 - Repurchase Agreements API.                          *
      *  193462 - Error message MMA1106 incorrectly presented.        *
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
 
      ** Index for arrays of warning message ids etc                                          193462
     D WIx             S              3P 0                                                    193462
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
 
     D CallFromVU      S              1A                                                      CAP087
     D*TCNR*****       S              6S 0                                                    CSD027
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
     C                   Z-ADD     0             WIx                                          193462
 
      ** Clear output book portfolio details
 
     C**********         Z-ADD     *ZERO         PNCNUM                                       CSD027
     C                   EVAL      PNCNUM = *BLANKS                                           CSD027
     C                   MOVEL     *BLANK        PNPTFR
     C                   MOVEL     *BLANK        PNPTCY
     C                   Z-ADD     *ZERO         PNPCDP
 
      ** Clear output trade fields
 
     C                   MOVEL     *BLANK        TDBK
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDBPBK        ANDEQ     *BLANKS
     C     PFBYSL        ANDEQ     *BLANKS                                                    CAP067
     C                   EXSR      BPBKD
     C                   END
      *
      ** VALIDATION - BOOK
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      BPBKV
     C                   END
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
     C                   END
      *
      *** If Buy-Sell Book indicator (BDBYSL) is equal to 'Y' and
      *** the action code (DDACTN) is equal to'I' the book is invalid.
      ** This only refers to trades not entered in Buy-Sell back API.                         CAP067
      *
     C                   IF        BDBYSL = 'Y' AND DDACTN = 'I'
     C                             AND PFBYSL = *BLANK                                        CAP067
     C                             AND CallFromVU <> 'Y'                                      CAP087
     C                   MOVEL     'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1105'     MsgIdXAr(Idx)
     C                   ENDIF
      *                                                                                       193462
      ** If action code is 'C' check to see if valid input.                                   193462
      *                                                                                       193462
      * 1st test Ignore checking if book on file matches that on screen                       193462
      *                                                                                       193462
      * 2nd test if original book is buy/sell back make sure that any                         193462
      * change to book is also buy/sell bak book. Send error message                          193462
      * saying problems may occur and they should change other trade                          193462
      * as well.                                                                              193462
      * 3rd test only do this if an ordinary trading book. Possible to                        193462
      * trade within non buy back/sell trading books but not from ordinary                    193462
      * trading book into a buy sell book.                                                    193462
      *                                                                                       193462
      *                                                                                       193462
      * Disable input fields for book if book is buy/sell and action code is                  193462
      * 'C' for change against original file record.                                          193462
      *                                                                                       193462
     C                   IF        DDACTN = 'C'                                               193462
      *                                                                                       193462
      ** Check buy/sell flag against original trade details on file.                          193462
      *                                                                                       193462
     C                   CALL      'AOBOOKR0'                                                 193462
     C                   PARM      *BLANK        @RTCD             7                          193462
     C                   PARM      '*KEY   '     @OPTN             7                          193462
     C                   PARM      OLDBK1        @BOOK             2                          193462
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        193462
      *                                                                                       193462
     C                   IF        BDBYSL = 'Y'                                               193462
     C                   MOVE      'Y'           OLDBKF            1                          193462
     C                   ELSE                                                                 193462
     C                   MOVE      'N'           OLDBKF                                       193462
     C                   ENDIF                                                                193462
     C                   ENDIF                                                                193462
      *                                                                                       193462
      ** If screen and file version of book are the same ignore                               193462
      *                                                                                       193462
     C     OLDBK1        IFNE      DDBPBK                                                     193462
      ***********                                                                             193462
      ****If*action*code*(DDACTN)*is*equal*to'C'*then*the*changed*Book                        193462
      ****must*have*a*BDBYSL*equal*to*'Y'.                                                    193462
      ***********                                                                             193462
      ** If file version of book is buy sell cannot be changed to ordinary                    193462
      *  book.                                                                                193462
      *                                                                                       193462
     C**********         IF        DDACTN = 'C' AND BDBYSL <> 'Y'                             193462
     C                   IF        OLDBKF <> OLDBKS and OLDBKF = 'Y'                          193462
     C                   MOVEL     'N'           ddBPBKok
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1106'     MsgIdXAr(Idx)
     C                   ENDIF
      ** If file version of book is ordinary cannot be changed to Buy  ary                    193462
      *  sell book                                                                            193462
      *                                                                                       193462
     C                   IF        OLDBKF <> OLDBKS and OLDBKF = 'N'                          193462
     C                   MOVEL     'N'           ddBPBKok                                     193462
     C                   ADD       1             Idx                                          193462
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)                               193462
     C                   MOVEL     'MMA1162'     MsgIdXAr(Idx)                                193462
     C                   ENDIF                                                                193462
      *                                                                                       193462
      ***If*file*version*of book is buy sell warn user if changing to                  193462 222727
      ***different*buy*sell book.                                                      193462 222727
      *******************                                                              193462 222727
     C*******************IF        OLDBKF = 'Y'  and WARNIND <> 'W'                    193462 222727
     C*******************          and OLDBKF =  OLDBKS                                193462 222727
     C*******************ADD       1             WIx                                   193462 222727
     C*******************MOVE      'W'           WARNIND                               193462 222727
     C*******************MOVEL     'DDBPBK'      FldNamXAr(WIx)                        193462 222727
     C*******************MOVEL     'MMA1160'     MsgIdXAr(WIx)                         193462 222727
     C*******************ENDIF                                                         193462 222727
      *******************                                                              193462 222727
      ***If*file*version*of book is ordinary book warn user if changing to             193462 222727
      ***different*ordinary book                                                       193462 222727
      *******************                                                              193462 222727
     C*******************IF        OLDBKF = 'N' and WARNIND <> 'W'                     193462 222727
     C*******************          and OLDBKF =  OLDBKS                                193462 222727
     C*******************ADD       1             WIx                                   193462 222727
     C*******************MOVE      'W'           WARNIND                               193462 222727
     C*******************MOVEL     'DDBPBK'      FldNamXAr(WIx)                        193462 222727
     C*******************MOVEL     'MMA1161'     MsgIdXAr(WIx)                         193462 222727
     C*******************ENDIF                                                         193462 222727
     C                   ENDIF                                                                193492
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the first leg,                    CAP067
      ** store book code                                                                      CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'Y'                                                        CAP067
      *                                                                                       CAP067
     C     OLDBKS        IFNE      'Y'                                                        CAP067
     C                   MOVEL     'N'           DDBPBKOK                                     CAP067
     C                   ADD       1             Idx                                          CAP067
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)                               CAP067
     C                   MOVEL     'MMA1221'     MsgIdXAr(Idx)                                CAP067
     C                   ELSE                                                                 CAP067
     C                   MOVEL     DDBPBK        PFBPBK                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the second leg,                   CAP067
      ** it must be the same as the its first leg's book code, else error                     CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'N'                                                        CAP067
     C     DDBPBK        IFNE      PFBPBK                                                     CAP067
     C                   MOVEL     'N'           DDBPBKOK                                     CAP067
     C                   ADD       1             Idx                                          CAP067
     C                   MOVEL     'DDBPBK'      FldNamXAr(Idx)                               CAP067
     C                   MOVEL     'MMA1215'     MsgIdXAr(Idx)                                CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
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
      *****************************************************************
      ** DEFAULTING
      *****************************************************************
     C     BPBKD         BEGSR
      *
      ** If Bank Portfolio is supported and screen book code is not
      ** entered, default book code as determined from AOPLCSR1.
      *
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDEQ     'B'
     C                   EXSR      AOPLCS
     C     ERPLCS        IFEQ      *BLANKS
     C                   MOVEL     O#BOOK        DDBPBK
     C                   GOTO      EBPBKD
     C                   ENDIF
     C                   ENDIF
      *
      *  If Bulk Agency Trade  : Book = Default Agency Book
      *
     C     DDBLKR        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'I'
     C                   MOVE      BVATBK        DDBPBK
     C                   ELSE
      *
      *  Else default market or portfolio book
      *
     C     CustClass     IFEQ      'M'
     C                   MOVE      BVDMBC        DDBPBK
     C                   ELSE
     C                   MOVE      BVDPBC        DDBPBK
     C                   END
     C                   END
 
     C     EBPBKD        ENDSR
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
      * check screen version of Book.                                                         193462
      *                                                                                       193462
     C                   IF        BDBYSL = 'Y'                                               193462
     C                   MOVE      'Y'           OLDBKS            1                          193462
     C                   ELSE                                                                 193462
     C                   MOVE      'N'           OLDBKS                                       193462
     C                   ENDIF                                                                193462
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
     C                   PARM                    CustClass         1
      *
      ** Security Day Basis
     C                   PARM                    DYBS              1
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell book code                                                             CAP067
     C                   PARM                    PFBPBK            2                          CAP067
      *
      ** ICD
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BVATBK            2
     C                   PARM                    BVDMBC            2
     C                   PARM                    BVDPBC            2
      *
      * Details of original book.                                                             193462
     C                   PARM                    OLDBK1            2                          193462
     C                   PARM                    WARNIND           1                          193462
     C                   PARM                    CallFromVU                                   CAP087
      *                                                                                       193462
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
 
     C                   Z-ADD     0             WIx                                          193462
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
(c) Finastra International Limited 2001
