     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas GO Global Update of Cust Details - TaskSplit')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011401 - Midas GO Global Update of Cust Details Task Split *
      *                                                               *
      *   NOTE: This program is based on processing for GOSDCUSTPD    *
      *         and GPGLCSGEN.                                        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD026387           Date 13May14               *
      *                 MD026124           Date 13May14               *
      *                 CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026387 - Reconciliation issue with GPAMADPD                *
      *  MD026124 - Fix to correct processing for removal of GOC0600  *
      *  AR740370 - If GPAMADPD records exist on Write, Update it     *
      *  CGP017 - GOC0100 Task Splits                                 *
      *                                                               *
      *****************************************************************
     FSDCUSTPD  IF   E             DISK    RECNO(WKRRN)
     F                                     INFSR(*PSSR)
     FSDCUDVPD  IF   E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D Z_SDCUSTL0    E DS                  EXTNAME(SDCUSTPD)
     D G_SDCUSTL0    E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(G_)

     D G_GPGLCUSL    E DS                  EXTNAME(GOGLCUSL)
     D B_GPGLCUSL    E DS                  EXTNAME(GOGLCUSL)
     D                                     PREFIX(B_)

     D TotRow          S             10  0
     D SQLCODCUSL      S              3  0
     D GPACOFXDS     E DS                  EXTNAME(GOACOFXPD)
     D GPINDSXDS     E DS                  EXTNAME(GOINDSXPD)
     D GPCUSTXDS     E DS                  EXTNAME(GOCUSTXPD)
     D GPCUSTDS      E DS                  EXTNAME(GOCUSTPD)
     D   W_CUGCUS    E                     EXTFLD(CUGCUS)
     D   W_CUBRCD    E                     EXTFLD(CUBRCD)
     D GPGLCUSLDS    E DS                  EXTNAME(GOGLCUSL)
     D                                     PREFIX(TMP_)
     D GZSDBRCHDS    E DS                  EXTNAME(SDBRCHPD)
     D   QQDFAC_X    E                     EXTFLD(QQDFAC)
     D GPAMADDS      E DS                  EXTNAME(GOAMADPD)
     D                                     PREFIX(H_)

B    D BR              S              3    DIM(999)
B    D SL              S             27    DIM(999)
     D #_BR            S              3    DIM(999)
     D #_ZN            S             10    DIM(999)
B
B    D SYNLOGREC       DS
B    D  BSCNTW                 1      9S 0
B    D  BSCNTD                10     18S 0
B    D  BSCNTU                19     27S 0
B
     D                 DS
     D  BUF_TIME               1      8
     D  BUF_HH                 1      2
     D  BUF_C1                 3      3
     D  BUF_MM                 4      5
     D  BUF_C2                 6      6
     D  BUF_SS                 7      8

     D                 DS
     D  ALP_TIME               1      6
     D  ALP_HH                 1      2
     D  ALP_MM                 3      4
     D  ALP_SS                 5      6

     D                 DS
     D  TIME_STR               1      6S 0
     D  STR_HH                 1      2S 0
     D  STR_MM                 3      4S 0
     D  STR_SS                 5      6S 0

     D                 DS
     D  TIME_END               1      6S 0
     D  END_HH                 1      2S 0
     D  END_MM                 3      4S 0
     D  END_SS                 5      6S 0

     C                   Z-ADD     0             WKRRN             9 0

     C                   READ      SDCUDVPD
     C     GLFERN        SETLL     SDCUSTPD
     C                   READ      SDCUSTPD
     C                   DOW       NOT %EOF(SDCUSTPD) AND WKRRN <= GLTERN
     C                   MOVEL     Z_SDCUSTL0    G_SDCUSTL0
