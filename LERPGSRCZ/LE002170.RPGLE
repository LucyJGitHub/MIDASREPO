     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility history rework request')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE002170 - Facility History Rework Request                   *
      *                                                               *
      *  Function:  This will trigger recalculation in COB for        *
      *             Facility History File starting from the "Rework   *
      *             From Date" input until the last record based on   *
      *             the corresponding facility exchange rate.         *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 203465             Date 22Feb02               *
      *                 CLE023  *CREATE    Date 19Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  203465 - Do not allow request for facility history rework if *
      *           CLE023 is not switched on in the system. Database   *
      *           error also occured, due to AOCUSTR0 pointer error.  *
      *  CLE023 - Lending Facility History Improvements.              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20         Error in Customer field                         *
      *    21         Error in Facility type field                    *
      *    22         Error in Facility sequence field                *
      *    23         Error in Rework from Date field                 *
      *    80         Record not found in FCLTYFM                     *
      *    81         Record not found in FACHISH                     *
      *    82         Record not found in FACACT                      *
      *    89         Subfile control for error message subfile       *
      *    99         Error indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR        - Error processing                               *
      * *INZSR       - Initialise                                     *
      * SrVCus       - Validate customer inserted                     *
      * SrVFac       - Validate facility inserted                     *
      * SrVDat       - Validate Rework from Date inserted             *
      * SrUpdt       - Update files                                   *
      * SRSndM       - Handles the display of error messages          *
      * SRReset      - Resets error indicators and message subfile    *
      * SrCF03       - Terminates the program                         *
      *                                                               *
      *****************************************************************
     FLE002170DFCF   E             WORKSTN INFSR(*PSSR)
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYFNF)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     FFACHISH   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FFACACT    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
     D True            C                   *On
     D False           C                   *Off
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Switchable features file.                                                            203465
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  203465
      *                                                                                       203465
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Array containing copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY ZSRSRC,ZALIGNZ1LE
      *
      ** DS for current screen details
     D WCurDet         DS
     D  #1CUST                 1     10
     D  #1FACT                11     13
     D  #1FCNO                14     15
     D  #1DATE                16     21
      *
      ** DS for previous screen details
     D WPrevDet        DS
     D  WPCUST                 1     10
     D  WPFACT                11     13
     D  WPFCNO                14     15
     D  WPDATE                16     21
      *
      ** Arrays for screen error indicators
     D WResetInd       S              1    DIM(4) CTDATA PERRCD(4)
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  NotFound              80     80
     D  NoFachish             81     81
     D  NoFacact              82     82
      *
      ** Work variables
     D*Wfcnum***       S              6S 0 INZ(0)                                             CSD027
     D Wfcnum          S              6A   INZ(*BLANKS)                                       CSD027
     D Wftyp           S              3S 0 INZ(0)
     D Wfseq           S              2S 0 INZ(0)
     D Wfdate          S              5S 0 INZ(0)
     D Wfcty           S              5A   INZ(*BLANKS)
     D Wffcty          S              5S 0 INZ(0)
     D ErrOnInp        S              1A   INZ('0')
     D WRun            S              1
      *
      ** Parameter list for access objects
     D PRtnCode        S              7A
     D POptn           S              7A
     D PCkey           S             10A
     D PKeySts         S              7A
      *
      ** Parameter list for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
      *
      ** Parameter list for ZA0340
     D P_MsgFile       S             10A
     D P_MsgID         S             10A
     D P_MsgDta        S             45A
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   WRITE     LE002170F0
     C                   WRITE     LE002170C0
     C                   EXFMT     LE002170F1
     C                   CLEAR                   WPrevDet
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
     C                   DOW       *INKC = *OFF
      *
      ** F3=Exit key is pressed
      *
     C                   IF        *INKC = *ON
     C                   EXSR      SrCF03
     C                   ENDIF
      *                                                                                       203465
      **  Determine if Lending Facility History Improvements - CLE023                         203465
      **  feature is installed                                                                203465
      *                                                                                       203465
     C                   CALLB     'AOSARDR0'                                                 203465
     C                   PARM      *BLANKS       PRTCD             7                          203465
     C                   PARM      '*KEY    '    POPTN             7                          203465
     C                   PARM      'CLE023 '     PSARD             6                          203465
     C     SCSARD        PARM      SCSARD        DSFDY                                        203465
      *                                                                                       203465
     C     PRTCD         IFEQ      *BLANKS                                                    203465
     C                   MOVE      'Y'           CLE023            1                          203465
     C                   ELSE                                                                 203465
     C                   MOVE      'N'           CLE023                                       203465
      *                                                                                       203465
     C     PRTCD         IFNE      '*NRF   '                                                  203465
     C     *LOCK         IN        LDA                                                        203465
     C                   MOVEL     'SCSARDPD'    DBFILE                                       203465
     C                   Z-ADD     64            DBASE                                        203465
     C                   MOVEL     'CLE023'      DBKEY                                        203465
     C                   OUT       LDA                                                        203465
     C                   EXSR      *PSSR                                                      203465
      *                                                                                       203465
     C                   ELSE                                                                 203465
      * Else, CLE023 not found, so rework not allowed:                                        203465
     C                   EVAL      P_MsgID = 'LEF0013'                                        203465
     C                   EXSR      SRSndM                                                     203465
     C                   EVAL      ErrOnInp = '1'                                             203465
     C                   ENDIF                                                                203465
      *                                                                                       203465
     C                   ENDIF                                                                203465
      *                                                                                       203465
      *
      ** F5=Refresh key is pressed
      *
     C                   IF        *INKE = *ON
     C                   EVAL      WCurDet = WPrevDet
     C                   ELSE
      *
     C                   EXSR      SrVCus
     C                   EXSR      SrVFac
     C                   EXSR      SrVDat
     C                   IF        ErrOnInp = '0'
     C                   EXSR      SrUpdt
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     LE002170C0
     C                   EXFMT     LE002170F1
     C                   EXSR      SRReset
      *
     C                   ENDDO
      *
      ** Terminate program if F3 is pressed.
      *
     C                   EXSR      SrCF03
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVCus - Validate Customer inserted.                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSndM, AOCUSTR0                                       *
      *                                                               *
      *****************************************************************
     C     SrVCus        BEGSR
      *
      ** Customer not entered.
      *
     C                   IF        #1CUST = *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'LEF0001'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ELSE
      *
     C                   EVAL      PCkey = #1CUST
     C**********         CALLB     'AOCUSTR0'                                                 203465
     C                   CALL      'AOCUSTR0'                                                 203465
     C                   PARM      '*BLANKS'     PRtnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCkey
     C                   PARM                    PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Customer not found.
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      *IN20 = *ON
     C                   EVAL      P_MsgID = 'LEF0002'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ELSE
      *
      ** Customer entered is valid.
      *
     C                   EVAL      #1CUST = *BLANKS
     C                   EVAL      #1CUST = BBCUST
     C                   MOVE      BBCUST        Wfcnum
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/SrVFac - Validate Facility.                                *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: SRSndM, ZALIGN                                         *
      *                                                               *
      *****************************************************************
     C     SrVFac        BEGSR
     C                   IF        ErronInp = '0'
      *
      ** Check if facility type and sequence are entered.
      *
     C                   IF        #1FACT = *BLANKS OR #1FCNO = *BLANKS
     C                   MOVEA     '11'          *IN(21)
     C                   EVAL      P_MsgID = 'LEF0010'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ELSE
      *
      ** Validate if facility reference entered is numeric.
      *
     C                   EVAL      Wfcty = #1FACT
     C                   MOVE      #1FCNO        Wfcty
     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      Wfcty         ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
     C                   IF        *IN99 = *ON
     C                   MOVEA     '11'          *IN(21)
     C                   EVAL      P_MsgID = 'LEF0011'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ELSE
      *
      ** If valid facility reference, chain customer and facility
      ** reference combination to facility file.
      *
     C                   MOVE      #1FACT        Wftyp
     C                   MOVE      #1FCNO        Wfseq
     C     Key001        CHAIN     FCLTYFMF                           80
     C                   SELECT
      *
      ** If facility record is not found.
      *
     C                   WHEN      NotFound = True
     C                   MOVEA     '111'         *IN(20)
     C                   EVAL      P_MsgID = 'LEF0003'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
      *
      ** If facility is found but not live anymore.
      *
     C                   WHEN      NotFound = False
     C                   IF        RECI <> 'D'
     C                   MOVEA     '111'         *IN(20)
     C                   EVAL      P_MsgID = 'LEF0009'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/SrVDat - Validate Rework From Date                         *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: SRSndM, ZDATE1, ZALIGN                                 *
      *                                                               *
      *****************************************************************
     C     SrVDat        BEGSR
     C                   IF        ErronInp = '0'
     C                   IF        #1DATE = *BLANKS
     C                   EVAL      *IN23 = *ON
     C                   EVAL      P_MsgID = 'LEF0004'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ELSE
      *
      ** Validate Rework from Date Field.
      *
     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      #1DATE        ZFIELD
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN23 = *ON
     C                   EVAL      P_MsgID = 'LEF0005'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ELSE
     C                   MOVE      #1DATE        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   EVAL      P_MsgID = 'LEF0005'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If Date entered is valid
      *
     C                   IF        ErrOnInp = '0'
     C                   EVAL      Wfdate = DaynoOut
      *
      ** Check if date inserted is equal to or greater than the rundate
      *
     C                   IF        Wfdate >= BJRDNB
     C                   EVAL      *IN23 = *ON
     C                   EVAL      P_MsgID = 'LEF0008'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ENDIF
      *
      ** Rework from date should not be earlier than the Date approved.
      *
     C                   IF        Wfdate < DTAP
     C                   EVAL      *IN23 = *ON
     C                   EVAL      P_MsgID = 'LEF0007'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SrUpdt - Update Files                                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SrUpdt        BEGSR
      *
     C                   MOVE      Wfcty         Wffcty
      *
     C     Key001        CHAIN     FACHISHF                           81
     C                   IF        NoFachish = False
     C                   EVAL      FHRWKR = 'Y'
     C                   EVAL      FHRWTP = 'M'
     C                   IF        FHRWDT = *ZERO OR FHRWDT < Wfdate
     C                   EVAL      FHRWDT = Wfdate
     C                   ENDIF
     C                   UPDATE    FACHISHF
      *
      ** Check FACACT for existing record.
      *
     C     Key002        CHAIN     FACACTF                            82
     C                   IF        NoFacact = True
     C                   EVAL      FCCNUM = Wfcnum
     C                   EVAL      FCDATE = Wfdate
     C                   EVAL      FCFCTY = Wffcty
     C                   WRITE     FACACTF
     C                   ELSE
     C                   EVAL      FCDATE = Wfdate
     C                   UPDATE    FACACTF
     C                   ENDIF
     C                   EVAL      WCurDet = WPrevDet
     C                   EXSR      SRReset
      *
      **  If facility not on FACHISH, then Facility History Rework
      **  is not allowed.
      *
     C                   ELSE
      *
     C                   MOVEA     '111'         *IN(20)
     C                   EVAL      P_MsgID = 'LEF0012'
     C                   EXSR      SRSndM
     C                   EVAL      ErrOnInp = '1'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Key for FACHISHF and FCLTYFMF
      *
     C     Key001        KLIST
     C                   KFLD                    Wfcnum
     C                   KFLD                    Wftyp
     C                   KFLD                    Wfseq
      *
      ** Key for FACACTF
      *
     C     Key002        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    Wfcnum
     C                   KFLD                    Wffcty
      *
      ** Read in installation data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtncode
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise job information
      *
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0RUNA = BJMRDT
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN89 = *ON
     C                   EVAL      #0PGMQ = '*'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SrCF03 - Handles the display of error messages.            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCF03        BEGSR
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRSndM - Handles the display of error messages.              *
      *                                                               *
      * Called by: SrVCus, SrVFac, SrVDat                             *
      *                                                               *
      * Calls: ZA0340                                                 *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
     C                   CALL      'ZA0340'
     C                   PARM      'UTMSGF'      P_MsgFile
     C                   PARM                    P_MsgID
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SR/SRReset - Resets error indicators and message subfile     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0250                                                 *
      *                                                               *
      *****************************************************************
     C     SRReset       BEGSR
     C                   MOVEA     WResetInd     *IN(20)
     C                   EVAL      *IN99 = *OFF
     C                   EVAL      ErrOnInp = '0'
     C                   CALL      'ZA0250'
     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
     C/COPY ZSRSRC,ZALIGNZ2LE
**  CPY@
(c) Finastra International Limited 2001
**  WResetInd
0000
