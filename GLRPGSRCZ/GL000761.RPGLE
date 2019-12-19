     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Reports Management')                          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000761 - Midas GL Reports Management (CRS)                 *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054905           Date 04Dec19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD040875           Date 26Aug16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054905 - Change Message Ref Id format                      *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD040875 - Message Ref ID for another branch with different  *
      *             Country Code (Country of Domicile) is incorrect   *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FGL000761DFCF   E             WORKSTN
     F                                     SFILE(GLCRMGS1:WWRRN)

      ** Report Management by message reference ID
     FGLCRMGL3  IF   E           K DISK    INFSR(*PSSR)

      ** Report management by Report Reference ID
     FGLCRMGL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A_)
     F                                     RENAME(GLCRMGD0:GLCRMGD1)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,STDDECLARE
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,FVAL_ARRAY
     D/COPY ZACPYSRC,APICTLARR
     D/COPY ZACPYSRC,MSGHNDDCL

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** EXTERNAL DS FOR Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Country  Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for User details
     D SDUSER        E DS                  EXTNAME(MUSER) PREFIX(Q)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Array for GL000767
     D ArAcctNumbr     S             83A   DIM(50)
     D ArExcCust       S            341A   DIM(50)
     D ArIncCust       S            278A   DIM(50)

      ** Parameter array for Customer exclusion for pool
     D ArExclDet       S            266A   DIM(50)

     D WCmdArr         S            100    DIM(1) CTDATA PERRCD(1)

      ** Override Database Table
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D ZMUSER          DS            17
     D  DBRN                  11     13

     D GLFATCA         DS
     D  WFATCAD                1      1

     D KKCDYR          S              4
     D KKRBRC          S              3
     D KKRCTR          S              2
     D***KKMSID          S             21                                                   MD054905
     D KKMSID          S             29                                                     MD054905
     D KKSTAT          S              4

     D PActMode        S              1A
     D***PMsgRId         S             21A                                                  MD054905
     D PMsgRId         S             29A                                                    MD054905
     D PDDocTp         S              7A
     D PDDocRf         S             30A
     D PDCorRf         S             30A
     D PDRtyp          S             18A
     D PDRyer          S              4A
     D PFuncKey        S              3A

     D PActn           S              1A
     D***PMsId**         S             21A                                                  MD054905
     D PMsId           S             29A                                                    MD054905
     D PYear           S              4A
     D PBrcd           S              3A
     D PCtry           S              2A
     D PStat           S              4A
     D PRType          S             18A
     D PWMsg           S             50A
     D PRpDocRef       S             35A
     D PCmd            S            200A
     D PCmdLen         S             15  5
     D PCancel         S              1A
     D PCUST           S             10A
     D PCNST           S              7A
     D PRCancel        S              1A
     D PBrcda          S              3A
     D PCtrya          S              2A
     D PStts           S              4A
     D PComm           S             50A
     D PCadd           S              1A

     D WWGGCO          S             12
     D Wwrong          S              1
     D WWCDYR          S              4S 0
     D WERROR          S              1
     D WInclude        S              1
     D WWZBR           S              3
     D WWERR           S              1  0
     D PRTCD           S              7
     D POPTN           S              7
     D X               S              4S 0
     D DDTMESTMP       S             26
     D START           S              3P 0
     D LENGTH1         S              3P 0
     D LENGTH2         S              3P 0
     D TRANSLATE       S              1A
     D TRIM            S              1A
     D WILD            S              1A
     D RESULT          S              3P 0
     D ZACTN           S              1
     D ZBR             S              3
     D WWEOF           S              1
     D Wread           S              1
     D WIN30           S              1
     D WWTMST          S             26Z
     D W1TMST          S             26A
     D WWRRn           S              5S 0
     D WWRRb           S              5S 0
     D WwCNT           S              3S 0
     D WRTCd           S              7
     D PUSRP           S             10
     D WKDRf1          S             16
     D DECIMALs        S              1S 0
     D DIGITs          S              2S 0
     D WKDRF1n         S             16
     D WZMsgFile       S             10
     D WZMsgID         S             10
     D WFound          S              1
     D PExitInd        S              1
     D WWDTTM          S             26
     D WMsgLen         S             15P 5 INZ(50)
     D WWYEAR          S              4S 0
     D WYr             S              2
     D WWYRCC          S              4
     D DayOut8         S              8S 0
     D WNAcrDt         S              8
     D DateIn5         S              5P 0
     D WCurYear        S              4A
     D WSysYear        S              4A
     D PYrno           S              4
     D PEnd            S              1
     D PBuild          S              1
     D PYrno2          S              4A
     D WcYear          S              4
     D Wpos            S              1S 0
     D WWBRCH          S              3

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
     D/COPY ZACPYSRC,MSGHNDDSP1
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   EXSR      SrINIT

     C                   IF        PCadd = 'Y'
     C                   EXSR      SrProcess
     C                   ENDIF

      ** Clear program message queue

     C                   CALL      'ZA0250'

     C                   DOW       *INKC = '0'

      ** Build Sub-file

     C                   EXSR      SrBLDSFL


      ** Read Subfile Record

     C                   IF        *INKE = '0'
     C                   EXSR      SrRDSFLR
     C                   ENDIF

     C                   ENDDO

     C                   IF        *INKC = '1'
     C                   EVAL      PEND = 'Y'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL - Subroutine to build subfile                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrChautN, SrRDCUST, SrCreate, ZA0250                   *
      *                                                               *
      *****************************************************************

     C     SrBLDSFL      BEGSR

     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDMSGR = *BLANKS
     C                   EVAL      DDRPTY = *BLANKS
     C                   EVAL      DDSTAT = *BLANKS
     C                   EVAL      DDDTTM = *BLANKS
     C                   EVAL      DDUSNM = *BLANKS
     C                   EVAL      DDRBR1 = *BLANKS
     C                   EVAL      DDCTR1 = *BLANKS
     C                   EVAL      DDSTT1 = *BLANKS
     C                   EVAL      DDWAR1 = *BLANKS
     C                   EVAL      Wweof = 'N'

     C                   IF        Wwrong = 'Y'
     C                             AND *INKE = '0'
     C                   EVAL      *In90 = *On

      ** Skip the rebuild subfile part

     C                   GOTO      DSPL1
     C                   ENDIF

      **  Initialise subfile relative record number.

     C                   Z-ADD     0             WWRRn

      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.

     C                   MOVE      '1'           *IN97
     C                   WRITE     GLCRMGS0
     C                   MOVE      '0'           *IN97

     C                   EVAL      KKMSID = D1MSGR
     C                   EVAL      WFound = 'N'

     C                   Z-ADD     0             WwCNT
     C                   IF        D1MSGR = *BLANKS
     C     *HIVAL        SETGT     GLCRMGL3
     C                   ELSE
     C     KKMSID        SETGT     GLCRMGL3
     C                   ENDIF

      **  Read a Valid report

     C                   EXSR      SrRDCUST

      **  set up message 'no data to display'

     C                   MOVE      *OFF          *IN80
     C                   IF        WFound = 'N'
     C                   MOVE      *ON           *IN80
     C                   ENDIF

      **  Set on ROLLUP indicator to drive initial loop.

     C                   MOVE      '1'           *IN98

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 is input.

     C     *IN98         DOWEQ     '1'

      **  Initialise count of records written to subfile page.

     C                   Z-ADD     0             WwCNT
     C                   IF        *IN95 = '0'
     C                   EVAL      WWRRN = WWRRB
     C                   ENDIF

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C                   DOW       NOT %EOF(GLCRMGL3)
     C                             AND WwCNT < 14

      **  Increment the subfile record no. and records written fields.

     C                   ADD       1             WWRRN
     C                   ADD       1             WwCNT

     C                   Z-ADD     WwRRN         DDSFRN
     C                   EVAL      *In95 = *OFF

     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDMSGR = GGMSID
     C                   EVAL      DDRPTY = GGRTYP
     C                   EVAL      DDSTAT = GGSTAT
     C                   MOVEL     GGDTTM        WWDTTM
     C                   EVAL      DDDTTM = WWDTTM
     C                   EVAL      DDUSNM = GGUSER
     C                   EVAL      DDAMID = GGAMID
     C                   EVAL      DDRBR1 = GGRBRC
     C                   EVAL      DDCTR1 = GGRCTR
     C                   EVAL      DDSTT1 = GGSTAT

     C                   WRITE     GLCRMGS1

      **  Read a valid report

     C                   EXSR      SrRDCUST
     C                   ENDDO

      **  Set up footer toggle text and write the footer

     C                   WRITE     GLCRMGF1

     C     Dspl1         TAG

      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record

     C                   IF        WFOUND = 'N'
     C                   MOVE      '1'           *IN97
     C                   WRITE     GLCRMGS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             WWRRN
     C                   Z-ADD     1             DDSFRN

      **  write to the subfile with non-display set on

     C                   MOVE      '1'           *IN93
     C                   WRITE     GLCRMGS1
     C                   MOVE      '0'           *IN93
     C                   WRITE     GLCRMGS0
     c                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     GLCRMGS0
     C                   ENDIF

      **  Write the message subfile

     C                   WRITE     GLCRMGM0

     C                   IF        *IN95 = '0'
     C                   EVAL      WWRRB = WWRRN
     C                   ENDIF
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      GLCRMGS0                               99

     C                   CALL      'ZA0250'
     C                   EVAL      *In95 = *OFF

      **  If F5, refresh screen
     C                   IF        *INKE = '1'
     C                   EVAL      D1MSGR = *Blanks
     C                   EVAL      D1RPTY = *Blanks
     C                   EVAL      D1STAT = *Blanks
     C                   EVAL      D1DTTM = *Blanks
     C                   EVAL      D1USNM = *Blanks
     C                   EVAL      D1YEAR = WSysYear
     C                   EVAL      WWRRB = 0
     C                   IF        WCurYear <> D1YEAR
     C                   EVAL      PYrno = D1YEAR
     C                   EVAL      PYrno2 = *Blanks
     C                   ELSE
     C                   EVAL      PYrno = *Blanks
     C                   MOVE      D1YEAR        PYrno2
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      **  If F9, go to add record screen
     C                   IF        *INKI = '1'
     C                   EVAL      WWERR = 0
     C                   IF        BJSBRC <> *BLANKS
     C                   EVAL      ZACTN = 'I'
     C                   EXSR      SRChautN
     C                   IF        WWERR = 1
     C                             OR WWERR = 2
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        WWERR = 0
     C                   EXSR      SrCreate
     C                   ENDIF
     C                   ENDIF

      **  If F3, bypass further processing.
     C                   IF        *INKC = '1'
     C                   EVAL      PEND = 'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDSFLR - Subroutine to read subfile record                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRErrMsg, ZALIGN                                       *
      *                                                               *
      *****************************************************************

     C     SrRDSFLR      BEGSR

     C                   EVAL      Wwrong = 'N'
     C                   EVAL      *IN20 = '0'
     C                   EVAL      Wpos = %SCAN(' ':D1YEAR)
     C                   IF        Wpos <> 0
     C                   EVAL      Wwrong = 'Y'
     C                   MOVE      *ON           *IN20
     C                   MOVEL     'USS0526'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ELSE

      ** Check numeric
     C                   CALL      'ZALIGN'
     C                   PARM                    WRTCd
     C                   PARM      D1YEAR        WKDRf1
     C                   PARM      *ZERO         DECIMALs
     C                   PARM      4             DIGITs
     C                   PARM      *BLANK        WKDRF1n

     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      Wwrong = 'Y'
     C                   MOVE      *ON           *IN20
     C                   MOVEL     'USS0526'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg

     C                   ELSE
     C                   IF        WWYRCC <> D1YEAR

     C                   EVAL      WWYRCC = D1YEAR
     C                   EVAL      PCmd    = WCmdArr(1)
     C                   Z-ADD     100           PCmdLen

     C                   IF        WCurYear = D1YEAR
     C                   EVAL      WYR = *Blanks

     C                   ELSE
     C                   MOVE      D1YEAR        WYR

     C                   ENDIF

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV3
     C                   PARM                    WMsgLen
     C                   CALL      'GL000760'
     C                   PARM      *Blanks       PRtcd

     C                   IF        WCurYear <> D1YEAR
     C                   EVAL      PYrno = D1YEAR
     C                   EVAL      PYrno2 = *Blanks
     C                   ELSE
     C                   EVAL      PYrno = *Blanks
     C                   MOVE      D1YEAR        PYrno2
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN

     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   EVAL      X = 1
     C                   EVAL      *IN99 = '0'

     C                   IF        *IN20 = '0'

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C     *IN99         DOUEQ     '1'

     C                   READC     GLCRMGS1                               99

      ** Validate action code

     C                   IF        *IN99 = '0'
     C                             AND DDACTN <> ' '

     C                   IF        DDACTN = 'C'
     C                             OR DDACTN = 'D'
     C                             OR DDACTN = 'E'
     C                             OR DDACTN = 'I'
     C                             OR DDACTN = 'O'
     C                             OR DDACTN = 'P'
     C                             OR DDACTN = 'R'
     C                             OR DDACTN = 'X'
     C                             OR DDACTN = ' '
     C                   EVAL      *In95 = *Off
     C                   EVAL      WWZBR = DDRBR1
     C                   IF        DDACTN = 'I'
     C                   EVAL      ZACTN = 'O'
     C                   ELSE
     C                   EVAL      ZACTN = DDACTN
     C                   ENDIF
     C                   EXSR      SRChautN
     C                   IF        WWERR = 1
     C                             OR WWERR = 2
     C                   EVAL      *In95 = *On
     C                   ENDIF

     C                   IF        DDRPTY = 'DRAFT NEW'
     C                             AND (DDACTN <> 'E'
     C                             AND DDACTN <> 'P'
     C                             AND DDACTN <> 'D'
     C                             AND DDACTN <> 'R'
     C                             AND DDACTN <> 'I'
     C                             AND DDACTN <> 'O'
     C                             AND DDACTN <> 'X')
     C                   EVAL      *In95 = *On
     C                   IF        DDACTN = 'C'
     C                   MOVEL     'USS0562'     WZMsgID
     C                   ELSE
     C                   MOVEL     'USS0686'     WZMsgID
     C                   ENDIF
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        DDRPTY = 'DRAFT NEW'
     C                             AND DDACTN = 'X'
     C                             AND DDAMID <> *BLANKS
     C                   EVAL      *In95 = *On
     C                   MOVEL     'USS0564'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        DDRPTY = 'APPROVED NEW'
     C                             AND (DDACTN <> 'E'
     C                             AND DDACTN <> 'C'
     C                             AND DDACTN <> 'P'
     C                             AND DDACTN <> 'I'
     C                             AND DDACTN <> 'O')
     C                   EVAL      *In95 = *On
     C                   SELECT
     C                   WHEN      DDACTN = 'R'
     C                   MOVEL     'USS0532'     WZMsgID
     C                   WHEN      DDACTN = 'X'
     C                   MOVEL     'USS0561'     WZMsgID
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     'USS0567'     WZMsgID
     C                   OTHER
     C                   MOVEL     'USS0528'     WZMsgID
     C                   ENDSL
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        (DDRPTY = 'DRAFT AMEND'
     C                             OR DDRPTY = 'DRAFT CORRECTED'
     C                             OR DDRPTY = 'DRAFT DELETE')
     C                             AND (DDACTN <> 'E'
     C                             AND DDACTN <> 'P'
     C                             AND DDACTN <> 'D'
     C                             AND DDACTN <> 'X')
     C                   EVAL      *In95 = *On
     C                   IF        DDACTN = 'C'
     C                   MOVEL     'USS0562'     WZMsgID
     C                   ELSE
     C                   MOVEL     'USS0686'     WZMsgID
     C                   ENDIF
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        (DDRPTY = 'DRAFT AMEND'
     C                             OR DDRPTY = 'DRAFT CORRECTED'
     C                             OR DDRPTY = 'DRAFT DELETE')
     C                             AND DDACTN = 'X'
     C                             AND DDAMID <> *BLANKS
     C                   EVAL      *In95 = *On
     C                   MOVEL     'USS0564'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        (DDRPTY = 'DRAFT NEW'
     C                             OR DDRPTY = 'DRAFT AMEND'
     C                             OR DDRPTY = 'DRAFT CORRECTED'
     C                             OR DDRPTY = 'DRAFT DELETE')
     C                             AND DDACTN = 'X'
     C                             AND DDUSNM = PSUSER
     C                   EVAL      *In95 = *On
     C                   MOVEL     'USS0566'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        (DDRPTY = 'APPROVED AMEND'
     C                             OR DDRPTY = 'APPROVED CORRECTED'
     C                             OR DDRPTY = 'APPROVED DELETE')
     C                             AND (DDACTN <> 'E'
     C                             AND DDACTN <> 'P')
     C                   EVAL      *In95 = *On
     C                   SELECT
     C                   WHEN      DDACTN = 'R'
     C                   MOVEL     'USS0532'     WZMsgID
     C                   WHEN      DDACTN = 'X'
     C                   MOVEL     'USS0561'     WZMsgID
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     'USS0567'     WZMsgID
     C                   OTHER
     C                   MOVEL     'USS0528'     WZMsgID
     C                   ENDSL

     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        *In95 = *On
     C                   IF        Wwrong = 'N'
     C                   MOVE      WWRRN         DDSFRN
     C     WWRRN         CHAIN     GLCRMGS1                           99
     C                   IF        *In99 = *Off
     C                   UPDATE    GLCRMGS1
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      Wwrong = 'Y'

     C                   ELSE

     C                   IF        DDACTN = 'P'
     C                   CALL      'GL000762P'
     C                   PARM      DDMSGR        PMsgRId
     C                   PARM      DDRPTY        PDRtyp
     C                   PARM      D1YEAR        PDRyer
     C                   ELSE

     C                   EVAL      PRCancel = 'Y'
     C                   EVAL      DDWARN = *BLANKS

     C                   DOW       PRCancel = 'Y'


     C                   IF        DDACTN = 'R'
     C                   EXSR      SrRScrn
     C                   ENDIF
     C                   EVAL      PRCancel = ' '

     C                   IF        DDACTN <> 'R'
     C                             OR (DDACTN = 'R'
     C                             AND *INKL = '0')
     C                   CALL      'GL000762'
     C                   PARM      DDACTN        PActMode
     C                   PARM      DDMSGR        PMsgRId
     C                   PARM      DDRPTY        PDRtyp
     C                   PARM      D1YEAR        PDRyer
     C                   PARM      *Blanks       ArExcCust
     C                   PARM      *Blanks       ArAcctNumbr
     C                   PARM      *Blanks       ArIncCust
     C                   PARM      *Blanks       PExitInd
     C                   PARM      *Blanks       PCancel
     C                   PARM      *Blanks       PRpDocRef
     C                   PARM      *Blanks       PRCancel
     C                   ENDIF
     C                   ENDDO

     C                   IF        PExitInd = 'Y'
     C                   EVAL      PEND = 'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   IF        PExitInd <> 'Y'
     C                             AND PCancel <> 'Y'
     C                   IF        ArAcctNumbr(1) <> *Blanks
     C                             OR PRpDocRef <> *Blanks
     C                             OR ArExcCust(1) <> *Blanks
     C                             OR ArIncCust(1) <> *Blanks
     C                             OR DDACTN = 'D'
     C                             OR DDACTN = 'R'
     C                             OR DDACTN = 'X'
     C                   EVAL      WInclude = 'N'
     C                   IF        DDACTN = 'I'
     C                   EVAL      WInclude = 'Y'
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    WMsgLen

     C                   ENDIF

     C                   IF        DDACTN = 'R'
     C                   EVAL      DDWAR1 = DDWARN
     C                   ENDIF

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV3
     C                   PARM                    WMsgLen

     C                   CALL      'GL000760'
     C                   PARM      *Blanks       PRtcd

     C                   CALL      'GL000767'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      DDACTN        PActn
     C                   PARM      DDMSGR        PMsId
     C                   PARM      D1YEAR        PYear
     C                   PARM      DDRBR1        PBrcd
     C                   PARM      DDCTR1        PCtry
     C                   PARM      DDSTT1        PStat
     C                   PARM      DDRPTY        PRType
     C                   PARM      DDWAR1        PWMsg
     C                   PARM                    PRpDocRef
     C                   PARM                    ArAcctNumbr
     C                   PARM                    ArExcCust
     C                   PARM                    ArIncCust

     C                   IF        WCurYear <> D1YEAR
     C                   CALL      'GLC000761B'
     C                   PARM                    D1YEAR
     C                   ENDIF

     C                   IF        WInclude = 'Y'
     C                   EVAL      WInclude = 'N'
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    WMsgLen

     C                   ENDIF

     C                   ELSE
     C                   MOVEL     'USS0531'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ELSE
     C                   EVAL      *In95 = *On
     C                   IF        Wwrong = 'N'
     C                   MOVE      WWRRN         DDSFRN
     C                   ENDIF
     C                   EVAL      Wwrong = 'Y'

     C     WWRRN         CHAIN     GLCRMGS1                           99
     C                   IF        *In99 = *Off
     C                   UPDATE    GLCRMGS1
     C                   MOVEL     'USS0686'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

     C                   IF        *IN95 = '0'
     C                   EVAL      WWRRB = 0
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDCUST - Subroutine to read report management records       *
      *                                                               *
      * Called by: SrBLDSFL                                           *
      *                                                               *
      * Calls: QCLSCAN                                                *
      *                                                               *
      *****************************************************************

     C     SrRDCUST      BEGSR

     C                   EVAL      Wread = 'N'
     C                   EVAL      Wweof = 'N'

     C                   READP     GLCRMGL3

     C                   IF        %EOF(GLCRMGL3)
     C                   EVAL      Wweof = 'Y'
     C                   ENDIF

     C                   DOU       %EOF(GLCRMGL3)
     C                             OR GGRYER <> *Blanks

     C                   IF        Wread = 'Y'
     C                   READP     GLCRMGL3
     C                   ENDIF

     C                   IF        D1RPTY <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    GGRTYP
     C                   PARM      18            Length1
     C                   PARM      1             Start
     C                   PARM                    D1RPTY
     C                   PARM      18            Length2
     C                   PARM      '1'           Translate
     C                   PARM      '1'           Trim
     C                   PARM      '?'           Wild
     C                   PARM                    Result

     C                   IF        Result < 1
     C                   MOVE      *BLANK        GGRYER
     C                   ENDIF
     C                   ENDIF

     C                   IF        D1STAT <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    GGSTAT
     C                   PARM      4             Length1
     C                   PARM      1             Start
     C                   PARM                    D1STAT
     C                   PARM      4             Length2
     C                   PARM      '1'           Translate
     C                   PARM      '1'           Trim
     C                   PARM      '?'           Wild
     C                   PARM                    Result

     C                   IF        Result < 1
     C                   MOVE      *BLANK        GGRYER
     C                   ENDIF
     C                   ENDIF

     C                   IF        D1DTTM <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    GGDTTM
     C                   PARM      13            Length1
     C                   PARM      1             Start
     C                   PARM                    D1DTTM
     C                   PARM      13            Length2
     C                   PARM      '1'           Translate
     C                   PARM      '1'           Trim
     C                   PARM      '?'           Wild
     C                   PARM                    Result

     C                   IF        Result < 1
     C                   MOVE      *BLANK        GGRYER
     C                   ENDIF
     C                   ENDIF

     C                   IF        D1USNM <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    GGUSER
     C                   PARM      10            Length1
     C                   PARM      1             Start
     C                   PARM                    D1USNM
     C                   PARM      10            Length2
     C                   PARM      '1'           Translate
     C                   PARM      '1'           Trim
     C                   PARM      '?'           Wild
     C                   PARM                    Result

     C                   IF        Result < 1
     C                   MOVE      *BLANK        GGRYER
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WRead = 'Y'
     C                   IF        Wweof <> 'Y'
     C                   EVAL      WFound = 'Y'
     C                   ENDIF

     C                   IF        WwCNT = 0
     C                             AND %EOF(GLCRMGL3)
     C                             AND GGRYER = *Blanks
     C                   EVAL      WFound = 'N'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit - Subroutine to initialize fields                      *
      *                                                               *
      * Called by: Main subroutine                                    *
      *                                                               *
      * Calls: ZAGENTMSTM                                             *
      *                                                               *
      *****************************************************************

     C     SrINIT        BEGSR

      ** Clear fields

     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      KKCDYR = *BLANKS
     C                   EVAL      KKRBRC = *BLANKS
     C                   EVAL      KKRCTR = *BLANKS
     C                   EVAL      KKMSID = *BLANKS
     C                   EVAL      W1TMST = *BLANKS
     C                   IF        PYrno <> *Blanks
     C                   MOVE      PYrno         WWYRCC
     C                   ENDIF
     C                   EVAL      PEND = ' '
     C                   EVAL      Pbuild = ' '
     C                   EVAL      WIN30 = *BLANKS
     C                   EVAL      Wwrong = 'N'

      ** Get timestamp.

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WWTMST

     C                   MOVE      WWTMST        W1TMST
     C                   IF        PYrno = *Blanks
     C                   EVAL      D1YEAR = WSysYear
     C                   ELSE
     C                   EVAL      D1YEAR = PYrno
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCreate - Subroutine to create report management             *
      *                                                               *
      * Called by: SrRDSFLR                                           *
      *                                                               *
      * Calls: AOUSERR0, ZA0250, SrValidate, ZAGENTMSTM               *
      *                                                               *
      *****************************************************************

     C     SrCreate      BEGSR

     C                   EVAL      WERROR = 'Y'
     C                   EVAL      DDCDYR = D1YEAR
     C                   EVAL      DDSTTS = 'LIVE'
     C                   EVAL      DDWARN = *BLANKS
     C                   EVAL      WIN30 = *BLANKS

     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       WRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PSUser        PUSRP
     C     SDUSER        PARM      SDUSER        DSSDY

     C                   IF        WRTCD <> *Blanks
     C                   EVAL      DDRBRC = *Blanks
     C                   ELSE
     C                   EVAL      DDRBRC = QDBRN
     C                   ENDIF

     C                   EVAL      DDCTRC = *Blanks
     C                   EVAL      WWBRCH = *Blanks
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DDRBRC
     C     SDBRCH        PARM      SDBRCH        DSFDY

     C                   IF        PRTCD = *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      A8BICN        PCUST
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DDCTRC = BBCOLC
     C                   EVAL      WWBRCH = BBCOLC
     C                   ENDIF
     C                   ENDIF

     C                   CALL      'ZA0250'

     C                   MOVEA     '0000000'     *IN(20)
     C                   MOVE      '0'           *IN30

     C                   DOW       *INKC = '0' AND
     C                             *INKL = '0' AND
     C                             WERROR = 'Y'

     C                   WRITE     GLCRMGS2
     C                   WRITE     GLCRMGF2

     C                   WRITE     GLCRMGM0
     C                   EXFMT     GLCRMGS2
     C                   CALL      'ZA0250'

     C                   MOVEA     '0000000'     *IN(20)

     C                   IF        *INKC = '0' AND
     C                             *INKE = '0' AND
     C                             *INKL = '0'
     C                   EVAL      WERROR = 'N'
     C                   EXSR      SrValidate

     C                   IF        WERROR = 'N'

     C                   EVAL      KKCDYR = DDCDYR
     C                   EVAL      KKRBRC = DDRBRC
     C                   EVAL      KKRCTR = DDCTRC
     C                   EVAL      KKSTAT = DDSTTS
     C                   MOVE      *IN30         WIN30

     C     KCRMG2        CHAIN     GLCRMGL2
     C                   IF        %FOUND(GLCRMGL2)
     C                   MOVE      *ON           *IN30
     C                   MOVEL     'USS0525'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

      ** Write record

     C                   IF        *IN30 = '0' OR
     C                             (*IN30 = '1' AND
     C                             WIN30 = '1')
     C                   EVAL      WIN30 = *BLANKS


     C                   EVAL      PBrcda = DDRBRC
     C                   EVAL      PCtrya = DDCTRC
     C                   EVAL      PStts = DDSTTS
     C                   EVAL      PComm = DDWARN
     C                   EVAL      PCAdd = 'Y'
     C                   IF        WCurYear <> DDCDYR
     C                   EVAL      PYrno = DDCDYR
     C                   EVAL      PYrno2 = *Blanks
     C                   ELSE
     C                   EVAL      PYrno = *Blanks
     C                   MOVE      DDCDYR        PYrno2
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN

     C                   ELSE
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   IF        *INKE = '1'
     C                   EVAL      DDCDYR = *BLANKS
     C                   EVAL      DDRBRC = QDBRN
     C                   EVAL      DDCTRC = WWBRCH
     C                   EVAL      DDSTTS = 'LIVE'
     C                   EVAL      DDWARN = *BLANKS

     C                   EVAL      KKCDYR = *BLANKS
     C                   EVAL      KKRBRC = *BLANKS
     C                   EVAL      KKRCTR = *BLANKS
     C                   EVAL      KKSTAT = *BLANKS
     C                   EVAL      WIN30 = *BLANKS

     C                   EVAL      *IN30 = '0'

     C                   CALL      'ZA0250'

     C                   ENDIF

     C                   IF        *INKL = '1'
     C                             AND *IN30 = '1'
     C                   EVAL      *INKL = '0'
     C                   EVAL      *IN30 = '0'
     C                   EVAL      WIN30 = *BLANKS
     C                   EVAL      WERROR = 'Y'

     C                   CALL      'ZA0250'

     C                   ENDIF

     C                   ENDDO

     C                   EVAL      KKCDYR = *BLANKS
     C                   EVAL      KKRBRC = *BLANKS
     C                   EVAL      KKRCTR = *BLANKS
     C                   EVAL      KKSTAT = *BLANKS

     C                   CALL      'ZA0250'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Srvalidate - Subroutine to validate input                     *
      *                                                               *
      * Called by: SrCreate                                           *
      *                                                               *
      * Calls: SRErrMsg, ZALIGN, AOBRCHR0                             *
      *                                                               *
      *****************************************************************

     C     SrValidate    BEGSR

     C                   EVAL      Wpos = %SCAN(' ':DDCDYR)
     C                   IF        Wpos <> 0
     C                   EVAL      WERROR = 'Y'
     C                   MOVE      *ON           *IN21
     C                   MOVEL     'USS0520'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ELSE

      ** Check numeric
     C                   CALL      'ZALIGN'
     C                   PARM                    WRTCD
     C                   PARM      DDCDYR        WKDRf1
     C                   PARM      *ZERO         DECIMALs
     C                   PARM      4             DIGITs
     C                   PARM      *BLANK        WKDRF1n

     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      WERROR = 'Y'
     C                   MOVE      *ON           *IN21
     C                   MOVEL     'USS0521'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ELSE
     C                   MOVE      DDCDYR        WWCDYR

     C                   ENDIF
     C                   ENDIF

     C                   IF        DDRBRC = *BLANKS
     C                   EVAL      DDRBRC = QDBRN
     C                   ENDIF

     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DDRBRC
     C     SDBRCH        PARM      SDBRCH        DSFDY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      WERROR = 'Y'
     C                   MOVE      *ON           *IN22
     C                   MOVEL     'USS0523'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF

     C                   IF        *IN22 = *OFF
     C                             AND BJSBRC = *BLANKS
     C                   EVAL      WWZBR = DDRBRC
     C                   EVAL      ZACTN = 'I'
     C                   EXSR      SRChautN
     C                   IF        WWERR = 1
     C                             OR WWERR = 2
     C                   EVAL      WERROR = 'Y'
     C                   MOVE      *ON           *IN22
     C                   ENDIF
     C                   ENDIF

     C                   IF        *IN22 = *OFF
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      A8BICN        PCUST
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = A8BICN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POptn
     C                   PARM                    BBCOLC
     C     SDCTRY        PARM      SDCTRY        DSFDY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE  = 002
     C                   EVAL      DBKEY  = BBCOLC
     C                   EXSR      *PSSR
     C                   ELSE                                                               MD040875
     C                   EVAL      DDCTRC = BBCOLC                                          MD040875
     C                   EVAL      WWBRCH = BBCOLC                                          MD040875
     C                   ENDIF

     C                   IF        DDSTTS <> 'LIVE' AND
     C                             DDSTTS <> 'TEST'
     C                   EVAL      WERROR = 'Y'
     C                   MOVE      *ON           *IN25
     C                   MOVEL     'USS0524'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRErrMsg
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChautN - Check for user authority if not multi-branching    *
      *                                                               *
      * Called by: SrBLDSFL                                           *
      *                                                               *
      * Calls: ZVACTU                                                 *
      *                                                               *
      *****************************************************************

     C     SRChautN      BEGSR

     C                   IF        BJSBRC <> *BLANKS
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    WWERR

      ** RETURN error message

     C     WWERR         IFEQ      1
     C                   MOVEL     'CSF9006'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SrErrMsg
     C                   ENDIF
     C                   ENDIF


     C                   IF        BJSBRC = *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM                    WWZBR
     C                   PARM                    WWERR

      ** RETURN error message

     C                   IF        WWERR = 1
     C                             OR WWERR = 2
     C                   MOVEL     'CSF9008'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SrErrMsg
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrErrMsg - Subroutine which handles the display of error      *
      *            messages                                           *
      *                                                               *
      * Called by: SrValidate, SrRDSFLR                               *
      *                                                               *
      * Calls: ZA0340                                                 *
      *                                                               *
      *****************************************************************

     C     SrErrMsg      BEGSR

     C                   CALL      'ZA0340'
     C                   PARM                    WZMsgFile
     C                   PARM                    WZMsgID

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRScrn - Subroutine to display recreate warning message      *
      *           input screen                                        *
      *                                                               *
      * Called by: SrRDSFLR                                           *
      *                                                               *
      * Calls: ZA0250                                                 *
      *                                                               *
      *****************************************************************

     C     SrRScrn       BEGSR

     C                   EVAL      *INKE = '1'
     C                   DOW       *INKE = '1'
     C                   EVAL      *INKE = '0'
     C                   EVAL      PRCancel = 'Y'
     C                   EVAL      DDCDYR = D1YEAR
     C                   EVAL      DDRBRC = DDRBR1
     C                   EVAL      DDCTRC = DDCTR1

     C                   EVAL      DDSTTS = DDSTT1

     C                   CALL      'ZA0250'

     C                   MOVEA     '0000000'     *IN(20)
     C                   MOVE      '1'           *IN30

     C                   WRITE     GLCRMGS2
     C                   WRITE     GLCRMGF2
     C                   WRITE     GLCRMGM0
     C                   EXFMT     GLCRMGS2

     C                   MOVE      '0'           *IN30

     C                   IF        *INKE = '1'
     C                   EVAL      DDWARN = *BLANKS
     C                   ENDIF

     C                   IF        *INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   IF        *INKL = '1'
     C                   EVAL      PCancel = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Subroutine to call GL000767 for report creation   *
      *                                                               *
      * Called by: SrCreate                                           *
      *                                                               *
      * Calls: GL000767                                               *
      *                                                               *
      *****************************************************************

     C     SrProcess     BEGSR

     C                   EVAL      DDRBRC = PBrcda
     C                   EVAL      DDCTRC = PCtrya
     C                   EVAL      DDSTTS = PStts
     C                   EVAL      DDWARN = PComm
     C                   IF        PYrno2 <> *Blanks
     C                   EVAL      DDCDYR = PYrno2
     C                   ELSE
     C                   EVAL      DDCDYR = PYrno
     C                   ENDIF

     C                   IF        WCurYear = DDCDYR
     C                   EVAL      WYR = *Blanks
     C                   ELSE
     C                   MOVE      DDCDYR        WYR
     C                   ENDIF

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV3
     C                   PARM                    WMsgLen
     C                   CALL      'GL000760'
     C                   PARM      *Blanks       PRtcd

     C                   CALL      'GL000767'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'N'           PActn
     C                   PARM      *BLANKS       PMsId
     C                   PARM      DDCDYR        PYear
     C                   PARM      DDRBRC        PBrcda
     C                   PARM      DDCTRC        PCtrya
     C                   PARM      DDSTTS        PStat
     C                   PARM      *BLANKS       PRType
     C                   PARM      DDWARN        PWMsg
     C                   PARM      *Blanks       PRpDocRef
     C                   PARM      *Blanks       ArAcctNumbr
     C                   PARM      *Blanks       ArExcCust
     C                   PARM      *Blanks       ArIncCust

     C                   IF        WCurYear <> DDCDYR
     C                   CALL      'GLC000761B'
     C                   PARM                    DDCDYR
     C                   ENDIF

     C                   EVAL      PBrcda = *Blanks
     C                   EVAL      PCtrya = *Blanks
     C                   EVAL      PStts = *Blanks
     C                   EVAL      PComm = *Blanks
     C                   EVAL      PCAdd = ' '

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial processing                                   *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PYrno
     C                   PARM                    PYrno2
     C                   PARM                    PEnd
     C                   PARM                    PBuild
     C                   PARM                    PBrcda
     C                   PARM                    PCtrya
     C                   PARM                    PStts
     C                   PARM                    PComm
     C                   PARM                    PCadd

      ** Initialize program name

     C                   MOVEL     'GL000761'    DBPGM

     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER

     C     *DTAARA       DEFINE                  GLFATCA
     C                   IN        GLFATCA
     C                   UNLOCK    GLFATCA

      ** Move workstation ID to screen field.

     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER

     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ

      ** ACCESS BANK DETAILS

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Convert Day Number to YYYYMMDD format

     C                   CALLB     'ZDATE9'
     C                   PARM      BJRDNB        DateIn5
     C                   PARM      *ZERO         DayOut8
     C                   PARM      *Blanks       PRtcd

     C                   MOVE      DayOut8       WNAcrDt
     C                   EVAL      D1YEAR = %SubSt(WNAcrDt:1:4)
     C                   Z-ADD     0             WWYEAR
     C                   MOVE      D1YEAR        WWYEAR
     C                   MOVE      D1YEAR        WCurYear
     C                   EVAL      WWYEAR = WWYEAR - 1
     C                   MOVE      WWYEAR        WSysYear

     C     KCRMG2        KLIST
     C                   KFLD                    KKCDYR
     C                   KFLD                    KKRBRC
     C                   KFLD                    KKRCTR
     C                   KFLD                    KKSTAT

     D/COPY SDCPYSRC,MSGHNDDATA

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     D/COPY ZACPYSRC,MSGHNDDSP2

     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2016
**  WCmdArr
SBMJOB CMD(CALL GLC000760 PARM(WYR)) JOB(GLC000760) JOBQ(INTERFACE) LOG(4 0 *SECLVL) LOGCLPGM(*YES)
** ##OV1
OVRDBF FILE(GLCRMXL0) TOFILE(GLCRMXL3) SHARE(*NO)
** ##OV2
DLTOVR FILE(GLCRMXL0)
** ##OV3
CLRPFM FILE(QTEMP/GLCRMXPD)
