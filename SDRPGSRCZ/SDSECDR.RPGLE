     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details retrieve')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSECDR   - SD Securities Clients retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1005480          Date 16Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG12213           Date 16Jan07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3122            Date 09Jul04               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1005480 - Depot customer reference error                   *
      *  BUG12213 - Depot details missing on wholesale customer input *
      *  CRE026 - Consumer Banking                                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3122 - Additional changes w/ 24X7 implementation.         *
      *  CAP084 - Java wrapper project                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCSDRL2  IF   E           K DISK    INFSR(*PSSR)                                     BUG12213
 
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
 
     D CurSecDets    E DS                  EXTNAME(SDSECDPD)
     D                                     PREFIX(@)
      * Current Securities Clients Detail in Screen Format
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
 
     D CrSdFilFmt    E DS                  EXTNAME(SDSECSPD)
     D                                     PREFIX(C_)
      * Current Securities Clients Detail in File Format
 
     D DepData         DS                                                                   BUG12213
     D PDepDet                 1   4050                                                     BUG12213
      * Other Depot                                                                         BUG12213
                                                                                            BUG12213
     D WFirst          S              1                                                     BUG12213
     D X2              S              4  0                                                  BUG12213
     D X3              S              4  0                                                  BUG12213
                                                                                            BUG12213
     D OKSecDets     E DS                  EXTNAME(SDESECDPD)
      * Error indicators
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                 BUG3122
      ** EXTERNAL DS FOR SECURITIES ICD DATA                                                 BUG3122
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
      **--------------------------------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Customer Number
     D DDCUSN          S              6A
 
      ** Customer Shortname
     D DDCSSN          S             10A
 
      ** Customer Number / Shortname
     D DDCSST          S             10A
 
      ** Customer Report Town
     D DDCRTN          S             10A
 
      ** Customer Report Name
     D DDCRNM          S             20A
     D DepotName       DS                                                                    BUG3122
     D  DDDSN1                 1     10                                                      BUG3122
     D  DDDSN2                11     20                                                      BUG3122
     D  DDDSN3                21     30                                                      BUG3122
     D  DDDSN4                31     40                                                      BUG3122
     D  DDDSN5                41     50                                                      BUG3122
     D  DDDSN6                51     60                                                      BUG3122
     D  DDDSN7                61     70                                                      BUG3122
     D  DDDSN8                71     80                                                      BUG3122
     D  DDDSN9                81     90                                                      BUG3122
     D  DDDSN0                91    100                                                      BUG3122
      *                                                                                      BUG3122
      ** 24x7 Status Dataarea                                                                BUG3122
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3122
      *                                                                                      BUG3122
      ** SD Data Area                                                                        BUG3122
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3122
      *                                                                                      BUG3122
      ** Externally described DS for SAR details                                             BUG3122
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 BUG3122
      *                                                                                      BUG3122
      ** Externally described DS for bank details                                            BUG3122
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3122
     D CSC011          S              1A                                                     BUG3122
      *                                                                                      BUG3122
      ** Processing date                                                                     BUG3122
     D WRDAY           S                   LIKE(BJRDNB)                                      BUG3122
     D POptn           S              7A                                                     BUG3122
     D PRtcd           S              7A                                                     BUG3122
     D PSARd           S              6A                                                     BUG3122
 
     D AAuth           S              1A   INZ(' ')                                        AR1005480
                                                                                           AR1005480
      **--------------------------------------------------------------------------------------------
 
     C                   CLEAR                   CrSdFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SDSECDRED
     C                   ELSE
     C                   MOVEL     DDCUSN_In     @SCRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read
      * and no error message returned
      *
     C     @SCRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @SCRED        DDCUSN
     C                   EXSR      SDSECDRTV
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      SDSECDCVT
     C                   ENDIF
      *                                                                                     BUG12213
      ** Retrieve other depot                                                               BUG12213
      *                                                                                     BUG12213
     C                   EXSR      SDCSDRTV                                                 BUG12213
 
     C                   ENDIF
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCUSN'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
     C                   MOVEA     Depotsn       DepotName                                   BUG3122
     C                   EVAL      @DDCUSN = DDCUSN                                          BUG3122
     C**********         EVAL                    Buffer = CurSecDets                         BUG3122
     C**********         EVAL      Buffer = CurSecDets + Depotname + DDCSSN         BUG3122 BUG12213
     C**********                       + DDCRNM + DDCRTN + BVACOP + BVCUIN          BUG3122 BUG12213
     C**********                       + BVDR1 + BVDR2 + BVDR3 + BVDR4 + BVDR5      BUG3122 BUG12213
     C**********                       + BVDR6 + BVDR7 + BVDR8 + BVDR9 + BVDR10     BUG3122 BUG12213
     C**********         EVAL      Buffer = CurSecDets + DepData                  BUG12213 AR1005480
     C                   EVAL      Buffer = CurSecDets + AAuth + DepData                   AR1005480
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCUSN_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      ** Access Securities Clients Details                                                   BUG3122
      *                                                                                      BUG3122
     C                   CALLB     'AOSTRDR0'                                                BUG3122
     C                   PARM      '*DBERR '     @RTCD             7                         BUG3122
     C                   PARM      '*FIRST '     @OPTN             7                         BUG3122
     C     SDSTRD        PARM      SDSTRD        DSFDY                                       BUG3122
      *                                                                                      BUG3122
      **Database error                                                                       BUG3122
      *                                                                                      BUG3122
     C     @RTCD         IFNE      *BLANKS                                                   BUG3122
     C                   MOVEL     'SDSTRDPD'    DBFILE                                      BUG3122
     C                   Z-ADD     1             DBASE                                       BUG3122
     C                   MOVEL     @OPTN         DBKEY                                       BUG3122
     C                   EXSR      *PSSR                                                     BUG3122
     C                   END                                                                 BUG3122
      *                                                                                      BUG3122
      ** Check if CSC011 is installed                                                        BUG3122
     C                   EVAL      CSC011 = 'N'                                              BUG3122
     C                   CALLB     'AOSARDR0'                                                BUG3122
     C                   PARM      *BLANKS       PRTCD                                       BUG3122
     C                   PARM      '*VERIFY'     POPTN                                       BUG3122
     C                   PARM      'CSC011'      PSARD                                       BUG3122
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3122
     C**********         IF        PRTCD = *BLANKS AND                                BUG3122 CRE026
     C                   IF        PRTCD <> *BLANKS AND                                       CRE026
     C                             PRTCD <> '*NRF   '                                        BUG3122
     C     *LOCK         IN        LDA                                                       BUG3122
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3122
     C                   EVAL      DBKEY  = 'CSC011'                                         BUG3122
     C                   EVAL      DBASE = 2                                                 BUG3122
     C                   OUT       LDA                                                       BUG3122
     C                   EXSR      *PSSR                                                     BUG3122
     C                   ENDIF                                                               BUG3122
                                                                                             BUG3122
     C                   IF        PRTCD = *BLANKS                                           BUG3122
     C                   EVAL      CSC011 = 'Y'                                              BUG3122
     C                   IN        SC24X7                                                    BUG3122
     C                   IN        SDSTAT                                                    BUG3122
     C                   ELSE                                                                BUG3122
     C                   EVAL      CSC011 = 'N'                                              BUG3122
     C                   ENDIF                                                               BUG3122
      ** Access bank details.                                                                BUG3122
      *                                                                                      BUG3122
     C                   CALLB     'AOBANKR0'                                                BUG3122
     C                   PARM      *BLANKS       PRtcd                                       BUG3122
     C                   PARM      '*FIRST '     POptn                                       BUG3122
     C     SDBANK        PARM      SDBANK        DSFDY                                       BUG3122
      *                                                                                      BUG3122
      ** Database error                                                                      BUG3122
      *                                                                                      BUG3122
     C                   IF        PRtcd <> *BLANKS                                          BUG3122
     C                   EVAL      DBKey = POptn                                             BUG3122
     C                   EVAL      DBFile = 'SDBANKPD'                                       BUG3122
     C                   Z-ADD     4             DBase                                       BUG3122
     C                   EXSR      *PSSR                                                     BUG3122
     C                   ENDIF                                                               BUG3122
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDSECDM01
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      **********************************************************************
     C     SDSECDRED     BEGSR
 
     C                   CALLB     'SDCUSDRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut       10
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * CUSTO REF. POINTER
     C                   PARM                    DDCUSN
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Securities client read
     C                   PARM      *BLANK        @SCRED            6
 
     C                   ENDSR
      **********************************************************************
     C     SDSECDRTV     BEGSR
 
     C                   EVAL      WRDAY = BJRDNB                                            BUG3122
     C                   CALLB     'SDSECDRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeIn        10
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      *BLANK        ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    C_BFFRNT
      *
      * (Midas) Trade Reference
     C                   PARM                    DDCUSN
      *
      * Key Screen Customer number / shortname entry
     C                   PARM                    DDCSST
      * OUTPUTS :
      *
      * Securities Clients Details in File Format
     C                   PARM                    CrSdFilFmt
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      * OK - Customer Reference
     C                   PARM      *BLANK        DDCUSNOK          1
      *
      ** Customer Shortname
     C                   PARM                    DDCSSN
 
      ** Customer Report Name
     C                   PARM                    DDCRNM
 
      ** Customer Report Town
     C                   PARM                    DDCRTN
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
 
 
     C                   ENDSR
      **********************************************************************
     C     SDSECDCVT     BEGSR
 
     C                   CALLB     'SDSECDCVT'
 
      * INPUTS
      * Return Code
     C                   PARM      *BLANK        ReturnCode       10
      *
      * Securities Clients Details File Format
     C                   PARM                    CrSdFilFmt
      * OUTPUTS
 
      * Securities Clients Details Screen Format
     C                   PARM                    CurSecDets
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************                     BUG12213
     C     SDCSDRTV      BEGSR                                                              BUG12213
                                                                                            BUG12213
     C                   EVAL      WFirst = 'Y'                                             BUG12213
     C     DDCUSN        SETLL     SDCSDRL2                                                 BUG12213
     C     DDCUSN        READE     SDCSDRL2                               98                BUG12213
     C                   DOW       *IN98 <> True                                            BUG12213
     C                   EXSR      SRSetOthDep                                              BUG12213
     C     DDCUSN        READE     SDCSDRL2                               98                BUG12213
     C                   ENDDO                                                              BUG12213
                                                                                            BUG12213
     C                   ENDSR                                                              BUG12213
      *****************************************************************                     BUG12213
      /EJECT                                                                                BUG12213
      *****************************************************************                     BUG12213
      *                                                               *                     BUG12213
      * SRSetOthDep - Set-up fields for depot reference               *                     BUG12213
      *                                                               *                     BUG12213
      *****************************************************************                     BUG12213
                                                                                            BUG12213
     C     SRSetOthDep   BEGSR                                                              BUG12213
                                                                                            BUG12213
     C                   IF        WFirst = 'Y'                                             BUG12213
                                                                                            BUG12213
     C                   Z-ADD     2             X2                                         BUG12213
     C                   Z-ADD     8             X3                                         BUG12213
                                                                                            BUG12213
     C                   ELSE                                                               BUG12213
                                                                                            BUG12213
     C                   EVAL      X2 = X2 + 27                                             BUG12213
     C                   EVAL      X3 = X3 + 27                                             BUG12213
                                                                                            BUG12213
     C                   ENDIF                                                              BUG12213
                                                                                            BUG12213
     C                   EVAL      %SUBST(PDepDet:X2:6) = DRDPOT                            BUG12213
     C                   EVAL      %SUBST(PDepDet:X3:20)= DRREFN                            BUG12213
                                                                                            BUG12213
     C                   EVAL      WFIRST = 'N'                                             BUG12213
                                                                                            BUG12213
     C                   ENDSR                                                              BUG12213
                                                                                            BUG12213
      *****************************************************************                     BUG12213
      /EJECT                                                                                BUG12213
      *****************************************************************                     BUG12213
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
