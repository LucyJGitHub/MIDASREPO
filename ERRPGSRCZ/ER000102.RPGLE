     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG transmission file creation')             *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000102 - Midas @24 KWG transmission file creation          *
      *                                                               *
      *  Function : This program fills the transmission workfile with *
      *             records of type 'A', 'C' and 'E' and copies it    *
      *             into PC format.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER076             Date 02Jul19               *
      *  Prev Amend No. MD052779           Date 21Feb19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER068             Date 25Feb14               *
      *                 CER059             Date 19Jul10               *
      *                 262700             Date 03Dec09               *
      *                 262095             Date 14Oct09               *
      *                 BUG25857           Date 04Sep09               *
      *                 BUG24101           Date 27May09               *
      *                 BUG22633           Date 09Mar09               *
      *                 BUG22632           Date 05Feb09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER076 - Update to KWG § 24c interface specification         *
      *           (BaFin version 3.3)                                 *
      *  MD052779 - Recompiled to fix buffer issue on ERCRCTPD file   *
      *  MD046248 - Finastra Rebranding                               *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262700 - Various error in KWG extract, applied fix BUG25857A.*
      *  262095 - Change BankName to ServiceProvider.                 *
      *  BUG25857 - KWG §24c in MDAS02 error                          *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *             (Recompile)                                       *
      *  BUG22633 - Extraction process fail to extract data           *
      *  BUG22632 - Unable to recreate transmission file              *
      *  CER047 - German Features LF037-00 Reporting @24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    98         Multi-purpose                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRCrtA - Create 'A' record                                   *
      *  SRCrtC - Create 'C' record                                   *
      *  SRCrtE - Create 'E' record                                   *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** ERCRCDPD - Record type 'C' workfile
      *
     F***ERCRCDPD**IF***F*2000********DISK*** INFSR(*PSSR)                                    262700
     F***ERCRCDPD**IF***F*1086********DISK*** INFSR(*PSSR)                             262700 CER076
     FERCRCDPD  IF   F 1145        DISK    INFSR(*PSSR)                                       CER076
     F                                     USROPN
      *
      ** ERTINFL0 - Midas @24 KWG file info by file number
      *
     FERTINFL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERTINFL2 - Midas @24 KWG file info by file number
      *
     FERTINFL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(ERTINFD0:ERTINFD2)
      *
      ** ERTRSPL0 - idas @24 KWG file info detail by file number
      *
     FERTRSPL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERACEXL2 - Midas @24 KWG account record by account number
      *
     FERACEXL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERACEPL0 - Midas @24 KWG account record persons by account
      *
     FERACEPL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERTSNDPD - Midas @24 KWG transmission workfile
      *
     FERTSNDPD  O  A E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the DB error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Declare constants for the call of 'AOSVALR0'
      *
     D WVal01          C                   'TransmissionFileMax'
     D WVal02          C                   'LastUseFileNumber'
     D WVal03          C                   'BankIntNumber'
     D*WVal04***       C                   'BankName'                                         262095
     D WVal04          C                   'ServiceProvider'                                  262095
     D WVal05          C                   'VendorID'
     D WVal06          C                   'InterfaceVersion'
     D***WVal07*         C                   'Serviceprovider'                              BUG22632
     D WVal07          C                   'ServiceProvider'                                BUG22632
     D WVal08          C                   'DataFormat'
     D WVal09          C                   'TransFileFolder'
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER076
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER076
                                                                                              CER076
     D*DSK24Ab**       DS            80                                                     BUG25857
     D**WAbLen**               1      4I 0 INZ(80)                                          BUG25857
     D*DSK24Ab**       DS            91                                              BUG25857 262700
     D**WAbLen**               1      4I 0 INZ(91)                                   BUG25857 262700
     D DSK24Ab         DS            80                                                       262700
     D  WAbLen                 1      4I 0 INZ(80)                                            262700
     D  WAbRtp                 5      5    INZ('A')
     D  WAbVId                 6     11S 0
     D**WAbBkN**              12     15                                                     BUG25857
     D**WAbVer**              16     21                                                     BUG25857
     D**WAbDat**              22     29                                                     BUG25857
     D**WAbTim**              30     35                                                     BUG25857
      *                                                                                     BUG22633
     D**WAbFnr**              36     41S 0                                                  BUG22633
     D**WAbFtp**              42     43                                                     BUG22633
     D**WAbUtp**              44     44                                                     BUG22633
     D**WAbLid**              45     46S 0                                                  BUG22633
     D**WAbFnm**              47     58                                                     BUG22633
      *                                                                                     BUG22633
     D**WAbFnr**              36     43S 0                                         BUG22633 BUG25857
     D**WAbFtp**              44     45                                            BUG22633 BUG25857
     D**WAbUtp**              46     46                                            BUG22633 BUG25857
     D**WAbLid**              47     48S 0                                         BUG22633 BUG25857
     D**WAbFnm**              49     60                                            BUG22633 BUG25857
      *                                                                                     BUG25857
     D**WAbBkN**              12     46                                              BUG25857 262700
     D**WAbVer**              47     52                                              BUG25857 262700
     D**WAbDat**              53     60                                              BUG25857 262700
     D**WAbTim**              61     66                                              BUG25857 262700
     D**WAbFnr**              67     74S 0                                           BUG25857 262700
     D**WAbFtp**              75     76                                              BUG25857 262700
     D**WAbUtp**              77     77                                              BUG25857 262700
     D**WAbLid**              78     79S 0                                           BUG25857 262700
     D**WAbFnm**              80     91                                              BUG25857 262700
     D  WAbBkN                12     22                                                       262700
     D  WAbVer                23     30                                                       262700
     D  WAbDat                31     38                                                       262700
     D  WAbTim                39     44                                                       262700
     D  WAbFnr                45     50S 0                                                    262700
     D  WAbFtp                51     52                                                       262700
     D  WAbUtp                53     53                                                       262700
     D  WAbLid                54     55S 0                                                    262700
     D  WAbFnm                56     67                                                       262700
      *
     D DSK24Eb         DS            80
     D  WEbLen                 1      4I 0 INZ(80)
     D  WEbRtp                 5      5    INZ('E')
     D  WEbNrc                 6      9I 0
     D  WEbDsc                10     80
      *
     D*DSK24At**       DS            57                                                     BUG25857
     D*DSK24At**       DS            88                                              BUG25857 262700
     D DSK24At         DS            66                                                       262700
     D  WAtRtp                 1      1    INZ('A')
     D  Wk01A                  2      2    INZ('#')
     D  WAtVId                 3      8S 0
     D  Wk02A                  9      9    INZ('#')
     D**WAtBkN**              10     13                                                     BUG25857
     D**Wk03A***              14     14    INZ('#')                                         BUG25857
     D**WAtVer**              15     20                                                     BUG25857
     D**Wk04A***              21     21    INZ('#')                                         BUG25857
     D**WAtDat**              22     29                                                     BUG25857
     D**WK05A***              30     30    INZ('#')                                         BUG25857
     D**WATTIM**              31     36                                                     BUG25857
     D**Wk06A***              37     37    INZ('#')                                         BUG25857
     D**WAtFnr**              38     45S 0                                                  BUG25857
     D**Wk07A***              46     46    INZ('#')                                         BUG25857
     D**WAtFtp**              47     48                                                     BUG25857
     D**Wk08A***              49     49    INZ('#')                                         BUG25857
     D**WAtUtp**              50     50                                                     BUG25857
     D**Wk09A***              51     51    INZ('#')                                         BUG25857
     D**WAtLid**              52     55                                                     BUG25857
     D**WkLfa***              56     57    INZ(X'0D25')                                     BUG25857
      *                                                                                     BUG25857
     D**WAtBkN**              10     44                                              BUG25857 262700
     D**Wk03A***              45     45    INZ('#')                                  BUG25857 262700
     D**WAtVer**              46     51                                              BUG25857 262700
     D**Wk04A***              52     52    INZ('#')                                  BUG25857 262700
     D**WAtDat**              53     60                                              BUG25857 262700
     D**WK05A***              61     61    INZ('#')                                  BUG25857 262700
     D**WATTIM**              62     67                                              BUG25857 262700
     D**Wk06A***              68     68    INZ('#')                                  BUG25857 262700
     D**WAtFnr**              69     76S 0                                           BUG25857 262700
     D**Wk07A***              77     77    INZ('#')                                  BUG25857 262700
     D**WAtFtp**              78     79                                              BUG25857 262700
     D**Wk08A***              80     80    INZ('#')                                  BUG25857 262700
     D**WAtUtp**              81     81                                              BUG25857 262700
     D**Wk09A***              82     82    INZ('#')                                  BUG25857 262700
     D**WAtLid**              83     86                                              BUG25857 262700
     D**WkLfa***              87     88    INZ(X'0D25')                              BUG25857 262700
     D  WAtBkN                10     20                                                       262700
     D  Wk03A                 21     21    INZ('#')                                           262700
     D  WAtVer                22     29                                                       262700
     D  Wk04A                 30     30    INZ('#')                                           262700
     D  WAtDat                31     38                                                       262700
     D  WK05A                 39     39    INZ('#')                                           262700
     D  WATTIM                40     45                                                       262700
     D  Wk06A                 46     46    INZ('#')                                           262700
     D  WAtFnr                47     54S 0                                                    262700
     D  Wk07A                 55     55    INZ('#')                                           262700
     D  WAtFtp                56     57                                                       262700
     D  Wk08A                 58     58    INZ('#')                                           262700
     D  WAtUtp                59     59                                                       262700
     D  Wk09A                 60     60    INZ('#')                                           262700
     D  WAtLid                61     64                                                       262700
     D  WkLfa                 65     66    INZ(X'0D25')                                       262700
      *
     D DSK24Et         DS            43
     D  WEtRtp                 1      1    INZ('E')
     D  Wk01E                  2      2    INZ('#')
     D  WEtNrc                 3     11S 0 INZ(0)
     D  Wk02E                 12     12    INZ('#')
     D  WEtNrn                13     21S 0 INZ(0)
     D  Wk03E                 22     22    INZ('#')
     D  WEtNru                23     31S 0 INZ(0)
     D  Wk04E                 32     32    INZ('#')
     D  WEtNre                33     41S 0 INZ(0)
     D  WkLfe                 42     43    INZ(X'0D25')
      *
      ** Error code for API's
      *
     D PQUSec          DS
     D  WQUSBprv               1      4B 0
     D  WQUSBavl               5      8B 0
     D  WQUSEi                 9     15
     D  WQUSErved             16     16
      *
      ** User space name
      *
     D                 DS
     D  PUsrSpc                      20
     D  WSpcNam                      10    INZ('ERFUSRSPC')
     D                                     OVERLAY(PUsrSpc)
     D WSpcLib                       10    INZ('QTEMP')
     D                                     OVERLAY(PUsrSpc:11)
      *
      ** Qualified file name for API QUSLFLD
      *
     D                 DS
     D  PFile                        20
     D  WFilNam                      10    INZ('ERCRCDPD')
     D                                     OVERLAY(PFile)
     D  WFilLib                      10    INZ('*LIBL')
     D                                     OVERLAY(PFile:11)
      *
      ** Receiving variables for Offset, Number of entities,
      ** Size of entity for API QUSLFLD
      *
     D PRcvVar1        DS
     D  WOffSet1               1      4B 0
     D  WNbrEnt                9     12B 0
     D  WSizEnt               13     16B 0
      *
      ** User space list data section for API QUSLFLD
      *
     D PFldList        DS           448
     D  WFldNam                1     10
     D  WFldPos               17     20B 0
     D  WFldLen               21     24B 0
     D  WFldVarInd           268    268
      *
      ** Receiver variabel for API QWCRSVAL
      *
     D                 DS
     D  PRcvVar2                   1000
     D  WNbrRtn                       9B 0 OVERLAY(PRcvVar2)
     D  WOffSet2                      9B 0 DIM(7) OVERLAY(PRcvVar2:5)
      *
      ** System value information table
      *
     D DSSysValInf     DS
     D  WSysvalnam             1     10
     D  WSysValDtaTyp         11     11
     D  WSysValInfSts         12     12
     D  WSysValLenDta         13     16B 0
     D  WSysVal               15    100    VARYING
      *
      ** Binary value
      *
     D                 DS
     D  WBinA                  1      4
     D  WBin4                  1      4B 0
     D  WBin2                  1      2B 0
      *
      ** Call to C procedure
      *
     D ER000103        PR            10I 0
     D   Path                       100A   CONST
      *
      ** Call to EBCDIC <-> ASCII translation procedure
      *
     D Translate       PR          2000A   OPDESC
     D  PTransTo                      6A   CONST
     D  PString                    2000A   CONST OPTIONS(*VARSIZE)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Variables
      *
     D  WRcd           S           2000A   VARYING
     D  WRcdPos        S              9B 0 INZ(1)
     D  WCmd           S           2000A
     D  WLen           S             15P 5
     D  WCount         S             10I 0
     D  WGwoffSet      S              4B 0 INZ(1)
     D  WgwSize        S              9B 0
     D  WAtfnm         S             20A
     D  WkVl01         S              3A
     D  WkVl02         S              8A
     D  WkVl03         S              6A
     D**WkVl04**       S              4A                                                    BUG25857
     D**WkVl04**       S             35A                                             BUG25857 262700
     D  WkVl04         S             11A                                                      262700
     D  WkVl05         S              4A
     D  WkVl06         S              6A
     D  WkVl07         S              4A
     D  WkVl08         S              8A
     D  WkVl09         S             60A
     D  WmVl01         S              3P 0
     D  WmVl02         S              8P 0
     D  WmVl03         S              6P 0
     D  WWork          S              8P 0
     D  WFnr           S              4A
     D  WVId           S              6A
     D  WFSq           S              3P 0
     D  WFSqA          S              3A
     D  Wx             S              5P 0
      *
      ** Entry Parameters
      *
     D PBkn            S              1A
     D PUtp            S              1A
     D PInlr           S              1A
     D PFnr            S              8P 0
     D PRtnCde         S              1P 0
      *
     D PSeq            S              5A
     D PLev            S              1A
     D PEnt            S              3A
     D PParm           S            100A
     D PRcvVarSiz2     S              9B 0 INZ(1000)
     D PNbrSysVal      S              9B 0 INZ(7)
     D ArrSysVal       S             10    DIM(7) CTDATA PERRCD(7)
     D Path            S            100A
     D PUsrSpcLen      S             10I 0
     D PLenDta         S             10I 0
     D PStrPos         S             10I 0
     D PAttrib         S             10A
     D PValue          S              1A
     D PubAut          S             10A
     D PUsrSpcTxt      S             50A
     D PFormat         S              8A
     D PRcdFmt         S             10A
     D POvrPrc         S              1A
      *
      ** Parameters for the call of 'AOSVALR0'
      *
     D PRtCd           S              7A
     D POp01           S             20A
     D POp02           S             20A
     D POp03           S             20A
     D POp04           S             20A
     D POp05           S             20A
     D POp06           S             20A
     D POp07           S             20A
     D POp08           S             20A
     D POp09           S             20A
     D POp10           S             20A
      *
     D PVl01           S            200A
     D PVl02           S            200A
     D PVl03           S            200A
     D PVl04           S            200A
     D PVl05           S            200A
     D PVl06           S            200A
     D PVl07           S            200A
     D PVl08           S            200A
     D PVl09           S            200A
     D PVl10           S            200A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Declaration of Input Specification
      *
     IERCRCDPD  NS  01
     I**********                        1 2000  GWINP                                         262700
     I**********                        1 1086  GWINP                                 262700  CER076
     I                                  1 1145  GWINP                                         CER076
      *
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
      ** Check size of file
      *
     C                   EVAL      WkVl01 = %TRIM(PVl01)
     C                   EVAL      WmVl01 = %INT(WkVl01)
     C                   IF        WgwSize > (WmVl01 * 1000000)
      *
      ** Finish this file and open new file
      *
     C                   EXSR      SRCrtE
      *
      ** Set new file type
      *
     C                   IF        WAbUtp = 'K'
     C                   MOVEL     'W'           WAbUtp
     C                   ENDIF
      *
     C                   IF        WAtUtp = 'K'
     C                   MOVEL     'W'           WAtUtp
     C                   ENDIF
      *
     C                   EXSR      SRCrtA
     C                   ENDIF
      *
      ** Create C-record
      *
     C                   OPEN      ERCRCDPD
      *
     C                   DOU       %EOF
      *
     C                   READ      ERCRCDPD
      *
     C                   IF        NOT(%EOF)
     C                   EXSR      SRCrtC
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   CLOSE     ERCRCDPD
      *
      ** If last record received, write E-record
      *
     C                   EVAL      *INLR = PInlr
      *
     C                   IF        *INLR
     C                   EXSR      SRCrtE
     C                   ENDIF
      *
      ** Return file number to calling program
      *
     C                   EVAL      PFnr = WAtFnr
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrtA - Create 'A' record                                   *
      *                                                               *
      *  Called by : MAIN Processing, *INZSR                          *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCrtA        BEGSR
      *
      ** Clear transmission work file
      *
     C                   EVAL      WCmd = 'CLRPFM FILE(ERTSNDPD)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Open file
      *
     C                   OPEN      ERTSNDPD
      *
      ** Reset number of 'C' records
      *
     C                   CLEAR                   WEbNrc
     C                   CLEAR                   WgwSize
      *
      ** Calculate next file number if NOT in recovery mode
      *
     C                   IF        PFnr = 0
      *
     C                   SELECT
      *
     C                   WHEN      PBkn = 'B'
     C                   Z-ADD     999999        WWork
      *
     C                   WHEN      PBkn = 'T'
     C                   Z-ADD     99999999      WWork
      *
     C                   ENDSL
      *
     C                   EVAL      WkVl02 = %TRIM(PVl02)
     C                   EVAL      WmVl02 = %INT(WkVl02)
                                                                                              262700
     C                   OPEN      ERTINFL0                                                   262700
     C     *HIVAL        SETLL     ERTINFL0                                                   262700
     C                   READ      ERTINFL0                                                   262700
     C                   IF        %FOUND(ERTINFL0)                                           262700
     C                   EVAL      WmVl02 = F10FNR                                            262700
     C                   ELSE                                                                 262700
     C                   EVAL      WmVl02 = 0                                                 262700
     C                   ENDIF                                                                262700
     C                   CLOSE     ERTINFL0                                                   262700
      *
     C                   IF        WmVl02 = WWork
     C                   EVAL      WmVl02 = 1
     C                   ELSE
     C                   EVAL      WmVl02 = WmVl02 + 1
     C                   ENDIF
      *
     C                   Z-ADD     WmVl02        WAbFnr
     C                   Z-ADD     WmVl02        WAtFnr
      *
      ** Delete possible existing records for this file number
      *
     C                   OPEN      ERTINFL0
     C                   OPEN      ERTRSPL0
     C                   OPEN      ERACEXL2
     C                   OPEN      ERACEPL0
      *
     C     WmVl02        DELETE(E) ERTINFD0
      *
     C                   DOU       NOT(%FOUND)
     C     WmVl02        DELETE    ERTRSPD0
     C                   ENDDO
      *
     C     WmVl02        SETLL     ERACEXL2
     C     WmVl02        READE     ERACEXD0
      *
     C                   DOW       NOT(%EOF)
      *
     C                   DOU       NOT(%FOUND)
     C     KLerac        DELETE    ERACEPD0
     C                   ENDDO
      *
     C                   DELETE    ERACEXD0
     C     WmVl02        READE     ERACEXD0
     C                   ENDDO
      *
     C                   CLOSE     ERACEPL0
     C                   CLOSE     ERACEXL2
     C                   CLOSE     ERTRSPL0
     C                   CLOSE     ERTINFL0
      *
      ** Set file number if in recovery mode
      *
     C                   ELSE
     C                   Z-ADD     PFnr          WAbFnr
     C                   Z-ADD     PFnr          WAtFnr
     C                   ENDIF
      *
      ** Set Verplichteten-ID, Betreiber Kennung, function type, etc.
      *
     C                   EVAL      WkVl03 = %TRIM(PVl03)
     C                   EVAL      WmVl03  = %INT(WkVl03)
     C                   Z-ADD     WmVl03        WAbVId
     C                   Z-ADD     WmVl03        WAtVId
     C                   EVAL      WkVl04 = %TRIM(PVl04)
     C                   MOVEL     WkVl04        WAbBkN
     C                   MOVEL     WkVl04        WAtBkN
     C                   EVAL      WkVl06 = %TRIM(PVl06)
     C                   MOVEL     WkVl06        WAbVer
     C                   MOVEL     WkVl06        WAtVer
     C                   MOVE      'IK'          WAbFtp
     C                   MOVE      'MD'          WAtFtp
     C                   EVAL      WkVl05 = %TRIM(PVl05)
     C                   MOVEL     WkVl05        WAbLid
     C                   MOVE      WkVl05        WAtLid
      *
      ** Set date and time from system values
      ** Get system values
      *
     C                   IF        PFnr = 0
     C                   CALL      'QWCRSVAL'
     C                   PARM                    PRcvVar2
     C                   PARM                    PRcvVarSiz2
     C                   PARM                    PNbrSysVal
     C                   PARM                    ArrSysVal
     C                   PARM                    PQUSec
      *
      ** Read through offset array
      *
     C                   DO        WNbrRtn       Wx
      *
      ** Read system value information table
      *
     C                   EVAL      DSSysValInf =
     C                             %SUBST(PRcvVar2:WOffSet2(Wx)+1)
      *
      ** If system value is available
      *
     C                   IF        WSysValInfSts <> 'L'
      *
      ** Select system value
      *
     C                   SELECT
      *
     C                   WHEN      WSysvalnam = 'QCENTURY'
      *
     C                   IF        WSysVal = '1'
     C                   MOVEL     '20'          WAbDat
     C                   MOVEL     '20'          WAtDat
     C                   ELSE
     C                   MOVEL     '19'          WAbDat
     C                   MOVEL     '19'          WAtDat
     C                   ENDIF
      *
     C                   WHEN      WSysvalnam = 'QDAY    '
     C                   EVAL      %SUBST(WAbDat:7:2) = WSysVal
     C                   EVAL      %SUBST(WAtDat:7:2) = WSysVal
      *
     C                   WHEN      WSysvalnam = 'QMONTH  '
     C                   EVAL      %SUBST(WAbDat:5:2) = WSysVal
     C                   EVAL      %SUBST(WAtDat:5:2) = WSysVal
      *
     C                   WHEN      WSysvalnam = 'QYEAR   '
     C                   EVAL      %SUBST(WAbDat:3:2) = WSysVal
     C                   EVAL      %SUBST(WAtDat:3:2) = WSysVal
      *
     C                   WHEN      WSysvalnam = 'QHOUR   '
     C                   EVAL      %SUBST(WAbTim:1:2) = WSysVal
     C                   EVAL      %SUBST(WATTIM:1:2) = WSysVal
      *
     C                   WHEN      WSysvalnam = 'QMINUTE '
     C                   EVAL      %SUBST(WAbTim:3:2) = WSysVal
     C                   EVAL      %SUBST(WATTIM:3:2) = WSysVal
      *
     C                   WHEN      WSysvalnam = 'QSECOND '
     C                   EVAL      %SUBST(WAbTim:5:2) = WSysVal
     C                   EVAL      %SUBST(WATTIM:5:2) = WSysVal
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** Set file name
      *
     C                   MOVE      WAbFnr        WFnr
     C                   EVAL      WkVl07 = %TRIM(PVl07)
     C                   EVAL      WAbFnm = WkVl07 + WFnr + '.' +
     C                             WAbFtp + WAbUtp
     C                   MOVE      WmVl03        WVId
     C                   OPEN      ERTINFL2
     C     NextFSQ       TAG
     C                   EVAL      WFSq = WFSq +1
      *
     C                   IF        WFSq = 999
     C                   MOVEL     'ERTINFPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'FSQ = 999'   DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WFSq          WFSqA
     C                   EVAL      WAtfnm = 'I' + WVId + WAtDat + '.' +
     C                                      WFSqA
     C     WAtfnm        CHAIN     ERTINFD2
      *
     C                   IF        %FOUND
     C                   GOTO      NextFSQ
     C                   ENDIF
      *
     C                   CLOSE     ERTINFL2
     C                   ENDIF
      *
      ** Write 'A' record
      *
     C                   EVAL      WkVl08 = %TRIM(PVl08)
      *
     C                   SELECT
     C                   WHEN      PBkn = 'B'
     C                   EVAL      F1WDTA = DSK24Ab
     C                   EVAL      %SUBST(F1WDTA:5) =
     C                             Translate(WkVl08:%SUBST(DSK24Ab:5))
     C                   EVAL      F1WLEN = WAbLen
     C                   EVAL      WgwSize = WgwSize+ WAbLen
      *
     C                   WHEN      PBkn = 'T'
     C                   EVAL      F1WDTA = Translate(WkVl08:DSK24AT)
     C                   EVAL      F1WLEN = %LEN(DSK24AT)
     C                   EVAL      WgwSize = WgwSize+ %LEN(DSK24AT)
      *
     C                   ENDSL
      *
     C                   IF        NOT %OPEN(ERTSNDPD)
     C                   OPEN      ERTSNDPD
     C                   ENDIF
      *
     C                   WRITE     ERTSNDD0
     C                   CLEAR                   F1WDTA
     C                   CLEAR                   F1WLEN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrtC - Create 'C' record                                   *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCrtC        BEGSR
      *
      ** Read through fields of file ERCRCDPD, extract the data and put
      ** it into variable and put it into variable length record
      *
     C                   CLEAR                   WRcd
     C                   RESET                   WRcdPos
      *
      ** Offset to begin of entities of the user space that holds
      ** the file field information
      *
     C                   EVAL      PStrPos = WOffSet1+ 1
     C                   EVAL      PLenDta = WSizEnt
     C                   EVAL      WCount = 1
      *
      ** Read while entities found
      *
     C                   DOW       WCount <= WNbrEnt
     C                   EVAL      WCount = WCount + 1
      *
      ** Read the user space
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    PUsrSpc
     C                   PARM                    PStrPos
     C                   PARM                    PLenDta
     C                   PARM                    PFldList
      *
      ** Extract data of a variable lenght field
      *
     C                   IF        WFldVarInd = '1'
      *
     C                   EVAL      WBinA = %SUBST(GWINP:WFldPos:2)
      *
     C                   SELECT
      *
     C                   WHEN      WFLDNAM = 'F1TINO ' and CER076 <> 'Y'                      CER076
     C                   WHEN      WFLDNAM = 'F1EINO ' and CER076 <> 'Y'                      CER076
     C                   WHEN      PBkn = 'B'
     C                   EVAL      %LEN(WRcd) = %LEN(WRcd) + WBin2 + 2
     C                   EVAL      %SUBST(WRcd:WRcdPos) =
     C                             %SUBST(GWINP:WFldPos:WBin2 + 2)
      *
     C                   IF        WBin2 > 0
     C                   EVAL      %SUBST(WRcd:WRcdPos + 2) =
     C                             Translate(WkVl08:
     C                             %SUBST(GWINP:WFldPos+ 2:WBin2))
     C                   ENDIF
      *
     C                   EVAL      WRcdPos = WRcdPos + WBin2 + 2
      *
     C                   WHEN      PBkn = 'T'
     C                   EVAL      %LEN(WRcd) = %LEN(WRcd) + WBin2 + 1
     C                   EVAL      %SUBST(WRcd:WRcdPos) =
     C                             %SUBST(GWINP:WFldPos+ 2:WBin2) + '#'
     C                   EVAL      WRcdPos = WRcdPos + WBin2 + 1
      *
     C                   ENDSL
      *
      ** Extract data of a static length field
      *
     C                   ELSE
      *
     C                   SELECT
     C                   WHEN      WFLDNAM = 'F1TINO ' and CER076 <> 'Y'                      CER076
     C                   WHEN      WFLDNAM = 'F1EINO ' and CER076 <> 'Y'                      CER076
     C                   WHEN      PBkn = 'B'
     C                   EVAL      %LEN(WRcd) = %LEN(WRcd) + WFldLen
     C                   EVAL      %SUBST(WRcd:WRcdPos) =
     C                             Translate(WkVl08:
     C                             %SUBST(GWINP:WFldPos:WFldLen))
     C                   EVAL      WRcdPos = WRcdPos + WFldLen
      *
     C                   WHEN      PBkn = 'T'
     C                   EVAL      %LEN(WRcd) = %LEN(WRcd) + WFldLen+ 1
     C                   EVAL      %SUBST(WRcd:WRcdPos) =
     C                             %SUBST(GWINP:WFldPos:WFldLen) + '#'
     C                   EVAL      WRcdPos = WRcdPos + WFldLen+ 1
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Increment individual record counter
      *
     C                   SELECT
      *
     C                   WHEN      PBkn = 'B'
      *
     C                   WHEN      PBkn = 'T'
      *
     C                   IF        WFldNam = 'F1CDTP'
      *
     C                   SELECT
      *
     C                   WHEN      %SUBST(GWINP:WFldPos:WFldLen) = 'N'
     C                   EVAL      WEtNrn = WEtNrn + 1
      *
     C                   WHEN      %SUBST(GWINP:WFldPos:WFldLen) = 'U'
     C                   EVAL      WEtNru = WEtNru + 1
      *
     C                   WHEN      %SUBST(GWINP:WFldPos:WFldLen) = 'E'
     C                   EVAL      WEtNre = WEtNre + 1
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDSL
      *
      ** Next Offset
      *
     C                   EVAL      PStrPos = PStrPos+ WSizEnt
     C                   ENDDO
      *
      ** Calculate total length of record
      *
     C                   EVAL      WBin4 = %LEN(WRcd)
      *
     C                   SELECT
     C                   WHEN      PBkn = 'B'
      *
      ** It is assumed that the first field of the 'C' record (GWLEN)
      ** contains the total length of the record in 4 byte binary
      ** format, o set the first 4 chars of the record to that binary
      ** value.
      *
     C                   EVAL      %SUBST(WRcd:1:4) = WBinA
     C                   WHEN      PBkn = 'T'
      *
      ** The record ends with a CRLF (X'0D25').
      *
     C                   EVAL      %LEN(WRcd) = %LEN(WRcd) + 1
     C                   EVAL      %SUBST(WRcd:WBin4:2) = X'0D25'
     C                   EVAL      WRcd = Translate(WkVl08:WRcd)
     C                   EVAL      WBin4 = WBin4+ 1
     C                   ENDSL
      *
      ** Write 'C' record
      *
     C                   EVAL      F1WDTA = WRcd
     C                   EVAL      F1WLEN = WBin4
      *
     C                   IF        NOT %OPEN(ERTSNDPD)
     C                   OPEN      ERTSNDPD
     C                   ENDIF
      *
     C                   WRITE     ERTSNDD0
     C                   CLEAR                   F1WDTA
     C                   CLEAR                   F1WLEN
      *
      ** Increment record counter
      *
     C                   EVAL      WEbNrc = WEbNrc + 1
     C                   EVAL      WEtNrc = WEtNrc + 1
      *
      ** Calculate size of file
      *
     C                   EVAL      WgwSize = WgwSize + WBin4
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrtE - Create 'E' record                                   *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCrtE        BEGSR
      *
      ** Write 'E' record
      *
     C                   SELECT
      *
     C                   WHEN      PBkn = 'B'
     C                   EVAL      F1WDTA = DSK24Eb
     C                   EVAL      %SUBST(F1WDTA:5:1) =
     C                             Translate(WkVl08:
     C                             %SUBST(DSK24Eb:5:1))
     C                   EVAL      %SUBST(F1WDTA:10) =
     C                             Translate(WkVl08:%SUBST(DSK24Eb:10))
     C                   EVAL      F1WLEN = WEbLen
     C                   EVAL      WgwSize = WgwSize+ WEbLen
      *
     C                   WHEN      PBkn = 'T'
     C                   EVAL      F1WDTA = Translate(WkVl08:DSK24Et)
     C                   EVAL      F1WLEN = %LEN(DSK24Et)
     C                   EVAL      WgwSize = WgwSize+ %LEN(DSK24Et)
      *
     C                   ENDSL
      *
     C                   IF        NOT %OPEN(ERTSNDPD)
     C                   OPEN      ERTSNDPD
     C                   ENDIF
      *
     C                   WRITE     ERTSNDD0
     C                   CLEAR                   F1WDTA
     C                   CLEAR                   F1WLEN
      *
      ** Close file
      *
     C                   CLOSE     ERTSNDPD
      *
      ** Copy file to folder via C-Program
      *
     C                   EVAL      WkVl09 = %TRIM(PVl09)
      *
     C                   SELECT
      *
     C                   WHEN      PBkn = 'B'
     C                   EVAL      Path = %TRIM(WkVl09) +
     C                                    %TRIM(WAbFnm) + X'00'
      *
     C                   WHEN      PBkn = 'T'
     C                   EVAL      Path = %TRIM(WkVl09) +
     C                                    %TRIM(WAtfnm) + X'00'
     C                   ENDSL
      *
      ** Call C-Module
      *
     C                   EVAL      PRtnCde = ER000103(Path)
      *
      ** Create transmission maintenance record, if no error occured
      *
     C                   IF        PRtnCde = 0
      *
     C                   OPEN      ERTINFL0
     C     WAtFnr        CHAIN     ERTINFD0
     C                   CLEAR                   F10STS
      *
     C                   SELECT
      *
     C                   WHEN      PBkn = 'B'
     C                   Z-ADD     WAbFnr        F10FNR
     C                   MOVEL     WAbUtp        F10UTP
     C                   MOVEL(P)  WAbFnm        F10FNM
     C                   MOVE      WAbDat        F10DAT
     C                   MOVE      WAbTim        F10TIM
     C                   Z-ADD     WEbNrc        F10NRC
      *
     C                   WHEN      PBkn = 'T'
     C                   Z-ADD     WAtFnr        F10FNR
     C                   MOVEL     WAtUtp        F10UTP
     C                   MOVEL(P)  WAtfnm        F10FNM
     C                   MOVE      WAtDat        F10DAT
     C                   MOVE      WATTIM        F10TIM
     C                   Z-ADD     WEtNrc        F10NRC
      *
     C                   ENDSL
     C                   Z-ADD     WgwSize       F10SIZ
      *
     C                   IF        %FOUND
     C                   UPDATE    ERTINFD0
     C                   ELSE
     C                   WRITE     ERTINFD0
     C                   ENDIF
      *
     C                   CLOSE     ERTINFL0
     C                   ELSE
     C                   RETURN
     C                   ENDIF
      *
      ** Print audit list
      *
     C                   EVAL      PParm = %EDITC(F10FNR:'3') +
     C                                     %EDITC(F10FNR:'3')
     C                   CALL      'ERC000150'
     C                   PARM      '     '       PSeq
     C                   PARM      ' '           PLev
     C                   PARM      '   '         PEnt
     C                   PARM                    PParm
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: SRCrtA                                                *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** *Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBkn
     C                   PARM                    PUtp
     C                   PARM                    PInlr
     C                   PARM                    PFnr
     C                   PARM                    PRtnCde
      *
      ** Retrieve information from AOSVALR0
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      WVal01        POp01
     C                   PARM                    PVl01
     C                   PARM      WVal02        POp02
     C                   PARM                    PVl02
     C                   PARM      WVal03        POp03
     C                   PARM                    PVl03
     C                   PARM      WVal04        POp04
     C                   PARM                    PVl04
     C                   PARM      WVal05        POp05
     C                   PARM                    PVl05
     C                   PARM      WVal06        POp06
     C                   PARM                    PVl06
     C                   PARM      WVal07        POp07
     C                   PARM                    PVl07
     C                   PARM      WVal08        POp08
     C                   PARM                    PVl08
     C                   PARM      WVal09        POp09
     C                   PARM                    PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM                    PVl10
      *
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
      *
     C                   IF        PVl01 = '*NRF   '
     C                   EVAL      DBKEY = POp01
     C                   ENDIF
      *
     C                   IF        PVl02 = '*NRF   '
     C                   EVAL      DBKEY = POp02
     C                   ENDIF
      *
     C                   IF        PVl03 = '*NRF   '
     C                   EVAL      DBKEY = POp03
     C                   ENDIF
      *
     C                   IF        PVl04 = '*NRF   '
     C                   EVAL      DBKEY = POp04
     C                   ENDIF
      *
     C                   IF        PVl05 = '*NRF   '
     C                   EVAL      DBKEY = POp05
     C                   ENDIF
      *
     C                   IF        PVl06 = '*NRF   '
     C                   EVAL      DBKEY = POp06
     C                   ENDIF
      *
     C                   IF        PVl07 = '*NRF   '
     C                   EVAL      DBKEY = POp07
     C                   ENDIF
      *
     C                   IF        PVl08 = '*NRF   '
     C                   EVAL      DBKEY = POp08
     C                   ENDIF
      *
     C                   IF        PVl09 = '*NRF   '
     C                   EVAL      DBKEY = POp09
     C                   ENDIF
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ER000102'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CER076
      ** Check if CER076 is on                                                                CER076
                                                                                              CER076
     C                   CALL      'AOSARDR0'                                                 CER076
     C                   PARM      *Blanks       PRtCd                                        CER076
     C                   PARM      '*VERIFY'     POptn             7                          CER076
     C                   PARM      'CER076'      PSard             6                          CER076
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER076
                                                                                              CER076
     C                   MOVE      'N'           CER076            1                          CER076
     C                   IF        PRtCd <> *Blanks                                           CER076
     C                   IF        PRtCd <> '*NRF'                                            CER076
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER076
     C                   MOVEL     '901'         DBASE                                        CER076
     C                   MOVEL     PSard         DBKEY                                        CER076
     C                   EXSR      *PSSR                                                      CER076
     C                   ENDIF                                                                CER076
     C                   ELSE                                                                 CER076
     C                   EVAL      CER076 = 'Y'                                               CER076
     C                   ENDIF                                                                CER076
      *
      ** Create the user space for the File Field information
      *
     C                   EVAL      PUsrSpcTxt = 'User space for' +
     C                             'program ER000100'
     C                   CALL      'QUSCRTUS'                           9898
     C                   PARM                    PUsrSpc
     C                   PARM      *BLANKS       PAttrib
     C                   PARM      80000         PUsrSpcLen
     C                   PARM      *BLANKS       PValue
     C                   PARM      '*ALL'        PubAut
     C                   PARM                    PUsrSpcTxt
      *
      ** Read the File Field information into the user space
      *
     C                   CALL      'QUSLFLD'
     C                   PARM                    PUsrSpc
     C                   PARM      'FLDL0100'    PFormat
     C                   PARM                    PFile
     C                   PARM      'ERCRCDD0'    PRcdFmt
     C                   PARM      '1'           POvrPrc
     C                   PARM                    PQUSec
      *
      ** Read the user space Offset, Number of entities, Size of entity
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    PUsrSpc
     C                   PARM      125           PStrPos
     C                   PARM      16            PLenDta
     C                   PARM                    PRcvVar1
      *
      ** If in recovery mode, get file type from existing record
      *
     C                   IF        PFnr <> 0
     C                   OPEN      ERTINFL0
     C     PFnr          CHAIN(N)  ERTINFD0
      *
     C                   IF        NOT(%FOUND)
     C                   EVAL      PRtnCde = 4
     C                   RETURN
     C                   ENDIF
      *
     C                   CLOSE     ERTINFL0
     C                   MOVEL     F10UTP        WAbUtp
     C                   MOVEL     F10UTP        WAtUtp
     C                   MOVEL     F10FNM        WAbFnm
     C                   MOVEL     F10FNM        WAtfnm
     C                   MOVE      F10DAT        WAbDat
     C                   MOVE      F10DAT        WAtDat
     C                   MOVE      F10TIM        WAbTim
     C                   MOVE      F10TIM        WATTIM
      *
      ** Create A-record with file type passed from calling program
      *
     C                   ELSE
     C                   MOVEL     PUtp          WAbUtp
     C                   MOVEL     PUtp          WAtUtp
     C                   ENDIF
     C                   EXSR      SRCrtA
      *
      ** Define Keylists
      *
     C     KLerac        KLIST
     C                   KFLD                    F12ACC
     C                   KFLD                    F12REF
     C                   KFLD                    F12VDT
     C                   KFLD                    F12VTM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module and procedure names for database error
      ** processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Transalte - Procedure for EBCDIC <-> ASCII translation       *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
      ** Procedure Translate
      *
     P Translate       B
     D Translate       PI          2000A   OPDESC
     D  PTransTo                      6A   CONST
     D  PString                    2000A   CONST OPTIONS(*VARSIZE)
      *
      ** S Translate EBCDIC to ASCII, if requested
      ** Prototype for CEEDOD (Retrieve operational descriptor)
      *
     D CEEDOD          PR
     D  ParmNum                      10I 0 CONST
     D                               10I 0
     D                               10I 0
     D                               10I 0
     D                               10I 0
     D                               10I 0
     D                               12A   OPTIONS(*OMIT)
      *
      ** Parameters passed to CEEDOD
      *
     D  PDescType      S             10I 0
     D  PDataType      S             10I 0
     D  PDescInfo1     S             10I 0
     D  PDescInfo2     S             10I 0
     D  PLength        S             10I 0
      *
      ** Definitions for procedure
      *
     D  WRetString     S           2000A   INZ(' ')
      *
      ** Parametrs for Calling QDCXLATE
      *
     D PLengthOfData   S              5P 0
     D PConversnData   S           2000A
     D PSBCSTbleName   S             10A
      *
      ** Use the operational descriptor to determine the length of the
      ** parameter that were passed
      *
     C                   CALLP     CEEDOD(2:PDescType:PDataType:
     C                             PDescInfo1:PDescInfo2:PLength:*OMIT)
      *
      ** Translate
      *
     C                   EVAL      PSBCSTbleName = 'ER' +
     C                                             %TRIM(PTransTo)
     C                   CALL      'QDCXLATE'                           9898
     C                   PARM      PLength       PLengthOfData
     C     WRetString    PARM      PString       PConversnData
     C                   PARM                    PSBCSTbleName
      *
     C                   IF        *IN98
     C                   RETURN    %SUBST(PString:1:PLength)
     C                   ENDIF
      *
      ** Done; return translated string to caller
      *
     C                   RETURN    %SUBST(WRetString:1:PLength)
      *
     P Translate       E
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
**  System Values
QCENTURY  QDAY      QMONTH    QYEAR     QHOUR     QMINUTE   QSECOND
