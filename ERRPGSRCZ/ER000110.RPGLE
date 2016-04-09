     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG response file receiver')                 *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000110 - Midas @24 KWG  response file receiver             *
      *                                                               *
      *  Function : This program reads the response file.             *
      *                                                               *
      *  Component of : ER000110                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER068             Date 25Feb14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26268           Date 01Oct09               *
      *                 262095             Date 14Oct09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26268 - Chapter 24 import gives a database error          *
      *  262095 - Change BankName to ServiceProvider.                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
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
      *  SRValA - Validate 'A' record                                 *
      *  SRValB - Validate 'B' record                                 *
      *  SRValE - Validate 'E' record                                 *
      *  SRWrite - Write record in Printer file                       *
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
      ** ERTINFL1 - Midas @24 KWG file info by file number
      *
     FERTINFL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERTRSPL0 - Midas @24 KWG file info detail by file number
      *
     FERTRSPL0  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERTRCVPD - Midas @24 KWG response workfile
      *
     FERTRCVPD  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** Midas @24 KWG account record by account number
      *
     FERACEXL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** Midas @24 KWG response file Report
      *
     FER000110P1O    E             PRINTER OFLIND(*IN71)
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
      **    True       logical = *on (fOR indcatOR processing)
      **    False      logical = *off (fOR indcatOR processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the DB error
      **                                    hANDler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields
      ** in the PSDS.  They have meaningful names, prefixed by 'PS'.
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
     D WVal01          C                   'ResponseFileFolder'
     D WVal02          C                   'DataFormat'
     D WVal03          C                   'InterfaceVersion'
     D WVal04          C                   'BankIntNumber'
     D*WVal05***       C                   'BankName'                                         262095
     D WVal05          C                   'ServiceProvider'                                  262095
      *
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data Structures
      *
     D DSK24Ab         DS            80
     D  WAbLen                 1      4I 0 INZ(80)
     D  WAbRtp                 5      5    INZ('A')
     D  WAbVId                 6     11S 0
     D**WAbBkN**              12     15                                                     BUG26268
     D**WAbVer**              16     21                                                     BUG26268
     D**WAbDat**              22     29                                                     BUG26268
     D**WAbTim**              30     35                                                     BUG26268
     D**WAbFnr**              36     41S 0                                                  BUG26268
     D**WAbFtp**              42     43                                                     BUG26268
     D**WAbUtp**              44     44                                                     BUG26268
     D**WAbLid**              45     46S 0                                                  BUG26268
     D**WAbFnm**              47     58                                                     BUG26268
     D  WAbBkN                12     22                                                     BUG26268
     D  WAbVer                23     30                                                     BUG26268
     D  WAbDat                31     38                                                     BUG26268
     D  WAbTim                39     44                                                     BUG26268
     D  WAbFnr                45     50S 0                                                  BUG26268
     D  WAbFtp                51     52                                                     BUG26268
     D  WAbUtp                53     53                                                     BUG26268
     D  WAbLid                54     55S 0                                                  BUG26268
     D  WAbFnm                56     67                                                     BUG26268
      *
     D DSK24Bb         DS
     D  WBbLen                 1      4I 0
     D  WBbRtp                 5      5    INZ('B')
     D  WBbEcl                 6      6S 0
     D  WBbEtp                 7      8S 0
     D  WBbDtl                 9     12I 0
     D  WBbDta                13  32760
      *
     D DSK24Eb         DS            80
     D  WEbLen                 1      4I 0 INZ(80)
     D  WEbRtp                 5      5    INZ('E')
     D  WEbNrc                 6      9I 0
     D  WEbDsc                10     80    INZ(*ALL'.')
      *
     D*DSK24At**       DS            55                                                     BUG26268
     D DSK24At         DS            62                                                     BUG26268
     D  WAtRtp                 1      1    INZ('A')
     D  Wk01A                  2      2    INZ('#')
     D  WAtVId                 3      8S 0 INZ(0)
     D  Wk02A                  9      9    INZ('#')
     D**WAtBkN**              10     13                                                     BUG26268
     D**Wk03A***              14     14    INZ('#')                                         BUG26268
     D**WAtVer**              15     20                                                     BUG26268
     D**Wk04A***              21     21    INZ('#')                                         BUG26268
     D**WAtDaT**              22     29                                                     BUG26268
     D**Wk05A***              30     30    INZ('#')                                         BUG26268
     D**WAtTiM**              31     36                                                     BUG26268
     D**Wk06A***              37     37    INZ('#')                                         BUG26268
     D**WAtFnr**              38     45S 0 INZ(0)                                           BUG26268
     D**Wk07A***              46     46    INZ('#')                                         BUG26268
     D**WAtFtp**              47     48                                                     BUG26268
     D**Wk08A***              49     49    INZ('#')                                         BUG26268
     D**WAtLid**              50     53                                                     BUG26268
     D**WkLfa***              54     55    INZ(X'0D25')                                     BUG26268
     D  WAtBkN                10     20                                                     BUG26268
     D  Wk03A                 21     21    INZ('#')                                         BUG26268
     D  WAtVer                22     27                                                     BUG26268
     D  Wk04A                 28     28    INZ('#')                                         BUG26268
     D  WAtDaT                29     36                                                     BUG26268
     D  Wk05A                 37     37    INZ('#')                                         BUG26268
     D  WAtTiM                38     43                                                     BUG26268
     D  Wk06A                 44     44    INZ('#')                                         BUG26268
     D  WAtFnr                45     52S 0 INZ(0)                                           BUG26268
     D  Wk07A                 53     53    INZ('#')                                         BUG26268
     D  WAtFtp                54     55                                                     BUG26268
     D  Wk08A                 56     56    INZ('#')                                         BUG26268
     D  WAtLid                57     60                                                     BUG26268
     D  WkLfa                 61     62    INZ(X'0D25')                                     BUG26268
      *
     D DSK24Ct         DS
     D  WCtRtp                 1      1    INZ('C')
     D  Wk01C                  2      2    INZ('#')
     D  WCtEcl                 3      4S 0 INZ(0)
     D  Wk02C                  5      5    INZ('#')
     D  WCtEtp                 6      9S 0 INZ(0)
     D  Wk03C                 10     10    INZ('#')
     D  WCtDta                11    522
     D  WkLfc                523    524    INZ(X'0D25')
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
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Unsigned Integer value of a character
      *
     D                 DS
     D  Puns                         10U 0 INZ(0)
     D  Pchr                          1A   OVERLAY(Puns:4)
      *
      ** Error code fOR API's
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
     D  WSpcLib                      10    INZ('QTEMP')
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
      ** Binary value
      *
     D                 DS
     D WBinA                   1      4
     D WBin4                   1      4B 0
     D WBin2                   1      2B 0
      *
      **  Call to C procedure
      *
     D ER000113        PR            10I 0
     D  Path                        100A   CONST
     D  Puns                         10U 0 VALUE
      *
      ** Call to EBCDIC <-> ASCII translation procedure
      *
     D Translate       PR         32760A   OPDESC
     D  PTransFrom                    6A   CONST
     D  PString                   32760A   CONST OPTIONS(*VARSIZE)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Variables
      *
     D WRcdtyp         S              1A
     D WRcdind         S              4A
     D WNbrRcd         S              9B 0
     D Path            S            100A
     D WRtnCde         S              1S 0
     D WFnm            S                   LIKE(F10FNM)
     D WCount          S             10I 0
     D WRcdPos         S              9B 0 INZ(1)
     D WFldDta         S            200A
     D WkVl02          S              6A
     D WKvl04          S              6A
     D WAtVIdA         S              6A
     D WAtFnrA         S              8A
     D WField          S           2000A
     D Wx              S             15P 0
     D Wy              S             15P 0
     D Wz              S             15P 0
     D WCtEclA         S              2A
     D WCtEtpA         S              4A
     D WEcde           S              4A
     D WEtNrcA         S              9A
     D WEtNrnA         S              9A
     D WEtNruA         S              9A
     D WEtNreA         S              9A
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
      ** Parameters
      *
     D POptn           S              7A
     D P0Rtn           S              7A
     D PAttrib         S             10A
     D PValue          S              1A
     D PubAut          S             10A
     D PUsrSpcTxt      S             50A
     D PUsrSpcLen      S             10I 0
     D PFormat         S              8A
     D PRcdFmt         S             10A
     D POvrPrc         S              1A
     D PZaMsId         S              7A
     D PZaMsgF         S             10A
     D PZAMsda         S            132A
     D PZaMstx         S            132A
     D PLenDta         S             10I 0
     D PStrPos         S             10I 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: the *INZ   ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read maintenance file
      *
     C                   READ      ERTINFD0
     C                   DOW       NOT(%EOF)
      *
      ** Setup indicators for printing header of the report
      *
     C                   EVAL      *IN71 = *ON
     C                   EVAL      R11FNR = F10FNR
      *
      ** Try to get response file, if not found continue with next
      ** record Create response file name
      *
     C                   MOVEL     F10FNM        WFnm
      *
     C                   SELECT
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      %SUBST(WFnm:10:2) = 'IB'
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      %SUBST(WFnm:1:1) = 'B'
      *
     C                   ENDSL
      *
      ** Copy file to database workfile via C-Program
      *
     C                   EVAL      Path = %TRIM(%SUBST(PVl01:1:60)) +
     C                                    %TRIM(WFnm) +
     C                                    X'00'
     C                   EVAL      R11PTH = Path
     C                   EVAL      WRtnCde = ER000113(Path:Puns)
      *
      ** Select for return code
      *
     C                   SELECT
      *
      ** Successful
      *
     C                   WHEN      WRtnCde = 0
      *
      ** Reset record indicator to START
      *
     C                   EVAL      WRcdind = '*STR'
      *
      ** Open workfile
      *
     C                   OPEN      ERTRCVPD
      *
      ** Read workfile
      *
     C                   READ      ERTRCVD0
     C                   DOW       NOT(%EOF)
      *
      ** Extract Record Type
      *
     C                   EVAL      WkVl02 = %SUBST(PVl02:1:6)
      *
     C                   SELECT
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      WRcdtyp =
     C                             Translate(WkVl02:%SUBST(F1WDTA:5:1))
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      WRcdtyp =
     C                             Translate(WkVl02:%SUBST(F1WDTA:1:1))
      *
     C                   ENDSL
      *
      ** Validate the record
      *
     C                   SELECT
      *
     C                   WHEN      WRcdtyp = 'A' AND WRcdind = '*STR'
     C                   EXSR      SRValA
     C                   EVAL      WRcdind = '*ANY'
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B' AND
     C                             WRcdtyp = 'B'AND
     C                             WRcdind = '*ANY' OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             WRcdtyp = 'C' AND
     C                             WRcdind = '*ANY'
     C                   EXSR      SRValB
      *
     C                   WHEN      WRcdtyp = 'E' AND WRcdind = '*ANY'
     C                   EXSR      SRValE
     C                   EVAL      WRcdind = '*END'
      *
     C                   OTHER
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     WRcdtyp       DBKEY
     C                   MOVE      WRcdind       DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
     C                   READ      ERTRCVD0
     C                   ENDDO
      *
      ** Close wORkfile
      *
     C                   CLOSE     ERTRCVPD
      *
      ** Update maintenance file
      *
     C                   UPDATE    ERTINFD0
      *
      ** File not found
      *
     C                   WHEN      WRtnCde = 1
      *
      ** Other error occured
      *
     C                   OTHER
     C                   MOVEL     'ER000113'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     WRtnCde       DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
     C                   READ      ERTINFD0
     C                   ENDDO
      *
      ** End the program
      *
     C                   CLOSE     ERTRSPL0
     C                   CLOSE     ERTINFL1
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValA - Validate 'A' record                                 *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRWrite                                              *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRValA        BEGSR
      *
      ** Move data to data structure of 'A' record
      *
     C                   SELECT
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      DSK24Ab = F1WDTA
     C                   EVAL      %SUBST(DSK24Ab:5) =
     C                             Translate(WkVl02:%SUBST(F1WDTA:5))
     C                   EVAL      R11DAT = %SUBST(WAbDat:7:2) + '/' +
     C                                      %SUBST(WAbDat:5:2) + '/' +
     C                                      %SUBST(WAbDat:1:4)
     C                   EVAL      R11TIM = %SUBST(WAbTim:1:2) + ':' +
     C                                      %SUBST(WAbTim:3:2) + ':' +
     C                                      %SUBST(WAbTim:5:2)
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      F1WDTA = Translate(WkVl02:F1WDTA)
     C                   RESET                   DSK24At
     C                   CLEAR                   WAtVIdA
     C                   CLEAR                   WAtFnrA
     C                   CLEAR                   WField
     C                   CLEAR                   Wz
     C                   CLEAR                   Wy
     C                   DO        F1WLEN        Wx
     C                   IF        %SUBST(F1WDTA:Wx:1) = '#' OR
     C                             %SUBST(F1WDTA:Wx:1) = X'0D'
     C                   ADD       1             Wz
      *
     C                   SELECT
      *
     C                   WHEN      Wz = 1 AND Wy > 0
     C                   EVAL      WAtRtp = %SUBST(WField:1:Wy)
      *
     C                   WHEN      Wz = 2 AND Wy > 0
     C                   EVALR     WAtVIdA = %SUBST(WField:1:Wy)
     C                   MOVE      WAtVIdA       WAtVId
      *
     C                   WHEN      Wz = 3 AND Wy > 0
     C                   EVAL      WAtBkN = %SUBST(WField:1:Wy)
      *
     C                   WHEN      Wz = 4 AND Wy > 0
     C                   EVAL      Wk03A  = %SUBST(WField:1:Wy)
      *
     C                   WHEN      Wz = 5 AND Wy > 0
     C                   EVAL      WAtDaT = %SUBST(WField:1:Wy)
      *
     C                   WHEN      Wz = 6 AND Wy > 0
     C                   EVAL      WAtTim = %SUBST(WField:1:Wy)
      *
     C                   WHEN      Wz = 7 AND Wy > 0
     C                   EVALR     WAtFnrA = %SUBST(WField:1:Wy)
     C                   MOVE      WAtFnrA       WAtFnr
      *
     C                   WHEN      Wz = 8 AND Wy > 0
     C                   EVAL      WAtFtp = %SUBST(WField:1:Wy)
      *
     C                   OTHER
     C                   LEAVE
      *
     C                   ENDSL
     C                   CLEAR                   Wy
     C                   ELSE
     C                   ADD       1             Wy
     C                   EVAL      %SUBST(WField:Wy:1)
     C                             = %SUBST(F1WDTA:Wx:1)
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      WAtLid = %SUBST(WField:1:Wy)
     C                   EVAL      R11DAT = %SUBST(WAtDaT:7:2) + '/' +
     C                                      %SUBST(WAtDaT:5:2) + '/' +
     C                                      %SUBST(WAtDaT:1:4)
      *
     C                   EVAL      R11TIM = %SUBST(WAtTim:1:2) + ':' +
     C                                      %SUBST(WAtTim:3:2) + ':' +
     C                                      %SUBST(WAtTim:5:2)
     C                   ENDSL
      *
      ** Check Verplichteten-ID
      *
     C                   EVAL      WKvl04 = %SUBST(PVL04:1:6)
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WAbVId <> %DEC(WKvl04:6:0) OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             WAtVId <> %DEC(WKvl04:6:0)
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     'VID    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check Betreiber Kennung
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C**********                   WAbBkN <> %SUBST(PVl05:1:4) OR                           BUG26268
     C                             WAbBkN <> %SUBST(PVl05:1:11) OR                          BUG26268
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C**********                   WAtBkN <> %SUBST(PVl05:1:4)                              BUG26268
     C                             WAtBkN <> %SUBST(PVl05:1:11)                             BUG26268
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     'BKN    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check Version
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C**********                   WAbVer <> %SUBST(PVl03:1:6) OR                           BUG26268
     C                             WAbVer <> %SUBST(PVl03:1:8) OR                           BUG26268
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C**********                   WAbVer <> %SUBST(PVl03:1:6)                              BUG26268
     C                             WAbVer <> %SUBST(PVl03:1:8)                              BUG26268
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     'VER    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check file number
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WAbFnr <> F10FNR OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             WAtFnr <> F10FNR
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     'FNR    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check file type
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WAbFtp <> 'IB' OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             WAtFtp <> 'BD'
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     'FTP    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check function type
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WAbUtp <> F10UTP
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     'UTP    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check file name
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WAbFnm <> WFnm
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '008'         DBASE
     C                   MOVEL     'FNM    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise number of 'B' records to zero
      *
     C                   CLEAR                   WNbrRcd
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValB - Validate 'B' record                                 *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRWrite                                              *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRValB        BEGSR
      *
      ** Move data to data structure of 'B' record
      *
     C                   SELECT
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      DSK24Bb = F1WDTA
     C                   EVAL      %SUBST(DSK24Bb:5:4) =
     C                             Translate(WkVl02:%SUBST(F1WDTA:5:4))
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      F1WDTA = Translate(WKVl02:F1WDTA)
     C                   RESET                   DSK24Ct
     C                   CLEAR                   WCtEclA
     C                   CLEAR                   WCtEtpA
     C                   CLEAR                   WField
     C                   CLEAR                   Wz
     C                   CLEAR                   Wy
     C                   DO        F1WLEN        Wx
     C                   IF        %SUBST(F1WDTA:Wx:1) = '#' OR
     C                             %SUBST(F1WDTA:Wx:1) = X'0D'
     C                   ADD       1             Wz
     C                   SELECT
     C                   WHEN      Wz = 1 AND Wy > 0
     C                   EVAL      WCtRtp = %SUBST(WField:1:Wy)
     C                   WHEN      Wz = 2 AND Wy > 0
     C                   EVALR     WCtEclA = %SUBST(WField:1:Wy)
     C                   MOVE      WCtEclA       WCtEcl
     C                   WHEN      Wz = 3 AND Wy > 0
     C                   EVALR     WCtEtpA = %SUBST(WField:1:Wy)
     C                   MOVE      WCtEtpA       WCtEtp
     C                   LEAVE
     C                   ENDSL
     C                   CLEAR                   Wy
     C                   ELSE
     C                   ADD       1             Wy
     C                   EVAL      %SUBST(WField:Wy:1) =
     C                             %SUBST(F1WDTA:Wx:1)
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      WCtDta = %SUBST(F1WDTA:Wx+1)
     C                   ENDSL
      *
      ** Reset fields
      *
     C                   CLEAR                   F11ACC
     C                   CLEAR                   F11REF
      *
      ** Extract C-Record from response data, if available
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WBbEcl = 2 OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             WCtEcl = 92
      *
      ** Set record position to begin of data
      *
     C                   RESET                   WRcdPos
      *
      ** Offset to begin of entities of the user space that holds the
      ** file field info
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
      **  Read the user space
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    PUsrSpc
     C                   PARM                    PStrPos
     C                   PARM                    PLenDta
     C                   PARM                    PFldList
      *
      ** Extract data of a variable length field
      *
     C                   IF        WFldVarInd = '1'
      *
     C                   SELECT
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      WBinA = %SUBST(WBbDta:WRcdPos:2)
     C                   EVAL      WRcdPos = WRcdPos + 2
      *
     C                   IF        WBin2 > 0
     C                   EVAL      WFldDta = Translate(WkVl02:
     C                             %SUBST(WBbDta:WRcdPos:WBin2))
     C                   EVAL      %SUBST(WBbDta:WRcdPos:WBin2) =
     C                             WFldDta
     C                   EVAL      WRcdPos = WRcdPos + WBin2
     C                   ENDIF
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   CLEAR                   WFldDta
     C                   CLEAR                   Wy
     C                   DO        WFldLen       Wx
      *
     C                   IF        %SUBST(WCtDta:WRcdPos:1) = '#' OR
     C                             %SUBST(WCtDta:WRcdPos:1) = X'0D'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             Wy
     C                   EVAL      %SUBST(WFldDta:Wy:1)
     C                             = %SUBST(WCtDta:WRcdPos:1)
     C                   EVAL      WRcdPos = WRcdPos + 1
     C                   ENDDO
      *
     C                   EVAL      WRcdPos = WRcdPos + 1
     C                   ENDSL
      *
      ** Extract data of a static length field
      *
     C                   ELSE
     C                   SELECT
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      WFldDta = Translate(WkVl02 :
     C                             %SUBST(WBbDta:WRcdPos:WFldLen))
     C                   EVAL      %SUBST(WBbDta:WRcdPos:WFldLen) =
     C                             WFldDta
     C                   EVAL      WRcdPos = WRcdPos + WFldLen
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      WFldDta =
     C                             %SUBST(WCtDta:WRcdPos:WFldLen)
     C                   EVAL      WRcdPos = WRcdPos + WFldLen + 1
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** Select field
      *
     C                   SELECT
      *
     C                   WHEN      WFldNam = 'F1CACC'
     C                   EVAL      F11ACC = WFldDta
      *
     C                   WHEN      WFldNam = 'F1CREF'
     C                   EVAL      F11REF = WFldDta
      *
     C                   ENDSL
      *
      ** Next Offset
      *
     C                   EVAL      PStrPos = PStrPos+ WSizEnt
     C                   ENDDO
      *
      ** Flag account record as not executed (error)
      *
     C                   OPEN      ERACEXL2
     C     KLerac        CHAIN     ERACEXD0
      *
     C                   IF        %FOUND
     C                   EVAL      F12SNT = 'E'
     C                   UPDATE    ERACEXD0
     C                   ENDIF
      *
     C                   CLOSE     ERACEXL2
     C                   ENDIF
      *
      ** Flag ALL account records as not executed (error)
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             (WBbEcl = 1 OR WBbEcl = 4) OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             (WCtEcl = 91 OR WCtEcl = 93)
     C                   OPEN      ERACEXL2
     C     F10FNR        SETLL     ERACEXL2
     C     F10FNR        READE     ERACEXD0
      *
     C                   DOW       NOT(%EOF)
     C                   EVAL      F12SNT = 'E'
     C                   UPDATE    ERACEXD0
     C     F10FNR        READE     ERACEXD0
     C                   ENDDO
      *
     C                   CLOSE     ERACEXL2
     C                   ENDIF
      *
      ** Set fields and write detail record
      *
     C                   CLEAR                   F11DTA
     C                   EVAL      F11FNR = F10FNR
     C                   SELECT
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      F11ECL = WBbEcl
     C                   EVAL      F11ETP = WBbEtp
      *
     C                   IF        WBbDtl > 0
     C                   EVAL      F11DTA = %SUBST(WBbDta:1:WBbDtl)
     C                   ENDIF
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      F11ECL = WCtEcl
     C                   MOVE      WCtEtp        F11ETP
     C                   EVAL      F11DTA = WCtDta
      *
     C                   ENDSL
      *
     C                   WRITE     ERTRSPD0
      *
      ** Set status
      *
     C                   IF        F10STS <> 'E'
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             F11ECL = 0 OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             F11ECL = 90
     C                   EVAL      F10STS = 'X'
     C                   ELSE
     C                   EVAL      F10STS = 'E'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write detail record to report
      *
     C                   EVAL      R11ECL = F11ECL
     C                   EVAL      R11ETP = F11ETP
     C                   MOVEL     F11ECL        WEcde
     C                   MOVE      F11ETP        WEcde
     C                   EVAL      PZaMsId = 'XXE' + WEcde
     C                   EVAL      PZAMsda = F11ACC + F11REF
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    P0Rtn
     C                   PARM                    PZaMsId
     C                   PARM                    PZaMsgF
     C                   PARM                    PZAMsda
     C     R11DSC        PARM                    PZaMstx
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             F11ECL <> 0 OR
     C                             %SUBST(PVl05:1:1) = 'T' AND
     C                             F11ECL <> 90
     C                   EVAL      *IN31 = *ON
     C                   ELSE
     C                   EVAL      *IN31 = *OFF
     C                   ENDIF
      *
     C                   EXSR      SRWrite
      *
      ** Count this 'B' record
      *
     C                   EVAL      WNbrRcd = WNbrRcd + 1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValE - Validate 'E' record                                 *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRWrite                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValE        BEGSR
      *
      ** Move data to data structure of 'E' record
      *
     C                   SELECT
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'B'
     C                   EVAL      DSK24Eb = F1WDTA
     C                   EVAL      %SUBST(DSK24Eb:5:1) =
     C                             Translate(WkVl02:%SUBST(F1WDTA:5:1))
     C                   EVAL      %SUBST(DSK24Eb:10) =
     C                             Translate(WKVl02:%SUBST(F1WDTA:10))
      *
     C                   WHEN      %SUBST(PVl05:1:1) = 'T'
     C                   EVAL      F1WDTA = Translate(WkVl02:F1WDTA)
     C                   RESET                   DSK24Et
     C                   CLEAR                   WEtNrcA
     C                   CLEAR                   WEtNrnA
     C                   CLEAR                   WEtNruA
     C                   CLEAR                   WEtNreA
     C                   CLEAR                   WField
     C                   CLEAR                   Wz
     C                   CLEAR                   Wy
      *
     C                   DO        F1WLEN        Wx
      *
     C                   IF        %SUBST(F1WDTA:Wx:1) = '#' OR
     C                             %SUBST(F1WDTA:Wx:1) = X'0D'
     C                   ADD       1             Wz
     C                   SELECT
      *
     C                   WHEN      Wz = 1 AND Wy > 0
     C                   EVAL      WEtRtp = %SUBST(WField:1:Wy)
      *
     C                   WHEN      Wz = 2 AND Wy > 0
     C                   EVALR     WEtNrcA = %SUBST(WField:1:Wy)
     C                   MOVE      WEtNrcA       WEtNrc
      *
     C                   WHEN      Wz = 3 AND Wy > 0
     C                   EVALR     WEtNrnA = %SUBST(WField:1:Wy)
     C                   MOVE      WEtNrnA       WEtNrn
      *
     C                   WHEN      Wz = 4 AND Wy > 0
     C                   EVALR     WEtNruA = %SUBST(WField:1:Wy)
     C                   MOVE      WEtNruA       WEtNru
      *
     C                   OTHER
     C                   LEAVE
      *
     C                   ENDSL
     C                   CLEAR                   Wy
     C                   ELSE
     C                   ADD       1             Wy
     C                   EVAL      %SUBST(WField:Wy:1)
     C                             = %SUBST(F1WDTA:Wx:1)
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVALR     WEtNreA = %SUBST(WField:1:Wy)
     C                   MOVE      WEtNreA       WEtNre
      *
     C                   ENDSL
      *
      ** Check number of 'B' records
      *
     C                   IF        %SUBST(PVl05:1:1) = 'B' AND
     C                             WEbNrc <> WNbrRcd
     C                   MOVEL     'ERTRCVPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     'NRC    '     DBKEY
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Write trailer to report
      *
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRWrite
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record in Printer file                       *
      *                                                               *
      *  Called by : MAIN Processing,SRValA,SRValB,SRValE             *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
      ** Write header
      *
     C                   IF        *IN71 = *ON
     C                   WRITE     ER00011R0
     C                   ENDIF
      *
      ** Reset indicator for writing a Header
      *
     C                   EVAL      *IN71 = *OFF
      *
      ** Print Error
      *
     C                   IF        *IN38 = *ON
     C                   WRITE     ER000110R2
     C                   ENDIF
      *
      ** Print End of Report
      *
     C                   IF        *IN39 = *ON
     C                   WRITE     ER000110R3
      *
      ** Print Detail
      *
     C                   ELSE
     C                   WRITE     ER000110R1
     C                   ENDIF
      *
      ** Reset indicator for writing a End of Report
      *
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialization routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
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
     C                   PARM      *BLANKS       POp06
     C                   PARM                    PVl06
     C                   PARM      *BLANKS       POp07
     C                   PARM                    PVl07
     C                   PARM      *BLANKS       POp08
     C                   PARM                    PVl08
     C                   PARM      *BLANKS       POp09
     C                   PARM                    PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM                    PVl10
      *
     C                   IF        PRtCd <> *BLANKS
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
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ER000110'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Messages file
      *
     C                   MOVEL     'STUSRMSG'    PZaMsgF
      *
      ** Get info from the SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Create the user space for the File Field information
      *
     C                   EVAL      PUsrSpcTxt = 'User space for' +
     C                             'program ER000110'
      *
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
     C                   EVAL      %SUBST(WFilNam:6:1) =
     C                             %SUBST(PVl05:1:1)
      *
     C                   CALL      'QUSLFLD'
     C                   PARM                    PUsrSpc
     C                   PARM      'FLDL0100'    PFormat
     C                   PARM                    PFile
     C                   PARM      'ERCRCDD0'    PRcdFmt
     C                   PARM      '0'           POvrPrc
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
      ** Open files
      *
     C                   OPEN      ERTINFL1
     C                   OPEN      ERTRSPL0
      *
      ** Set unsigned integer value for C-procedure
      *
     C                   EVAL      Pchr = %SUBST(PVl05:1:1)
      *
      ** Defining Keylists
      *
     C     KLerac        KLIST
     C                   KFLD                    F10FNR
     C                   KFLD                    F11ACC
     C                   KFLD                    F11REF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module AND procedure names fOR Db errOR processing.
      ** The following /COPY sets these values, AND also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Translate - Procedure for EBCDIC <-> ASCII translation       *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     P Translate       B
     D Translate       PI         32760A   OPDESC
     D  PTransFrom                    6A   CONST
     D  PString                   32760A   CONST OPTIONS(*VARSIZE)
      *
      ** S Translate ASCII to EBCDIC, if requested
      ** Prototype for CEEDOD (Retrieve operational descriptOR)
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
     D  WRetString     S          32760A   INZ(' ')
      *
      ** Parametrs for Calling QDCXLATE
      *
     D  PLengthOfData  S              5P 0
     D  PConversnData  S           2000A
     D  PSBCSTbleName  S             10A
      *
      ** Use the operational descriptor to determine the length of the
      ** parameter that were passed
      *
     C                   CALLP     CEEDOD(2:PDescType:PDataType:
     C                             PDescInfo1:PDescInfo2:PLength:*OMIT)
      *
      ** Translate
      *
     C                   EVAL      PSBCSTbleName = 'ER1' +
     C                                             %TRIM(PTransFrom)
     C                   CALL      'QDCXLATE'                           9898
     C                   PARM      PLength       PLengthOfData
     C     WRetString    PARM      PString       PConversnData
     C                   PARM                    PSBCSTbleName
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
(c) Misys International Banking Systems Ltd. 2008
