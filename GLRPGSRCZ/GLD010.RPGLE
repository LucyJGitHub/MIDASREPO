     H DEBUG
     H COPYRIGHT('(c) Finastra International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLD010 - Customer Exchanges Events Extract                   *
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
      * sr_Extract     -  Extract records to Extract File             *
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
      * Customer Exchanges Detail File
     FCUSEXCE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(CX_)
      *
      * Customer Exchanges Extract Detail File
     FGLCXXFPP  O    E             DISK    INFSR(*PSSR)
      *
      * Customer Exchanges Extract Trailer File
     FGLCXXZPP  O    E             DISK    INFSR(*PSSR)
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
     C                   Read      CUSEXCE                                23
      *
     C     *IN23         Ifeq      *Off
      *
     C     *IN23         Doueq     *On
      *
      * In I/C mode, all Customer Exchanges will be extracted.
     C     P_Mode        Ifeq      'I/C'
     C                   Exsr      sr_Extract
     C                   Endif
      *
      * In COB mode, all Customer Exchanges with a value date > event control date will be extracted
     C     P_Mode        Ifeq      'COB'
      * Do not use the input date to check whether to extract or not - use the value dates instead
     C**   CX_Vald       Ifgt      ECD
     C                   Exsr      sr_Extract
     C**                 Endif
      *
     C                   Endif
      *
     C                   Read      CUSEXCE                                23
     C                   Enddo
      *
     C                   Endif
      *
      * Write one record to the Customer Exchanges Extract Trailer File
     C                   Move      'D'           G2RECI
     C                   Z-ADD     #Count        G2NORE
     C                   Z-ADD     #Amnt         G2HRWN
     C                   Z-ADD     0             G2HRDC
     C                   Write     GLCXXZP0
      *
     C                   Move      *On           *INLR
     C                   Return
      *****************************************************************
     C     sr_Extract    Begsr
      *
     C
      * ----------
      * Debit side
      * ----------
     C                   Move      CX_DRBR       G2BRCA
     C                   Move      CX_DCUS       G2CNUM
      *
     C                   Move      CX_DCUS       Wk_Cust          10
     C                   Exsr      srGetShort
     C                   Move      Wk_Short      G2CSSN
      *
     C                   Move      CX_DRCY       G2CURR
     C                   Exsr      GetSortSeq
     C                   Z-Add     Wk_SS         G2ECSS
      *
     C                   Z-Add     CX_DRVD       G2EVDT
     C                   Move      'CEDR'        G2ETYP
     C                   Move      CX_IPDN       G2IPDN
     C                   Z-Add     CX_DCOD       G2ACOD
     C                   Z-Add     CX_VALD       G2VLDT
     C                   Z-Add     CX_DRAM       G2AMNT
      * Incoming = DR
     C                   Move      'I'           G2DCIN
      *
     C                   Add       1             #Count
     C                   Add       G2AMNT        #Amnt
      * Write a record to the Customer Exchanges Extract File - for Debit side = Incoming
     C     P_Mode        Ifeq      'COB'
     C     CX_DRVD       andgt     ECD
     C     P_Mode        oreq      'I/C'
     C                   Write     GLCXXFP0
     C                   Endif
      *
      * -----------
      * Credit side
      * -----------
     C                   Move      CX_CBRC       G2BRCA
     C                   Move      CX_CCUS       G2CNUM
      *
     C                   Move      CX_CCUS       Wk_Cust
      *
     C                   Exsr      srGetShort
     C                   Move      Wk_Short      G2CSSN
      *
     C                   Move      CX_CRCY       G2CURR
     C                   Exsr      GetSortSeq
     C                   Z-Add     Wk_SS         G2ECSS
      *
     C                   Z-Add     CX_CRVD       G2EVDT
     C                   Move      'CECR'        G2ETYP
     C                   Move      CX_IPDN       G2IPDN
     C                   Z-Add     CX_CCOD       G2ACOD
     C                   Z-Add     CX_VALD       G2VLDT
     C                   Z-Add     CX_CRAM       G2AMNT
      * Outgoing = CR
     C                   Move      'O'           G2DCIN
      *
     C                   Add       1             #Count
     C                   Add       G2AMNT        #Amnt
      * Write a record to the Customer Exchanges Extract File - for Credit side = Outgoing
     C     P_Mode        Ifeq      'COB'
     C     CX_CRVD       andgt     ECD
     C     P_Mode        oreq      'I/C'
     C                   Write     GLCXXFP0
     C                   Endif
      *
      * -------
      * Charges
      * -------
      * Now check for any Charges
     C     CX_HAMT       Ifne      0
      *
     C     CX_HSGN       Ifeq      '+'
     C                   Move      CX_DRBR       G2BRCA
     C                   Move      CX_DRCY       G2CURR
      * Incoming = DR
     C                   Move      'I'           G2DCIN
     C                   Else
     C                   Move      CX_CBRC       G2BRCA
     C                   Move      CX_CRCY       G2CURR
      * Outgoing = CR
     C                   Move      'O'           G2DCIN
     C                   Endif
      *
     C                   Exsr      GetSortSeq
     C                   Z-Add     Wk_SS         G2ECSS
      *
     C                   Move      CX_HCUS       G2CNUM
      *
     C                   Move      CX_HCUS       Wk_Cust
     C                   Exsr      srGetShort
     C                   Move      Wk_Short      G2CSSN
      *
     C                   Z-Add     CX_VALD       G2EVDT
     C                   Move      'CECH'        G2ETYP
     C                   Move      CX_IPDN       G2IPDN
     C                   Z-Add     CX_HACD       G2ACOD
     C                   Z-Add     CX_VALD       G2VLDT
     C                   Z-Add     CX_HAMT       G2AMNT
      *
     C                   Add       1             #Count
     C                   Add       G2AMNT        #Amnt
     C                   Write     GLCXXFP0
     C                   Endif
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
     C                   Move      BBCRNM        G2CRNM
     C                   Move      BBCRTN        G2CRTN
     C                   Else
     C                   Move      *Blanks       Wk_Short
     C                   Move      *Blanks       G2CRNM
     C                   Move      *Blanks       G2CRTN
     C                   Endif
      *
     C                   EndSr
      *****************************************************************
      * GetSortSeq - Retrieve Currency Sort Sequence                  *
      *****************************************************************
     C     GetSortSeq    Begsr
      *
     C                   Z-Add     1             I                 3 0
     C     G2CURR        Lookup    CY(I)                                  50
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
