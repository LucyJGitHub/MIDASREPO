     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Time Zone End of Year Process')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001009 -  Midas SD Time Zone End of Year Process           *
      *                                                               *
      *  Function:  This program updates the time zone history file   *
      *             for the succeeding year's details.                *
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
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Time Zone Update File
     FSDTIZOL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Time Zone File by Year
     FSDTIZOL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTIZOD0:@TIZOL6)
 
      ** Midas SD Time Zone File by Time Zone Code/Year
     FSDTIZOL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTIZOD0:@TIZOL4)
 
      ** Midas SD Time Zone Level Code Update File
     FSDTZLVL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Time Zone Level Code Retieval File
     FSDTZLVL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTZLVD0:@TZLVL5)
 
      ** DST Code Retrieval File
     FSDDSTCL1  If   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDSTCD0:@DSTCL1)
 
      ** Midas SD Market Identification Code File
     FSDMICCL1  If   E           K DISK    INFSR(*PSSR)
 
      ** Time Zone History File by DST Code
     FSDTIZHL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Time Zone History File by DST Code
     FSDTZLHL0  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
     D SDTIZH        E DS                  EXTNAME(SDTIZHPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
     D TimCodeChg      C                   CONST('M')
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameter list fields
     D PLevel          S              1A
     D PEnty           S              3A
     D PSeq            S              5A
     D PData           S            100A
      *
      ** Parameter for 'AOBANKR0'
     D PRtCd           S              7A
     D POptn           S              7A
      *
     D CurYear         S              4A
     D PreYear         S              4A
     D ZDayNo          S              5P 0
      *
      ** Parameter for ZDATE9
     D ZYearNo         DS
     D  MDATYr                 1      4  0
     D  MDATMn                 5      6  0
     D  MDATDy                 7      8  0
     D PRetCode        S              1  0
      *
     D TimeStamp       S                   LIKE(THTMST)
      *
     D WOfSt           S              3S 0 Inz(*ZEROS)
     D WTmpOffset      S              4S 0
     D WTime           S               T   TIMFMT(*Hms)
     D WTime1          S              6A
     D WTmp            S              6A
     D WRun            S              1A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *LOVAL        SETLL     SDTIZOL0
     C                   READ      SDTIZOL0
     C                   DOW       NOT %EOF(SDTIZOL0)
     C                   IF        TZYEAR = PreYear
     C     Key1          CHAIN     SDTIZOL6
     C                   IF        %FOUND(SDTIZOL6)
     C                   EXSR      SRPopuDet
     C                   WRITE     SDTIZHD0
      *
     C                   ELSE
     C                   EVAL      CurYear = *BLANKS
     C     Key1          CHAIN     SDTIZOL6
     C                   IF        %FOUND(SDTIZOL6)
     C                   EXSR      SRPopuDet
     C                   WRITE     SDTIZHD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     *LOVAL        SETLL     SDTZLVL0
     C                   READ      SDTZLVL0
     C                   DOW       NOT %EOF(SDTZLVL0)
     C                   IF        TLYEAR = PreYear
     C     Key4          CHAIN     SDTZLVL5
     C                   IF        %FOUND(SDTZLVL5)
     C                   EXSR      SRPopuDet2
     C                   WRITE     SDTZLHD0
      *
     C                   ELSE
     C                   EVAL      CurYear = *BLANKS
     C     Key4          CHAIN     SDTZLVL5
     C                   IF        %FOUND(SDTZLVL5)
     C                   EXSR      SRPopuDet2
     C                   WRITE     SDTZLHD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuDet - Populate details from time zone maintenance file *
      *              and write intime zone history file.              *
      *                                                               *
      *  Called by : Main Procedure                                   *
      *                                                               *
      *  Calls     : SRCalcOff                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRPopuDet     BEGSR
      *
     C                   EVAL      THRECI = 'D'
     C                   EVAL      THTZCD = TZTZCD
     C                   EVAL      THYEAR = TZYEAR
     C                   EVAL      THDSTC = TZDSTC
     C                   EVAL      THDSTF = TZDSTF
     C                   EVAL      THGMTO = TZGMT
     C                   EVAL      THGMTS = TZGMTS
      *
      ** DST Details
      *
     C     Key2          CHAIN     @DSTCL1
     C                   IF        %FOUND(SDDSTCL1)
     C                   EVAL      THDSTS = DSDSDT
     C                   EVAL      THSTIM = DSDSDH
     C                   EVAL      THDSTE = DSDSED
     C                   EVAL      THETIM = DSDENH
     C                   EVAL      THDSTO = DSOFFS
     C                   ENDIF
      *
      ** Effective Offset
      *
     C                   Z-ADD     BJRDNB        THEFFD
     C                   IF        BJRDNB >= DSDSDT AND
     C                             BJRDNB <= DSDSED
     C                   EVAL      WOfSt = DSOFFS
     C                   EXSR      SRCalcOff
     C                   ELSE
     C                   EVAL      THEFFO = TZGMT
     C                   ENDIF
     C                   EVAL      THEFFS = TZGMTS
      *
      ** Timestamp, Type of Change
      *
     C                   EVAL      THTYLC = TimCodeChg
      *
     C                   CALL      'ZAGENTS'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     THTMST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuDet2 - Populate details from time zone level code file *
      *               and write in time zone level code history file. *
      *                                                               *
      *  Called by : Main Procedure                                   *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPopuDet2    BEGSR
      *
     C                   EVAL      THRECI = 'D'
     C                   EVAL      TVTZLC = TLTZLC
     C                   EVAL      TVTZCD = TLTZCD
     C                   EVAL      TVYEAR = TLYEAR
     C                   EVAL      TVZONE = TLZONE
     C                   EVAL      TVBRCA = TLBRCA
     C                   Z-ADD     BJRDNB        TVEFFD
      *
      ** Type of Change, Timestamp
      *
      *
     C                   CALL      'ZAGENTS'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     TVTMST
      *
      ** MIC Code
      *
     C     Key3          CHAIN     SDMICCL1
     C                   IF        %FOUND(SDMICCL1)
     C                   EVAL      TVMICC = MICCOD
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCalcOff - Calculate Effective Offset                       *
      *                                                               *
      *  Called By: SRPopuDet, SRPopuDet2                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCalcOff     BEGSR
      *
      ** Calculate Effective Offset
      *
     C                   EVAL      WTmpOffset = TZGMT
     C                   MOVEL     '000000'      WTmp
     C                   MOVEL     WTmpOffset    WTmp
     C                   EVAL      WTime = %TIME(WTmp:*HMS0)
     C                   IF        (TZGMTS = '+')
     C                   ADDDUR    WOfSt:*MN     WTime
     C                   ELSE
     C                   SUBDUR    WOfSt:*MN     WTime
     C                   ENDIF
     C                   EVAL      WTime1  = %Char(WTime:*Hms0)
     C                   MOVEL     WTime1        THEFFO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PData
      *
      ** Call The Access Object - AOBANKR0
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*DBERR'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   EVAL      ZDayNo = BJRDNB
     C                   EXSR      SRZDate9
     C                   Move      MDATYr        CurYear
      *
     C                   EVAL      ZDayno = BJPEYD
     C                   EXSR      SRZDate9
     C                   Move      MDATYr        PreYear
      *
     C     Key1          KLIST
     C                   KFLD                    CurYear
      *
     C     Key2          KLIST
     C                   KFLD                    TZDSTC
      *
     C     Key3          KLIST
     C                   KFLD                    TLTZCD
      *
     C     Key4          KLIST
     C                   KFLD                    TLTZCD
     C                   KFLD                    CurYear
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate9 - Convert day number to YYYYMMDD                    *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate9      BEGSR
      *
     C                   CALLB     'ZDATE9'
     C                   PARM                    ZDayNo
     C                   PARM      *ZERO         ZYearNo
     C                   PARM                    PRetCode
     C
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
