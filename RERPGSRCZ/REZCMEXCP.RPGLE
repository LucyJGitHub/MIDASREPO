     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Mgt Chk for Sweep/Top Exceptions')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RECMEXCP - Midas RE Cash Management Check for SWEEP/TOP      *
      *             Exceptions                                        *
      *                                                               *
      *  Function:  This user check program will check for the        *
      *             folowing:                                         *
      *             Incoming MT101:                                   *
      *             1.   Blocked ZB/Sweeping                          *
      *             2.   Top Account is closed                        *
      *             3.   Top Account is inactive                      *
      *             4.   Top Account is bankrupt                      *
      *             5.   Top Account is in bad debt                   *
      *             6.   Top Account is blocked on debits             *
      *             7.   Top Account requires referral on debits      *
      *             8.   No cover on top account                      *
      *             9.   Holiday in account currency                  *
      *            10.   Date must not be before backvalue date       *
      *                  or over forward value date                   *
      *             Incoming MT103:                                   *
      *             1.   Blocked ZB/Sweeping                          *
      *             2.   Top Account is closed                        *
      *             3.   Top Account is inactive                      *
      *             4.   Top Account is blocked on credits            *
      *             5.   Top Account requires referral on credits     *
      *             6.   Floor limit on top exceeded (Inc Reply MT103)*
      *             7.   Holiday in account currency                  *
      *             8.   Date must not be before backvalue date       *
      *                  or over forward value date                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. 223783             Date 28May12               *
      *  Prev Amend No. AR928996A          Date 03May12               *
      *                 AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 215902  *CREATE    Date 07Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  223783 - Call AOIBANR4 with correct parameter                *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *             (Child: AR676229)                                 *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215902 - Incoming MT101 and MT103 must be checked for        *
      *           exceptions.  Created as part of CRE008.             *
      *                                                               *
      *****************************************************************

     FREZSHLJ1  IF   E           K DISK
     FREZSHLL0  IF   E           K DISK
     F                                     RENAME(REZSHLD0:REZSHLDX)
     FRECMBRL1  IF   E           K DISK

      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      * Incoming Message Data Structure
     D/COPY MECPYSRC,ME1100_ILE
      *****************************************************************
     D
     D ACCT          E DS                  EXTNAME(ACCNTAB)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D                                     PREFIX(X_)
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
     D
      *****************************************************************
     D                 DS
     D  @Top                   1     35
     D  @Slash                 1      1
     D  @Retail                2     11
     D  @Blank24              12     35
     D***@GLaccount             2     19                                                      CGL029
     D  @GLaccount             2     25                                                       CGL029
     D  @GLBrca                2      4
     D**@GLCnum*               5     10  0                                                    CSD027
     D  @GLCnum                5     10                                                       CSD027
     D  @GLCcy                11     13
     D***@GLAcod               14     17                                                      CGL029
     D***@GLAcsq               18     19                                                      CGL029
     D***@GLBlank16            20     35                                                      CGL029
     D  @GLAcod               14     23                                                       CGL029
     D  @GLAcsq               24     25                                                       CGL029
     D  @GLBlank16            26     35                                                       CGL029
     D  @IBAN                  2     35

     D WVDAT           DS             6
     D  YY                     1      2
     D  MM                     3      4
     D  DD                     5      6

     D WPSTA           S             15
     D @PSTA           S             15  0
     D WVDATD          S              6
     D @VALD           S              6  0
     D DateIn          S              6
     D DaynoOut        S              5P 0
     D WDFIN           S              1
     D ErrorFlag       S              1
     D X               S              3  0
     D KACCD           S             10  0                                                    CGL029
     D P@ACCD          S             10                                                       CGL029
      *****************************************************************

      ** Define entry parameters
     C     *ENTRY        PLIST
      ** Return Code Parameter
     C                   PARM                    RTNCDE            7
      ** Incoming Message Header
     C                   PARM                    PHEAD
      ** Incoming Message Data
     C                   PARM                    PDATA
     C                   PARM                    PDAT2                                        CSW209
      ** Subset of FT message data relating for a specific message tag
     C                   PARM                    SBSMSG          251
      ** Pattern which can be applied to the function
     C                   PARM                    PATTRN           32
      ** Operator (GE, LE, GT, LT)
     C                   PARM                    POPER             2
      ** Message tag
     C                   PARM                    PMTAG             5
      ** Logging require
     C                   PARM                    PREPT             1
      ** Program for messages
     C                   PARM                    PCPGM            10
      ** Return Field
     C                   PARM                    RETFLD          256
      *
      * Define Key List
     C     KYACCO        KLIST
     C**********         KFLD                    KCNUM             6 0                        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KCCY              3
     C**********         KFLD                    KACCD             4 0                        CGL029
     C                   KFLD                    KACCD                                        CGL029
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KBRCA             3
      *
      * Define Key List
     C     KHier         KLIST
     C                   KFLD                    CLHIER
     C                   KFLD                    CLLINK
      *
     C     KRECMBR       KLIST
     C                   KFLD                    CLHIER
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACCD
     C                   KFLD                    KACSQ

      *  Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      *  Access Cash Management Details

     C                   CALLB     'AOCMANR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY
      *
      *  Check if IBAN feature is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*VERIFY'     P@OPTN            7
     C                   PARM      'CFT004'      P@SARD            6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      ** Allow IBAN processing
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   MOVE      'N'           CFT004
     C                   END
      *
      * Begin Processing
      *
     C                   MOVE      PCPGM         ##PGM            10
     C                   MOVEL     'F      '     RTNCDE
     C                   MOVE      'N'           FOUND             1
     C                   MOVE      'N'           WClosed           1
     C                   MOVE      'N'           WReferDR          1
     C                   MOVE      'N'           WReferCr          1
     C                   MOVE      'N'           WBlockDR          1
     C                   MOVE      'N'           WBlockCR          1
     C                   MOVE      'N'           WInactive         1
     C                   MOVE      'N'           WBankrupt         1
     C                   MOVE      'N'           WBadDebt          1
     C                   MOVE      'N'           WNoCover          1
     C                   Move      'N'           WFlrLimit         1
     C                   Move      'N'           WHoliday          1
     C                   Move      'N'           WHolDef           1
     C                   Move      'N'           WFVDate           1
     C                   Move      'N'           WBVDate           1
     C                   Move      'N'           WBlockZBS         1
      *
      * First, retrieve top account and posting details
     C                   EXSR      GetTopPost
      *
     C                   If        FOUND = 'Y'
      * Then get account status
     C                   EXSR      GetAcStatus
      * Check if blocked for ZB/Sw
     C                   EXSR      ChkBlockZBS
      * Check for cover
     C     PMTPY         IFEQ      '101'
     C                   EXSR      ChkCover
     C                   ENDIF
      * Check floor limit
     C                   EXSR      ChkFlrLimit
      * Check holiday
     C                   EXSR      ChkHoliday
      * Check forward and backvalue
     C                   EXSR      ChkBackFwd
      * Issue exception
     C                   EXSR      IssueExcep
      *
     C                   If        WClosed   <> 'Y'  And
     C                             WBlockDR  <> 'Y'  And
     C                             WBlockCR  <> 'Y'  And
     C                             WInactive <> 'Y'  And
     C                             WBankrupt <> 'Y'  And
     C                             WBadDebt  <> 'Y'  And
     C                             WNoCover  <> 'Y'  And
     C                             WFlrLimit <> 'Y'  And
     C                             WHoliday  <> 'Y'  And
     C                             WHolDef   <> 'Y'  And
     C                             WFVDate   <> 'Y'  And
     C                             WBVDate   <> 'Y'  And
     C                             WBlockZBS <> 'Y'
      *
     C                   Movel     'T      '     RTNCDE
     C                   ENDIF
      *
     C                   Else
     C* Top Account not found
     C                   If        PREPT = 'Y'
     C                   If        PMTPY = '101'
     C     MEMSDT        Cat       '50H':0       MEMSDT
     C                   Else
     C     MEMSDT        Cat       '59':0        MEMSDT
     C                   Endif
     C                   MOVEL     PCPGM         MEPGMQ
     C                   MOVEL     'REUSRMSG'    MEMSGF
     C                   MOVEL     'RE75409'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C                   Endif
      *
     C                   RETURN
      *
     C**********************************************************************
     C* SR/GetTopPost = Get Top Account and Posting Details
     C**********************************************************************
     C*
     C     GetTopPost    BEGSR
     C*
     C* If MT101, use fld 50....MT103, fld 59
     C     PMTPY         IFEQ      '101'
     C                   MOVEL     PH50          DSTRAN
     C                   ELSE
     C                   MOVEL     P59           DSTRAN
     C                   ENDIF
     C                   MOVEL     TMLIN         @Top
      *
     C     @Slash        IFEQ      '/'
     C                   SELECT
     C* Get GL account if retail given
     C     @Blank24      Wheneq    *Blank
     C                   MOVEL     @Retail       P@RETL
     C                   CALL      'AOACCTR0'                           90
     C                   PARM                    P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10
     C                   PARM      *BLANK        P@CNUM            6
     C                   PARM      *BLANK        P@CUCD            3
     C**********         PARM      *BLANK        P@ACCD            4                          CGL029
     C                   PARM      *BLANK        P@ACCD                                       CGL029
     C                   PARM      *BLANK        P@ACSQ            2
     C                   PARM      *BLANK        P@BRCA            3
     C     ACCT          PARM      ACCT          DSSDY
     C*
     C     P@RTCD        IFEQ      *BLANK
     C     RECI          ANDEQ     'D'
     C                   MOVEL     BRCA          KBRCA
     C**********         Z-ADD     CNUM          KCNUM                                        CSD027
     C                   EVAL      KCNUM =       CNUM                                         CSD027
     C                   MOVEL     CCY           KCCY
     C                   Z-ADD     ACOD          KACCD
     C                   Z-ADD     ACSQ          KACSQ
     C                   MOVEL     'Y'           FOUND
     C                   ENDIF
     C*
     C* CHECK  IF GL ACCOUNT
     C     @GLBlank16    Wheneq    *BLANK
     C                   MOVEL     @GLBrca       P@BRCA
     C                   MOVE      @GLCnum       P@CNUM
     C                   MOVEL     @GLCcy        P@CUCD
     C                   MOVE      @GLAcod       P@ACCD
     C                   MOVE      @GLAcsq       P@ACSQ
     C                   CALL      'AOACCTR0'                           90
     C                   PARM                    P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *BLANK        P@RETL           10
     C                   PARM                    P@CNUM            6
     C                   PARM                    P@CUCD            3
     C**********         PARM                    P@ACCD            4                          CGL029
     C                   PARM                    P@ACCD                                       CGL029
     C                   PARM                    P@ACSQ            2
     C                   PARM                    P@BRCA            3
     C     ACCT          PARM      ACCT          DSSDY
     C*
     C     P@RTCD        IFEQ      *BLANK
     C     RECI          ANDEQ     'D'
     C                   MOVEL     BRCA          KBRCA
     C**********         Z-ADD     CNUM          KCNUM                                        CSD027
     C                   EVAL      KCNUM =       CNUM                                         CSD027
     C                   MOVEL     CCY           KCCY
     C                   Z-ADD     ACOD          KACCD
     C                   Z-ADD     ACSQ          KACSQ
     C                   MOVEL     'Y'           FOUND
     C                   ENDIF
     C*
     C* Get GL account if IBAN given
     C     CFT004        Wheneq    'Y'
     C                   CALL      'AOIBANR4'                           90
     C                   PARM                    P@RTCD
     C**********         PARM      '*VERIFY'     P@OPTN                                       223783
     C                   PARM      '*KEY   '     P@OPTN                                       223783
     C                   PARM                    @IBAN
     C     ACCT          PARM      ACCT          DSSDY
     C*
     C     P@RTCD        IFEQ      *BLANK
     C     RECI          ANDEQ     'D'
     C                   MOVEL     BRCA          KBRCA
     C**********         Z-ADD     CNUM          KCNUM                                        CSW209
     C                   EVAL      KCNUM =       CNUM                                         CSW209
     C                   MOVEL     CCY           KCCY
     C                   Z-ADD     ACOD          KACCD
     C                   Z-ADD     ACSQ          KACSQ
     C                   MOVEL     'Y'           FOUND
     C                   ENDIF
     C*
     C                   ENDSL
     C                   ENDIF
     C*
     C* Get Hierarchy Details
     C                   Movel     *blanks       X_RTCD
     C*
     C                   If        FOUND = 'Y'
     C     KYACCO        Chain     REZSHLJ1                           70
     C                   If        *IN70 = '0'
     C     KHier         Chain     REZSHLL0                           70
     C                   If        *IN70 = '0'
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      *BLANK        I_HTYP            2

     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
     C                   Endif
     C                   Endif

      * End if error occurred in module
      * or if no record found

     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C     *IN70         OREQ      '1'
     C                   Movel     CLHIER        WHier             9
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + WHier
     C                   Movel     'N'           FOUND
     C                   ENDIF
      *
      *  Retrieve Currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CLCCCY        @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Endif
      *
      *  Retrieve Posting Amount
     C                   If        PMTPY = '101'
     C                   Eval      WPSTA = %subst(P32B : 28 : 15)
     C                   Else
     C                   Eval      WPSTA = %subst(PDCA : 34 : 15)
     C                   Endif
     C                   Eval      X=%scan(',' : WPSTA)
      *
     C                   If        X > 0
     C                   Eval      %Subst(WPSTA: X : 1) = '.'
     C                   Eval      ZFIELD = *blanks
     C                   Move      WPSTA         ZFIELD
     C                   Z-add     A6NBDP        ZADEC
     C                   Eval      ZADIG = 13 - A6NBDP
      *
     C                   Call      'ZALIGN'                             90
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZAFLD            16
      *
     C                   If        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     04            DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 004 *
     C                   MOVEL     'ZALIGN  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Move      ZAFLD         @PSTA
     C                   Endif
      *
      *  Retrieve Posting Value date
     C     PMTPY         IfEQ      '101'
     C                   Eval      WVDAT = %subst(PH30 : 25 : 6)
     C                   Else
     C                   Movel     PDCA          DSTRAN
     C                   Movel     TVVDAT        WVDAT
     C                   Endif
     C                   Eval      WVDATD = DD + MM + YY
     C                   Movel     WVDATD        DateIn
     C                   Callb     'ZDATE1'                             90
     C                   PARM                    DateIn
     C                   PARM                    DayNoOut
     C                   PARM      'D'           WDFIN
     C                   PARM                    ErrorFlag
      *
     C                   If        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 002 *
     C                   MOVEL     'ZDATE1  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Z-add     DayNoOut      @VALD
     C*
     C                   ENDSR
     C*
     C**********************************************************************
     C* SR/GetAcStatus - Get Account Status
     C**********************************************************************
     C*
     C     GetAcStatus   BEGSR
     C*
      *
     C* Account closed
     C     RECI          IFNE      'D'
     C     ACST          OREQ      'C'
     C                   MOVEL     'Y'           WClosed
     C                   ENDIF
     C*
     C* Referral on Debits required
     C                   TESTB     '0'           RETB                     99
     C   99              MOVE      'Y'           WReferDR
     C*
     C* Referral on Credits required
     C                   TESTB     '1'           RETB                     99
     C   99              MOVE      'Y'           WReferCR
     C*
     C* Block Debit
     C                   TESTB     '2'           RETB                     99
     C   99              MOVE      'Y'           WBlockDR
     C*
     C* Block Credit
     C                   TESTB     '3'           RETB                     99
     C   99              MOVE      'Y'           WBlockCR
     C*
     C* Inactive
     C                   TESTB     '4'           RETB                     99
     C   99              MOVE      'Y'           WInactive
     C*
     C* Bankrupt
     C                   TESTB     '6'           RETB                     99
     C   99              MOVE      'Y'           WBankrupt
     C*
     C* Bad debt
     C                   TESTB     '7'           RETB                     99
     C   99              MOVE      'Y'           WBadDebt
     C*
     C                   ENDSR
     C**********************************************************************
     C* SR/ChkBlockZBS - Check if Blocked for ZB/S
     C**********************************************************************
     C*
     C     ChkBlockZBS   BEGSR

      * Sweeping Blocked?
     C     KRECMBR       CHAIN     RECMBRL1                           99        *
     C  N99              MOVE      'Y'           WBlockZBS
     C*
     C                   ENDSR
     C**********************************************************************
     C**********************************************************************
     C* SR/ChkCover - Check for Cover
     C**********************************************************************
     C*
     C     ChkCover      BEGSR

      * If check for cover on top a/c is not done
      *  then top a/c balance & overdraft are not monitored

     C                   Z-ADD     *ZERO         TopBalance       15 0
     C                   MOVE      *ALL'9'       TopOverDft       15 0

     C     ZDCHKC        IFEQ      'Y'
     C                   CALLB     'RE100615'
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM      'I/C'         I_MODE            3
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      *ZERO         TopBalance
     C                   PARM      *ZERO         TopOverDft
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN DETERMINE TOP BALANCE'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *  Access amount from message
     C                   Eval      TopBalance = TopBalance + @PSTA
     C     TopBalance    IFGT      TopOverDft
     C                   Movel     'Y'           WNoCover
     C                   Endif
     C
     C*
     C                   ENDSR
     C**********************************************************************
     C* SR/ChkFlrLimit - Check for Floor Limit
     C**********************************************************************
     C*
     C     ChkFlrLimit   BEGSR
     C
     C*  Check floor limit only for Incoming Reply MT103s as  the top
     C*  account here is not a master account.
     C*  For Incoming MT101 and Incoming MT103 Direct Sweep, this check is not done
     C*  because the top account is master account and this check is not
     C*  applicable
     C
     C     PMTPY         IFEQ      '103'
     C
     C* This is a reply MT103 if '*TRNO' exists in Retfld
     C
     C     '*TRNO'       SCAN      RETFLD                                 25
     C                   IF        *IN25 = *ON
     C
     C     ZLFLFT        IFGT      @PSTA
     C                   Move      'Y'           WFlrLimit         1
     C                   Endif
     C
     C                   Endif
     C
     C                   Endif
     C
     C                   ENDSR
     C**********************************************************************
     C* SR/ChkHoliday  - Check for Holiday
     C**********************************************************************
     C*
     C     ChkHoliday    BEGSR
     C
     C* For MT101, check holiday only if value date is greater than or equal to
     C* today's date
     C
     C     PMTPY         IFEQ      '101'
     C     @VALD         ANDGE     BJRDNB
     C
     C* For MT103, check holiday if:
     C*       Holiday convention is "Exclude"
     C
     C     PMTPY         OREQ      '103'
     C     @VALD         ANDGE     BJRDNB
     C     ZDSHOC        ANDEQ     'E'
     C
     C                   Z-ADD     @VALD         ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      CLCCCY        ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM      *BLANK        ZHOLID            1
     C     ZHOLID        IFEQ      'H'
     C                   MOVEL     'Y'           WHoliday
     C                   ENDIF
     C                   ENDIF
     C
     C*  For deferred sweeps:
     C* For MT101, check that today is a holiday if deferred sweep
     C
     C     PMTPY         IFEQ      '101'
     C     @VALD         ANDLT     BJRDNB
     C
     C* For MT103, check today is a holiday if deferred sweep and
     C*       Holiday convention is "Exclude"
     C
     C     PMTPY         OREQ      '103'
     C     @VALD         ANDLT     BJRDNB
     C     ZDSHOC        ANDEQ     'E'
     C
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      CLCCCY        ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM      *BLANK        ZHOLID            1
     C     ZHOLID        IFEQ      'H'
     C                   MOVEL     'Y'           WHolDef
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDSR
     C**********************************************************************
     C* SR/ChkBackFwd  - Check Date is within BackValue and Forward Value Dates
     C**********************************************************************
     C*
     C     ChkBackFwd    BEGSR

      *  Determine External Forward and Back Value dates
     C                   MOVEL     CMEFVD        I_FVD
     C                   MOVEL     CMEBVD        I_BVD

     C*  If Back Value Days is '00', consider deferred sweeps and
     C*  change number to 01.
     C                   If        %subst(I_BVD:1:2) = '00' OR
     C                             %subst(I_BVD:1:2) = '  '
     C                   Eval      %subst(I_BVD:1:2) = '01'
     C                   If        %subst(I_BVD:3:1) = ' '
     C                   Eval      %subst(I_BVD:3:1) = 'B'
     C                   Endif
     C                   Endif
     C*  If Incoming MT103 and Forward value Days is '00', change to '02' to cover
     C*  date offset from the sending bank
     C                   If        PMTPY = '103'
     C                   If        %subst(I_FVD:1:2) = '00'  OR
     C                             %subst(I_FVD:1:2) = '  '
     C                   Eval      %subst(I_FVD:1:2) = '02'
     C                   If        %subst(I_FVD:3:1) = ' '
     C                   Eval      %subst(I_FVD:3:1) = 'B'
     C                   Endif
     C                   Endif
     C                   Endif

     C                   CALLB     'REZFWDBCK'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS

      * Forward value days
      * Back value days
     C                   PARM                    I_FVD             3
     C                   PARM                    I_BVD             3

      * SDBANKPD
     C                   PARM                    SDBANK

      * OUTPUTS
      * Forward value date
      * Back value date
     C                   PARM                    O_FVDate          5 0
     C                   PARM                    O_BVDate          5 0

      * End if error occurred in module

     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN FORWARD AND BACK DAYS'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C     @VALD         IFGT      O_FVDate
     C                   Move      'Y'           WFVDate
     C                   Endif
     C
     C     @VALD         IFLT      O_BVDate
     C                   Move      'Y'           WBVDate
     C                   Endif
     C
     C                   ENDSR
     C**********************************************************************
      * IssueExcep - Issue Exception messages
      ********************************************************************
     C     IssueExcep    BEGSR
     C
     C     PREPT         IFEQ      'Y'
     C
     C                   MOVE      *BLANKS       MEMSDT
     C                   MOVEL     PCPGM         MEPGMQ
     C                   MOVEL     'REUSRMSG'    MEMSGF
     C
     C*  Top Account is Blocked for ZB/SW
     C                   If        WBlockZBS = 'Y'
     C                   MOVEL     'RE76015'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Top Account is closed.
     C                   If        WClosed   = 'Y'
     C                   MOVEL     'RE76000'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Top Account is inactive.
     C                   If        WInactive = 'Y'
     C                   MOVEL     'RE76001'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Date is beyond Forward Value Date
     C                   If        WFVDate = 'Y'
     C                   MOVEL     'RE76013'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Date is beyond Back Value Date
     C                   If        WBVDate = 'Y'
     C                   MOVEL     'RE76014'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Top Account is bankrupt.
     C                   If        WBankrupt = 'Y'
     C                   MOVEL     'RE76004'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Top Account is in bad debt
     C                   If        WBadDebt = 'Y'
     C                   MOVEL     'RE76005'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Deferred Sweep but today is a Holiday
     C                   If        WHolDef   = 'Y'
     C                   MOVEL     'RE76016'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C
     C                   If        PMTPY = '101'
     C
     C*  Top Account requires referral for debits.
     C                   If        WReferDR  = 'Y'
     C                   MOVEL     'RE76002'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Top Account is blocked on debits
     C                   If        WBlockDR  = 'Y'
     C                   MOVEL     'RE76003'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  No cover on top account
     C                   If        WNoCover = 'Y'
     C                   MOVEL     'RE76006'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  The requested execution date is a holiday in account currency
     C                   If        WHoliday = 'Y'
     C                   MOVEL     'RE76008'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C                   Endif
     C
     C                   If        PMTPY = '103'
     C
     C*  Top Account requires referral for credits
     C                   If        WReferCR  = 'Y'
     C                   MOVEL     'RE76009'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  Top Account is blocked on credits
     C                   If        WBlockCR  = 'Y'
     C                   MOVEL     'RE76010'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  The floor limit on top is exceeded
     C                   If        WFlrLimit= 'Y'
     C                   MOVEL     'RE76011'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C*  The value date is a holiday in account currency
     C                   If        WHoliday = 'Y'
     C                   MOVEL     'RE76012'     MEMSID
     C                   EXSR      MESNMS
     C                   Endif
     C
     C                   Endif
     C
     C                   Endif
     C
     C                   EndSR
      ********************************************************************
     C     MESNMS        BEGSR
      *
     C     MEPGMQ        IFEQ      *blank
     C                   MOVEL     ##PGM         MEPGMQ
     C                   ENDIF
      *
      * If level to send is blanks default to *SAME
      *
     C     MEPGRL        IFEQ      *BLANK
     C                   MOVEL     '*SAME'       MEPGRL
     C                   ENDIF
      *
      * If no message file specified, use default
      *
     C     MEMSGF        IFEQ      *BLANK
     C                   MOVEL     'MEMSG   '    MEMSGF
     C                   ENDIF
      *
     C                   CALL      'AOCREPT'
     C                   PARM                    MEMSID            7
     C                   PARM                    MEMSGF           10
     C                   PARM                    MEMSFL           10
     C                   PARM                    MEMSDT          256
     C                   PARM                    MEPGRL            5
     C                   PARM                    MEPGMQ           10
     C                   PARM                    MEMSGQ           10
     C                   PARM                    MEMSGT            7
      *
     C                   MOVEL     'Y'           MEMSGS            1
      *
      * Clear all fields for default mechanism next time
      *
     C                   MOVEL     *BLANK        MEMSID
     C                   MOVEL     *BLANK        MEMSFL
     C                   MOVEL     *BLANK        MEMSDT
     C                   MOVEL     *BLANK        MEPGRL
     C                   MOVEL     *BLANK        MEMSGQ
     C                   MOVEL     *BLANK        MEMSGT
      *
     C                   ENDSR
      ********************************************************************
      *
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
