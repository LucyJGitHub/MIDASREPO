     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Incoming message processing')
      *****************************************************************
      *  Midas - Midas/TI Interface                                   *
      *                                                               *
      *  TI0210 - Trade Innovation Incoming Message Processing        *
      *                                                               *
      *  Function:  This program reads incoming messages from SWIFT   *
      *             and writes them to the TI/SWIFT workfile MSTISIPD *
      *                                                               *
      *  Called By: TIC0210 - TI Incoming Message Processing          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 BUG4892            Date 22Nov04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210825             Date 31Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003             Date 10Nov00               *
      *                 174955             Date 10FEB00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 175156             Date 08Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001  *CREATE    Date 07Jul97               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG4892 - TRNO is not unique for messages received into TI   *
      *            Use MIR instead. Replace MSMSI2L7 with MSMSI2L9.   *
      *  210825 - Error reading through multiple incoming messages.   *
      *  CTI003 - Change to limit number of messages to be dealt with *
      *            at one time; to prevent system becoming jammed.    *
      *  174955 - Allocation problem in job #xxnSWTFR.                *
      *  175156 - Allow for messages ending 00                        *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
     F********************************************************************
     F*
     FSDBRCHL4  IF   E           K DISK
     FMSIXI2LG  UF   E           K DISK
     F                                     COMMIT
     F*MSMSI2L7**IF***E           K DISK                                                     BUG4892
     FMSMSI2L9  IF   E           K DISK                                                      BUG4892
     F*MSTISIPD**O****E             DISK                                                      174955
     FMSTISIPD  O    E             DISK    INFSR(*PSSR)                                       174955
     F                                     COMMIT
      ********************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *       96         record not found in SDBRCHL4
      *       97         error writing to MSTISIPD
      *       98         date format MMDDYY
      *       99         departmental server does not exist
      *       99         record not found in MSIXI2LG
      *       99         record not found in MSIXI2L7
      *       U7U8       Database Error
     F********************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
      * Copyright Statement
      *
      /SPACE 3
      *
     D ARR             DS
     D  @ARR                   1   9999
     D                                     DIM(9999)
      ** Data Structure for Message
      *
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  CTI003
      *                                                                                       CTI003
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CTI003
      * DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                          CTI003
     D LDA           E DS           256    EXTNAME(LDA)
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     DW@SOM            S              1    inz(x'01')
     DW@EOM            S              1    inz(x'03')
     DW@ZRO            S              1    inz(x'00')                                         175156
      ** Control codes: Start of message, End of message
      *
     D                 DS
     D  MTPY                   1      3
     D  W#MTPY                 1      3  0
      ** Define SWIFT message type as numeric
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *                                                                                       CTI003
      * Set counter for number of Incoming SWIFT Msgs to be processed                         CTI003
      *  - and make total numeric                                                             CTI003
     C                   Z-ADD     1             MessageCount      3 0                        CTI003
     C                   CALL      'AOTIINR0'                                                 CTI003
     C                   PARM      '*MSG'        WWRTCD            7                          CTI003
     C                   PARM      '*FIRST'      WWOPTN            7                          CTI003
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        CTI003
      *   Error?                                                                              CTI003
     C     WWRTCD        IFNE      *BLANKS                                                    CTI003
     C                   MOVEL     '*FIRST'      DBKEY                                        CTI003
     C                   MOVEL     'SDTIINPD'    DBFILE                                       CTI003
     C                   Z-ADD     003           DBASE                                        CTI003
     C                   EXSR      *PSSR                                                      CTI003
     C                   ENDIF                                                                CTI003
     C                   Z-ADD     TINOSM        TotalMessages     3 0                        CTI003
      * If TotalMessages = 0 then default value in to make program work                       CTI003
     C     TotalMessages IFEQ      0                                                          CTI003
     C                   Z-ADD     200           TotalMessages                                CTI003
     C                   ENDIF
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
      * Departmental server passed as a parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@DS              2
     C                   PARM                    @@MFLG            1
     C                   PARM                    @@BFL            10
     C                   PARM                    @@LIB            10
      *
      * Check that departmental server exists
      *
     C     @@DS          SETLL     SDBRCHL4                               99
     C     *IN99         IFEQ      *OFF
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SDBRCHL4'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     @@DS          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Loop for each branch with this department server
      *
     C     @@DS          READE     SDBRCHL4                               96
     C     *IN96         DOWEQ     *OFF
      *
      * Read from the Midas/SWIFT incoming messages file
      *
     C     A8BRCD        SETLL     MSIXI2LG
     C     A8BRCD        READE     MSIXI2LG                               99    *
      *
     C     *IN99         DOWNE     '1'
      * Stop loop when total number of Incoming Messages reached                              CTI003
     C*****MessageCount**ORGT      TotalMessages                                       CTI003 210825
     C     MessageCount  ANDLE     TotalMessages                                              210825
      *
      * Build then Write the message data for this message to MSTISIPD
      *
     C                   EXSR      PROCESS
      *
      * Update LEO (TI) status field on MSIXI2PD to 'P'
      *
     C                   MOVEL     'P'           LSTS
     C                   EXCEPT
      *
      **  COMIT all changes since no error on writing the message
      *
     C                   COMMIT
      *                                                                                       CTI003
     C                   ADD       1             MessageCount                                 CTI003
      *
      * Update Messages available flag to 'Y'
      *
     C                   MOVE      'Y'           @@MFLG
      *
      * Read from the Midas/SWIFT incoming messages file
      *
     C     A8BRCD        READE     MSIXI2LG                               99    *
     C                   ENDDO
     C*
      *
      * Read next branch with same departmental server
      *  unless total number of messages has been reached                                     CTI003
     C     MessageCount  IFGT      TotalMessages                                              CTI003
     C                   SETON                                        96                      CTI003
     C                   ELSE                                                                 CTI003
     C     @@DS          READE     SDBRCHL4                               96
     C                   ENDIF                                                                CTI003
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
     C****************************************************************
     C/EJECT
      ****************************************************************
      *                                                               *
      ***PROCESS*-*Read*MSMSI2L7*and*build*messages*for*MSTISIPD      *                      BUG4892
      ** PROCESS - Read MSMSI2L9 and build messages for MSTISIPD      *                      BUG4892
      *                                                               *
      *  Called by MAIN main processing                               *
      *  Calls     WRTMSG - write messages to MSTISIPD                *
      *                                                               *
     C****************************************************************
     C     PROCESS       BEGSR
      *
      **Read*all*message*data*for*the*message*(TRNO)*read*from                               BUG4892
      * Read all message data for the message (MIR) read from                                BUG4892
      * MSIXI2PD
      *
     C*****TRNO*         SETLL     MSMSI2D0                               99    *            BUG4892
     C*****TRNO*         READE     MSMSI2D0                               99    *            BUG4892
     C     MIR           SETLL     MSMSI2D0                               99    *            BUG4892
     C     MIR           READE     MSMSI2D0                               99    *            BUG4892
      *
      ** Initialize message array:
      **  blank the array, put HEX 01 in first pos., set array pointer to 2
      *
     C                   MOVEL     *BLANK        @ARR
     C                   MOVE      W@SOM         @ARR(1)
     C                   Z-ADD     2             @                 5 0
      *
     C     *IN99         DOWNE     '1'
      *
      * If a basic header record has been read in then
      *   write the message saved in array to MSTISIPD,
      *   initialise the message array,
      *   and set the array pointer to 2
      *
     C     '{1:'         SCAN      MDTA                                   99
     C     *IN99         IFEQ      '1'
     C                   EXSR      WRTMSG
     C                   MOVEL     *BLANK        @ARR
     C                   MOVE      W@SOM         @ARR(1)
     C                   Z-ADD     2             @
     C                   ENDIF
      *
      * If message is 400 or 700 series then:
      * Move data from record just read in into array
      * from a position in the array defined by the array pointer
      * and increment the array pointer by 256
      *
     C     W#MTPY        IFGE      400
     C     W#MTPY        ANDLE     499
     C     W#MTPY        ORGE      700
     C     W#MTPY        ANDLE     799
      *
     C                   MOVEA     MDTA          @ARR(@)
     C                   ADD       256           @
      *
      * If message length greater than 9999, ignore this message
      * by initialising the message array and setting the pointer to 2
      *
     C     @             IFGT      9999
     C                   SETON                                        U6
     C                   DUMP
     C                   MOVEL     *BLANK        @ARR
     C                   MOVE      W@SOM         @ARR(1)
     C                   Z-ADD     2             @
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*****TRNO*         READE     MSMSI2D0                               99    *            BUG4892
     C     MIR           READE     MSMSI2D0                               99    *            BUG4892
     C                   ENDDO
      *
      ** After EOF reached in the messages workfile
      *   write the message saved in array to MSTISIPD
      *
     C                   EXSR      WRTMSG
      *
     C                   ENDSR
     C****************************************************************
     C/EJECT
      ****************************************************************
      *                                                               *
      ** WRTMSG - Write Messages to the TI/SWIFT Workfile             *
      *                                                               *
      *  Called by PROCESS - builds messages                          *
      *  Calls     none                                               *
      *                                                               *
     C****************************************************************
     C     WRTMSG        BEGSR
      *
      * Find position in array of last message character
      *
     C     ' '           CHECKR    ARR           POS               4 0
      *
      * Ignore this message if POS < 2
      *
     C     POS           IFGE      2
      *
      *  Now write X'03' at position POS + 1
      *
     C     @ARR(POS)     IFNE      W@ZRO                                                      175156
     C                   ADD       1             POS
     C                   END                                                                  175156
     C                   MOVE      W@EOM         @ARR(POS)
      *
      *  write the message from the array to MSTISIPD (DATA 128)
      *
     C                   Z-ADD     1             COUNT             4 0
     C     COUNT         DOUGT     POS
     C                   MOVEA     @ARR(COUNT)   DATA
     C********           WRITE     MSTISID0
     C                   WRITE     MSTISID0                             97
      *
      **  Error on write to PF/MSTISIPD
      *
     C     *IN97         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     002           DBASE                                *********
     C                   MOVEL     'MSTISIPD'    DBFILE                               ROR 002 *
     C                   MOVEL     '        '    DBKEY                                *********
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ADD       128           COUNT
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   *PSSR - Error handling                                      *
      *                                                               *
      *  Called by MAIN-Main processing                               *
      *  Calls     none                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      **  Database error
      *
     C                   ROLBK
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
     OMSIXI2D0  E
     O                       LSTS
** CPY@   Object Copyright
(c) Misys International Banking Systems Ltd. 2001
