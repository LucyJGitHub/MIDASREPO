     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SDCUSTX2')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00045 - Migrate SDCUSTX2                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG33.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain SDCUST - record not found
      *       31      Chain SDCFCD - record not found
      *       32      Chain SDFCTL - record not found
      *       69      Read, write or chain fail
      *
     FSMPBCFPD  IF   E             DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FSDCUSTL0  UF   E           K DISK    INFSR(*PSSR)
     FSDCFCDL0  UF A E           K DISK    INFSR(*PSSR)
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
      *
      /EJECT
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Access to bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Set up variables for program
     C     ACCNTKEY      KLIST
     C                   KFLD                    bbstcn_n          6
     C                   KFLD                    BBSTCU
     C                   KFLD                    bbstac_n         10 0
     C                   KFLD                    BBSTSQ
     C                   KFLD                    BBSTBR
      *
     C                   Z-ADD     0             Inserts           5 0
     C                   Z-ADD     0             Updates           5 0
      *
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBCFPD
     C                   READ      SMPBCFPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
      * See if customer already exists on Fees Detail file.
     C     BBCNUM        CHAIN     @CFCDL0                            3169
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      * If it doesn't then check if it exists on the main Customer Details file.
     C     *IN31         IFEQ      *ON
     C     BBCNUM        CHAIN     @BBREBG                            3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      * If customer does not exist on main Customer Details file then
      *  read next record from SMPBCFPD ...
     C     *IN30         IFEQ      *ON
     C                   SETOFF                                       30
     C                   GOTO      READ_NEXT
     C                   ENDIF
      *
      * ... otherwise retrieve data to write record.
     C                   EXSR      ACCNT_SR
     C                   MOVEL     BBCNUM        E6CUST
     C                   MOVEL     BBTAIF        E6TAIF
     C                   MOVEL     'I'           E6TYLC
     C                   WRITE     @CFCDL0
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Inserts
      *
     C                   ELSE
      * If customer does exist on Fees Detail file then retrieve data
      *  to update record.
     C                   EXSR      ACCNT_SR
     C     E6TAIF        IFEQ      *BLANK
     C     BBTAIF        ANDNE     *BLANK
     C                   MOVEL     BBTAIF        E6TAIF
     C                   ENDIF
     C                   MOVEL     'A'           E6TYLC
     C                   UPDATE    @CFCDL0
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Updates
     C                   ENDIF
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBCFPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update file controls.
     C     'SDCFCDPD  '  CHAIN     SDFCTLL0                           3269
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN32         IFEQ      *OFF
     C                   ADD       Inserts       AHNORC
     C                   ADD       Inserts       AHNOIN
     C                   ADD       Updates       AHNOAM
     C                   UPDATE    @AHREAU                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * ACCNT_SR - Chain to the Accounts file.  If the account        *
      *            exists then update or write can be attempted.      *
      *
      *****************************************************************
      *
     C     ACCNT_SR      BEGSR                                                  ** *PSSR SR **
      *
     C                   MOVEL     BBSTCN        bbstcn_n
     C                   EVAL      bbstac_n = BBSTAC
     C     ACCNTKEY      CHAIN     ACCNT                              3269
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If account not found then do not update data.
     C     *IN32         IFEQ      *OFF
     C                   MOVEL     BBSTBR        E6SBCH
     C                   MOVEL     BBSTCU        E6SCCY
     C                   MOVEL     BBSTAC        FieldLen04        4
     C                   MOVEL     BBSTSQ        FieldLen02        2
     C     BBSTCN        CAT       FieldLen04    FieldLen10       10
     C     FieldLen10    CAT       FieldLen02    E6SMAC
     C                   MOVEL     PRFC          E6PFCD
      *
     C                   ELSE
     C                   SETOFF                                       32
     C                   ENDIF
      *
     C                   Z-ADD     BJRDNB        E6LCD
      *
     C     ACCNT_SR_E    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
