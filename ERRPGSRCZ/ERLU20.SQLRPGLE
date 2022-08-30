     H DEBUG
      *****************************************************************
/*OVRF*: OVRDBF FILE(EREXRAZ1) TOFILE(EREXRAV1) SHARE(*NO)          : *
/******: OVRDBF SDECOSPD SDECOSLXPD                                 : *           183923    MD058085
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas Amount Due Weighting Rates Decision Table')
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting                                   *
      *                                                               *
      *  ERLU20 - Amount Due Weighting Rates Decision Table           *
      *           Maintenance                                         *
      *                                                               *
      *  Function:  This program is used to record the weighting      *
      *             rates to apply on the customer exposures.         *
      *                                                               *
      *  Called By: ERCLU20 - Amount Due Weighting Rates Maintenance  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Aug05               *
      *                 UPG402             Date 05Oct04               *
      *                 UPGCSW             Date 27Sep02               *
      *                 210004             Date 26Sep02               *
      *                 183923             Date 20Sep00
      *                 CAD031             Date 05Jan99               *
      *                 ULX012  *CREATE    Date 12Aug98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus (Recompile only)           *
      *  UPG402 - Recompile due to change in ZALIGNZ2                 *
      *  UPGCSW - Due to an upgrade of swift changes 2002 rename      *
      *           variable V to W (confict with hook ZSRSRC/ZCOTRZ1   *
      *           Amend ZSRSRC,ZALIGNZ2
      *  210004 - Mismatch between ',' and '.' in Amend mode.         *
      *           Link with fix 206456 in ZEDIT. So, apply same fix   *
      *           in SR/ZALIGN and SR/ZFRPED.                         *
      *  183923 - File SDECOSPD is renamed SDECOSLXPD.                *
      *           Recompile                                           *
      *  CAD031 - To use new economic sector codes                    *
      *  ULX012 - Guarantees and Collateral Management enhancements   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *    F U N C T I O N    O F   I N D I C A T O R S               *
      *    ============================================               *
      *                                                               *
      *  *IN03  -  F3  pressed, exit program                          *
      *  *IN05  -  F05 pressed, refresh screen                        *
      *  *IN12  -  F09 pressed => Change Mode                         *
      *  *IN15  -  Program called in enquiry mode                     *
      *  *IN16  -  'Add Mode'                                         *
      *  *IN17  -  No data to display                                 *
      *  *IN18  -  Record deleted                                     *
      *  *IN20  -  Error Selection field and Action Code              *
      *  *IN21  -  Error Economic Sector Code field                   *
      *  *IN22  -  Error Zone A/B field                               *
      *  *IN23  -  Error Claim's Type field                           *
      *  *IN24  -  Error Claim's Maturity field                       *
      *  *IN25  -  Error Weighting Rate field                         *
      *  *IN35  -  Rollup key pressed                                 *
      *  *IN45  -  Any valid key                                      *
      *  *IN60  -  Eof not reached                                    *
      *  *IN63  -  SFLNXTCHG indicator                                *
      *  *IN77  -  Working field for scan '?'                         *
      *  *IN80  -  SFLDSPCTL indicator                                *
      *  *IN81  -  SFLDSP indicator                                   *
      *  *IN87  -  Eof in the subfile                                 *
      *  *IN88  -  Eof in the Master file                             *
      *  *IN89  -  Working indicator                                  *
      *                                                               *
      *  *INLR  -  End processing                                     *
      *  *INU7  -  Data-base                                          *
      *  *INU8  -  Error control                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  SRF9   -  SR executed if F9 pressed                          *
      *  SRCHCK -  SR To check if changes in subfile                  *
      *  SRVAL  -  SR To validate                                     *
      *  INISFL -  Initialize subfile                                 *
      *  LOASFE -  Load subfile                                       *
      *  LOASF9 -  Load subfile when F9 Key has been pressed          *
      *  SELEC  -  SR selection for the record read                   *
      *  PRESS  -  SR to move the appropriate values into field WWAID,*
      *            depending on which function key has been pressed   *
      *  *INZSR -  Initial Processing                                 *
      *                                                               *
      *  ZASNMS -  SR to send message to program's message queue      *
      *  *PSSR  -  Dump routine in case of error                      *
      *                                                               *
      *****************************************************************
     FEREXRAZ1  IF   E           K DISK    INFSR(*PSSR)
      ***  Amount due Weighting Rates Decision Table
      *
     FEREXRAV1  UF A E           K DISK    COMMIT
      ***  Amount due Weighting Rates Decision Table
     F                                     RENAME(EREXRAD0:UPERLUAC)
      *
     F**SDECOSPDIF  E           K        DISK         KINFSR *PSSR        CAD031
     F*SDNCOSPD* IF   E           K DISK    INFSR(*PSSR)                         CAD031     MD058085
      ***  ER Economic Sector table
      *
     FERLU20DF  CF   E             WORKSTN INFDS(INFDS#)
      ***  Amount due Weighting Rates Display file
     F                                     SFILE(ERLU20S1:SFLREC)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D*COPY*ZSRSRC,ZALIGNZ1                                                                 MD058085
     D/COPY ZSRSRC,ZALIGNZ1LE                                                               MD058085
      *
     D TXT             S             78    DIM(3) CTDATA PERRCD(1)
      ***  Bottom lign screen
      *
     D DUR             S              5    DIM(15) CTDATA PERRCD(1)
     D PER             S              2  0 DIM(15) ALT(DUR)
      ***  Duration and period Code
      *
      ***  Array containing Copyright statement
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D INFDS#          DS
     D  CPFPOS               378    379B 0
      *
     D PSDS           SDS
     D  ##PGM            *PROC
     D  SJOB                 244    253
     D  SUSER                254    263
     D  STIME                282    287  0
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ***  Local data area for database error details
      *
     D                 DS
     D  DHECSC                 1      4
     D  DHZABI                 5      5
     D  DHCLAT                 6      6
     D  DHCLAM                 7     11
     D  DHWEIG                12     14
     D  SELEC1                 1     14
      *
     D                 DS
     D  WWECSC                 1      4
     D  WWZABI                 5      5
     D  WWCLAT                 6      6
     D  WWCLAM                 7     11
     D  WWWEIG                12     14
     D  SELEC2                 1     14
      *
     D                 DS
     D  WKECSC                 1      4  0
     D  WKZABI                 5      5
     D  WKCLAT                 6      6  0
     D  WKPECO                 7      9  0
     D  WKSELE                 1      9
      *
     D                 DS
     D  W2ECSC                 1      4  0
     D  W2ZABI                 5      5
     D  W2CLAT                 6      6  0
     D  W2PECO                 7      9  0
     D  WWSAV2                 1      9
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  DS for access programs, short data structure
      *
     D SDNCOS        E DS                  EXTNAME(SDNCOJW0)                                MD058085
     D CPYR@#          DS
      ***  Data structure for compilation  - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                M A I N     P R O C E S S I N G                *
      *****************************************************************
      *
      ***  ' ADD MODE ' on first cycle
      *
     C     *IN09         IFNE      *ON
     C                   EXSR      INISFL                                       Init. Subfile
     C                   EXSR      LOASFE                                       Load subfile Enquiry
      *
     C     CPFPOS        IFNE      *ZEROS
     C                   Z-ADD     CPFPOS        SFLREC
     C                   ENDIF
     C                   ENDIF
      *
      ***  Do while not F3 or F12 pressed
      *
     C     *INKC         DOWEQ     *OFF                                         - B1
     C     *IN12         ANDEQ     *OFF
      *
     C                   MOVE      SELEC1        SELEC2
      *
      ***  Reset F9 Indicator
      *
     C                   MOVE      *OFF          *IN16
      *
      ***  Write subfile
      *
     C     *IN09         IFNE      *ON                                          - B2
      *
      ***  Set Up Function Key Text - Standard Functions  *
      *
     C     *IN15         IFEQ      *ON
     C                   MOVEA     TXT(3)        ##CTX1
     C                   ELSE
     C     *IN16         IFEQ      *ON
     C                   MOVEA     TXT(2)        ##CTX1
     C                   ELSE
     C                   MOVEA     TXT(1)        ##CTX1
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     ERLU20F2                                     Bottom
     C                   WRITE     #MSGCTL                                      Wrt Msg Scr
     C                   EXFMT     ERLU20C1                                     Subfile control
      *
      ***  Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ***  Which key has been pressed
      *
     C                   EXSR      PRESS
      *
     C     WWAID         IFEQ      'UP'                                         - B3
     C                   Z-ADD     WWRRN         SFLREC
     C                   EXSR      LOASFE
     C                   ENDIF                                                  - E3
      *
     C     CPFPOS        IFNE      *ZEROS
     C                   Z-ADD     CPFPOS        SFLREC
     C                   ENDIF
     C                   ENDIF                                                  - E2
      *
      ***  F9 Key has been pressed
      *
     C     *IN09         IFEQ      *ON                                          - B2
     C                   EXSR      SRF9
     C                   MOVE      SELEC1        SELEC2
      *
     C     *INKC         IFEQ      *ON                                          - B3
     C                   MOVE      *OFF          *IN16
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                  - E2
      *
      ***  Enter has been pressed
      *
     C     *IN45         IFEQ      *OFF                                         - B2
     C     *IN16         ANDEQ     *OFF
      *
     C     *IN45         IFEQ      *OFF                                         - B3
     C     SELEC1        ANDNE     SELEC2
     C                   EXSR      INISFL
     C                   EXSR      LOASFE
      *
      ***  No details in the file
      *
     C     SFLREC        IFEQ      0
     C                   MOVEL     'ERL0020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN17
     C                   EXSR      LOASF9
     C                   MOVE      *OFF          *IN17
     C                   ENDIF
      *
     C     CPFPOS        IFNE      *ZEROS
     C                   Z-ADD     CPFPOS        SFLREC
     C                   ENDIF
      *
     C                   ENDIF                                                  - E3
      *
      ***  Check if changes in subfile
      *
     C                   EXSR      SRCHCK
     C                   ENDIF                                                  - E2
      *
      ***  F5 Key has been pressed : REFRESH PROCESSING ==> REBUILD SUBFILE
      ***  or back from F9 screen with F9 Key
      *
     C                   MOVE      *BLANKS       IN16
      *
     C     *IN05         IFEQ      *ON                                          - B2
     C     *IN16         OREQ      *ON
     C                   MOVE      'Y'           IN16              1
     C                   MOVE      '0'           *IN16
     C                   MOVE      *BLANKS       SELEC1
      *
     C                   EXSR      INISFL
     C                   EXSR      LOASFE
      *
      ***  No details in the file
      *
     C     SFLREC        IFEQ      0
     C                   MOVEL     'ERL0020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN17
     C                   EXSR      LOASF9
     C                   MOVE      *OFF          *IN17
     C                   ENDIF
      *
     C     CPFPOS        IFNE      *ZEROS
     C                   Z-ADD     CPFPOS        SFLREC
     C                   ENDIF
     C                   MOVE      *BLANKS       IN16
     C                   ENDIF                                                  - E2
     C                   ENDDO                                                  - E1
      *
      ***  End of program
      *
     C                   MOVE      *ON           *INLR
     C                   ROLBK
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRF9 -  SR executed if F9 pressed                             *
      * ----                                                          *
      *   Called by : Main processing                                 *
      *   Calls     : INISFL LOASF9 ZASNMS SRVAL                      *
      *****************************************************************
      *
     C     SRF9          BEGSR
      *
     C                   MOVE      *ON           *IN16
      *
     C                   EXSR      INISFL
     C                   EXSR      LOASF9
     C                   Z-ADD     1             SFLREC
      *
     C     *INKC         DOWEQ     *OFF                                         - B1
     C     *IN12         ANDEQ     *OFF
      *
      ***  Write subfile 'F9'
      *
      ***  Set Up Function Key Text - Standard Functions  *
      *
     C     *IN15         IFEQ      *ON
     C                   MOVEA     TXT(3)        ##CTX1
     C                   ELSE
     C     *IN16         IFEQ      *ON
     C                   MOVEA     TXT(2)        ##CTX1
     C                   ELSE
     C                   MOVEA     TXT(1)        ##CTX1
     C                   ENDIF
     C                   ENDIF
     C                   WRITE     ERLU20F2                                     Bottom
     C                   WRITE     #MSGCTL                                      Wrt Msg Scr
     C                   EXFMT     ERLU20C1                                     Subfile control
      *
      ***  Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ***  F9 Key pressed once again = F12 IS SETON
      *
     C     *IN09         IFEQ      *ON                                          - B2
     C                   MOVE      *ON           *IN12
     C                   MOVE      *OFF          *IN09
     C                   ENDIF                                                  - E2
      *
      ***  Enter has been pressed on 'F9' Screen
      *
     C     *IN45         IFEQ      *OFF                                         - B2
     C                   READC     ERLU20S1                               87
      *
     C     *IN87         DOWEQ     *OFF                                         - B3
     C                   MOVE      *OFF          *IN15
     C                   MOVEA     '00000'       *IN(21)
     C                   MOVE      *OFF          *IN63
      *
      ***  Validate input fields
      *
     C                   EXSR      SRVAL
      *
      ***  No errors
      *
     C     WWERR         IFEQ      'N'                                          - B4
      *
      ***  Check if the new record already exist in the file
      *
     C                   MOVE      DSECSC        WKECSC
     C                   MOVE      DSZABI        WKZABI
     C                   MOVE      DSCLAT        WKCLAT
     C                   MOVE      D2PECO        WKPECO
      *
     C     KWGAR1        CHAIN     EREXRAZ1                           89
      *
      ***  Record already exist in the file
      *
     C     *IN89         IFEQ      *OFF                                         - B5
     C                   MOVEA     '11111'       *IN(21)
     C                   MOVEL     'ERL2003'     ZAMSID
     C                   MOVE      *ON           *IN63
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X5
      *
     C                   MOVE      DSECSC        XRECSC                         Economic Sector Code
     C                   MOVE      DSZABI        XRZABI                         Zone A/B
     C                   MOVE      DSCLAT        XRCLAT                         Claim's Type
     C                   MOVE      DSCLAM        XRCLAM                         Claim's Maturity
     C                   MOVE      D2PECO        XRPECO                         Period Code
     C                   MOVE      DSWEIG        XRWEIG                         Weighting Rate
     C                   MOVE      'I'           XRLCTY
     C                   Z-ADD     BJRDNB        XRLCD
     C                   WRITE     UPERLUAC
      *
      ***  Write done then protect record
      *
     C                   MOVE      *ON           *IN15
     C                   COMMIT
     C                   ENDIF                                                  - E5
     C                   ENDIF                                                  - E4
      *
     C                   UPDATE    ERLU20S1
     C                   MOVE      *OFF          *IN15
     C                   MOVEA     '00000'       *IN(21)
     C                   MOVE      *OFF          *IN63
      *
      ***  Read next changed record
      *
     C                   READC     ERLU20S1                               87
     C                   ENDDO                                                  - E3
     C                   ENDIF                                                  - E2
      *
      ***  Refresh on F9 SCREEN
      *
     C     *IN05         IFEQ      *ON                                          - B2
     C                   EXSR      INISFL
     C                   EXSR      LOASF9
     C                   ENDIF                                                  - E2
      *
      ***  Rollup on F9 SCREEN
      *
     C     *IN35         IFEQ      *ON                                          - B2
     C                   Z-ADD     WWRRN2        SFLREC
     C                   EXSR      LOASF9
     C                   ENDIF                                                  - E2
     C                   ENDDO                                                  - E1
      *
     C     *IN12         IFEQ      *ON
     C                   MOVE      *OFF          *IN12
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCHCK - SR To check if changes in subfile                    *
      * ------                                                        *
      *   Called by : Main processing                                 *
      *   Calls     : ZASNMS                                          *
      *****************************************************************
      *
     C     SRCHCK        BEGSR
      *
      ***  Retrive all changed records
      *
     C                   READC     ERLU20S1                               87
      *
     C     *IN87         DOWEQ     *OFF                                         - B1
      *
      ***  Validation on record subfile
      *
     C                   MOVE      *OFF          *IN63
     C                   MOVEA     '000000'      *IN(20)
      *
     C     DSSELE        IFNE      'D'                                          - B2
     C     DSSELE        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN20
     C                   MOVE      *ON           *IN63
     C                   MOVEL     'ERB3001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E2
      *
      ***  Validate input fields
      *
     C     DSSELE        IFNE      'D'                                          - B2
     C                   EXSR      SRVAL
     C                   ENDIF                                                  - E2
      *
      ***  NO ERRORS
      *
     C     *IN20         IFEQ      *OFF                                         - B2
     C     WWERR         ANDEQ     'N'
     C     DSSELE        OREQ      'D'
      *
      ***  If no error and 'D' selected ==> DELETE IN FILE
      *
     C     DSSELE        IFEQ      'D'                                          - B3
     C                   MOVE      DSECSC        WKECSC
     C                   MOVE      DSZABI        WKZABI
     C                   MOVE      DSCLAT        WKCLAT
     C                   MOVE      D2PECO        WKPECO
     C                   MOVE      DSWEIG        WKWEIG
      *
     C     KWGAR2        CHAIN     EREXRAV1                           88
      *
     C     *IN88         IFEQ      *OFF                                         - B4
     C                   DELETE    UPERLUAC
     C                   MOVE      *ON           *IN15
     C                   MOVE      *ON           *IN18
      *
      ***  Record Updated/Deleted by an other workstation
      *
     C                   ELSE
     C                   MOVEA     '111111'      *IN(20)
     C                   MOVE      *ON           *IN63
     C                   MOVEL     'ERL0022'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E4
      *
     C                   ELSE                                                   - X3
      *
      ***  Update file and subfile
      *
     C                   MOVE      DSECSC        WKECSC
     C                   MOVE      DSZABI        WKZABI
     C                   MOVE      DSCLAT        WKCLAT
     C                   MOVE      D2PECO        WKPECO
     C                   MOVE      D2WEIG        WKWEIG
      *
     C     KWGAR2        CHAIN     EREXRAV1                           88
      *
     C     *IN88         IFEQ      *OFF                                         - B4
     C                   MOVE      DSECSC        XRECSC                         Economic Code
     C                   MOVE      DSZABI        XRZABI                         Zone A/B
     C                   MOVE      DSCLAT        XRCLAT                         Claim's Type
     C                   MOVE      DSCLAM        XRCLAM                         Claim's Maturity
     C                   MOVE      D2PECO        XRPECO                         Period code
     C                   MOVE      DSWEIG        XRWEIG                         Weighting Rate
     C                   MOVE      'A'           XRLCTY
     C                   Z-ADD     BJRDNB        XRLCD
     C                   MOVE      DSWEIG        D2WEIG
     C                   UPDATE    UPERLUAC
      *
      ***  Record Updated/Deleted by an other workstation
      *
     C                   ELSE
     C                   MOVEA     '111111'      *IN(20)
     C                   MOVE      *ON           *IN63
     C                   MOVEL     'ERL0022'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E4
     C                   ENDIF                                                  - E3
     C                   COMMIT
     C                   ENDIF                                                  - E2
      *
     C                   UPDATE    ERLU20S1
     C                   MOVE      *OFF          *IN18
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN15
     C                   MOVEA     '000000'      *IN(20)
      *
      ***  Read next changed record
      *
     C                   READC     ERLU20S1                               87
     C                   ENDDO                                                  - E1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVAL - SR To valdidate                                       *
      * -----                                                         *
      *   Called by : SRF9 SRCHCK                                     *
      *   Calls     : ZASNMS AODLSTR0 AOLOANR0 AOACODR0 AOCURRR0      *
      *               AOCUSTR0                                        *
      *****************************************************************
      *
     C     SRVAL         BEGSR
      *
     C                   MOVE      'N'           WWERR             1
      *
     C     DSECSC        IFEQ      *BLANKS                                      - B1
     C                   MOVE      *BLANKS       DSECON
     C                   ENDIF                                                  - E1
      *
     C     DSECSC        IFEQ      *BLANKS                                      - B1
     C     DSZABI        IFEQ      *BLANKS                                      - B2
     C     DSCLAT        ANDEQ     *BLANKS
     C     DSCLAM        ANDEQ     *BLANKS
     C     DSWEIG        ANDEQ     *BLANKS
     C                   MOVE      *BLANKS       DSECON
     C                   MOVE      *OFF          *IN63
     C                   MOVE      'Y'           WWERR
     C                   ELSE
     C                   MOVE      *ON           *IN21
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL2001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ***  Economic Sector Code validation
      *
     C     DSECSC        IFNE      *BLANKS                                      - B1
      *
     C                   MOVEL     DSECSC        WWN04             4 0
     C                   MOVEL     WWN04         WWK04             4
      ***  Check if numeric
     C     DSECSC        IFNE      WWK04                                        - B2
     C                   MOVE      *BLANKS       DSECON
     C                   MOVE      *ON           *IN21
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X2
     C                   MOVE      DSECSC        WKECSC
      *
     C***********WKECSC    CHAINSDECOSPD             89                   CAD031
     C*****WKECSC        CHAIN     SDNCOSPD                           89              CAD03 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDNCOS                                                                        MD058085
     C+ from SDNCOJW0                                                                       MD058085
     C+ where VNECOS = :WKECSC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       89                    MD058085
     C                   IF        SQLCODE = 100                                            MD058085
     C                   SETON                                        89                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
      *
     C     *IN89         IFEQ      *ON                                          - B3
     C                   MOVE      *BLANKS       DSECON
     C                   MOVE      *ON           *IN21
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X3
     C*********************MOVELVGECON    DSECON    P                     CAD031
     C                   MOVEL(P)  VNECON        DSECON                                        CAD03
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ***  Zone A/B validation
      *
     C     DSZABI        IFNE      *BLANKS                                      - B1
     C     DSZABI        ANDNE     'A'
     C     DSZABI        ANDNE     'B'
     C                   MOVE      *ON           *IN22
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E1
      *
      ***  Economic Sector Code is mandatory with this field
      *
     C     DSECSC        IFNE      *BLANKS                                      - E1
     C     DSZABI        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN22
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E1
      *
      ***  Claim's Type validation
      *
     C     DSCLAT        IFNE      *BLANKS                                      - B1
     C     DSCLAT        ANDNE     '1'
     C                   MOVE      *ON           *IN23
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL2000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E1
      *
      ***  Claim's Maturity validation
      *
     C                   Z-ADD     1             X                 2 0
     C     DSCLAM        LOOKUP    DUR(X)                                 89
      *
     C     *IN89         IFEQ      *OFF                                         - B1
     C                   MOVE      *BLANKS       D2PECO
     C                   MOVE      *ON           *IN24
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL2002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X1
     C                   Z-ADD     PER(X)        D2PECO
     C                   ENDIF                                                  - E1
      *
      ***  Weighting Rate validation
      *
     C     DSWEIG        IFEQ      *BLANKS                                      - B1
     C     DSECSC        ANDNE     *BLANKS
     C     DSWEIG        OREQ      *BLANKS
     C     DSZABI        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN25
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5009'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X1
     C     DSWEIG        IFNE      *BLANKS                                      - B2
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   DSWEIG        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      *ON                                          - B3
     C                   MOVE      *ON           *IN25
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X3
     C                   MOVE      ZFIELD        W3NUM             3 0
      *
     C     W3NUM         IFLT      0                                            - B4
     C     W3NUM         ORGT      100
     C                   MOVE      *ON           *IN25
     C                   MOVE      *ON           *IN63
     C                   MOVE      'Y'           WWERR
     C                   MOVEL     'ERL5008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X4
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DSWEIG
     C                   ENDIF                                                  - E4
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * INISFL - Initialize subfile                                   *
      * -----                                                         *
      *   Called by : Main processing SRF9                            *
      *   Calls     : None                                            *
      *****************************************************************
      *
     C     INISFL        BEGSR
      *
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN81
     C                   WRITE     ERLU20C1
     C                   MOVE      *ON           *IN80
     C                   MOVE      *OFF          *IN60
     C                   Z-ADD     0             SFLREC
     C                   Z-ADD     0             WWRRN2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * LOASFE - Load subfile                                         *
      * ------                                                        *
      *   Called by : Main processing                                 *
      *   Calls     : SELEC                                           *
      *****************************************************************
      *
     C     LOASFE        BEGSR
      *
      ***  If selection field reset to blank by user ==> SELECT ALL RECORDS
      *
     C     SELEC1        IFNE      SELEC2                                       - B1
     C     DHECSC        ANDEQ     *BLANKS
     C     DHZABI        ANDEQ     *BLANKS
     C     DHCLAT        ANDEQ     *BLANKS
     C     DHCLAM        ANDEQ     *BLANKS
     C     DHWEIG        ANDEQ     *BLANKS
     C                   MOVE      SELEC1        SELEC2
     C                   ENDIF                                                  - B2
      *
      ***  Init screen line number
      *
     C                   Z-ADD     0             WWCPT             2 0
      *
      ***  Economic Sector Code selected
      *
     C     DHECSC        IFNE      *BLANKS                                      - B1
     C                   MOVE      DHECSC        WKECSC
     C     WKECSC        SETLL     EREXRAZ1
     C                   ELSE
     C     *LOVAL        SETLL     EREXRAZ1
     C                   ENDIF                                                  - E1
      *
      ***  Rollup pressed
      *
     C     WWAID         IFEQ      'UP'                                         - B1
     C                   MOVEL     WWSAV2        WKSELE
     C     KWGAR1        SETLL     EREXRAZ1
     C                   ENDIF                                                  - E1
      *
      ***  Read next record
      *
     C                   READ      EREXRAZ1                               87
      *
      ***  Load subfile
      *
     C                   MOVE      *OFF          *IN63
      *
     C     *IN87         DOWEQ     '0'                                          - B1
     C     WWCPT         ANDLT     14
      *
     C     XRECSC        IFEQ      *ZERO                                        - B2
     C                   MOVE      *BLANKS       DSECSC
     C                   MOVE      *BLANKS       DSECON
     C                   ELSE                                                   - X2
     C                   MOVE      XRECSC        DSECSC                         Economic Sector Code
     C                   MOVE      XRECSC        WKECSC
      *
     C***********WKECSC    CHAINSDECOSPD             89                   CAD031
     C*****WKECSC        CHAIN     SDNCOSPD                           89              CAD03 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDNCOS                                                                        MD058085
     C+ from SDNCOJW0                                                                       MD058085
     C+ where VNECOS = :WKECSC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       89                    MD058085
     C                   IF        SQLCODE = 100                                            MD058085
     C                   SETON                                        89                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
      *
     C     *IN89         IFEQ      *ON                                          - B3
     C                   MOVE      *BLANKS       DSECON
     C                   ELSE                                                   - X3
     C*********************MOVELVGECON    DSECON    P      Economic SectorCAD031
     C                   MOVEL(P)  VNECON        DSECON                         Sector NarrativCAD03
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                  - E2
      *
     C                   MOVE      XRZABI        DSZABI                         Zone A/B
      *
     C     XRCLAT        IFEQ      *ZERO                                        - B2
     C                   MOVE      *BLANKS       DSCLAT
     C                   ELSE                                                   - X2
     C                   MOVE      XRCLAT        DSCLAT                         Claim's Type
     C                   ENDIF                                                  - E2
      *
     C                   MOVEL     XRCLAM        DSCLAM
      *
     C                   MOVE      XRWEIG        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DSWEIG                         Weighting Rate
      *
     C                   Z-ADD     XRPECO        D2PECO                         Periodic code
      *
     C                   MOVE      XRWEIG        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        D2WEIG
      *
     C                   MOVE      *BLANKS       DSSELE
      *
      ***  Selection has been enterred and not coming from F9
      *
     C     SELEC1        IFNE      *BLANKS                                      - B2
     C     IN16          ANDEQ     *BLANKS
      *
      ***  Record read selected or not ???
      *
     C                   MOVE      'N'           WWSEL             1
     C                   EXSR      SELEC
      *
     C     WWSEL         IFEQ      'Y'                                          - B3
      *
      ***  Load fields
      *
     C                   ADD       1             SFLREC               81
     C                   ADD       1             WWCPT                          SCREEN LINE MBR
      *
      ***  Write in subfile
      *
     C                   WRITE     ERLU20S1
     C                   ENDIF                                                  - E3
      *
     C                   ELSE                                                   - X2
      *
      ***  Load fields
      *
     C                   ADD       1             SFLREC               81
     C                   ADD       1             WWCPT                          SCREEN LINE MBR
      *
      ***  Write in subfile
      *
     C                   WRITE     ERLU20S1
     C                   ENDIF                                                  - E2
      *
      ***  Read next record
      *
     C                   READ      EREXRAZ1                               87
     C                   MOVE      XRECSC        W2ECSC
     C                   MOVE      XRZABI        W2ZABI
     C                   MOVE      XRCLAT        W2CLAT
     C                   MOVE      XRPECO        W2PECO
     C                   ENDDO                                                  - E1
      *
     C     *IN87         IFEQ      *ON                                          B*1
     C                   MOVE      *ON           *IN60
     C                   ENDIF                                                  E*1
      *
     C                   MOVE      DHECSC        WWECSC
     C                   MOVE      DHZABI        WWZABI
     C                   MOVE      DHCLAT        WWCLAT
     C                   MOVE      DHCLAM        WWCLAM
     C                   MOVE      DHWEIG        WWWEIG
     C                   Z-ADD     SFLREC        WWRRN             4 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * LOASF9 - Load subfile when F9 Key has been pressed            *
      * ------                                                        *
      *   Called by : Main processing SRF9                            *
      *   Calls     : None                                            *
      *****************************************************************
      *
     C     LOASF9        BEGSR
      *
     C                   MOVE      *OFF          *IN63
      *
      ***  Init screen line number
      *
     C                   Z-ADD     1             CPT               2 0
      *
      ***  Load subfile
      *
     C     CPT           DOWLE     14                                           - B1
      *
     C                   MOVE      *BLANKS       DSSELE
     C                   MOVE      *BLANKS       DSECSC
     C                   MOVE      *BLANKS       DSECON
     C                   MOVE      *BLANKS       DSZABI
     C                   MOVE      *BLANKS       DSCLAT
     C                   MOVE      *BLANKS       DSCLAM
     C                   MOVE      *BLANKS       DSWEIG
     C                   MOVE      *BLANKS       D2PECO
     C                   MOVE      *BLANKS       D2WEIG
      *
      ***  Load fields
      *
     C                   ADD       1             SFLREC               81
     C                   ADD       1             WWRRN2            4 0
     C                   ADD       1             CPT                            SCREEN LINE MBR
      *
      ***  Write in subfile
      *
     C                   WRITE     ERLU20S1
     C                   ENDDO                                                  - E1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SELEC - SR - selection for the record read                    *
      * ------                                                        *
      *   Called by : LOANSFE                                         *
      *   Calls     : None                                            *
      *****************************************************************
      *
     C     SELEC         BEGSR
      *
     C     DHECSC        IFEQ      *BLANKS                                      - B1
     C     DHZABI        ANDEQ     *BLANKS
     C     DHCLAT        ANDEQ     *BLANKS
     C     DHCLAM        ANDEQ     *BLANKS
     C     DHWEIG        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWSEL
     C                   ENDIF                                                  - E1
      *
      ***  Economic Sector selected
      *
     C     DHECSC        IFNE      *BLANKS                                      - B1
      *
     C     DHECSC        IFLE      DSECSC                                       - B2
     C                   MOVE      'Y'           WWSEL
     C                   ELSE                                                   - X2
     C                   MOVE      'N'           WWSEL
     C                   GOTO      ENDSEL
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ***  Zone A/B selected
      *
     C     DHZABI        IFNE      *BLANKS                                      - B1
      *
     C     DHZABI        IFEQ      DSZABI                                       - B2
     C                   MOVE      'Y'           WWSEL
     C                   ELSE                                                   - X2
     C                   MOVE      'N'           WWSEL
     C                   GOTO      ENDSEL
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ***  Claim's Type selected
      *
     C     DHCLAT        IFNE      *BLANKS                                      - B1
      *
     C     DHCLAT        IFEQ      DSCLAT                                       - B2
     C                   MOVE      'Y'           WWSEL
     C                   ELSE                                                   - X2
     C                   MOVE      'N'           WWSEL
     C                   GOTO      ENDSEL
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ***  Claim's Maturity selected
      *
     C     DHCLAM        IFNE      *BLANKS                                      - B1
      *
     C     DHCLAM        IFEQ      DSCLAM                                       - B2
     C                   MOVE      'Y'           WWSEL
     C                   ELSE                                                   - X2
     C                   MOVE      'N'           WWSEL
     C                   GOTO      ENDSEL
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ***  Weighting Rate selected
      *
     C     DHWEIG        IFNE      *BLANKS                                      - B1
     C                   MOVE      DHWEIG        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      *OFF                                         - B2
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DHWEIG
      *
     C     DHWEIG        IFEQ      DSWEIG                                       - B3
     C                   MOVE      'Y'           WWSEL
     C                   ELSE                                                   - X3
     C                   MOVE      'N'           WWSEL
     C                   GOTO      ENDSEL
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
     C     ENDSEL        TAG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZASNMS - SR to send message to program's message queue        *
      * -------                                                       *
      *   Called by : Main processing SRF9 SRCHCK SRVAL               *
      *   Calls     : Y2SNMGC                                         *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
      ***  Message file specified use PMSGF
      *
     C                   MOVEL     PMSGF         ZAMSGF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
      ***  Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file
     C                   MOVEL     *BLANK        ZAMSID                         Message id.
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * PRESS - SR to move the appropriate values into field WWAID,   *
      * ------- depending on which function key has been pressed      *
      *   Called by : Main processing                                 *
      *   Calls     : None                                            *
      *****************************************************************
      *
     C     PRESS         BEGSR
      *
      ***  If ENTER pressed, the VLDCMDKEY indicator will be off
      *
     C                   MOVE      '  '          WWAID
      *
     C     *IN45         IFEQ      *OFF
     C                   MOVE      'RA'          WWAID             2
     C                   ENDIF
      *
      ***  I1 F3 Key
      *
     C     *INKC         IFEQ      *ON
     C                   MOVE      '03'          WWAID
     C                   ENDIF
      *
      ***  If F12 Key
      *
     C     *INKL         IFEQ      *ON
     C                   MOVE      '12'          WWAID
     C                   ENDIF
      *
      ***  If ROLLUP pressed
      *
     C     *IN35         IFEQ      *ON
     C                   MOVE      'UP'          WWAID
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *   *INZSR - Initial Processing                                 *
      *   ------                                                      *
      *   Called by : Main processing                                 *
      *   Calls     : AOBANKR0                                        *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
      *
      ***  In mode Enquiry, all the fields are displayed only
      *
     C     ACTION        IFEQ      'E'
     C                   MOVE      *ON           *IN15
     C                   ENDIF
      *
      ***  Select the program MSGQ for error msg.
      *
     C                   MOVEL     '*'           TOPQ             10
     C                   MOVEL     '*PRV'        TOPRQ             5
     C**********           MOVEL'ERUSRMSG'PMSGF  10                                           CER001
     C                   MOVEL     'STUSRMSG'    PMSGF            10
      *
      ***  Fill in fields for subroutine ZASNMS
      *
     C                   MOVEL     'ERLU20'      ZAPGM            10            Message queue
     C**********           MOVEL'ERUSRMSG'ZAMSGF 10        Message file                       CER001
     C                   MOVEL     'STUSRMSG'    ZAMSGF           10            Message file
     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
      *
      ***  Define necessary KLIST'S
      *
      ***  Access to LF/EREXRAV1
      *
     C     KWGAR2        KLIST
     C                   KFLD                    WKECSC                         Economic Sector
     C                   KFLD                    WKZABI                         Zone A/B
     C                   KFLD                    WKCLAT                         Claim's Type
     C                   KFLD                    WKPECO                         Period Code
     C                   KFLD                    WKWEIG            3 0          Weighting Rate
      *
      ***  Access to LF/EREXRAZ1
      *
     C     KWGAR1        KLIST
     C                   KFLD                    WKECSC                         Economic Sector
     C                   KFLD                    WKZABI                         Zone A/B
     C                   KFLD                    WKCLAT                         Claim's Type
     C                   KFLD                    WKPECO                         Period Code
      *
      ***  Access the LDA details Data Area
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     *ZEROS        DBASE
     C                   MOVE(P)   'ERLU20'      DBPGM
     C                   OUT       LDA
      *
      ***  Access Bank details file
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WORTCD            7
     C                   PARM      '*FIRST '     WOOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     WORTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL(P)  'SDBANKPD'    DBFILE                         * DB ERROR 01 *
     C                   MOVEL(P)  '*FIRST'      DBKEY                          ***************
     C                   MOVEL(P)  'ERLU20'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BJMRDT        SMRDT
     C                   MOVE      '.'           BNDCSP            1                        MD058085
      *
      ***  SETUP 'ADD' OR 'AMEND' MODE
      *
     C                   READ      EREXRAZ1                               88
      *
     C     *IN88         IFEQ      *ON
     C                   MOVE      *ON           *IN09
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Dump routine in case of error                       *
      *  ------                                                       *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WWRUN         IFEQ      *BLANK
     C                   MOVE      'Y'           WWRUN             1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C*COPY*ZSRSRC,ZALIGNZ2                                                                 MD058085
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058085
     C*COPY*ZSRSRC,ZEDITZ2                                                                  MD058085
     C/COPY ZSRSRC,ZEDITZ2LE                                                                MD058085
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA TXT
D=Delete   F3=Exit   F5=Refresh   F9=Go to 'Add' Mode
           F3=Exit   F5=Refresh   F9=Go to 'Change' Mode
F3=Exit   F5=Refresh
**CTDATA DUR
<=01D05
 =02D10
<=01M15
<=02M20
<=03M25
<=06M35
<=01Y45
<=02Y55
<=03Y60
<=04Y62
<=05Y65
<=06Y70
<=07Y72
> 07Y75
     90
**CTDATA CPY@
(c) Finastra International Limited 2005
