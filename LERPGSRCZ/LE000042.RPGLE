     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Available Balance Retrieval')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE000042 - Available Balance Retrieval                       *
      *                                                               *
      *  Function:  This will recalculate for the Available Balances  *
      *  (COB)      using ABC Criteria                                *
      *                                                               *
      *  Called By: LEC000475 - Pre-check Auto-settlements            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD049078           Date 12Jan18               *
      *  Prev Amend No. MD034451C          Date 02Mar16               *
      *                 MD030959           Date 17Jun15               *
      *                 CLE164             Date 18Aug14               *
      *                 AR1021979 *CREATE  Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD049078 - Wrong postings of MR and RE of PDCL loan          *
      *  MD034451C - Recompiled due to changed PF/HELDIHB.            *
      *  MD030959 - Recompiled due to changed PF/HELDIHC.             *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR1021979 - PDP/CLE134 Enhancements                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         General Indicator Used For CHAIN                *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR      - Initialise                                      *
      * *PSSR       - Error processing                                *
      * SRWorkDay   - Set working dates for today and next n working  *
      *               days                                            *
      * SRBaseAvail - Calculate Base Available Balance                *
      * SROverDraft - Retrieve OverDraft Repayment                    *
      *                                                               *
      *****************************************************************
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      ** Midas GL Accounts master
 
     FGLCOLLLG  IF   E           K DISK
      ** Midas GL Live Collateral Details by Account
 
     FGLCOLLQ0  IF   E           K DISK
      ** Midas GL Collateral Details Extension File
 
     FHELDIL1   IF   E           K DISK
     F                                     IGNORE(HELDIHAF)
     F                                     IGNORE(HELDIHCF)
      ** Midas RE Held Item File -  By Branch
 
     FGLHATML2  IF   E           K DISK
      ** Midas GL Account Transfer Input file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
      ** Data Area giving Installation Control Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External data structures for Bank Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External data structures for Currency Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structures for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
     D WDATEIN         S              5  0
     D WBRC1           S              3
     D WXREF           S             10
     D @RUN            S              1
     D @OPTN           S              7
     D @RTCD           S              7
     D PCNUM           S              6
     D PCCY            S              3
     D PACOD           S             10S 0
     D PACSQ           S              2S 0
     D PBRCA           S              3A
     D PBLAF           S             15P 0
     D POVLN           S             15P 0
     D PHELD           S             15P 0                                                    CLE164
     D PCOLL           S             15P 0                                                    CLE164
     D PACNO           S             10S 0                                                    CLE164
     D POVTL           S             15P 0
     D WACBS           S             15P 0
     D WDATS           S              5P 0
     D WCBCS           S             15P 0
     D WHITS           S             15P 0
     D WHELDS          S              1
     D WBAVS           S             15P 0
     D ACTIND          S              1
     D LOCIND          S              1
 
      ** Array Indices
 
      ** Other variables
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     IGLCOLQD0
     I              CDXREF                      CDXREF10
      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Start of processing
 
      ** Retrieve account details
 
     C     KACCNT        CHAIN     ACCNT
      *
     C                   IF        %FOUND(ACCNT)
     C                   IF        ATYP = 'R'
     C                             AND FCCU = *BLANKS AND
     C                             FACT = *ZERO AND FCNO = *ZERO
      *
      ** set working date for today and the next 9 working days
      *
     C                   EXSR      SRWorkDay
     C                   EVAL      WACBS = CLBL
     C                   EVAL      WBAVS = CLBL
     C                   EVAL      PACNO = ACNO                                               CLE164
      *
      ** compute base available balance
      *
     C                   EXSR      SRBaseAvail
     C                   EVAL      PBLAF = WBAVS
      *
      ** compute overdraft repayment
      *
     C                   IF        WDATS < ODED
     C                   EXSR      SROverDraft
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWorkDay - Subroutine to set working date for today and the *
      *              next 9 working days                              *
      *                                                               *
      *****************************************************************
     C     SRWorkDay     BEGSR
      *
      ** Initialize variables
      *
     C                   EVAL      WDATS = BJRDNB
     C                   EVAL      WDATEIN = WDATS
     C                   DOW       LOCIND <> 'W'
     C                             AND LOCIND <> 'W'
      *
      ** Location currency
      *
     C                   Z-ADD     WDATEIN       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   MOVE      *BLANKS       ZIND
      *
     C                   EXSR      ZCHKH
      *
     C                   MOVE      ZIND          LOCIND
      *
      ** Account currency
      *
     C                   Z-ADD     WDATEIN       ZDAYNO
     C                   MOVE      CCY           ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   MOVE      *BLANKS       ZIND
      *
     C                   EXSR      ZCHKH
      *
     C                   MOVE      ZIND          ACTIND
      *
     C                   IF        LOCIND = 'W' OR ACTIND = 'W'
     C                   EVAL      WDATS = WDATEIN
     C                   LEAVE
     C                   ENDIF
     C
     C                   ADD       1             WDATEIN
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBaseAvail - Subroutine to calculate Base Available Balance *
      *                                                               *
      *****************************************************************
     C     SRBaseAvail   BEGSR
      *
      ** Initialize variables
      *
     C                   EVAL      WHELDS = *BLANK
     C**********         EVAL      WBAVS = 0                                                MD049078
     C                   EVAL      WHITS = 0
     C                   EVAL      WCBCS = 0
     C**********         EVAL      WACBS = 0                                                MD049078
      *
      ** Check if Blocked Collateral Exists
      *
     C     KGCOLG        CHAIN     GLCOLLLG                           90
      *
     C                   DOW       *IN90 = *OFF
      *
     C                   IF        CDBCOL = 'Y'
     C                             AND CDCOPT = 'A'
      *
     C                   IF        CDEDAT >= WDATS AND
     C                             CDVDAT <= WDATS
      *
     C                   MOVE      CDCBRC        WBRC1
     C                   MOVE      CDCREF        WXREF
      *
     C     KGCOQ0        CHAIN     GLCOLLQ0
     C                   IF        %FOUND(GLCOLLQ0)
      *
     C                   IF        CDXCBC > 0
     C                   EVAL      WCBCS = WCBCS + CDXCBC
     C                   ENDIF
      *
     C                   ELSE
      *
      ** account should always have corresponding record on GLCOLLQ0
      ** when the preceding conditions are satisfied
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLCOLLQD'
     C                   EVAL      DBKEY = WXREF
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KGCOLG        READE     GLCOLLLG                               90
     C                   ENDDO
     C                   EVAL      PCOLL = WCBCS                                              CLE164
      *
      ** Check if Held Items Exists
      *
     C     KHLDL1        CHAIN     HELDIL1                            90
      *
     C                   DOW       *IN90 = *OFF
      *
     C                   IF        RECI = 'D'
      *
     C                   IF        HEXP > WDATS
      *
     C                   EVAL      WHITS = WHITS + HLDA
     C                   IF        HHIT = 'Y'
     C                   EVAL      WHELDS = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KHLDL1        READE     HELDIL1                                90
     C                   ENDDO
     C                   EVAL      PHELD = WHITS                                              CLE164
      *
      ** Get currency detail
      *
     C                   EXSR      SRGetCurrD
      *
      * If there is a blocked collateral amount
     C                   IF        WCBCS <> *ZERO
      *
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items debit all Blocked Collateral
      **  = Cleared Account Balance + all Held Items + all Blocked Collateral
      *
     C                   EVAL      WBAVS = WBAVS + WHITS
     C                   EVAL      WBAVS = WBAVS + WCBCS
     C                   ELSE
      *
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items
      **  = Cleared Account Balance + all Held Items
      *
     C                   EVAL      WBAVS = WBAVS + WHITS
      *
      ** If there are no hard held items
      *
     C                   IF        WHELDS <> 'Y'
      *
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items credit Overdraft Line
      **  = Cleared Account Balance + all Held Items - Overdraft Line
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROverDraft - Subroutine to retrieve OverDraft Repayment     *
      *                                                               *
      *****************************************************************
     C     SROverDraft   BEGSR
      *
      ** Initialize variables
      *
     C                   EVAL      POVLN = 0
      *
     C                   EVAL      POVLN = ODLN * (10**A6NBDP)
     C                   EVAL      POVLN = POVLN * -1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCCY
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Input parameters :
      ** Customer Name
      *
     C                   PARM                    PCNUM
      ** Currency Code
     C                   PARM                    PCCY
      ** Account Code
     C                   PARM                    PACOD
      ** Account Sequence
     C                   PARM                    PACSQ
      ** Branch Code
     C                   PARM                    PBRCA
      ** Available Balance
     C                   PARM                    PBLAF
      ** Overdraft Repayment
     C                   PARM                    POVLN
      ** Held Items                                                                           CLE164
     C                   PARM                    PHELD                                        CLE164
      ** Blocked Collateral                                                                   CLE164
     C                   PARM                    PCOLL                                        CLE164
      ** Retail Account Number                                                                CLE164
     C                   PARM                    PACNO                                        CLE164
      ** Initialise Available Balance
     C                   EVAL      PBLAF = 0
      ** Initialise LDA field
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE000042'    DBPGM
     C                   OUT       LDA
      *
      ** Key List for ACCNT
      *
     C     KACCNT        KLIST
     C                   KFLD                    PCNUM
     C                   KFLD                    PCCY
     C                   KFLD                    PACOD
     C                   KFLD                    PACSQ
     C                   KFLD                    PBRCA
      *
      ** Key List for GLCOLLLG
      *
     C     KGCOLG        KLIST
     C                   KFLD                    PBRCA
     C                   KFLD                    PCNUM
     C                   KFLD                    PCCY
     C                   KFLD                    PACOD
     C                   KFLD                    PACSQ
      *
      ** Key List for GLCOLLQ0
      *
     C     KGCOQ0        KLIST
     C                   KFLD                    WBRC1
     C                   KFLD                    WXREF
      *
      ** Key List for HELDIL1
      *
     C     KHLDL1        KLIST
     C                   KFLD                    PBRCA
     C                   KFLD                    PCNUM
     C                   KFLD                    PCCY
     C                   KFLD                    PACOD
     C                   KFLD                    PACSQ
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        JNSTAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE
