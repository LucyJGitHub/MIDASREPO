     H DEBUG
     H COPYRIGHT('(c) Finastra International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLD020 - Journal Entries Events Extract                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. DUG503             Date 08Apr18               *
      *  Prev Amend No. DUG431  *CREATE    Date 23Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG431 - Amendments to 'Events by Value Date' Report         *
      *                                                               *
      *****************************************************************
      * SUBROUTINES:                                                  *
      *****************************************************************
      *                                                               *
      * Standard:                                                     *
      * ---------                                                     *
      * *Inzsr         -  Program Initialisation Routine              *
      * *Pssr          -  Error handling subroutine                   *
      *                                                               *
      * Custom:                                                       *
      * -------                                                       *
      *                                                               *
      *****************************************************************
      * INDICATOR USAGE                                               *
      *****************************************************************
      *                                                               *
      * LR - Last Record                                              *
      * U7 - Database error                                           *
      * U8 - Database error                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Events Account Codes File
     FGLEVACV0  IF   E           K DISK    INFSR(*PSSR)
      *
      *
     FGLJENPPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(JE_)
      *
     FGLJENHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JH_)
      * Journal Entries Extract Detail File
     FGLJEXFPP  O    E             DISK    INFSR(*PSSR)
      *
      * Journal Entries Extract Trailer File
     FGLJEXZPP  O    E             DISK    INFSR(*PSSR)
      *
     FTABTG30   IT   F   40        DISK
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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
     D CY              S              3    DIM(200) FROMFILE(TABTG30) PERRCD(1)
     D CYD             S             37    DIM(200) ALT(CY)
      *
     D*    CURRENCY DETAILS FROM TABTG30
     D CYDDS           DS
     D  CDP                    1      1  0
     D  SPOT                   2      8P 8
     D  MDIN                   9      9  0
     D  ERLC                  10     16P 8
     D  TNOT                  17     17  0
     D  CCNM                  18     31
     D  TACC                  32     35  0
     D  SSNO                  36     37  0

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR G/L DETAILS

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C                   Read      GLJENPPD                               23
      *
     C     *IN23         Ifeq      *Off
      *
     C     *IN23         Doueq     *On
      *
      * In I/C mode, all Journal Entries with status of 'A' or 'S' will be extracted
     C     P_Mode        Ifeq      'I/C'
      *
      * Go into GLJENHPD to pick up Batch Status Flag
     C     JE_BTBTNB     Chain     GLJENHL0                           27
     C     *In27         Ifeq      *Off
      *
     C     JH_BRBTSF     Ifeq      'A'
     C     JH_BRBTSF     oreq      'S'
      * Extract only Journal Entries with an account code on the new Events Account Codes file
     C     JE_BTACCD     Chain     GLEVACV0                           28
     C     *In28         Ifeq      *Off
     C                   Exsr      sr_Extract
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      * In COB mode, all Journal Entries with a value date > event control date will be extracted
     C     P_Mode        Ifeq      'COB'
      *
     C     JE_BTVLDT     Ifgt      ECD
      * Extract only Journal Entries with an account code on the new Events Account Codes file
     C     JE_BTACCD     Chain     GLEVACV0                           28
     C     *In28         Ifeq      *Off
     C                   Exsr      sr_Extract
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   Read      GLJENPPD                               23
     C                   Enddo
      *
     C                   Endif
      *
      * Write one record to the Journal Entries Extract Trailer File
     C                   Move      'D'           G3RECI
     C                   Z-ADD     #Count        G3NORE
     C                   Z-ADD     #Amnt         G3HRWN
     C                   Z-ADD     0             G3HRDC
     C                   Write     GLJEXZP0
      *
     C                   Move      *On           *INLR
     C                   Return
      *****************************************************************
     C     sr_Extract    Begsr
      *
     C                   Move      JE_BTIBCA     G3BRCA
     C                   Move      JE_BTCUST     G3CNUM
      *
     C                   Move      JE_BTCUST     Wk_Cust          10
     C                   Exsr      srGetShort
     C                   Move      Wk_Short      G3CSSN
      *
     C                   Move      JE_BTCYCD     G3CURR
     C                   Exsr      GetSortSeq
     C                   Z-Add     Wk_SS         G3ECSS
      *
     C                   Z-Add     JE_BTVLDT     G3EVDT
     C                   Move      'JRNE'        G3ETYP
     C                   Move      JE_BTBTNB     G3BTNB
     C                   Z-Add     JE_BTBINB     G3BINB
     C                   Move      JE_BTACCD     G3ACOD
     C                   Z-Add     JE_BTPTDT     G3PTDT
     C                   Z-Add     JE_BTPTAM     G3AMNT
      * DR = Incoming
     C     JE_BTDCIN     Ifeq      'D'
     C                   Move      'I'           G3DCIN
     C                   Endif
      * CR = Outgoing
     C     JE_BTDCIN     Ifeq      'C'
     C                   Move      'O'           G3DCIN
     C                   Endif
     C********           Move      JE_BTDCIN     G3DCIN
      *
     C                   Add       1             #Count
     C                   Add       G3AMNT        #Amnt
      * Write a record to the Journal Entries Extract File
     C                   Write     GLJEXFP0
      *
     C                   Endsr
      *****************************************************************
      * srGetShort - Retrieve Customer Shortname                      *
      *****************************************************************
     C     srGetShort    Begsr
      *
     C                   CALLB     'AOCUSTR0'
     C                   Parm      '       '     @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      Wk_Cust       @CNUM            10
     C                   Parm                    @CNST             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C     @RTCD         Ifeq      *Blanks
     C                   Move      BBCSSN        Wk_Short         10
     C                   Move      BBCRNM        G3CRNM
     C                   Move      BBCRTN        G3CRTN
     C                   Else
     C                   Move      *Blanks       Wk_Short
     C                   Move      *Blanks       G3CRNM
     C                   Move      *Blanks       G3CRTN
     C                   Endif
      *
     C                   EndSr
      *****************************************************************
      * GetSortSeq - Retrieve Currency Sort Sequence                  *
      *****************************************************************
     C     GetSortSeq    Begsr
      *
     C                   Z-Add     1             I                 3 0
     C     G3CURR        Lookup    CY(I)                                  50
     C     *IN50         Ifeq      '1'
     C                   Move      CYD(I)        CYDDS
     C                   Z-Add     SSNO          Wk_SS             2 0
     C                   Endif
      *
     C                   EndSr
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        Begsr
      *
      *
      * P_Mode = 'I/C' or 'COB'
     C     *ENTRY        PLIST
     C                   Parm                    P_Mode            3
     C                   Parm                    ReturnCd          7
      *
      ** Access bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Z-add     1             DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
1649 C                   CALL      'AOGELRR0'
1649 C                   Parm      '*MSG   '     @RTCD
1649 C                   Parm      '*FIRST '     @OPTN
1649 C     SDGELR        PARM      SDGELR        DSFDY
1649 C*
1649 C     @RTCD         Ifne      *BLANKS
1649 C                   Movel     'SDGELRPD'    DBFILE
1649 C                   Z-add     2             DBASE
1649 C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
1649 C                   Endif
      *
      * ----------------------------
      * Calculate Event Control Date
      * ----------------------------
      *
      * For Accrual for Non-working Days Processing Types 0 and 1,
0609 C     BJDNWD        Sub       1             ECD               5 0
      *
      * If Accrual for Non-working days indicator = 2:
      *   If the Accrual/Profit Date < or = Date of Next Working Day - 1,
      *   the Event Control Date should be the Accrual/Profit Date.
      *   Otherwise, it should be Run Date.
      *   This is because Processing Type 2 processes non-working days
      *   retrospectively and will only generate events up to today,
      *   unless the Next Accrual Day is before the Next Working Day, in
      *   which case it will generate events to Accrual Day.
      *
     C     BKANWD        Ifeq      '2'
     C     BKAPDT        Ifle      ECD
     C                   Z-add     BKAPDT        ECD
     C                   Else
     C                   Z-add     BJRDNB        ECD
     C                   Endif
     C                   Endif
      *
     C                   Z-Add     0             #Count            9 0
     C                   Z-Add     0             #Amnt            15 0
      *
     C                   Endsr
      *****************************************************************
      * *PSSR  - INITIAL PROCESSING
      *****************************************************************
     C     *PSSR         Begsr
      *
     C                   Move      '*DBERR '     ReturnCd
     C                   Seton                                        U7U8
     C                   Dump
     C                   Seton                                        LR
     C                   Return
      *
     C                   Endsr
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
