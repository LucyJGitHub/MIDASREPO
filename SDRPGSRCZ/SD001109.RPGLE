     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Time Zone History Report Program')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001109 -  Midas SD Time Zone History Report                *
      *                                                               *
      *  Function:  This program list all Time Zone Code history      *
      *             defined in the system.                            *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG20953           Date 11Sep08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG20953 - Dberror on SDC001109 00001 during COB             *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for SDTIZHL1                        *
      *    10         Toggle switch, use for Header 1                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrintAll    - Print All Records                             *
      * SRPopuVar     - Populate Variable for printing                *
      * SRHeader1     - Print Header 1                                *
      * SRAudit       - Write Audit Report                            *
      * SREnd         - Write Trailer in Report                       *
      * SRDSTDate     - Convertion of Dates to DDMMMYY or MMMDDYY     *
      * SRInitialise  - Initialise Variables
      * *INZSR        - Initialise                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Time Zone History Retrieval File
     FSDTIZHL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Time Zone Level Code History Retrieval File
     FSDTZLHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD DST Code Retrieval File
     FSDDSTCL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Time Zone Code retrieval File
     FSDTIZOL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Time Zone History Printer File
     FSD001109P1O    E             PRINTER OFLIND(OA)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas SD Time Zone History Printer File - Audit
     FSD001109AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
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
 
      ** File Information Data Structure for SD001109P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD001109AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PTZCD                  1     10A
     D  PYEAR                 11     14A
     D  PDSCD                 15     24A
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
     D All             C                   CONST('*ALL')
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameter list fields
     D PLevel          S              1
     D PCmd            S              1
     D PEnty           S              3
      *
      ** Parameter for 'AOBANKR0'
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Other fields used
     D WOpen           S              1    INZ('N')
     D WRun            S              1A
     D NoDataMatch     S               N   INZ(*OFF)
      *
     D PDateIn         S              5P 0
     D PDateOut        S              7P 0
     D PADateOut       S              7A
     D STime           S              6A
     D ETime           S              6A
      *
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
     C                   EVAL      *IN04 = *OFF
     C                   EXSR      SRPrintAll
     C                   EXSR      SRPrintLVl
      *
     C                   EXSR      SREnd
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintAll - Print All Records in Time Zone History File     *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : SRHeader1, SRWrite                               *
      *                                                               *
      *****************************************************************
      *
     C     SRPrintAll    BEGSR
      *
     C     *LOVAL        SETLL     SDTIZHD0
     C                   READ      SDTIZHD0                               02
     C                   EXSR      SRHeader1
     C                   WRITE     SD001109R1
      *
     C                   DOW       NOT %EOF(SDTIZHL1)
     C                   IF        THEFFD = BJRDNB
     C                   EXSR      SRWrite
     C                   END
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   IF        *IN02 = *OFF
     C                   IF        OA = *ON
     C                   EXSR      SRHeader1
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG20953
     C                   READ      SDTIZHD0                                                 BUG20953
      *                                                                                     BUG20953
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintLvl - Print Records in Time Zone Level Code History   *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : SRAudit, SRPopSbHd, SrWrite2                     *
      *                                                               *
      *****************************************************************
      *
     C     SRPrintLvl    BEGSR
      *
     C     *LOVAL        SETLL     SDTZLHD0
     C                   READ      SDTZLHD0                               03
     C                   IF        *IN03 = *ON AND *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
     C                   IF        TVEFFD = BJRDNB
     C                   EXSR      SRPopSbHd
     C                   WRITE     SD001109R3
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDTZLHL1)
     C                   MOVE      'N'           #WDST
     C                   EVAL      *IN04 = *OFF
     C                   EXSR      SRWrite2
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   IF        *IN03 = *OFF
     C                   IF        OA = *ON
     C                   EXSR      SRHeader1
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write the Time Zone History in Printer             *
      *                                                               *
      *  Called by : SRPrintAll                                       *
      *                                                               *
      *  Calls     : SRPopuVar                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
     C                   EXSR      SRPopuVar
     C                   WRITE     SD001109R2
     C                   READ      SDTIZHD0                               02
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite2 - Write Level Codes History in Printer              *
      *                                                               *
      *  Called by : SRPrintLvl                                       *
      *                                                               *
      *  Calls     : SRPopSbHd, SRPopuVAr2                            *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite2      BEGSR
      *
     C                   IF        TVTZLC <> RTZLC1 OR
     C                             TVZONE <> RZONE OR
     C                             TVBRCA <> RBRCA OR
     C                             TVMICC <> RMICC
     C                   EXSR      SRPopSbHd
     C                   WRITE     SD001109R3
     C                   ENDIF
     C                   EXSR      SRPopuVar2
     C                   WRITE     SD001109R2
     C                   READ      SDTZLHD0                               03
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuVar - Pupulating Variable                              *
      *                                                               *
      *  Called by : SRWrite, SRPopuVar2                              *
      *                                                               *
      *  Calls     : SRDSTDate                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRPopuVar     BEGSR
      *
      **  Time Zone Code
      *
     C                   EVAL      RTZCD = THTZCD
      *
      **  Year
      *
     C                   EVAL      RYEAR = THYEAR
      *
      **  DST Code
      *
     C                   EVAL      RDSTC = THDSTC
      *
      **  DST Flag
      *
     C                   SELECT
     C                   WHEN      THDSTF = 'Y'
     C                   EVAL      RDSTF = 'YES'
     C                   WHEN      THDSTF = 'N'
     C                   EVAL      RDSTF = 'NO'
     C                   ENDSL
      *
      **  GMT Offset/Sign
      *
     C                   MOVE      THGMTO        RGMTO
     C                   MOVEL     THGMTS        RGMTO
      *
      **  DST Start Date
      *
     C                   EVAL      PDateIn = THDSTS
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RDSTS
      *
      **  DST Start Time
      *
     C                   MOVE      THSTIM        STIME
     C                   EVAL      RSTIM  = %SUBST(STIME:1:2) + ':' +
     C                                      %SUBST(STIME:3:2) + ':' +
     C                                      %SUBST(STIME:5:2)
      *
      **  DST End Date
      *
     C                   EVAL      PDateIn = THDSTE
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RDSTE
      *
      **  DST End Time
      *
     C                   MOVE      THETIM        ETIME
     C                   EVAL      RETIM  = %SUBST(ETIME:1:2) + ':' +
     C                                      %SUBST(ETIME:3:2) + ':' +
     C                                      %SUBST(ETIME:5:2)
      *
      **  DST Offset
      *
     C                   MOVE      THDSTO        RDSTO
      *
      **  Effective Date
      *
     C                   EVAL      PDateIn = THEFFD
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RDSCD
      *
      **  Effective Offset/Sign
      *
     C                   MOVE      THEFFO        REFFO
     C                   MOVEL     THEFFS        REFFO
      *
      **  Type Of Change
      *
     C                   SELECT
     C                   WHEN      THTYLC = 'G'
     C                   EVAL      RTYLC = 'GMT Change'
     C                   WHEN      THTYLC = 'D'
     C                   EVAL      RTYLC = 'DST Code Change'
     C                   WHEN      THTYLC = 'F'
     C                   EVAL      RTYLC = 'DST Flag Change'
     C                   WHEN      THTYLC = 'P'
     C                   EVAL      RTYLC = 'DST Process'
     C                   WHEN      THTYLC = 'Y'
     C                   EVAL      RTYLC = 'Year End Change'
     C                   OTHER
     C                   EVAL      RTYLC = THTYLC
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopSbHd  - Populating Variable for the Sub-Header          *
      *                                                               *
      *  Called by :  SRPrintlvl, SrWrite2                            *
      *                                                               *
      *  Calls     :  None                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRpopSbHd     BEGSR
      *
      ** Level Code
      *
     C                   MOVE      TVTZLC        RTZLC1            1
     C                   SELECT
     C                   WHEN      TVTZLC = 'S'
     C                   EVAL      RTZLC = 'System Level'
     C                   WHEN      TVTZLC = 'B'
     C                   EVAL      RTZLC = 'Branch Level'
     C                   WHEN      TVTZLC = 'Z'
     C                   EVAL      RTZLC = 'Zone Level'
     C                   WHEN      TVTZLC = 'M'
     C                   EVAL      RTZLC = 'Market Level'
     C                   ENDSL
      *
      ** Zone
      *
     C                   EVAL      RZONE = TVZONE
      *
      ** Branch Code
      *
     C                   EVAL      RBRCA = TVBRCA
      *
      ** MIC Code
      *
     C                   EVAL      RMICC = TVMICC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuVar2 - Pupulating Variable                             *
      *                                                               *
      *  Called by : SRWrite2                                         *
      *                                                               *
      *  Calls     : SRDSTDate                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRPopuVar2    BEGSR
      *
      ** Time Zone Code
      *
     C                   EVAL      RTZCD = TVTZCD
      *
      ** Year
      *
     C                   EVAL      RYEAR = TVYEAR
      *
      ** Effective Date
      *
     C                   EVAL      PDateIn = TVEFFD
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RDSCD
      *
      ** Access Time Zone History file to retrieve the time zone details.
      *
     C     KEY1          CHAIN     SDTIZHD0
     C                   IF        %FOUND(SDTIZHL1)
     C                   EXSR      SRPopuVar
     C                   EVAL      RTZCD = TVTZCD
     C                   ELSE
      *
      ** If the time zone code does not exist from the history file, access
      ** time zone file and DST code file.
      *
     C     KEY1          CHAIN     SDTIZOD0
     C                   IF        %FOUND(SDTIZOL1)
     C                   MOVE      'Y'           #WDST             1
     C                   SELECT
     C                   WHEN      TZDSTF = 'Y'
     C                   EVAL      RDSTF = 'YES'
     C                   WHEN      TZDSTF = 'N'
     C                   EVAL      RDSTF = 'NO'
     C                   ENDSL
     C                   EVAL      RDSTC = TZDSTC
     C                   MOVE      TZGMT         RGMTO
     C                   MOVEL     TZGMTS        RGMTO
     C     KEY2          CHAIN     SDDSTCD0
     C                   IF        %FOUND(SDDSTCL1)
      *
     C                   EVAL      PDateIn = DSDSDT
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RDSTS
      *
     C                   MOVE      DSDSDH        STIME
     C                   EVAL      RSTIM  = %SUBST(STIME:1:2) + ':' +
     C                                      %SUBST(STIME:3:2) + ':' +
     C                                      %SUBST(STIME:5:2)
      *
     C                   EVAL      PDateIn = DSDSED
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RDSTE
      *
     C                   MOVE      DSDENH        ETIME
     C                   EVAL      RETIM  = %SUBST(ETIME:1:2) + ':' +
     C                                      %SUBST(ETIME:3:2) + ':' +
     C                                      %SUBST(ETIME:5:2)
      *
     C                   MOVE      DSOFFS        RDSTO
      *
     C                   ELSE
     C                   EVAL      *IN04 = *ON
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN04 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN04 = *ON
     C                   IF        #WDST <> 'Y'
     C                   EVAL      RDSTC = *BLANKS
     C                   EVAL      RDSTF = *BLANKS
     C                   ENDIF
     C                   EVAL      RDSTS = *BLANKS
     C                   EVAL      RSTIM = *BLANKS
     C                   EVAL      RDSTE = *BLANKS
     C                   EVAL      RETIM = *BLANKS
     C                   EVAL      RDSTO = *BLANKS
     C                   EVAL      RGMTO = *BLANKS
     C                   EVAL      REFFO = *BLANKS
     C                   EVAL      RTYLC = *BLANKS
     C                   ENDIF
     C                   ENDSR
      *
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSTDate - Convertion of Dates to DDMMMYY or MMMDDYY        *
      *                                                               *
      *  Called by : SRPopuVar, SRPopuVar2                            *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDSTDate     BEGSR
     C
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut
     C                   PARM      *BLANKS       PADateOut
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader1 - Print Header 1                                   *
      *                                                               *
      *  Called by : SRPrintAll                                       *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRHeader1     BEGSR
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD001109P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Print the Header of the report.
      *
     C                   WRITE     SD001109R0
     C                   EVAL      OA = *OFF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write Trailer in Report                              *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SREnd         BEGSR
      *
     C                   WRITE     SD001109R4
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write Audit Report                                 *
      *                                                               *
      *  Called by : SRPrintLvl                                       *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
     C                   OPEN      SD001109AU
      *
      ** Ensure No Record Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANKS       ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
      ** Key for  Time Zone History File
      *
     C     KEY1          KLIST
     C                   KFLD                    RTZCD
     C                   KFLD                    RYEAR
      *
      ** Key for  DST Code File
      *
     C     KEY2          KLIST
     C                   KFLD                    RDSTC
      *
      ** Call The Access Object - AOBANKR0
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST'      POptn
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
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
