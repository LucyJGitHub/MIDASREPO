     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Select components to be run today')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      *  CB000001 - Midas CB Select components to be run today        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCB021   *CREATE   Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB021 -  COB Restructure - Non Working Day COB              *
      *                                                               *
      *****************************************************************
     FSDMMODPD  IT   F  128        DISK
      /SPACE 2
      *****************************************************************
      *
      *    U7&U8   DATABASE ERROR
      *
      *****************************************************************
      /EJECT
      *
      ** Logical Constants
      *
     D True            C                   Const(*ON)
     D False           C                   Const(*OFF)
     D SQLOK           C                   Const(0)
     D SQLEoF          C                   Const(100)
     D COMSRows        C                   Const(500)
     D DCL1Rows        C                   Const(99)
     D Error           S              1A
      *
      ** DataStructure of Variables
      *
     D                 DS                  Inz
     D PrvCom                              Like(COMSJ0DS.DHCOTT)
     D PrvSeq                              Like(COMSJ0DS.DHCSEQ)
     D ConditionsMet                  1N
     D Match                          1N
     D COMSReturned                   5U 0
     D DCL1Returned                   3U 0
     D COMSIdx                        5U 0
     D CBMDIndex                      5U 0
     D MODIndex                       2S 0
     D MOIIndex                       3S 0
     D ULRows                         5U 0
     D MLoopCtr                       5U 0
     D MLoopRow                       5U 0
      *
      ** Switcheable Features
      *
     D CRT001                         1A
     D CRT002                         1A
     D CSC054                         1A
     D WPEA                           1A
      *
      ** Data Structures for SQL Results
      *
     D COMSJ0DS      E DS                  Occurs(COMSRows) Inz
     D                                     Qualified
     D                                     EXTNAME(CBCOMSJ0)

     D CBMDCNDS      E DS                  Occurs(DCL1Rows) Inz
     D                                     Qualified
     D                                     EXTNAME(CBMDCNL1)

     D CBCOMSDS      E DS                  EXTNAME(CBCOMSL0) Inz
     D                                     Qualified
      *
      ** Array showing positions of modules on file SDMMODPD
      *
     D MODPOS          S              2    Dim(128) CTDATA PERRCD(11)
      *
      ** Array to determine whether module is on taken from file mmodf
      *
     D SMOD            S              1    DIM(128) FROMFILE(SDMMODPD)
     D                                     PERRCD(128)

      *
      ** Any changes to these fields are reflected to MOD/MOO
      *
     D MODID           DS                  Inz
     D  DJMD01                             Like(CBMDCNDS.DJMD01)
     D  DJMD02                             Like(CBMDCNDS.DJMD02)
     D  DJMD03                             Like(CBMDCNDS.DJMD03)
     D  DJMD04                             Like(CBMDCNDS.DJMD04)
     D  DJMD05                             Like(CBMDCNDS.DJMD05)
     D  DJMD06                             Like(CBMDCNDS.DJMD06)
     D  DJMD07                             Like(CBMDCNDS.DJMD07)
     D  DJMD08                             Like(CBMDCNDS.DJMD08)
     D  DJMD09                             Like(CBMDCNDS.DJMD09)
     D  DJMD10                             Like(CBMDCNDS.DJMD10)
     D MOD                            2A   Dim(10) Overlay(MODID)

     D MODON           DS                  Inz
     D  DJMP01                             Like(CBMDCNDS.DJMP01)
     D  DJMP02                             Like(CBMDCNDS.DJMP02)
     D  DJMP03                             Like(CBMDCNDS.DJMP03)
     D  DJMP04                             Like(CBMDCNDS.DJMP04)
     D  DJMP05                             Like(CBMDCNDS.DJMP05)
     D  DJMP06                             Like(CBMDCNDS.DJMP06)
     D  DJMP07                             Like(CBMDCNDS.DJMP07)
     D  DJMP08                             Like(CBMDCNDS.DJMP08)
     D  DJMP09                             Like(CBMDCNDS.DJMP09)
     D  DJMP10                             Like(CBMDCNDS.DJMP10)
     D MOO                            1A   Dim(10) Overlay(MODON)

      *
      ** Local Data Area
      *
     D LDA            UDS           256    Inz
     D  DBFILE               134    141A
     D  DBKEY                142    170A
     D  DBPGM                171    180A
     D  DBASE                181    183S 0
      *
      ** Data structures needed for access programs
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD) Inz
     D DSFDY         E DS                  EXTNAME(DSFDY) Inz
      *
     D PEAIND          S             15A   Inz('PEAIndicator')
     D PEACOM          C                   Const('SCC000121')

      *
      *****************************************************************
      /EJECT
      *
      ** Set DHCRQD fields of all components to 'N'
      *
     C/EXEC SQL
     C+ Update CBCOMSL0
     C+    set DHCRQD = 'N'
     C/END-EXEC
      *
      ** Select components in CBCOMSJ0 with DHCFRQ = 39
      ** Result set is returned to COMSJ0DS after fetch
      *
      ** DECLARE
      *
     C/EXEC SQL
     C+ declare COMSCur insensitive scroll cursor for
     C+ select *
     C+  from CBCOMSJ0
     C+  where DHCFRQ = '39'
     C+  or DHCOTT = 'COBBEGIN'
     C+  or DHCOTT = 'SCOBFINISH'
     C/END-EXEC
      *
      ** OPEN
      *
     C/EXEC SQL
     C+ open COMSCur
     C/END-EXEC

     C/EXEC SQL
     C+ get diagnostics :MLoopRow = DB2_NUMBER_ROWS
     C/END-EXEC
      *
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or MLoopRow = 0
     C                   EVAL      ERROR = 'Y'
     C                   EVAL      DBFILE = 'CMPJ0'
     C                   EVAL      DBKEY = *Blanks
     C                   EVAL      DBPGM = 'CB000001'
     C                   EVAL      DBASE = 1
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   IF        MLoopRow > COMSRows
     C                   EVAL      ULRows = COMSRows
      *
     C                   EVAL      MLoopCtr = %DIV(MLoopRow:COMSRows)
      *
     C                   IF        %REM(MLoopRow:COMSRows) <> 0
     C                   EVAL      MLoopCtr += 1
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ULRows = MLoopRow
     C                   EVAL      MLoopCtr = 1
     C                   ENDIF
      *
      ** Start fetch loop
      *
     C                   DOW       MLoopCtr > 0
      *
      ** FETCH into COMSJ0DS and determine number of rows
      *
     C/EXEC SQL
     C+ fetch next from COMSCur for
     C+  :ULRows rows into :COMSJ0DS
     C/END-EXEC
      *
     C                   EVAL      COMSReturned = SQLER3
      *
      ** Error in SQL
      *
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or COMSReturned = 0
     C                   EVAL      ERROR = 'Y'
     C                   EVAL      DBFILE = 'CMPJ0'
     C                   EVAL      DBKEY = *Blanks
     C                   EVAL      DBPGM = 'CB000001'
     C                   EVAL      DBASE = 2
     C                   EXSR      DBERR
     C                   ENDIF

     C                   EVAL      ULRows = DCL1Rows
      *
      ** Do While there are records in COMSJ0DS
      *
     C                   EVAL      COMSIdx = 1

     C                   DOW       COMSIdx <= COMSReturned
     C                   EVAL      %Occur(COMSJ0DS) = COMSIdx
      *
      ** Bypass the processing if this record has the same component
      ** name and sequence combination to the previous record
      *
     C                   IF        COMSJ0DS.DHCOTT = PrvCom
     C                             and
     C                             COMSJ0DS.DHCSEQ = PrvSeq
     C                   EVAL      PrvCom
     C                              = COMSJ0DS.DHCOTT
     C                   EVAL      PrvSeq
     C                              = COMSJ0DS.DHCSEQ
     C                   EVAL      COMSIdx += 1
     C                   ITER
     C                   ENDIF
      *
      *
      ** If extra modules indicator DHCEMI is N,
      ** conditions are met else check if component is
      ** required today and set it for further
      ** validations or processing
      *
     C                   IF        COMSJ0DS.DHCEMI = 'N'
     C                   EVAL      ConditionsMet = True
     C*
     C                   ELSE
     C                   EVAL      ConditionsMet = False
      *
      ** Select details from CBMDCNL1 using current DHCOTT/DHCSEQ
      *
      ** DECLARE
     C/EXEC SQL
     C+ Declare DCL1Cur scroll cursor for
     C+ select *
     C+  from CBMDCNL1
     C+  where DJCOTT = :COMSJ0DS.DHCOTT
     C+        and DJCSEQ = :COMSJ0DS.DHCSEQ
     C/END-EXEC
      *
      ** OPEN
     C/EXEC SQL
     C+ open DCL1Cur
     C/END-EXEC
      *
      ** FETCH into CBMDCNDS and determine number of rows
     C/EXEC SQL
     C+ fetch first from DCL1Cur for
     C+  :ULRows rows into :CBMDCNDS
     C/END-EXEC
      *
     C                   EVAL      DCL1Returned = SQLER3
      *
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or DCL1Returned = 0
     C                   EVAL      ERROR = 'Y'
     C                   EVAL      DBFILE = 'MDCL1'
     C                   EVAL      DBKEY = COMSJ0DS.DHCOTT + ' ' +
     C                                     COMSJ0DS.DHCSEQ
     C                   EVAL      DBPGM = 'CB000001'
     C                   EVAL      DBASE = 3
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** CLOSE
     C/EXEC SQL
     C+ close DCL1Cur
     C/END-EXEC
      *

     C                   EVAL      CBMDIndex = 1
      *
      ** Read all records on CBMDCNL1 datastructure
      ** and if conditions are not met
      *
     C                   DOW       CBMDIndex <= DCL1Returned
     C                             and not ConditionsMet
     C                   EVAL      %Occur(CBMDCNDS) = CBMDIndex
      *
      ** Processing to check if module is on
      *
      ** Set up work fields
     C                   EVAL      MATCH = True
     C                   EVAL      MODIndex = 1
      *
     C                   DOW       MODIndex <= 10
     C                             And Match

     C                   EVAL-CORR MODID = CBMDCNDS
     C                   EVAL-CORR MODON = CBMDCNDS
      *
      ** Reset MOIIndex for lookup of module ID's array
      *
     C                   EVAL      MOIIndex = 1
      *
      ** Process if module ID exists
      *
     C                   IF        MOD(MODIndex) <> *Blanks
      *
      ** Check if module id is valid and ON. If SD
      ** which is assumed to exist and be on,
      ** is OFF, this will trigger a database error
      *
     C                   IF        MOD(MODIndex) <> 'SD'
     C                             or
     C                             MOD(MODIndex) = 'SD' and
     C                             MOO(MODIndex) = 'N'

     C                   EVAL      MOIIndex = %LookUp(
     C                             MOD(MODIndex):MODPOS:MOIIndex)
      *
     C                   IF        MOIIndex = 0
     C                   EVAL      ERROR = 'Y'
     C                   EVAL      DBFILE = 'MDCL1'
     C                   EVAL      DBKEY = MOD(MODIndex)
     C                   EVAL      DBPGM = 'CB000001'
     C                   EVAL      DBASE = 4
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Determine whether module exists and is on in
      ** system and set up match field as required
      *
     C                   IF        MOO(MODIndex) = 'Y' and
     C                             SMOD(MOIIndex) = 'N'
     C                             or
     C                             MOO(MODIndex) = 'N' and
     C                             SMOD(MOIIndex) = 'Y'
      *
     C                   EVAL      Match = False
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      MODIndex += 1
     C                   ENDDO
      *
      ** If Match, set up conditions met field else
      ** read next record from CBMDCNL1 data structure
      *
     C                   IF        Match
     C                   EVAL      ConditionsMet = True
     C                   ELSE
     C                   EVAL      CBMDIndex += 1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Processing to check Module ID
      *
      ** Set up work fields
     C                   EVAL      Match = True
     C                   EVAL      MOIIndex = 1
      *
      ** Determine whether main module exists - NOT CHECKED
      ** for SD module this is assumed to exist in all systems
      *
     C                   IF        COMSJ0DS.DHCMOD <> 'SD'
      *
     C                   EVAL      MOIIndex = %LookUp(
     C                                        COMSJ0DS.DHCMOD:
     C                                        MODPOS:MOIIndex)
     C                   IF        MOIIndex = 0
     C                   EVAL      Error = 'Y'
     C                   EVAL      DBFILE = 'CMPPD'
     C                   EVAL      DBKEY = COMSJ0DS.DHCMOD
     C                   EVAL      DBPGM = 'CB000001'
     C                   EVAL      DBASE = 5
     C                   EXSR      DBERR
     C                   END
      *
      ** Check if module is off in system
      *
     C                   IF        SMOD(MOIIndex) = 'N'
     C                   EVAL      Match = False
     C                   ENDIF
     C*
     C                   ENDIF
      *
      ** Update components file if required today
      *
      ** If there is a match and conditions are met,
      ** Check if component name/seq exist in CBCOMSL0 then
      ** setup fields needed to be changed then update if exists
      *
     C                   IF        Match and ConditionsMet
      *
     C/EXEC SQL
     C+ select * into :CBCOMSDS
     C+  from CBCOMSL0
     C+  where DHCOTT = :COMSJ0DS.DHCOTT
     C+        and DHCSEQ = :COMSJ0DS.DHCSEQ
     C/END-EXEC
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or CBCOMSDS.DHCOTT = *Blanks
     C                   Eval      ERROR = 'Y'
     C                   Eval      DBFILE = 'CMPL0'
     C                   Eval      DBKEY = COMSJ0DS.DHCOTT + ' ' +
     C                                     COMSJ0DS.DHCSEQ
     C                   Eval      DBPGM = 'CB000001'
     C                   Eval      DBASE = 6
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
     C                   IF        CRT001 = 'Y' and
     C                             CRT002 = 'Y' and
     C                             COMSJ0DS.ACSARN = 'CRT002'
     C                   EVAL      CBCOMSDS.DHCRQD = 'N'
     C                   ELSE
     C                   EVAL      CBCOMSDS.DHCRQD = 'Y'
     C                   ENDIF
      *
     C                   IF        CSC054 = 'Y' and
     C                             WPEA = 'Y' and
     C                             CBCOMSDS.DHCRQD = 'Y' and
     C                             CBCOMSDS.DHCOTT = PEACOM
     C                   EVAL      CBCOMSDS.DHCHTA = 'Y'
     C                   EVAL      CBCOMSDS.DHCHTB = 'Y'
     C                   ENDIF
      *
      ** Update fields changed to CBCOMSL0
      ** Raise error if update failed
      *
     C/EXEC SQL
     C+ update CBCOMSL0
     C+  set
     C+   DHCRQD = :CBCOMSDS.DHCRQD,
     C+   DHCHTA = :CBCOMSDS.DHCHTA,
     C+   DHCHTB = :CBCOMSDS.DHCHTB
     C+  where DHCOTT = :CBCOMSDS.DHCOTT
     C+    and DHCSEQ = :CBCOMSDS.DHCSEQ
     C/END-EXEC
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or SQLER3 = 0
     C                   EVAL      ERROR = 'Y'
     C                   EVAL      DBFILE = 'CMPL0'
     C                   EVAL      DBKEY = COMSJ0DS.DHCOTT + ' ' +
     C                                     COMSJ0DS.DHCSEQ
     C                   EVAL      DBPGM = 'CB000001'
     C                   EVAL      DBASE = 7
     C                   EXSR      DBERR
     C
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Save Component Name/Component Sequence number as
      ** last record read
      *
     C                   EVAL      PrvCom
     C                              = COMSJ0DS.DHCOTT
     C                   EVAL      PrvSeq
     C                              = COMSJ0DS.DHCSEQ
      *
      ** Read next record from CBCOMSJ0 data structure
      *
     C                   EVAL      COMSIdx += 1
     C                   ENDDO
     C                   EVAL      MLoopCtr -= 1
     C                   ENDDO
      *
      ** CLOSE
      *
     C/EXEC SQL
     C+ close COMSCur
     C/END-EXEC
      *
      ** End Program
      *
     C                   RETURN
      *
      /EJECT
      *************************************************************
      *
      ** Initial Subroutine
      *
      *************************************************************
     C     *InzSR        BEGSR
      *
     C     *Entry        PLIST
     C                   PARM                    Error
      *
      **  Check if SAR CRT001 and CRT002 are on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CRT001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CRT001 = 'Y'
     C                   ELSE
     C                   EVAL      CRT001 = 'N'
     C                   ENDIF
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CRT002 = 'Y'
     C                   ELSE
     C                   EVAL      CRT002 = 'N'
     C                   END
      *
      ** Check if CSC054 Period End Adjustments is Switched On
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC054'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CSC054 = 'Y'
     C                   ELSE
     C                   EVAL      CSC054 = 'N'
     C                   ENDIF
      *
      ** Check PEA Indicator
      *
     C                   IF        CSC054 = 'Y'
     C/EXEC SQL
     C+ select GIVAL into :WPEA
     C***from*SDSVALPD                                                                      MD054605
     C+  from SDSVLJW0                                                                      MD054605
     C+  where GISVAL = :PEAIND
     C/END-EXEC
     C                   ENDIF
      *
     C                   ENDSR
     C*
     C*************************************************************
      /EJECT
      *************************************************************
      *
      ** S/R DBERR to perform database ERROR exit from program
      ** Called from Main Cycle
      ** Calls no other subroutines
      *
      *************************************************************
      *
     C     DBERR         BEGSR
      *
      ** SetOn indicators U7 U8
      ** and return to calling program
      *
     C                   SETON                                        U7U8
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
**CTDATA MODPOS

      MT#A#B#C  #E#FGL
DL  EMFMSTLEREMSSERC#G
FDCMFXMMABFTCAFF  #I#J
#KMEIRDLDLTMRMTKMQMFIA
                  PM
      CF          LB
          CP  OD
          HFMC      ED
AACGPLTIPB


