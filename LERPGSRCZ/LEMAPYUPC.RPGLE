     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayments - Database update Ctrl')    *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LEMAPYUPC - LE Manual Repayments - Database Update Ctrl.     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 14Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 04Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 201589             Date 03Jan02               *
      *                 CDE005             Date 14Jan03               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  201589 - Change to check a new locking dataarea LEMAPYLCK    *
      *           to determine whether this DBU is already active.    *
      *  CDE005 - Reservation ID                                      *
      *  CAP077 - Lending API enhancement - Manual Repayments         *
      *                                                               *
      *****************************************************************
      *
     FLEVMAPYPD UF   E             DISK    RECNO(WRRN)
     F                                     COMMIT
     FLEVMAPYL2 UF   E           K DISK
     F                                     RENAME(LEVMAPYD0:LEVMAPYD2)
     FLEVEMAPYPDO    E             DISK
     F                                     RENAME(LEVMAPYD0:LEVEMAPYRR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(CL_)
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEMAPYU001
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in MAPY API update')
      *
      *****************************************************************
      *
      ***  Externally described data structure for valid Manual Repayment
      *
     D ValidMAPY     E DS                  EXTNAME(LEVMAPYPD)
      ***  New repayment shedule in File Format
      *
     D LEMAPYUPC       DS             1    DTAARA(LEMAPYUPC)
      *
     D ErrorMAPY     E DS                  EXTNAME(LEEMAPYPD)
      ***  Error indicators Screen
      *
     D CrMaPyFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Current Manual Repayment in File Format
     D                                     PREFIX(L)
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
     D                                     PREFIX(PD_)
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
      ***  Loan PAyment/receipt instructions
      *
     D***NewSettlDS     DS            34                                                      CGL029
     D  NewSettlDS     DS            40                                                       CGL029
      ***  New settlement details for Loan Amendments
     D  WTYPE                  1      2
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
      *
     D***OldSettlDS     DS            34                                                      CGL029
     D  OldSettlDS     DS            40                                                       CGL029
      ***  Current Settlement details for Loan Amendment
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
      *
     D PassDtaDS       DS           512
     D CLE002                  1      1A
     D CLE003                  2      2A
     D CLE004                  3      3A
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE009                  6      6A
     D CLE014                  7      7A
     D CLE023                  8      8A
     D CEU004                  9      9A
     D CDE001                 10     10A
     D WrkDDESEQ              11     13A
     D WrkDDPASD              14     14A
     D WrkCntrMR              15     15  0
     D WrkReactFacil          16     16
      *
     D  MAPY_DBER      DS            16
      ***  DS For Data error in MAPY valid file
      *
     D**K@LNRF**               1      6  0                                                    CLE148
     D  K@LNRF                 1      6                                                       CLE148
     D  BLK1                   7      7
     D  K@VDAT                 8     12  0
     D  BLK2                  13     13
     D  K@LASN                14     16  0
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External data structure for SAR details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  Data structure for bank details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Midas Cust. Lending ICD accessed via access program
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ***  Midas SE Trading ICD accessed via access program
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Midas General Ledger ICD accessed via access program
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Midas Retail ICD accessed via access program
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Data structure for Module Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  DS for Access ProgramsS, Short DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  DS for Access ProgramsS, Long DS
      *
     D Object          S             10A   INZ('LEMAPYUPC')
     D LockObj         S             10A   INZ('LEMAPYLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D K@TMES          S             26Z
      *
      ***  Dummy message ID and message file fields for use on the calls to
      ***  ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
     D WRRN            S              7S 0
                                                                                              244636
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEMAPYU002
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
      *
      /COPY WNCPYSRC,LEMAPYU003
      *
      ***  Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APMAPYDTQ'
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
      *
      ***  Initialise Data queue parms
      *
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APMAPYDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      *
      ***  Wait for data queue prompt
      ***  Server program will send data queue entry when record is
      ***  written to the valid transactions file
      *
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *
      ***  Lock allocation data area
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
      *
      /COPY WNCPYSRC,LEMAPYU004
      *
      ***  Position file cursor to start of file to prevent problems on
      ***  later calls
      *
     C     1             SETLL     LEVMAPYPD
      *
      ***  Read valid records
      *
     C                   READ      LEVMAPYPD                              99    *
     C     *IN99         DOWEQ     '0'
      *
     C                   EVAL      K@LNRF = MRLNRF
     C                   EVAL      K@VDAT = MRVDAT
     C                   EVAL      K@LASN = MRLASN
     C                   EVAL      K@TMES = MRTMES
      *
      /COPY WNCPYSRC,LEMAPYU005
      *
      ***  Load the API Dump data area with as many fields from the message
      ***  header as are available, so that dumps in any lowere level modules
      ***  will include the key information
      *
     C                   EVAL      ARFOTranID = MRFRNT
     C                   EVAL      ARFOAsocID = MRAFRT
     C                   EVAL      ARRprLocn  = MRREPA
      *
      /COPY WNCPYSRC,LEMAPYU006
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         Widx              3 0
      *
     C                   MOVE      *ALL'Y'       ErrorMAPY
      *
      ***  Convert the value date and set up the retrieve parameters
      *
     C                   MOVE      MRVDAT        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVALD
      *
     C                   MOVEL     MRCHTP        DDACTN
     C                   MOVE      MRLNRF        DDLNRF
     C                   MOVE      MRLASN        DDSEQN
      *
     C                   IF        MRXAVD <> 0
     C                   MOVE      MRXAVD        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDEVAL
      *
     C                   MOVE      MRXASQ        DDESEQ
     C                   Endif
      *
      ***  Retrieve Manual Repayment details
      *
     C                   EXSR      RTVMAPY
     C                   IF        MRXAVD <> 0
     C                   MOVE      MRXASQ        WrkDDESEQ
     C                   else
     C                   MOVE      *BLANKS       WrkDDESEQ
     C                   Endif
     C                   eval      WrkDDPASD = MRPAST
      *
      ***  Check if no error
      *
     C     DDACTNOK      IFEQ      'Y'
     C     DDLNRFOK      ANDEQ     'Y'
     C     DDSEQNOK      ANDEQ     'Y'
     C     DDVALDOK      ANDEQ     'Y'
     C     Idx           ANDEQ     *ZERO
      *
     C                   CALLB     'LEMAPYUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    ValidMAPY
      ***  Past Due/Repayment Scheduled in file format
     C                   PARM                    PDLoAmFilFmt
      ***  Loan in File Fmt
     C                   PARM                    WrkLnDetails
      ***  Old settlement details
     C                   PARM                    OldSettlDS
      ***  New settlement details
     C                   PARM                    NewSettlDS
      ***  Passed Data
     C                   PARM                    PassDtaDS
     C                   PARM                    ErrorMAPY
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      * Reservation ID                                                          CDE005
     C                   PARM      *BLANKS       ResrvId          10            CDE005
      *
     C                   ELSE
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   ENDIF
      *
      /COPY WNCPYSRC,LEMAPYU007
      *
      ***  Commit updates if no error
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C     Idx           ORNE      *ZERO
     C     @@RTCD        OREQ      '*RECLCK'                                                AR868380
     C                   ROLBK
     C                   ELSE
     C     WRRN          CHAIN     LEVMAPYPD                          99
B004 C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVMAPYPD'   DBFILE                         *************
     C                   Z-ADD     WRRN          DBASE                          * DBERR 001 *
     C                   MOVE      *BLANKS       DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ELSE
     C                   DELETE    LEVMAPYPD
     C                   COMMIT
E004 C                   ENDIF
     C                   ENDIF
      *
      /COPY WNCPYSRC,LEMAPYU008
      *
      ***  If an error has occurred, reaccess record in error and remove from
      ***  the file to prevent program processing the same record again
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C     Idx           ORNE      *ZERO
     C     @@RTCD        OREQ      '*RECLCK'                                                AR868380
     C                   EVAL      K@LNRF = MRLNRF
     C                   EVAL      K@VDAT = MRVDAT
     C                   EVAL      K@LASN = MRLASN
     C                   EVAL      K@TMES = MRTMES
      *
      ***  Write details of record to error file
      *
      ***  process LEVMAPYPD
      *
     C                   WRITE     LEVEMAPYRR
     C     KKMAPY        CHAIN     LEVMAPYL2                          99
B004 C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVMAPYPD'   DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVE      MAPY_DBER     DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ENDIF
     C                   DELETE    LEVMAPYD2
      *
      ***  Send message to system operator
      *
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   ENDIF
      *
      ***  Read valid record
      *
     C                   READ      LEVMAPYD0                              99    *
     C                   ENDDO
      *
      ***  Unlock allocation data area
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      *
      ***  End loop for data queue prompt
      *
     C                   ENDDO
      *
      /COPY WNCPYSRC,LEMAPYU009
      *
      ***  Exit from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVMAPY- Retrieve Manual Repayment                          *
      *****************************************************************
     C     RTVMAPY       BEGSR
      *
     C                   CALLB     'LEMAPYRTV'
      *
      ***  Inputs
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ***  Response mode SECURITY CKECKING
     C                   PARM      'S'           @@RSMD            1
     C                   PARM                    DDACTN            1            Action Code
     C                   PARM                    FOTRID           20            Front Office Id
     C                   PARM                    DDLNRF            6            Midas Loan Ref
     C                   PARM                    DDVALD            6            Midas Value Date
     C                   PARM                    DDSEQN            3            Midas Sequ. no
     C                   PARM                    DDEVAL            6            Midas Expected Date
     C                   PARM                    DDESEQ            3            Midas Expected Seq
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014
      *
      ***  Outputs
      *
      ***  (Current) Manual Repayment in file format
     C                   PARM      *BLANKS       CrMaPyFilFmt
     C                   PARM      *BLANK        DDACTNOK                       OK Actn code
     C                   PARM      *BLANK        DDLNRFOK                       OK Loan ref
     C                   PARM      *BLANK        DDVALDOK                       OK Value Date
     C                   PARM      *BLANK        DDSEQNOK                       OK Sequence
     C                   PARM      *BLANK        DDEVALOK                       OK Expected Date
     C                   PARM      *BLANK        DDESEQOK                       OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators for display
     C                   PARM                    WWHoldTaxRat     11 7          W/hold Tax Rate
     C                   PARM      ' '           WExpectType       1            Expected LOAM type
     C                   PARM      ' '           WPTYP72           1            Expected on type 72
     C                   PARM      '  '          WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM      0             WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    WrkCntrMR                      Counter MR (UPD)
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan details
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         WIdx
     C                   PARM                    PRcvParm                                     244636
      *
      ***  Save the settlement details for update
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
      *
      ***  if Only Warning, Refresh OK Flag
      *
     C                   if        IDX = 0
     c                   eval      Widx = 0
     C                   MOVE      *ALL'Y'       ErrorMAPY
     C                   MOVE      *BLANKS       WMsgidArr
     C                   MOVEL     *BLANKS       WFldNamArr
     C                   MOVEL     *BLANKS       WMsgIdArr
     C                   MOVEL     *BLANKS       WMsgDtaArr
     C                   endif
      *
     C                   ENDSR
      *****************************************************************
      *
      ***  Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,LEMAPYU010
      *
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Define key list for LEVMAPYL2
      *
     C     KKMAPY        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF                                       CLE148
     C                   KFLD                    K@VDAT            5 0
     C                   KFLD                    K@LASN            3 0
     C                   KFLD                    K@TMES
      *
      ***  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 003 *
     C                   Z-ADD     3             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C                   KFLD                    K@LNRF
     C                   KFLD                    K@RCDT            1
      *
      ***  Access Customer Lending data
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access Trading Data
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END

     C                   MOVEL     BGMBIN        MBIN              1
      *
      ***  Access General Ledger
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '005'         DBASE                          * DBERR 005 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   If        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY

     C                   endif
      *
      ***  Determine if Customer Lending Enhancements - Authorization
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - BackValuation
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - Syndication
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE004
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - other features
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE007
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
     C                   END
      *
      ***  Determine if Customer Lending Enhancements -
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *
      ***  Determine if CEU004 is activated
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
      ***  Determine if CDE001 is activated - Data Export for CCRM limits
      *
     C                   MOVE      'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   END
      *
      ***  Determine if CLE023 is activated - LE enh: History improvement
      *
     C                   MOVE      'N'           CLE023            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   END

      *  Check if an existing DBU_CLIP job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      *
      ***  Lock allocation data area
      *    =========================
      *
      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.
      *
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
      *
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
      *
      *   Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
      *
      ***  Create required QTEMP objects
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
      *
      ***  Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,LEMAPYU011
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ***  The following /COPY contains the standard program status
      ***  subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
	(c) Finastra International Limited 2002