B    C                   EVAL      G_BBBRCD      = BBBRCD
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBALFILE

     C/EXEC SQL
     C+ select * into :GPGLCUSLDS from GPGLCUSLL1
     C+ where CGBRCD = :BBBRCD
     C+   and CGCNUM = :BBCUST
     C+ fetch first row only
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                             AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      SQLCODCUSL = SQLCODE
     C                   EVAL      G_GPGLCUSL = GPGLCUSLDS

     C                   CLEAR                   B_GPGLCUSL
     C                   MOVEL     G_GPGLCUSL    B_GPGLCUSL
     C                   EXSR      SET_OUT_FLDS
     C                   IF        SQLCODCUSL <> 100

      ** redo the transfer of DS since now GPGLCUSLDS is being updated

     C**********         EVAL      G_GPGLCUSL = GPGLCUSLDS                                  MD026124
     C     B_GPGLCUSL    Ifne      G_GPGLCUSL

     C                   CALL      'GPCUSLUPD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#Delete          1
     C                   PARM      G_GPGLCUSL    I#RecordIMAGE 32000

     C**********         IF        (CGGLOB <> B_CGGLOB OR                                   MD026387
     C**********                    CGCSSN <> B_CGCSSN OR                                   MD026387
     C**********                    CGRNM <> B_CGRNM OR                                     MD026387
     C**********                    CGRTN <> B_CGRTN OR                                     MD026387
     C**********                    CGICD <> B_CGICD OR                                     MD026387
     C**********                    CGACO <> B_CGACO OR                                     MD026387
     C**********                    CGCNCZ <> B_CGCNCZ OR                                   MD026387
     C**********                    CGCOLC <> B_CGCOLC OR                                   MD026387
     C**********                    CGBRCD <> B_CGBRCD OR                                   MD026387
     C**********                    CGCUST <> B_CGCUST OR                                   MD026387
     C**********                    CGZONE <> B_CGZONE)                                     MD026387
     C                   EXSR      UPDAMAD
     C**********         Endif                                                              MD026387
     C                   Endif
     C                   ELSE

     C                   CALL      'GPCUSLUPD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#Delete          1
     C                   PARM      G_GPGLCUSL    I#RecordIMAGE 32000

     C                   EXSR      UPDAMAD
     C                   ENDIF

     C                   READ      SDCUSTPD
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C/SPACE 5
      *****************************************************************
      * Update Global File                                            *
      *****************************************************************
     C     UPD_GLOBALFILEBEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_SDCUSTL0
     C                   EVAL      I#AIMG = G_SDCUSTL0
     C/COPY GPCPYSRCG,GPSDCUSTPD
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Record the time                                               *
      *****************************************************************
     C     RECD_TIME     BEGSR
     C                   TIME                    NUM_TIME          6 0
     C                   MOVEL     NUM_TIME      ALP_TIME          6
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
     C                   ENDSR
      *****************************************************************
      * Set output fields                                             *
      *****************************************************************
     C     SET_OUT_FLDS  BEGSR

     C                   EVAL      Glob_Customer = 'N'

     C/EXEC SQL
     C+ select * into :GPCUSTXDS from GPCUSTXL0
     C+ where CUBRCD = :BBBRCD
     C+   and CUCUST = :BBCUST
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                             AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        SQLCODE <> 100
     C     *LIKE         DEFINE    CUGCUS        CUGCUS2
     C                   EVAL      CUGCUS2 = CUGCUS

     C/EXEC SQL
     C+ select * into :GPCUSTDS from GPCUSTL0
     C+ where CUGCUS = :CUGCUS2
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                             AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Bring back values of renamed fields

     C                   EVAL      CUGCUS = W_CUGCUS
     C                   EVAL      CUBRCD = W_CUBRCD

     C                   IF        SQLCODE <> 100
     C                   EVAL      Glob_Customer = 'Y'
     C                   ENDIF
     C                   ENDIF

      * Output either global or local (zone) customer details

     C                   IF        Glob_Customer = 'Y'
B    C                   EXSR      SET_OUT_GLOB
     C                   ELSE
B    C                   EXSR      SET_OUT_LOCL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Set output fields for a global customer                       *
      *****************************************************************
     C     SET_OUT_GLOB  BEGSR
      * Zone
     C                   Z-ADD     1             #X
     C     BBBRCD        LOOKUP    #_BR(#X)                               99
     C                   EVAL      Zone_ID  = #_ZN(#X)

B     * Branch
     C                   EVAL      CGBRCD   = BBBRCD
B     * Local Customer Number
     C                   EVAL      CGCUST   = BBCUST
     C                   MOVE      BBCUST        CGCNUM
B     * Global Customer ID
     C                   EVAL      CGGLOB   = CUGCUS
