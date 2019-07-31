     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance watch list engine feeder')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDRWENGN - Compliance Watch List Engine Feeder               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG3641            Date 07Jul04               *
      *                 221249             Date 10Sep03               *
      *                         *CREATE    Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG3641- Globalg MMM/Compliance Interface                    *
      *  221249 - Comp Watch jobs not ending                          *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas Compliance Watch Hit List by Func. Type/Identifier/Brch
 
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** DS for Midas Watch List Transaction Details File
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)
 
      ** DS for Midas Watch List Details Queue
     D SDWLSTDS      E DS                  EXTNAME(SDWLSTPD)
 
      ** DS for Midas Watch List Message Status Queue
     D SDWLMSDS      E DS                  EXTNAME(SDWLMSPD)
 
      ** DS for Midas Switchable features descriptions File                                  BUG3641
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3641
                                                                                             BUG3641
      ** DS for access programs, short data structure                                        BUG3641
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG3641
                                                                                             BUG3641
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CSW034          S              1A
     D PRetCode        S              7A
     D PSrvContext     S               *
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5  0
     D PDtqDta         S          31000A
     D PDtqWait        S              5  0
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PObject         S             10A
     D PLib            S             10A
     D PObjType        S              7A
     D PLockState      S              7A
     D PMember         S             10A
     D PWaitTime       S              6A
     D PDlcobj         S              1A
     D PReturn         S              7A
     D PNoOfMsg        S              9P 0
     D PDtaQName       S             10A
     D PDtaQLib        S             10A
     D PLength         S              5  0
     D PMessage        S            100A
 
     D WRUN            S              1A
     D WDBASE          S              3  0
     D WrFUNT          S              8A
     D WrIDEN          S             40A
     D WrBRCH          S              3A
     D WrkAmt          S             18S 3
     D @END            S              3A                                        221249
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Open OFAC-Agent server
 
     C                   EXSR      SROpnSrv
 
      ** Main Processing
 
     C                   EXSR      SRProc
 
      ** End of program
 
     C                   EXSR      SREnd
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROpnSrv   - Open Client Connection to OFAC-AGENT server      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SROpnSrv      BEGSR
 
      ** Open OFAC server
 
     C                   CALL      'SDOFACOP'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Error calling SDOFACOP
 
     C                   SELECT
 
     C                   WHEN      PRetCode = '*INIT  '
     C                   EVAL      WDBASE = 10
     C                   EVAL      PMsgId = 'USR9686'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*OPEN  '
     C                   EVAL      WDBASE = 11
     C                   EVAL      PMsgID = 'USR9687'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*NREADY'
     C                   EVAL      WDBASE = 12
     C                   EVAL      PMsgID = 'USR9688'
     C                   EXSR      SRSndErr
 
     C                   ENDSL
 
      ** Perform database error either of the following return code is true
 
     C                   IF        PRetCode = '*INIT  ' OR
     C                             PRetCode = '*OPEN  ' OR
     C                             PRetCode = '*NREADY'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFile = 'SDOFACOP'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProc - Main Processing                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SREngine   SRDAllObj                                   *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
      ** While Dataqueue data is not 'END'
 
     C                   EVAL      PDtqLen = 31000
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'SDCWEDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
 
     C*******************DOW       W5IDEN  <> 'END'                                           221249
     C                   DOW       @END    <> 'END'                                           221249
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam
     C                   PARM                    PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqDta
     C                   PARM                    PDtqWait
      *                                                                                       221249
     C                   MOVEL     PDtqDta       SDWLSTDS                                     221249
     C                   MOVEL     W5IDEN        @END                                         221249
 
     C*******************IF        W5IDEN <> 'END'                                            221249
     C                   IF        @END   <> 'END'                                            221249
 
     C*******************MOVEL     PDtqDta       SDWLSTDS                                     221249
 
     C                   CLEAR                   SDWLTD
 
     C                   EVAL      W4IDEN = W5IDEN
     C                   EVAL      W4ITEM = W5ITEM
     C                   EVAL      W4BRCH = W5BRCH
     C                   EVAL      W4SYSM = W5SYSM
     C                   EVAL      W4FUNT = W5FUNT
     C                   EVAL      W4CNUM = W5CNUM
     C                   EVAL      W4CTYP = W5CTYP
     C                   EVAL      W4CUST = W5CUST
     C                   IF        W5DDAT <> *BLANKS
     C                   MOVE      W5DDAT        W4DDAT
     C                   ENDIF
     C                   IF        W5VDAT <> *BLANKS
     C                   MOVE      W5VDAT        W4VDAT
     C                   ENDIF
     C                   IF        W5MDAT <> *BLANKS
     C                   MOVE      W5MDAT        W4MDAT
     C                   ENDIF
     C                   EVAL      W4DEN1 = W5DEN1
     C                   EVAL      W4DEN2 = W5DEN2
     C                   MOVE      W5AMT1        WrkAmt
     C                   EVAL      W4AMT1 = WrkAmt
     C                   MOVE      W5AMT2        WrkAmt
     C                   EVAL      W4AMT2 = WrkAmt
     C                   EVAL      W4ARLS = W5ARLS
 
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREngine - Call Compliance Watch List Engine                  *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREngine      BEGSR
 
     C                   Call      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    SDWLTD
     C                   PARM                    W5SSTR
 
      ** Error calling SDWLENGN
 
     C                   SELECT
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = 13
     C                   EVAL      PMsgID = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = 14
     C                   EVAL      PMsgID = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = 15
     C                   EVAL      PMsgID = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = 16
     C                   EVAL      PMsgID = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = 17
     C                   EVAL      PMsgID = 'USR9684'
     C                   EXSR      SRSndErr
 
     C                   OTHER
 
     C                   IF        PRetCode <> *BLANK
     C                   EVAL      PMsgID = 'USR9685'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Function is Message Management
 
     C                   IF        W4FUNT = 'MGOREF'
     C                   EXSR      SRMGOREF
     C                   ENDIF
 
     C                   ENDSL
 
      ** Perform database error either of the following return code is true
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*FOFEXE' OR
     C                             PRetCode = '*SRVNAM' OR
     C                             PRetCode = '*DBNAME' OR
     C                             PRetCode = '*USRNAM' OR
     C                             PRetCode = '*PASSWD'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = SDWLTD
     C                   EVAL      DBFile = 'SDWLENGN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMGOREF - Send details to Message Status data queue          *
      *                                                               *
      * Called by: SREngine  SREnd  *PSSR                             *
      *                                                               *
      * Calls:  SRDAllObj                  *
      *                                                               *
      *****************************************************************
     C     SRMGOREF      BEGSR
 
     C                   EVAL      W8RTCD = PRetCode
     C                   EVAL      W8IDEN = W4IDEN
     C                   EVAL      W8ITEM = W4ITEM
     C                   EVAL      W8BRCH = W4BRCH
     C                   EVAL      W8ARLS = W4ARLS
 
     C                   IF        W8RTCD = *BLANKS
 
     C                   EVAL      WrFUNT = 'MGOREF'
     C                   EVAL      WrIDEN = W8IDEN
     C                   EVAL      WrBRCH = W8BRCH
 
     C     KWatch        CHAIN     SDCWHTL1                           01
 
     C                   IF        *IN01 = *ON OR
     C                             W3TREL = 'Y'
     C                   EVAL      W8RTCD = '*NOHIT'
     C                   ELSE
     C                   EVAL      W8RTCD = '*HIT'
     C                   ENDIF
     C
     C                   ENDIF
 
      ** Write record to Status Dataq
 
     C                   MOVEL     SDWLMSDS      PMessage
     C                   If        CSW034 = 'N'                                              BUG3641
                                                                                             BUG3641
     C                   EVAL      PLength = 100
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SDCWSDTQ'    PDtaQName
     C                   PARM      '*LIBL'       PDtaQLib
     C                   PARM                    PLength
     C                   PARM                    PMessage
                                                                                             BUG3641
     C                   else                                                                BUG3641
                                                                                             BUG3641
      ** If Global Processing for MidasPlus write to Global keyed DataQ                      BUG3641
     C                   CALL      'SDFRMCMP'                                                BUG3641
     C                   PARM                    PMessage                                    BUG3641
                                                                                             BUG3641
     C                   EndIf                                                               BUG3641
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDAllObj - Unlock allocation data area                       *
      *                                                               *
      * Called by: SRProc  SRMGOREF  SREnd  *PSSR                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDAllObj     BEGSR
 
      ** Unlock allocation data area
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    PObject
     C                   PARM      '*LIBL'       PLib
     C                   PARM      '*DTAARA'     PObjType
     C                   PARM      '*EXCL'       PLockState
     C                   PARM      *BLANKS       PMember
     C                   PARM      *BLANKS       PReturn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send error message                                 *
      *                                                               *
      *****************************************************************
     C     SRSndErr      BEGSR
 
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM      'SDRWENGN'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End of Program                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRDAllObj                                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Unlock allocation data area
 
     C                   EVAL      PObject = 'SDRWENGN'
     C                   EXSR      SRDAllObj
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
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
     C     *INZSR        BEGSR
 
      ** Setup key list to access file SDCWHTL1
 
     C     KWatch        KLIST
     C                   KFLD                    WrFUNT
     C                   KFLD                    WrIDEN
     C                   KFLD                    WrBRCH
 
      ** Check for CSW034 Midas Message Manager Global Processing                            BUG3641
                                                                                             BUG3641
     C                   CALL      'AOSARDR0'                                                BUG3641
     C                   PARM      *BLANKS       PRetCde           7                         BUG3641
     C                   PARM      '*VERIFY'     POption           7                         BUG3641
     C                   PARM      'CSW034'      PSard             6                         BUG3641
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3641
                                                                                             BUG3641
     C                   IF        PretCde <> *BLANKS AND PRetCde <> '*NRF   '               BUG3641
     C     *LOCK         IN        LDA                                                       BUG3641
     C                   EVAL      DBKEY = 'CSW034'                                          BUG3641
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3641
     C                   EVAL      DBASE = 1                                                 BUG3641
     C                   OUT       LDA                                                       BUG3641
     C                   EXSR      *PSSR                                                     BUG3641
     C                   ENDIF                                                               BUG3641
                                                                                             BUG3641
     C                   IF        PRetCde = *BLANKS                                         BUG3641
     C                   EVAL      CSW034 = 'Y'                                              BUG3641
     C                   ELSE                                                                BUG3641
     C                   EVAL      CSW034 = 'N'                                              BUG3641
     C                   ENDIF                                                               BUG3641
                                                                                             BUG3641
      ** Initialise Data queue parameters
 
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
      ** Send details to Message Status data queue
 
     C                   IF        W4FUNT = 'MGOREF' AND
     C                             W4IDEN <> *BLANKS
     C                   EXSR      SRMGOREF
     C                   ENDIF
 
      ** Unlock allocation data area
 
     C                   EVAL      PObject = 'SDRWENGN'
     C                   EXSR      SRDAllObj
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
