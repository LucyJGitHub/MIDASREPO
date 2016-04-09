     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Drop Processing')
      *****************************************************************
      *                                                               *
      *  Midas - MIDAS Common Routines                                *
      *                                                               *
      *  SD001004 - Midas SD Drop Process                             *
      *                                                               *
      *  Function:  This module will check the year field set for the *
      *             different files SDTIZOPD, SDTIZHPD, and SDDSTCPD  *
      *             and drop it if the value is less than the current *
      *             year minus the value set at system value level.   *
      *                                                               *
      *  Called By: SDC001004 - Midas SD Drop Process                 *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         Control indicator                               *
      *    U8         Control indicator                               *
      *    LR         Last Record indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR         - Error processing                              *
      * *INZSR        - Initialise                                    *
      * SRDropTZOFile - Drop records from Time Zone file              *
      * SRDropTZHFile - Drop records from Time Zone History file      *
      * SRDropDSTFile - Drop records from DST file                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSDTIZOPD  UF   E           K DISK
      ** Time Zone Update File
      *
     FSDTIZHPD  UF   E           K DISK
      ** Time Zone History Update File
      *
     FSDDSTCPD  UF   E           K DISK
      ** SD DST Code Update File
      *
     FSDTZLVPD  UF   E           K DISK
      ** SD Time Zone Level Code File
      *
     FSDTZLHPD  UF   E           K DISK
      ** SD Time Zone Level Code History File
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D RetPeriod       C                   CONST('SDTZRFRetP')
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for AOBANKR0
     D @RUN            S              1
     D @Rtcd           S              7A
     D @Optn           S              7A
      *
      ** Parameters for AOSVALR0
     D PRtcd           S              7A
     D POp01           S             20A
     D PVl01           S            200A
     D POp02           S             20A
     D PVl02           S            200A
     D POp03           S             20A
     D PVl03           S            200A
     D POp04           S             20A
     D PVl04           S            200A
     D POp05           S             20A
     D PVl05           S            200A
     D POp06           S             20A
     D PVl06           S            200A
     D POp07           S             20A
     D PVl07           S            200A
     D POp08           S             20A
     D PVl08           S            200A
     D POp09           S             20A
     D PVl09           S            200A
     D POp10           S             20A
     D PVl10           S            200A
      *
      ** Work variables
     D WRunYear        S              4S 0
     D WFilYear        S              4S 0
     D WElapsed        S              2S 0
     D WRetPeriod      S              2S 0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Perform drop process for Time Zone File
      *
     C                   EXSR      SRDropTZOFile
      *
      ** Perform drop process for Time Zone History File
      *
     C                   EXSR      SRDropTZHFile
      *
      ** Perform drop process for DST File
      *
     C                   EXSR      SRDropDSTFile
      *
      *
      ** Perform drop process for Time Zone Level Code File
      *
     C                   EXSR      SRDropTZLVFile
      *
      *
      ** Perform drop process for Time Zone Level Code History File
      *
     C                   EXSR      SRDropTZLHFile
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDropTZOFile - Subroutine to drop records from Time Zone     *
      *                 File                                          *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDropTZOFile BEGSR
      *
     C                   DOW       NOT (%EOF(SDTIZOPD))
     C                   READ      SDTIZOPD
     C                   IF        (NOT %EOF) AND
     C                             TZYEAR <> *BLANKS
     C                   MOVE      TZYEAR        WFilYear
     C                   EVAL      WElapsed = WRunYear - WFilYear
     C                   IF        WElapsed > WRetPeriod
     C                   DELETE    SDTIZOD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDropTZHFile - Subroutine to drop records from Time Zone     *
      *                 History File                                  *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDropTZHFile BEGSR
      *
     C                   DOW       NOT (%EOF(SDTIZHPD))
     C                   READ      SDTIZHPD
     C                   IF        (NOT %EOF) AND
     C                             THYEAR <> *BLANKS
     C                   MOVE      THYEAR        WFilYear
     C                   EVAL      WElapsed = WRunYear - WFilYear
     C                   IF        WElapsed > WRetPeriod
     C                   DELETE    SDTIZHD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDropDSTFile - Subroutine to drop records from DST File      *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDropDSTFile BEGSR
      *
     C                   DOW       NOT (%EOF(SDDSTCPD))
     C                   READ      SDDSTCPD
     C                   IF        (NOT %EOF) AND
     C                             DSYEAR <> *BLANKS
     C                   MOVE      DSYEAR        WFilYear
     C                   EVAL      WElapsed = WRunYear - WFilYear
     C                   IF        WElapsed > WRetPeriod
     C                   DELETE    SDDSTCD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDropTZLVFile - Subroutine to drop records from Time Zone    *
      *                 Level Code File                               *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDropTZLVFileBEGSR
      *
     C                   DOW       NOT (%EOF(SDTZLVPD))
     C                   READ      SDTZLVPD
     C                   IF        (NOT %EOF) AND
     C                             TLYEAR <> *BLANKS
     C                   MOVE      TLYEAR        WFilYear
     C                   EVAL      WElapsed = WRunYear - WFilYear
     C                   IF        WElapsed > WRetPeriod
     C                   DELETE    SDTZLVD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDropTZLHFile - Subroutine to drop records from Time Zone    *
      *                 Level Code History File                       *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDropTZLHFileBEGSR
      *
     C                   DOW       NOT (%EOF(SDTZLHPD))
     C                   READ      SDTZLHPD
     C                   IF        (NOT %EOF) AND
     C                             TVYEAR <> *BLANKS
     C                   MOVE      TVYEAR        WFilYear
     C                   EVAL      WElapsed = WRunYear - WFilYear
     C                   IF        WElapsed > WRetPeriod
     C                   DELETE    SDTZLHD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   EVAL      WFilYear = *ZEROS
     C                   EVAL      WElapsed = *ZEROS
     C                   EVAL      WRunYear = *ZEROS
      *
      ** Call AOBANKR0 to get the current Midas run date
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSfdy
      *
     C     @Rtcd         IFNE      *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey  = @OPTN
     C                   EVAL      DBase  = 002
     C                   EXSR      *Pssr
     C                   ENDIF
      *
      ** Get the year of the Midas run date
      *
     C                   Z-ADD     BJRDNB        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
     C                   MOVEL     ZSDATC        WRunYear
      *
      ** Call AOSVALR0 to get the retention period set-up
      ** from the system
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      RetPeriod     POp01
     C                   PARM      *BLANKS       PVl01
     C                   PARM      *BLANKS       POp02
     C                   PARM      *BLANKS       PVl02
     C                   PARM      *BLANKS       POp03
     C                   PARM      *BLANKS       PVl03
     C                   PARM      *BLANKS       POp04
     C                   PARM      *BLANKS       PVl04
     C                   PARM      *BLANKS       POp05
     C                   PARM      *BLANKS       PVl05
     C                   PARM      *BLANKS       POp06
     C                   PARM      *BLANKS       PVl06
     C                   PARM      *BLANKS       POp07
     C                   PARM      *BLANKS       PVl07
     C                   PARM      *BLANKS       POp08
     C                   PARM      *BLANKS       PVl08
     C                   PARM      *BLANKS       POp09
     C                   PARM      *BLANKS       PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM      *BLANKS       PVl10
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 17
     C                   EVAL      DBKey = POp01
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     PVl01         WRetperiod
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