B     * Customer Shortname
     C                   EVAL      CGCSSN   = CUCSSN
B     * Cust. Name & Address 1
B     * Cust. Name & Address 2
B     * Cust. Name & Address 3
B     * Cust. Name & Address 4
     C                   EVAL      CGNA1    = CUCNA1
     C                   EVAL      CGNA2    = CUCNA2
     C                   EVAL      CGNA3    = CUCNA3
     C                   EVAL      CGNA4    = CUCNA4
B     * Customer Report Name
B     * Customer Report Town
     C                   EVAL      CGRNM    = CUCRNM
     C                   EVAL      CGRTN    = CUCRTN
B     * Bank/non-bank Indicator
     C                   EVAL      CGNBI    = CUBNBI
B     * Global Industry Code
     C                   EVAL      CGICD    = CUGICD
B     * Global Account Officer Code
     C                   EVAL      CGACO    = CUGACO
B     * Country of Citizenship
B     * Country of Location
     C                   EVAL      CGCNCZ   = CUCNCZ
     C                   EVAL      CGCOLC   = CUCOLC
B     * Date Deleted
     C                   EVAL      CGDTDL   = CUDTDL
B     * Zone
     C                   EVAL      CGZONE   = Zone_ID
B     * SWIFT Financial Inst Ind
     C                   IF        CUSWFI = 'Y'
     C                   EVAL      CGSWFI   = 'Y'
     C                   ELSE
     C                   EVAL      CGSWFI   = 'N'
     C                   ENDIF
B     * Status
     C                   IF        CUDTDL > 0 OR BBCLST = 'Y'
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
      * Local Customer shortname
     C                   Eval      CGLCSSN = BBCSSN
B
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Set output fields for a local customer                        *
      *****************************************************************
     C     SET_OUT_LOCL  BEGSR
      * Get zone
     C                   Z-ADD     1             #X
     C     BBBRCD        LOOKUP    #_BR(#X)                               99
     C                   EVAL      Zone_ID  = #_ZN(#X)

B     * Branch
     C                   EVAL      CGBRCD   = BBBRCD
B     * Customer Number
     C                   EVAL      CGCUST   = BBCUST
     C                   MOVE      BBCUST        CGCNUM
B     * Global Customer ID
     C                   EVAL      CGGLOB   = BBBRCD + '-' + BBCUST
B     * Customer Shortname
     C                   EVAL      CGCSSN   = BBCSSN
B     * Cust. Name & Address 1
B     * Cust. Name & Address 2
B     * Cust. Name & Address 3
B     * Cust. Name & Address 4
     C                   EVAL      CGNA1    = BBCNA1
     C                   EVAL      CGNA2    = BBCNA2
     C                   EVAL      CGNA3    = BBCNA3
     C                   EVAL      CGNA4    = BBCNA4
B     * Customer Report Name
B     * Customer Report Town
     C                   EVAL      CGRNM    = BBCRNM
     C                   EVAL      CGRTN    = BBCRTN
B     * Bank/non-bank Indicator
     C                   EVAL      CGNBI    = BBBNBI
B     * Global Industry Code
     C                   move      *Blanks       CGICD

     C/EXEC SQL
     C+ select * into :GPINDSXDS from GPINDSXL0
     C+ where IDZONE = :Zone_ID
     C+   and IDLICD = :BBLICD
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                             AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        SQLCODE <> 100
     C                   EVAL      CGICD    = IDGIND
     C                   Endif

B     * Global Account Officer Code
     C                   move      *Blanks       CGACO

     C/EXEC SQL
     C+ select * into :GPACOFXDS from GPACOFXL0
     C+ where ACZONE = :Zone_ID
     C+   and ACACOC = :BBACOC
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                             AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        SQLCODE <> 100
     C                   EVAL      CGACO    = ACGACO
     C                   Endif

B     * Country of Citizenship
B     * Country of Location
     C                   EVAL      CGCNCZ   = BBCNCZ
     C                   EVAL      CGCOLC   = BBCOLC
B     * Date Deleted
     C                   EVAL      CGDTDL   = BBDTDL
B     * Zone
     C                   EVAL      CGZONE   = Zone_ID
