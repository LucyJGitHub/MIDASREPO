     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD MDF extract invalid transactions')
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  SD1493 - Extract Invalid Transactions                        *
      *                                                               *
      *  Function:  This program will extract all invalid transactions*
      *             still on the various invalid transaction files    *
      *             for MDF                                           *
      *                                                               *
      *  Called By: SDC1493 - Transactions Awaiting Repair component  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 196570  *CREATE    Date 12Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  196570 - Patch for Market Data Feed: enhanced MDF reporting  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FFDIFWRTPD IF   E           K DISK    INFSR(*PSSR)
      ** FD Forward Rate Details invalid logging file
     F                                     RENAME(FDIFWRTD0:FDIFWRD0)
      *
     FFDIINTRPD IF   E           K DISK    INFSR(*PSSR)
      ** FD Interest Rate Details invalid logging file
     F                                     RENAME(FDIINTRD0:FDIINTD0)
      *
     FSDIBSRTPD IF   E           K DISK    INFSR(*PSSR)
      ** FD Base Rate Details invalid logging file
     F                                      RENAME(SDIBSRTD0:FDIBSRD0)
      *
     FSDISPTRPD IF   E           K DISK    INFSR(*PSSR)
      ** FD Spot Rate Details invalid logging file
     F                                     RENAME(SDISPTRD0:SDISPTD0)
      *
     FSEIPRCSPD IF   E           K DISK    INFSR(*PSSR)
      ** SE Security Price Details invalid logging file
     F                                     RENAME(SEIPRCSD0:SEIPRCD0)
     FSDINVLPD  O    E           K DISK    INFSR(*PSSR)
      ** Merged API invalid logging file **
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     31 - read indicator for invalid INTRs                     *
      *     32 - read indicator for invalid BSRTs                     *
      *     33 - read indicator for invalid SPTRs                     *
      *     34 - read indicator for invalid PRCSs                     *
      *     36 - read indicator for invalid FWRTs                     *
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D                 DS
     D  AYRS                   1      4
     D  AMON                   6      7
     D  ADAY                   9     10
     D  AHRS                  12     13
     D  AMIN                  15     16
     D  ASEC                  18     19
     D  AMSC                  21     26
     D  ATMST                  1     26
      *
     D                 DS
     D  BYRS                   1      4
     D  BMON                   5      6
     D  BDAY                   7      8
     D  BHRS                   9     10
     D  BMIN                  11     12
     D  BSEC                  13     14
     D  BMSC                  15     20
     D  BTMST                  1     20  0
      *
     D                 DS
     D  PDBRCA                 1      3
     D  PDCNUM                 4      9
     D  PDCCY                 10     12
     D**PDACOD**              13     16                                                       CGL029
     D**PDACSQ**              17     18                                                       CGL029
     D**PDACCN**               1     18                                                       CGL029
     D  PDACOD                13     22                                                       CGL029
     D  PDACSQ                23     24                                                       CGL029
     D  PDACCN                 1     24                                                       CGL029
      *
     D WAPTRAN         DS            18
     D  WSDSN                  1     10
     D  WSDED                 11     16
     D  WSDET                 17     18
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     IFDIFWRD0
     I              DDACTN                      RDACTN
     I              DDCCY                       RDCCY
     I              DDFOTRANID                  RDFOTR
     I              DDFOASOCID                  RDFOAS
     I              DDRPRLOCN                   RDRPRL
     I              DDTMESTMP                   RDTMES
     I              DDDFRI                      RDDTFR
      *
     IFDIINTD0
     I              DDACTN                      SDACTN
     I              DDCCY                       SDCCY
     I              DDFOTRANID                  SDFOTR
     I              DDFOASOCID                  SDFOAS
     I              DDRPRLOCN                   SDRPRL
     I              DDTMESTMP                   SDTMES
     I              DDDTFR                      SDDTFR
      *
     IFDIBSRD0
     I              DDACTN                      TDACTN
     I              DDCYCD                      TDCYCD
     I              DDFOTRANID                  TDFOTR
     I              DDRPRLOCN                   TDRPRL
     I              DDTMESTMP                   TDTMES
     I              DDDTFR                      TDDTFR
      *
     ISDISPTD0
     I              DDACTN                      UDACTN
     I              DDCYCD                      UDCYCD
     I              DDSPRT                      UDSPRT
     I              DDFOTRANID                  UDFOTR
     I              DDRPRLOCN                   UDRPRL
     I              DDTMESTMP                   UDTMES
     I              DDDTFR                      UDDTFR
      *
     ISEIPRCD0
     I              DDACTN                      VDACTN
     I              DDPSSN                      VDPSSN
     I              DDFOTRANID                  VDFOTR
     I              DDFOASOCID                  VDFOAS
     I              DDRPRLOCN                   VDRPRL
     I              DDTMESTMP                   VDTMES
     I              DDDTFR                      VDDTFR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Initial processing
     C                   EXSR      INIT
      *
      ** Main processing
     C                   EXSR      MAIN
      *
      ** End processing
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main Processing                                        *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls:     ZDATE2, *PSSR                                      *
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Extract invalid transactions from the
      *
     C                   EXSR      IFWRT
     C                   EXSR      IINTR
     C                   EXSR      IBSRT
     C                   EXSR      ISPTR
     C                   EXSR      IPRCS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * IFWRT - FD Forward Rate Details                               *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     IFWRT         BEGSR
      *
      ** Do first read before main loop
     C                   READ      FDIFWRTPD                              36
      *
      ** Loop while records read
     C     *IN36         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   IF        RDDTFR <> *BLANKS
     C                   MOVE      RDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      RDTMES        APTMES
     C                   MOVEL     RDFOTR        APFOTR
     C                   MOVEL     *BLANKS       APFOAS
     C                   MOVEL     'FDFWRT'      APFUNC
     C                   MOVEL     RDCCY         APTRAN
     C                   MOVE      RDDTFR        APDTFR
      *
      ** Write details
     C                   WRITE     SDINVLD0
      *
     C                   ENDIF
      ** Read next record and loop back
     C                   READ      FDIFWRTPD                              36
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IINTR - FD Interest Rate Details                              *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     IINTR         BEGSR
      *
      ** Do first read before main loop
     C                   READ      FDIINTRPD                              31
      *
      ** Loop while records read
     C     *IN36         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   IF        SDDTFR <> *BLANKS
     C                   MOVE      SDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
     C                   MOVE      SDDTFR        APDTFR
      *
     C                   MOVE      SDTMES        APTMES
     C                   MOVEL     SDFOTR        APFOTR
     C                   MOVEL     *BLANKS       APFOAS
     C                   MOVEL     'FDINTR'      APFUNC
     C                   MOVEL     SDCCY         APTRAN
      *
      ** Write details
     C                   WRITE     SDINVLD0
      *
     C                   ENDIF
      ** Read next record and loop back
     C                   READ      FDIINTRPD                              31
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IBSRT - SD Base Rate Details                                  *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     IBSRT         BEGSR
      *
      ** Do first read before main loop
     C                   READ      SDIBSRTPD                              32
      *
      ** Loop while records read
     C     *IN32         DOWEQ     '0'
 
      * Set output fields
      *
     C                   IF        TDDTFR <> *BLANKS
     C                   MOVE      TDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
 
     C                   MOVE      TDTMES        APTMES
     C                   MOVEL     TDFOTR        APFOTR
     C                   MOVEL     *BLANKS       APFOAS
     C                   MOVEL     'SDBSRT'      APFUNC
     C                   MOVEL     TDCYCD        APTRAN
     C                   MOVE      TDDTFR        APDTFR
      *
      ** Write details
     C                   WRITE     SDINVLD0
      *
     C                   ENDIF
      ** Read next record and loop back
     C                   READ      SDIBSRTPD                              32
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      */EJECT
      *****************************************************************
      * ISPTR - SD Spot Rate Details                                  *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     ISPTR         BEGSR
      *
      ** Do first read before main loop
     C                   READ      SDISPTRPD                              33
      *
      ** Loop while records read
     C     *IN33         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   IF        UDDTFR <> *BLANKS
     C
     C                   MOVE      UDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      UDTMES        APTMES
     C                   MOVEL     UDFOTR        APFOTR
     C                   MOVEL     *BLANKS       APFOAS
     C                   MOVEL     'SDSPTR'      APFUNC
     C                   MOVEL     UDCYCD        APTRAN
     C                   MOVE      UDDTFR        APDTFR
      *
      ** Write details
     C                   WRITE     SDINVLD0
      *
     C                   ENDIF
      ** Read next record and loop back
     C                   READ      SDISPTRPD                              33
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IPRCS - SE Security Price Details                             *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     IPRCS         BEGSR
      *
      ** Do first read before main loop
     C                   READ      SEIPRCSPD                              34
      *
      ** Loop while records read
     C     *IN34         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   IF        VDDTFR <> *BLANKS
     C                   MOVE      VDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      VDTMES        APTMES
     C                   MOVEL     VDFOTR        APFOTR
     C                   MOVEL     *BLANKS       APFOAS
     C                   MOVEL     'SEPRCS'      APFUNC
     C                   MOVEL     VDPSSN        APTRAN
     C                   MOVE      VDDTFR        APDTFR
      *
      ** Write details
     C                   WRITE     SDINVLD0
      *
      ** Read next record and loop back
     C                   READ      SEIPRCSPD                              34
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * INIT - Initialisation routine                                 *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     *PSSR                                              *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * END - End Routine                                             *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls: None                                                   *
      *****************************************************************
     C     END           BEGSR
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: INIT, MAIN                                         *
      * Calls:     None                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   MOVEL(P)  'SD1493'      DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@ - Object copyright
(c) Misys International Banking Systems Ltd. 2001
