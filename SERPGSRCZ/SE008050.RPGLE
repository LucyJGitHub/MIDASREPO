     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Purchased Int Set up on Cposnd Init')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008050 - SE Purchased Int Set Up on Cposnd                 *
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
      *                 236698             Date 27Oct05               *
      *                 233615 *CREATE     Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CPK024 - Packaging for MPLUS 1.2.1 release. Renamed TRADSDL0 *
      *  236698 - Should calculate the total interest from trade      *
      *           sales and then reduce this by the proportion of the *
      *           position that has been purchased.                   *
      *  233615 - Takeon programs for CGL031                          *
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
     F*TRADSDL0* IF   E           K DISK    INFSR(*PSSR)                                      CPK024
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
     D WrkNOML         S             20S 8
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
     C                   Z-ADD     *ZEROS        WrkCSPI
     C                   Z-ADD     *ZEROS        WrkNOMLs                                     236698
     C                   Z-ADD     *ZEROS        WrkNOMLp                                     236698
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     CPOSS
     C                   READ      CPOSS
     C
     C                   DOW       Not%EOF(CPOSS)
 
     C     WrkCSSC       IFNE      CSSC
     C                   EXSR      SRSecty
     C                   ENDIF
 
     C     CPNR          IFNE      *ZEROS
 
      ** Read the Trades
 
     C**********         Z-ADD     CSCN          WCust                                       CSD027A
     C                   Eval      WCust = CSCN                                              CSD027A
     C                   MOVEL     CSBA          WBrca
     C                   MOVEL     CSSC          WSesn
     C                   Z-ADD     LCPN          WDate
 
     C*****KEYTD         SETLL     TRADSDL0                                                   CPK024
     C*****KEYTR         READE     TRADSDL0                               10                  CPK024
     C     KEYTD         SETLL     TRADSDL1                                                   CPK024
     C     KEYTR         READE     TRADSDL1                               10                  CPK024
     C
     C**********         DOW       Not%EOF(TRADSDL0)                                          CPK024
     C                   DOW       Not%EOF(TRADSDL1)                                          CPK024
 
     C     T_RECI        IFNE      '*'
     C     T_RECI        ANDNE     'R'
     C     T_RECI        ANDNE     'C'
 
     C                   IF        T_TDTP = 'TS'
     C     WrkCSPI       ADD       T_ITRA        WrkCSPI
     C     WrkNOMLs      ADD       T_NOML        WrkNOMLs                                     236698
     C                   ENDIF
 
     C                   IF        T_TDTP = 'TP'
     C*****WrkCSPI*****  SUB       ITRA          WrkCSPI                                      236698
     C     WrkNOMLp      ADD       T_NOML        WrkNOMLp                                     236698
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
     C     D_RECI        ANDNE     'C'
 
     C                   IF        D_DPMV = 'WI'
     C     WrkCSPI       ADD       D_PINT        WrkCSPI
     C     WrkNOMLs      ADD       D_DPNA        WrkNOMLs                                     236698
     C                   ENDIF
 
     C                   IF        D_DPMV = 'WO'
     C*****WrkCSPI*******SUB       PINT          WrkCSPI                                      236698
     C     WrkNOMLp      ADD       D_DPNA        WrkNOMLp                                     236698
     C                   ENDIF
     C                   ENDIF
 
     C     KEYDP         READE     SEDPMVL4                               11
     C                   ENDDO
 
     C*****CSPI          IFEQ      *ZEROS
     C**************     Z-ADD     WrkCSPI       CSPI                                         236698
     C     WrkNOMLs      IFEQ      *ZEROS                                                     236698
     C     CSNV          OREQ      *ZEROS                                                     236698
     C                   Z-ADD     *ZEROS        CSPI                                         236698
     C                   ELSE                                                                 236698
     C*****CSCN*         IFEQ      950158                                                    CSD027A
     C     CSCN          IFEQ      '950158'                                                  CSD027A
     C     WrkNOMLp      DIV(H)    WrkNOMLs      WrkNOML                                      236698
     C     WrkCSPI       MULT      WrkNOML       CSPI                                         236698
     C     WrkCSPI       SUB       CSPI          CSPI                                         236698
     C                   ENDIF                                                                236698
     C                   ENDIF                                                                236698
                                                                                              236698
     C                   Z-ADD     *ZEROS        WrkCSPI
     C                   Z-ADD     *ZEROS        WrkNOMLp                                     236698
     C                   Z-ADD     *ZEROS        WrkNOMLs                                     236698
                                                                                              236698
     C                   UPDATE    CPOSNDF                              12
     C*****              ENDIF
 
     C                   ENDIF
 
     C                   READ      CPOSS
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSecty - Access Security Details                             *
      *                                                               *
      *****************************************************************
     C     SRSecty       BEGSR
 
      ** Check for Security Shortname
 
     C     CSSC          CHAIN     SECTY
 
     C                   IF        NOT%FOUND(SECTY)
     C                   EVAL      DBKEY = CSSC
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      CSSC          WrkCSSC
 
     C                   ENDSR
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
 
     C     KEYTD         KLIST
     C**********         KFLD                    WCust             6 0                       CSD027A
     C                   KFLD                    WCust             6                         CSD027A
     C                   KFLD                    WBrca             3
     C                   KFLD                    WSesn            10
     C                   KFLD                    WDate             5 0
 
     C     KEYTR         KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WBrca
     C                   KFLD                    WSesn
 
     C     KEYDP         KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WBrca
     C                   KFLD                    WSesn
 
     C     *LIKE         DEFINE    CSPI          WrkCSPI
     C     *LIKE         DEFINE    T_NOML        WrkNOMLs                                     236698
     C     *LIKE         DEFINE    T_NOML        WrkNOMLp                                     236698
 
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