B     * SWIFT Financial Inst Ind
     C                   IF        BBSWFI = 'Y'
     C                   EVAL      CGSWFI   = 'Y'
     C                   ELSE
     C                   EVAL      CGSWFI   = 'N'
     C                   ENDIF
B     * Status
     C                   IF        BBDTDL > 0 OR BBCLST = 'Y'
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
      * Local Customer shortname
     C                   Eval      CGLCSSN = BBCSSN
B
     C                   ENDSR
      *****************************************************************
      * UPDAMAD - Update GPAMADL0                                     *
      *****************************************************************
     C     UPDAMAD       BEGSR

     C/EXEC SQL
     C+ declare AMADCUR insensitive scroll cursor for
     C+ select * from GPAMADL0
     C+ where CNUM = :BBCUST
     C/END-EXEC

     C/EXEC SQL
     C+ open AMADCUR
     C/END-EXEC

     C/EXEC SQL
     C+ get diagnostics :TotRow  = DB2_NUMBER_ROWS
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from AMADCUR into :GPAMADDS
     C/END-EXEC

     C                   DOW       SQLCODE = 0

      * Move

     C                   MOVEL     CGGLOB        H_CGGLOB
     C                   MOVEL     CGCSSN        H_CGCSSN
     C                   MOVEL     CGRNM         H_CGRNM
     C                   MOVEL     CGRTN         H_CGRTN
     C                   MOVEL     CGICD         H_CGICD
     C                   MOVEL     CGACO         H_CGACO
     C                   MOVEL     CGCNCZ        H_CGCNCZ
     C                   MOVEL     CGCOLC        H_CGCOLC
     C                   MOVEL     CGBRCD        H_CGBRCD
     C                   MOVEL     CGCUST        H_CGCUST
     C                   MOVEL     CGZONE        H_CGZONE

      * Update

     C                   CALL      'GPAMADUPD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#Delete          1
     C                   PARM      GPAMADDS      I#RecordIMAGE 32000

     C/EXEC SQL
     C+ fetch next from AMADCUR into :GPAMADDS
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ close AMADCUR
     C/END-EXEC

     C                   ENDSR
     ******************************************************************
     C/SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program   *
      *          start                                                *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10

     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_SDCUSTL0
     C                   CLEAR                   G_SDCUSTL0
     C                   Z-ADD     0             #X                3 0
      * Read all branches

     C/EXEC SQL
     C+ declare GZBRCCUR insensitive scroll cursor for
     C+ select * from GZSDBRCHL0
     C/END-EXEC

     C/EXEC SQL
     C+ open GZBRCCUR
     C/END-EXEC

     C/EXEC SQL
     C+ get diagnostics :TotRow = DB2_NUMBER_ROWS
     C/END-EXEC

     C                   IF        TotRow > 0

     C/EXEC SQL
     C+ fetch next from GZBRCCUR into :GZSDBRCHDS
     C/END-EXEC

      * For each branch

     C     SQLCODE       DOWEQ     0

      * Add branch & zone to arrays
     C                   ADD       1             #X
     C                   MOVEL     A8BRCD        #_BR(#X)
     C                   MOVEL     A8ZONE        #_ZN(#X)

      * Read next branch

     C/EXEC SQL
     C+ fetch next from GZBRCCUR into :GZSDBRCHDS
     C/END-EXEC

     C                   ENDDO
     C                   ENDIF

     C/EXEC SQL
     C+ close GZBRCCUR
     C/END-EXEC

     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_STR = NUM_TIME

B     * Initialize branches
B    C                   MOVE      '***'         BR
B
      * Initialize overall totals
     C                   Z-ADD     *ZERO         T_BSCNTW          9 0
     C                   Z-ADD     *ZERO         T_BSCNTD          9 0
     C                   Z-ADD     *ZERO         T_BSCNTU          9 0

      * Key lists

     C                   MOVE      *BLANK        Glob_Customer     1
     C                   MOVE      *BLANK        Zone_ID          10

     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS                          *
      *****************************************************************
     C     *PSSR         BEGSR

     C     RunBefore     IFEQ      *BLANKS

     C                   MOVE      'Y'           RunBefore         1

     C                   DUMP
     C                   ENDIF

     C                   SETON                                        LRU7U8
     C                   RETURN

     C                   ENDSR
      *********************************************************************
