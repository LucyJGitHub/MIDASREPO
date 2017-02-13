     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRPIFUPD - Midas DL Reporting Information Update Program    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024368           Date 13Dec16               *
      *  Prev Amend No. MD030983           Date 04Oct16               *
      *                 CSW216             Date 14Mar16               *
      *                 MD023231           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD023802           Date 26Nov13               *
      *                 MD022751           Date 11Oct13               *
      *                 MD022579           Date 02Oct13               *
      *                 MD022052           Date 09Sep13               *
      *                 MD022367           Date 16Sep13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024368 - DB Error when reversing Deal with no Reporting    *
      *             details. Applied for MD-39839                     *
      *  MD030983 -  Generated messages still display previous trade  *
      *              repository details upon reversal of the deal     *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD023231 - MT300 not generated when Trade Repo ID is changed *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD023802 - Missing MT340 CANC for Trade Repo ID              *
      *  MD022751 - Paper Confirmation generated for trade repository *
      *             ID entered that has no Swift id                   *
      *  MD022579 - MT300 not generated when Trade Repo ID is changed *
      *  MD022052 - Action amend_Amend maturity date where trade repo *
      *             has SWIFT Id_MT360 for trade repo is not generated*
      *  MD022367 - MT300 Incorrect value for field tag 21 during     *
      *             AMEND and DELETE of FXDL                          *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
 
      ** Reporting information keyed by API ID and Transaction Ref
     FDLRPIFL2  UF A E           K DISK
     F                                     COMMIT
      *
      ** Outgoing Message History
     FMGHISTL5  IF   E           K DISK
 
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
 
      ** Include the FX standard declares
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Valid Report Information details
     D RPIFValid     E DS                  EXTNAME(DLVRPIPD)
     D***ValdS1*                1    997                                                      CSW214
     D***ValdS2*             1002   1806                                                      CSW214
     D***ValdS3*             1818   1826                                                      CSW214
     D***ValdS1                 1   1037                                               CSW214 CSW216
     D***ValdS2              1042   1846                                               CSW214 CSW216
     D***ValdS3              1858   1866                                               CSW214 CSW216
     D***ValdS4              1898   1954                                               CSW214 CSW216
     D  ValdS1                 1   1077                                                       CSW216
     D  ValdS2              1082   1886                                                       CSW216
     D  ValdS3              1898   1906                                                       CSW216
     D  ValdS4              1938   1994                                                       CSW216
     D  WVTRRF                        6A   OVERLAY(RVTRRF)                                  MD022052
 
      ** Report Information details
     D DLRPIF        E DS                  EXTNAME(DLRPIFPD)
     D***RPIFS1*                1    997                                                      CSW214
     D***RPIFS2*             1002   1806                                                      CSW214
     D***RPIFS3*             1818   1826                                                      CSW214
     D***RPIFS1*                1   1037                                               CSW214 CSW216
     D***RPIFS2*             1042   1846                                               CSW214 CSW216
     D***RPIFS3*             1858   1866                                               CSW214 CSW216
     D***RPIFS4*             1898   1954                                               CSW214 CSW216
     D  RPIFS1                 1   1077                                                       CSW216
     D  RPIFS2              1082   1886                                                       CSW216
     D  RPIFS3              1898   1906                                                       CSW216
     D  RPIFS4              1938   1994                                                       CSW216
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                MD022751
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   MD022751
 
     D PRtnCode        S              7
 
     D Seq             S              3
     D REPOID          S             10A                                                    MD022751
     D PRtcd           S              7A                                                    MD022751
     D POptn           S              7A                                                    MD022751
     D PCusn           S             10A                                                    MD022751
     D PKySt           S              7A                                                    MD022751
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - Main Processing                                        *
     C*                                                               *
     C*****************************************************************
      *
      ** Exit if action if not insert, amend, and delete
      *
     C     RVCHTP        IFNE      'I'
     C     RVCHTP        ANDNE     'A'
     C     RVCHTP        ANDNE     'D'
     C                   RETURN
     C                   END
      *
      ** Insert, amend, or delete record
      *
 
     C     RVCHTP        CASEQ     'I'           RPIFIns
     C     RVCHTP        CASEQ     'A'           RPIFAmd
     C     RVCHTP        CASEQ     'D'           RPIFDel
     C                   END
      *
      * Return to calling program
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* RPIFIns - Insert an RPIF record                              *
     C*                                                              *
     C****************************************************************
     C     RPIFIns       BEGSR
 
     C     RPIFKey       CHAIN     DLRPIFL2                           99
 
     C     *IN99         IFEQ      '0'
 
     C                   MOVEL     RVTRRF        DBKEY
     C                   MOVE      RVAPID        DBKEY
     C                   MOVEL     'DLRPIF'      DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
 
     C                   ELSE
 
     C                   MOVEL     RPIFValid     DLRPIF
     C**********         EVAL      RICFRQ = 'Y'                                             MD022751
     C**********         EVAL      RICFGN = 'N'                                             MD022751
     C                   EXSR      SRFMTID                                                  MD022751
     C                   Z-ADD     0             RICFNR
     C                   EVAL      RICHTP = RVCHTP
     C                   Z-ADD     BJRDNB        RILCD
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    RITMST
 
     C                   WRITE     DLRPIFD0
 
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* RPIFAmd - Amend an RPIF record                               *
     C*                                                              *
     C****************************************************************
     C     RPIFAmd       BEGSR
      *
     C     RPIFKey       CHAIN     DLRPIFL2                           99
      *
     C     *IN99         IFEQ      '0'
 
      ** If any field changed in reporting information except
      ** Event Type, then set confirmation Required = 'Y'
      ** and confirmation generated Flag to 'N'.
 
     C                   IF        ValdS1 <> RPIFS1 OR
     C                             ValdS2 <> RPIFS2 OR
     C**********                   ValdS3 <> RPIFS3                                         MD022367
     C                             ValdS3 <> RPIFS3 OR                                      MD022367
     C                             ValdS4 <> RPIFS4 OR                                        CSW214
     C                             ValdS1 =  RPIFS1 AND                                     MD022367
     C                             ValdS2 =  RPIFS2 AND                                     MD022367
     C**********                   ValdS3 =  RPIFS3 AND RVCHTP = 'A'                 MD022367 CSW214
     C                             ValdS3 =  RPIFS3 AND                                       CSW214
     C                             ValdS4 =  RPIFS4 AND                                       CSW214
     C                             RVCHTP =  'A'                                              CSW214
 
     C**********         EVAL      RICFRQ = 'Y'                                             MD022579
     C**********         EVAL      RICFGN = 'N'                                             MD022579
     C**********         EVAL      RVCFRQ = 'Y'                                    MD022579 MD022751
     C**********         EVAL      RVCFGN = 'N'                                    MD022579 MD022751
 
     C**********         IF        RVTRID <> RITRID                                         MD022052
     C**********         EVAL      RIPRED = RITRID                                          MD022579
     C                   EVAL      Seq = '999'
     C*****HSTKey        SETLL     MGHISTD0                           01                    MD022052
     C     HSTKey        SETLL     MGHISTD0                               01                MD022052
 
     C**********         IF        *IN01 = *OFF                                             MD022052
     C**********         IF        *IN01 = *ON                                     MD022052 MD022579
     C                   IF        *IN01 = *ON OR                                           MD022579
     C                             *IN01 = *OFF AND                                         MD022579
     C                             RVTRID <> RITRID                                         MD022579
     C                   Z-ADD     0             RICFNR
     C                   EVAL      RVCFNR = RICFNR                                          MD023231
     C                   EVAL      RVPRED = RITRID                                          MD022579
     C                   ELSE
     C**********         READ      MGHISTL5                               01                MD022052
     C                   READP     MGHISTL5                               01                MD022052
     C                   MOVEL     HSSEQ         RICFNR
     C                   MOVEL     RICFNR        RVCFNR                                     MD022052
     C                   EVAL      RVPRED = *BLANKS                                         MD023231
     C                   ENDIF
     C**********         ENDIF                                                              MD022052
 
     C                   ENDIF
 
     C                   EVAL      DLRPIF = RPIFValid
     C                   EVAL      RICHTP = RVCHTP
     C                   EXSR      SRFMTID                                                  MD022751
     C                   Z-ADD     BJRDNB        RILCD
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    RITMST
 
     C                   UPDATE    DLRPIFD0
 
     C                   ELSE
 
     C                   EVAL      DLRPIF = RPIFValid
     C                   EVAL      RICFRQ = 'Y'
     C                   EVAL      RICFGN = 'N'
     C                   Z-ADD     0             RICFNR
     C                   EVAL      RICHTP = RVCHTP
     C                   Z-ADD     BJRDNB        RILCD
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    RITMST
 
     C                   WRITE     DLRPIFD0
 
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* RPIFDel - Delete an RPIF record                              *
     C*                                                              *
     C****************************************************************
     C     RPIFDEL       BEGSR
 
     C     RPIFKey       CHAIN     DLRPIFL2                           99
 
     C     *IN99         IFEQ      '0'
 
     C                   EVAL      RICFRQ = 'Y'                                             MD023802
     C                   EVAL      RICFGN = 'N'                                             MD023802
     C                   EVAL      RICHTP = 'D'
     C                   Z-ADD     BJRDNB        RILCD
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    RITMST
     C                   EVAL      RIPRED = *BLANKS                                         MD030983
 
     C                   UPDATE    DLRPIFD0
 
     C**********         ELSE                                                               MD024368
 
     C**********         MOVEL     RVTRRF        DBKEY                                      MD024368
     C**********         MOVEL     'DLRPIF'      DBFILE                                     MD024368
     C**********         MOVEL     '004'         DBASE                                      MD024368
     C**********         EXSR      SRERR                                                    MD024368
 
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtnCode
     C                   PARM                    RPIFValid
 
     C     RPIFKey       KLIST
     C                   KFLD                    RVAPID
     C                   KFLD                    RVTRRF
 
     C     HSTKey        KLIST
     C**********         KFLD                    RVTRID                                     MD022052
     C                   KFLD                    WVTRRF                                     MD022052
     C                   KFLD                    RVTRID                                     MD022579
     C                   KFLD                    Seq
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRtnCode
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtnCode      IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
 
     C                   ENDSR
     C****************************************************************                      MD022751
      /EJECT                                                                                MD022751
      *****************************************************************                     MD022751
      *                                                               *                     MD022751
      * SRFMTID - Swift Id access for Trade Repository                *                     MD022751
      *                                                               *                     MD022751
      *****************************************************************                     MD022751
     C     SRFMTID       BEGSR                                                              MD022751
                                                                                            MD022751
     C                   EVAL      REPOID = *BLANKS                                         MD022751
     C                   EVAL      REPOID = RITRID                                          MD022751
     C                   CALL      'AOCSSWR0'                                               MD022751
     C                   PARM      *BLANKS       PRtcd                                      MD022751
     C                   PARM      '*KEY'        POptn                                      MD022751
     C                   PARM      REPOID        PCusn                                      MD022751
     C                   PARM      *BLANKS       PKySt                                      MD022751
     C     SDCUST        PARM      SDCUST        DSLDY                                      MD022751
     C                   IF        BBCSID = *BLANKS                                         MD022751
     C                   EVAL      RICFRQ = 'N'                                             MD022751
     C                   EVAL      RICFGN = 'N'                                             MD022751
     C                   ELSE                                                               MD022751
     C                   EVAL      RICFRQ = 'Y'                                             MD022751
     C                   EVAL      RICFGN = 'N'                                             MD022751
     C                   ENDIF                                                              MD022751
                                                                                            MD022751
     C                   ENDSR                                                              MD022751
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - Exception errors                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     PRtnCode
     C                   MOVEL     'DLRPIFUPD'   DBPGM
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      ** Terminate the program
      *
     C                   RETURN
 
     C                   ENDSR
     C****************************************************************
