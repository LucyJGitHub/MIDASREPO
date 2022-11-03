     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  XX118007 - Combine Pos'n Settlement Gen./Adjustment Audit    *
      *                                                               *
      *  Function: This program is based on a copy of SE4862 (SE2580) *
      *   (COB)    (including output to POSETDY1 and POSETDY2         *
      *            although S01401 is off), with the exception        *
      *            that the value calculated as Nr of Live Records    *
      *            will replace the Value NORE of POSETA.             *
      *            No check is to be done to see if Nr of records     *
      *            calculated and old NORE from POSETA do not match.  *
      *            Journaling and Commitment Control is used.         *
      *                                                               *
      *  NOTE:     Any changes applied to SE2580 may also need to     *
      *            be applied to this program.                        *
      *                                                               *
      *  Called By: XXC118003 - SE On-Line Positions Generation       *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *****************************************************************
      *
      *  Last Amend No. HUT118   *Create   Date 03Nov22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT118 - Position Settlements Online Generation              *
      *                                                               *
      *****************************************************************
      *
     FPOSETD    IF   E           K DISK
     FPOSETA    UF   E           K DISK    USROPN
     F                                     COMMIT
     FPOSETDY1  IF A E           K DISK
     F                                     COMMIT
     FPOSETDY2  IF A E           K DISK
     F                                     COMMIT
     FXX118007AUO    E             PRINTER
     FTABSE     IF   E           K DISK
     F* ICD 1     TABTB10F                          KIGNORE
     F                                     IGNORE(TABTB11F)
     F                                     IGNORE(TABTB36F)
     F                                     IGNORE(TABTB40F)
     F                                     IGNORE(TABTG10F)
     F                                     IGNORE(TABTG20F)
     F                                     IGNORE(TABLETHF)
     F                                     IGNORE(TABLETLF)
     F                                     IGNORE(TABLETRF)
     F                                     IGNORE(TABLETXF)
     F                                     IGNORE(TABLET2F)
     F                                     IGNORE(TABLET3F)
     F                                     IGNORE(TABLET5F)
     F                                     IGNORE(TABTE10F)
     F                                     IGNORE(TABLETNF)
     F                                     IGNORE(TABLETKF)
     F                                     IGNORE(TABLETPF)
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   35 - EOF for Position Settlements            (POSEB)        *
      *   36 - EOF for Position Settlements Audit file (POSETA)       *
      *   50 - Print '*** DIFFERENCE ***' on report                   *
      *   60 - Amend S01496 switch *ON                                *
      *   88 - Write Fail on POSETDY1                                 *
      *   89 - Chain Fail on POSETDY1                                 *
      *                                                               *
      *   99 - DB Error on Table file.                 (TABSE )       *
      *U7&U8 - DB Error occurred                                      *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  I N D E X   T O   S U B R O U T I N E S                      *
      *                                                               *
      *   CNTNEW - Count number of live records                       *
      *   CNTOLD - Total number of records as per the audit file      *
      *   RUNCTL - Run Control Processing                             *
      *   *PSSR  - Error handling                                     *
      *   ZNOREC - DB Error Processing                                *
      *   ZDEFN  - Define all program variables                       *
      *   ZSYSTM - Obtain ICD1                                        *
      *                                                               *
      *****************************************************************
      /EJECT
     D OVR             S             31    DIM(6) CTDATA PERRCD(1)
     D OVS             S             31    DIM(7) CTDATA PERRCD(1)
      *
      /EJECT
     D                SDS
      *
      * System Status Data-Structure.
      *
     D  @PGMNM           *PROC
      *
     D CPYR@#          DS
      *
      *  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ***  External Data Structure for Securities Trading Clients.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Long Data Structure for Access Objects.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Short Data Structure for Access Objects.
      *
     D LDA             DS           256
      *
      * Local Data Area data-structure.
      *
     D  DBLOT                134    183
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      * DATA STRUCTURE FOR SESTAT
      *
     D SESTAT        E DS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      /EJECT
      *================================================================
      *              I N I T I A L I S A T I O N
      *================================================================
      *
     C     *ENTRY        PLIST
     C                   PARM                    @PHASE            1
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANK        DBLOT
     C                   MOVEL     @PGMNM        DBPGM
     C                   OUT       LDA
      *
     C                   EXSR      ZSYSTM
      *
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8
     C     *LOCK         IN        LDA
     C                   MOVE      'TABLE'       DBFILE                         *****************
     C                   MOVEL     *BLANKS       DBKEY                          ** DB ERROR 05 **
     C                   Z-ADD     5             DBASE                          *****************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   END
      *
      * DEFINE DATA AREA SESTAT
      *
     C     *DTAARA       DEFINE                  SESTAT
     C                   IN        SESTAT
      *
      **  Access Switchable features file for MT5xx processing
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'S01401'      WSARD             6
      *
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01401            1
     C                   END
      *
      **  Define key list for Position Settlements Extension file
     C     KPOSET        KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PSSH
     C                   KFLD                    PCPY
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
      *
      **  Access SAR details file to see if JYSKE Enhcmts is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01496'      WSARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
      **  Access SAR details file to see if Corporate Action installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSE007'      WSARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE007            1
     C                   ENDIF
      *
      ***  Access SAR details file to see if Securities Redenomination
      ***  is installed
      *
     C                   MOVE      'N'           CEU017            1
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU017'      WSARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU017            1
     C                   ENDIF
      *
      /EJECT
      *================================================================
      *            M A I N   L I N E   C O D E
      *================================================================
      *
     C                   EXSR      CNTNEW
      *
      ** (only process if not database error yet)
     C     *INU7         IFEQ      '0'
     C     @PHASE        ANDNE     'I'
     C                   EXSR      CNTOLD
     C                   END
      *
     C     ENDPGM        TAG
     C     @PHASE        IFNE      'I'
     C                   EXSR      RUNCTL
     C                   END
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CNTNEW SR  : Counts the number of records in the combined     *
      *              member of POSETD.                                *
      *                                                               *
      *****************************************************************
      *
     C     CNTNEW        BEGSR
      *
     C                   READ      POSETD                                 35
      *
     C     *IN35         DOWEQ     '0'
     C     *INU7         ANDEQ     '0'
      *
      **  Process records with RECI = 'R' only if Jyske Enhancements
      **  feature is installed
      **  OR Process records with RECI = 'R' if Corporate Action
      **  feature is installed
      *
     C     S01496        IFEQ      'Y'
     C     CSE007        OREQ      'Y'
     C     CEU017        OREQ      'Y'
     C     RECI          ORNE      'R'
      *
      * Don't count any records marked as deleted.
      *
     C     RECI          IFNE      '*'
     C     RECI          ANDNE     'M'
      *
     C     S01496        IFEQ      'Y'
     C     CSE007        OREQ      'Y'
     C     CEU017        OREQ      'Y'
     C     RECI          IFNE      'R'
     C                   ADD       1             @COUNT
     C                   END
     C                   ELSE
     C                   ADD       1             @COUNT
     C                   END
      *
     C                   END
      *
      ***  If Portfolio Management is licensed in the System and the
      ***  MT5xx Feature is present, then for Portfolio Customers, for
      ***  Coupon and Dividend Position Settlements, ensure that a
      ***  corresponding Extension record is present.
      *
      **   HUT118 -  Include output to POSETDY1 and POSETDY2
      **             although S01401 is off.
      **
     C     PFPL          IFEQ      'Y'
      *
      *****Select*only*Coupons*and*Dividends.
      ***  Select only Dividends.                                               HUT118
      *                                                                         HUT118
     C**** PEVT          IFEQ      'CP'                                         HUT118
     C**** PEVT          OREQ      'DV'                                         HUT118
     C     PEVT          IFEQ      'DV'                                         HUT118
      *
      ***  Ascertain if Customer is Safe Custody or Discretionary.
      *
     C                   MOVE      PCPY          WPCPY             6
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY   '     WOPTN             7
     C                   PARM                    WPCPY
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C     WRTCD         IFEQ      *BLANKS
     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
      *
      ***  Check if record exists on Extension File.
      *
     C     KPOSET        CHAIN     POSETDY1                           89
      *
      ***  If it doesn't, set one up and Write it.
      *
     C     *IN89         IFEQ      '1'
     C                   CLEAR                   POSETDD1
     C                   MOVE      PBCA          POPBCA
     C                   MOVE      PSSH          POPSSH
     C                   MOVE      PCPY          POPCPY
     C                   MOVE      PDUD          POPDUD
     C                   MOVE      PEVT          POPEVT
     C                   MOVE      LCD           POLCD
     C                   MOVE      'N'           PORCDG
     C                   MOVE      *ZEROS        POSEQN
     C                   MOVE      'N'           POGMES
      *
     C                   WRITE     POSETDD1                             88
      *
      **  If the Write fails, then process a database error
     C     *IN88         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'POSETDY1'    DBFILE                         * DB ERROR 01 *
     C                   MOVEL     PCPY          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   SETON                                        U7U8
     C                   END
      *
      ***  End of Position Settlement Extension record not on file.
     C                   ENDIF
      *
      ** Check if record exists on Extension File.
      *
     C     KPOSET        CHAIN     POSETDY2                           89
      *
      ** If it doesn't, set one up and Write it.
      *
     C     *IN89         IFEQ      '1'
     C                   CLEAR                   POSETDD2
     C                   MOVE      PBCA          P2PBCA
     C                   MOVE      PSSH          P2PSSH
     C                   MOVE      PCPY          P2PCPY
     C                   MOVE      PDUD          P2PDUD
     C                   MOVE      PEVT          P2PEVT
      *
     C                   WRITE     POSETDD2                             88
      *
      ** If the Write fails, then process a database error
      *
     C     *IN88         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'POSETDY2'    DBFILE                         * DB ERROR 02 *
     C                   MOVEL     PCPY          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   SETON                                        U7U8
     C                   END
     C                   END
      ***  End of Counterparty on File.
     C                   ENDIF
      ***  End of Portfolio Customers.
     C                   ENDIF
      ***  End of only Coupons and Dividends.
     C                   ENDIF
      ***  End of Portfolio Management licensed and MT5xx present.
     C                   ENDIF
      ***  End of Jyske Enhancements installed
     C                   ENDIF
      *
     C                   READ      POSETD                                 35
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CNTOLD SR  : Counts the total number of records in the 4 old  *
      *              members of POSETD.                               *
      *                                                               *
      *****************************************************************
     C     CNTOLD        BEGSR
      *
      * Override to the appropriate member.
      *
      *
      * If Portfolio Management has not been Licensed CPOSN1 & CPOSN2
      * will be empty
      *
     C     PFPL          IFEQ      'Y'
     C                   Z-ADD     1             @X
     C                   ELSE
     C                   Z-ADD     3             @X
     C                   END
      *
     C     S01496        IFEQ      'Y'
     C                   Z-ADD     7             W01496            1 0
     C                   ELSE
     C                   Z-ADD     6             W01496
     C                   ENDIF
     C     @X            DOWLE     W01496
      *
      * If feature Corporate Action is not installed
      * or feature Securities Redenomination is installed
     C     CSE007        IFNE      'Y'
     C     CEU017        ANDNE     'Y'
      *
      * By-pass override of member CORPAC
     C     S01496        IFEQ      'Y'
     C     @X            ANDEQ     6
     C     S01496        ORNE      'Y'
     C     @X            ANDEQ     5
     C                   Z-ADD     *ZEROS        NORE
     C                   GOTO      RDNXT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C  N60              MOVEA     OVR(@X)       @OVRDB
     C   60              MOVEA     OVS(@X)       @OVRDB
      *
     C                   CALL      'QCMDEXC'
     C                   PARM      @OVRDB        #CMD
     C                   PARM      31            #CMDLN
      *
      * Get the audit record and total it up.
      *
     C                   OPEN      POSETA
     C                   READ      POSETA                                 36
      *
      * If processing member POSETA don't close file
      *
     C     @X            IFNE      W01496
     C                   CLOSE     POSETA
     C                   END
      *
      * If no record exists, execute the standard database error rtn.
      *  and exit this routine.
      *
     C     *IN36         IFEQ      '1'
      *
     C     S01496        IFEQ      'Y'
     C     @X            ANDEQ     6
     C     S01496        ORNE      'Y'
     C     @X            ANDEQ     5
     C                   Z-ADD     *ZEROS        NORE
     C                   ELSE
     C                   EXSR      ZNOREC
