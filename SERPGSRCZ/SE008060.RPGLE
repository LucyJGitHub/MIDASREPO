     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Average Purchased Date on Cposnd Init')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008060 - SE Average Purchased Date on Cposnd               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 CPK024             Date 13Feb06               *
      *                 233615 *CREATE     Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CPK024 - Packaging for MPLUS 1.2.1 release. Renamed TRADSDL0 *
     A*  233615 - Takeon programs for CGL031                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  10 - Record not found in TRADCS                              *
      *  11 - Record not found in SEDPMVL4                            *
      *  12 - Error in update for CPOSND                              *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
 
      ** Midas SE Trades
     F*TRADSDL0  IF   E           K DISK    INFSR(*PSSR)                                      CPK024
     FTRADSDL1  IF   E           K DISK    INFSR(*PSSR)                                       CPK024
     F                                     PREFIX(T_)
 
      ** Midas SE Depot Movements
     FSEDPMVL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D_)
 
      ** Midas SE Securities
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Customer Position
     FCPOSS     UF A E           K DISK
     F                                     IGNORE(DPOSNDF)
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
     ** +--------------------------------------+
     ** ¦ Arrays and Data Structures           ¦
     ** ¦ ==========================           ¦
     ** +--------------------------------------+
 
      ** External DS for bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
 
      ** Working Variables
     D WrkCSSC         S             10A   INZ(*BLANKS)
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
     C                   Z-ADD     *ZEROS        WrkA
     C                   Z-ADD     *ZEROS        WrkB
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     CPOSS
     C                   READ      CPOSS
     C
     C                   DOW       Not%EOF(CPOSS)
 
      ** Read the Trades
 
     C**********         Z-ADD     CSCN          WCust                                       CSD027A
     C                   Eval      WCust = CSCN                                              CSD027A
     C                   MOVEL     CSBA          WBrca
     C                   MOVEL     CSSC          WSesn
     C                   Z-ADD     *Zero         WDate
 
     C*****KEYTR1        SETLL     TRADSDL0                                                   CPK024
     C*****KEYTR         READE     TRADSDL0                               10                  CPK024
     C     KEYTR1        SETLL     TRADSDL1                                                   CPK024
     C     KEYTR         READE     TRADSDL1                               10                  CPK024
     C
     C**********         DOW       Not%EOF(TRADSDL0)                                          CPK024
     C                   DOW       Not%EOF(TRADSDL1)                                          CPK024
 
     C     T_RECI        IFNE      '*'
     C     T_RECI        ANDNE     'R'
     C     T_RECI        ANDNE     'C'
 
     C                   IF        T_TDTP = 'TS'
     C     T_TDVD        MULT      T_NOML        TmpA             19 0
     C     WrkA          ADD       TmpA          WrkA             19 0
     C     WrkB          ADD       T_NOML        WrkB             15 0
     C                   ENDIF
     C                   ENDIF
 
     C*****KEYTR         READE     TRADSDL0                               10                  CPK024
     C     KEYTR         READE     TRADSDL1                               10                  CPK024
     C                   ENDDO
 
      ** Read the Depot Movements
 
     C**********         Z-ADD     CSCN          WCust                                       CSD027A
     C                   Eval      WCust = CSCN                                              CSD027A
     C                   MOVEL     CSBA          WBrca
     C                   MOVEL     CSSC          WSesn
 
     C     KEYDP         SETLL     SEDPMVL4
     C     KEYDP         READE     SEDPMVL4                               11
     C
     C                   DOW       Not%EOF(SEDPMVL4)
 
     C     D_RECI        IFNE      '*'
     C     D_RECI        ANDNE     'R'
 
     C                   IF        D_DPMV = 'WI'
     C     WrkCSPI       ADD       D_PINT        WrkCSPI
     C     D_DPMD        MULT      D_DPNA        TmpA             19 0
     C     WrkA          ADD       TmpA          WrkA             19 0
     C     WrkB          ADD       D_DPNA        WrkB             15 0
     C                   ENDIF
     C                   ENDIF
 
     C     KEYDP         READE     SEDPMVL4                               11
     C                   ENDDO
 
     C     WrkB          IFNE      *ZEROS
     C     WrkA          DIV       WrkB          APDT
     C                   UPDATE    CPOSNDF                              12
     C                   ENDIF
     C                   Z-ADD     *ZEROS        WrkA
     C                   Z-ADD     *ZEROS        WrkB
 
     C                   READ      CPOSS
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Define key list for file
 
     C     KEYTR         KLIST
     C**********         KFLD                    WCust             6 0                       CSD027A
     C                   KFLD                    WCust             6                         CSD027A
     C                   KFLD                    WBrca             3
     C                   KFLD                    WSesn            10
 
     C     KEYTR1        KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WBrca
     C                   KFLD                    WSesn
     C                   KFLD                    WDate             5 0
 
     C     KEYDP         KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WBrca
     C                   KFLD                    WSesn
 
     C     *LIKE         DEFINE    CSPI          WrkCSPI
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     PRtcd
     C                   MOVEL     'SE008050'    DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
 
      ** TERMINATE THE PROGRAM
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ****************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