?    C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     RDNXT         TAG
      *
     C                   ADD       1             @X
     C  N99              ADD       NORE          @COUN2
     C  N99              END
      *
     C     ENDOLD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RUNCTL SR  : Performs the final run control processing.       *
      *                                                               *
      *****************************************************************
      *
     C     RUNCTL        BEGSR
      *
      * Output Header Record.
      *
     C                   WRITE     HEADER
      *
      * If U8 & U7 are on output the DB Error format.
      *
     C     *INU7         IFEQ      '1'
     C     *INU8         ANDEQ     '1'
     C                   WRITE     ERROR
     C                   ELSE
      *
      * If the count of live records NE count of old records, print out
      *  a 'difference' note on the report.
      *
      *   HUT118 - The value calculated as Nr of Live Records (@COUNT)
      *            will replace the Value NORE of POSETA.
      *            No check is to be done to see if Nr of records
      *            calculated and old NORE from POSETA do not match.
      *            that the value calculated as Nr of Live Records
      *
      *
     C                   Z-ADD     @COUNT        NLRB
     C                   Z-ADD     0             NOIN
     C                   Z-ADD     0             NOAM
     C                   Z-ADD     0             NODE
     C                   Z-ADD     @COUNT        NORE
     C                   Z-ADD     0             TNLU
     C                   UPDATE    POSETAF
     C                   CLOSE     POSETA
      *
     C                   Z-ADD     @COUNT        OCNT01
     C                   Z-ADD     @COUN2        OCNT02
     C                   WRITE     CONTROL
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZNOREC SR  : Handles the 'no records on file' database error, *
      *              using the array pointer @X as the DB Error No.   *
      *                                                               *
      *****************************************************************
      *
     C     ZNOREC        BEGSR
      *
     C                   SETON                                        U7U899
     C                   MOVE      'POSET'       DBFILE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   Z-ADD     @X            DBASE
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      * ZDEFN SR   : Defines all program variables.                   *
      *                                                               *
      *****************************************************************
      *
     C     ZDEFN         BEGSR
      *
      * Define Data Areas
      * -----------------
      *
      * Define Like Work Fields
      * -----------------------
      *
      * Define Non-Like Work Fields
      * ---------------------------
      *
     C                   Z-ADD     0             @COUNT           15 0          New Rec. Count
     C                   Z-ADD     0             @COUN2           15 0          Old Rec. Count
     C                   MOVE      *BLANKS       #CMD             35            Command String
     C                   Z-ADD     0             #CMDLN           15 5          Command Length
     C                   MOVE      *BLANKS       @OVRDB           31            Command String
     C                   Z-ADD     0             @X                1 0          Array Index
      *
     C                   ENDSR

      *****************************************************************
      *  ZSYSTM - Subroutine to chain the installation control data.  *
      *  Called by: SRINIT                                            *
      *  Calls: Nothing                                               *
      *****************************************************************
     C     ZSYSTM        BEGSR
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVE      'XX118007'    DBPGM
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERR 01 *
     C                   Z-ADD     1             DBASE                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Check system date format, DDMMYY or MMDDYY.
      *
     C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      **
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      **
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ***
**CTDATA CPY@
(c) Finastra International Limited 2022
**CTDATA OVR
OVRDBF FILE(POSETA) MBR(CPOSN1)
OVRDBF FILE(POSETA) MBR(CPOSN2)
OVRDBF FILE(POSETA) MBR(DPOSN1)
OVRDBF FILE(POSETA) MBR(DPOSN2)
OVRDBF FILE(POSETA) MBR(CORPAC)
OVRDBF FILE(POSETA) MBR(POSETA)
**CTDATA OVS
OVRDBF FILE(POSETA) MBR(CPOSN1)
OVRDBF FILE(POSETA) MBR(CPOSN2)
OVRDBF FILE(POSETA) MBR(DPOSN1)
OVRDBF FILE(POSETA) MBR(DPOSN2)
OVRDBF FILE(POSETA) MBR(REDEMP)
OVRDBF FILE(POSETA) MBR(CORPAC)
OVRDBF FILE(POSETA) MBR(POSETA)
