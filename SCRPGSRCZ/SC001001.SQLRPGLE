     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC CoB Optimisation Manager Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC001001 - CoB Optimisation Manager Maintenance              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD024412           Date 09May14               *
      *  Prev Amend No. AR1090366          Date 21Feb13               *
      *                 CCB022A *REWRITE   Date 06Aug12               *
      *                 CCB022  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024412 - Additional changes for COM processing             *
      *  AR1090366 - Deliverable data for SCCOMMTD and SCCOMXTD       *
      *            - were delivered, files are in DMLIB (Recompile)   *
      *  CCB022 - COB Restructure - COB File Manager (rewrite)        *
      *  CCB022 - COB Restructure - COB File Manager                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *       20  Column Heading display                              *
      *       21  Selection on subfile Error Indicator                *
      *       22  SFLDSPCTL                                           *
      *       23  SFLDSP                                              *
      *       24  SFLEND                                              *
      *       25  SFLEND Message Indicator                            *
      *       26  Logically Del. Error Indicator                      *
      *       27  Protected fields for Core record                    *
      *       28  Protected field DFMODE for Bespoke record           *
      *       29  Error Indicator for Complex Condition               *
      *       30  Error Indicator for Type                            *
      *       31  Error Indicator for Name                            *
      *       32  Error Indicator for Sequence or Member              *
      *       33  Error Indicator for Module/Feature/Section          *
      *       34  Error Indicator for Condition                       *
      *       35  Error Indicator for Mode                            *
      *       36  Proctected field for Mode on Insert                 *
      *       37  SFLCLR                                              *
      *       38  PR Logically deleted field in DSPF                  *
      *       39  Disable INKF                                        *
      *       40  Disable INKJ                                        *
      *       41  Disable INKC                                        *
      *       42  Display of DFCCSQ for Amend                         *
      *       43  Error Indicator for DFCCSQ                          *
      *       44  PR Field DFCCSQ                                     *
      *       45  Error Indicator for DFSCTD                          *
      *       49  SFLNXTCHG indicator                                 *
      *       50  Confirm Indicator for Setting LDEL to Y             *
      *       51  F12 Indicator for Second screen                     *
      *       60  If record is found on validation of CCSQ            *
      *       86  OVERLAY PUTOVER indicator on Error Messages         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *  ZASNMS - Send message to program's message queue             *
      *  LDSUBF - Display all record to subfile                       *
      *  MVDFTR - Moves display file fields to record                 *
      *  MVRTDF - Moves data fields to display file                   *
      *  CLRRFD - Clear Record fields                                 *
      *  CLRFLD - Clear Display File Fields                           *
      *  CLEAR  - Clears the Error Messages on the subfile            *
      *  RSTIND - Reset Error Indicators                              *
      *  EXIT   - Exit Program                                        *
      *  ADDRCD - Process the screen of insert                        *
      *  PERMAD - Permanent Add Processing                            *
      *  VALFLD - Process the screen of insert                        *
      *  INSRCD - Process the screen of insert                        *
      *  AMDRCD - Amend/Update selected record                        *
      *  DELRCD - Delete selected record                              *
      *  GETRCD - Loads the selected record to second screen          *
      *  CKBLNK - Check complex condition blanks                      *
      *  CHKCON - Check Condition if met                              *
      *  CHKSTS - Checks if the condition is the same with            *
      *           the module's/feature's current status               *
      *  CHCKLF - Checks the file name if it is an LF                 *
      *  VALFIL - Validate when type is File                          *
      *  VALCMP - Validate when type is Component                     *
      *  VALEXC - Validate when type is Exclusion                     *
      *  UPPERC - Converts to Upper case                              *
      *  DSPSCD - Display Section Description Screen                  *
      *  VLCCSQ - Validate Complex Condition Sequence if Amend        *
      *  CKCCSQ - Check Latest Complex Condition Sequence             *
      *  RECDEL - Deletes Record that are Logically Deleted 'Y'       *
      *           and Mode is 'Bespoke'                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Display File
     FSC001001DFCF   E             WORKSTN
     F                                     SFILE(SC00101S0:RdCtr)
 
      ** Midas modules information
     FSDMMIDL0  IF   E           K DISK
 
      ** Midas Switchable Features
     FSCSARSL0  IF   E           K DISK
 
      ** Midas Components
     FCBCMPNL0  IF   E           K DISK
 
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFUSER                254    263
 
      ** Constant Variables
     D Num             C                   '0123456789'
     D LoCase          C                   'abcdefghijklmnopqrstuvwxyz'
     D UpCase          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** Declared Variables
     D WRun            S              1A
     D RdCtr           S             10  0
     D Ccsq            S              3  0
     D WwSqmr          S             10  0
     D Pos             S              3  0
     D TotRow          S             13  0
     D WSrcfnm         S             11A
     D WCcsq           S              3A
     D WCseq           S              5A
     D WMbr            S             10A
     D WUniq           S               Z
     D WName           S             10A
 
      ** SCC001001 Parameters
     D RtCd            S              7
     D PMode           S              4
     D PName           S             10
     D PMbr            S             10
     D***Ptype**         S              1                                                   MD024412
     D Ptype           S              6                                                     MD024412
 
      ** Key Fields
     D PCott           S             10
     D PCseq           S              5
     D KFeat           S              6
     D KMod            S             10
 
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
 
      ** Error Indicators
     D ErIOff          S             11
     D ErrInd          S              1
 
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
 
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7
 
      ** CHKCON Variables
     D PRtcd           S              7
     D POptn           S              7
     D PSard           S              6
     D WAnd            S              1
     D WStat           S              1
     D WIgnore         S              1
     D IsMet           S              1
     D FstDel          S              1
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D ComDS         E DS                  EXTNAME(SCCOMJK0)
 
      ** Main Process
 
     C                   DOW       *INKC = '0'
 
      ** Display Column Headings on Subfile
 
     C                   EVAL      *IN20 = *ON
 
      ** Process First Screen
 
     C                   EXSR      LDSUBF
 
      ** End program if F3 is Pressed
 
     C     *INKC         CASEQ     '1'           EXIT
 
      ** Execute Insert Screen when F6 is Pressed
 
     C     *INKF         CASEQ     '1'           ADDRCD
 
      ** Check if Amend or Delete
 
     C     SRCFNM        CASEQ     *BLANKS       GETRCD
 
     C                   ENDCS
     C                   ENDDO
 
      ** End of Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  GETRCD - Get the record selected from the display file       *
      *                                                               *
      *****************************************************************
     C     GETRCD        BEGSR
 
      ** Read changed record and process it
 
     C                   READC     SC00101S0                              80
     C                   DOW       *IN80 = '0'
     C                   SELECT
 
      ** If Delete
 
     C                   WHEN      AMDDEL = 'D'
 
     C                   IF        DFDEL = 'No'
 
     C                   EXSR      DELRCD
 
     C                   DOW       *INKJ = '0' AND *INKL = '0'
     C                   EXSR      DELRCD
     C                   ENDDO
 
      ** Error if record is Logically del is No.
 
     C                   ELSE
     C                   EVAL      ZAMSID = 'CBM0281'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN49 = *ON
 
     C                   UPDATE    SC00101S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
 
      ** If Amend
 
     C                   WHEN      AMDDEL = 'A'
 
     C                   EXSR      AMDRCD
 
     C                   DOW       ErrInd = 'Y' AND *INKL = '0' OR *INKE = '1'
     C                   EXSR      AMDRCD
     C                   ENDDO
 
      ** If AMDDEL is not 'A' or 'D'
 
     C                   WHEN      AMDDEL <> 'A' AND AMDDEL <> 'D' AND
     C                             AMDDEL <> ' '
     C                   EVAL      ZAMSID = 'CBM0314'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN49 = *ON
 
     C                   UPDATE    SC00101S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDSL
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN49 = *OFF
     C                   EVAL      AMDDEL = ' '
 
     C                   UPDATE    SC00101S0
     C                   READC     SC00101S0                              80
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DELRCD - DELETE Record                                       *
      *                                                               *
      *****************************************************************
     C     DELRCD        BEGSR
 
      ** SETUP Display for Delete Screen
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN27 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN44 = *ON
 
     C                   WRITE     SC00101F0
     C                   WRITE     SC00101F5
 
      ** Display Error Message if ErrInd = Y
 
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   WRITE     SC00101C1
     C                   ENDIF
 
     C                   EXFMT     SC00101F2
 
      ** Reset Values
 
     C                   EXSR      CLEAR
     C                   EXSR      RSTIND
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      ErrInd = 'N'
 
      ** If F10 is Pressed update Logically Deleted to Yes
 
     C                   IF        *INKJ = '1'
 
     C/EXEC SQL
     C+ update SCCOMXTD set FMDEL = 'Y'
     C+ where FMUNIQ = :DFUNIQ
     C/END-EXEC
 
     C                   IF        DFTYPE = 'F'
     C                   EXSR      PERMAD
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        *INKL <> '1'
     C                   EVAL      ZAMSID = 'CBM0302'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AMDRCD - Amend Record                                        *
      *                                                               *
      *****************************************************************
     C     AMDRCD        BEGSR
 
      ** SETUP Display for Amend Screen
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
 
     C                   IF        DFTYPE = 'X'
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      DFCOND = *BLANK
     C                   EVAL      DFCPLX = *BLANKS
     C                   ENDIF
 
      ** Display on screen Complex Condition Sequence if type is not X
 
     C                   IF        DFTYPE <> 'X'
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      DFSCTD = *BLANKS
     C                   ENDIF
 
     C                   IF        DFMODE = 'Bespoke'
     C                   EVAL      *IN28 = *ON
     C                   ENDIF
 
     C                   IF        DFMODE = 'Core'
     C                   EVAL      *IN27 = *ON
     C                   ENDIF
 
     C                   WRITE     SC00101F0
     C                   WRITE     SC00101F4
 
      ** Display Error Message if ErrInd = Y
 
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   WRITE     SC00101C1
     C                   ENDIF
 
     C                   EXFMT     SC00101F2
 
      ** Reset Values
 
     C                   EXSR      CLEAR
     C                   EXSR      RSTIND
     C                   EVAL      ErrInd = 'N'
 
     C                   SELECT
 
      ** If F5 is Pressed Refresh
 
     C                   WHEN      *INKE = '1'
     C/EXEC SQL
     C+ select * into :COMDS from SCCOMJK0 where FMUNIQ = :DFUNIQ
     C/END-EXEC
     C                   EXSR      MVRTDF
     C                   EVAL      AMDDEL = 'A'
 
      ** If F12 is press go back to Main Screen
 
     C                   WHEN      *INKL = '1'
     C                   EVAL      AMDDEL = ' '
 
      ** Validations for Bespoke Records
 
     C                   WHEN      DFMODE = 'Bespoke'
 
     C                   EXSR      VALFLD
 
      ** if Type is X, Display Section Description
 
     C                   IF        DFTYPE = 'X' AND ErrInd <> 'Y'
     C                   EXSR      DSPSCD
 
     C                   DOW       ErrInd = 'Y' AND *IN51 = *OFF
     C                             OR *INKE = *ON
     C                   EXSR      DSPSCD
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        ErrInd <> 'Y'
 
     C                   EXSR      MVDFTR
     C/EXEC SQL
     C+ update SCCOMMTD set FMTYPE = :FMTYPE , FMNAME = :FMNAME,
     C+ FMCSEQ = :FMCSEQ , FMMBR = :FMMBR, FMMOD = :FMMOD,
     C+ FMFEAT = :FMFEAT, FMCOND = :FMCOND, FMCPLX = :FMCPLX,
     C+ FMSCTD = :FMSCTD
     C+ where FMUNIQ = :DFUNIQ
     C/END-EXEC
 
     C/EXEC SQL
     C+ update SCCOMXTD set FMDEL = :DFLDEL , FMCCSQ = :DFCCSQ
     C+ where FMUNIQ = :DFUNIQ
     C/END-EXEC
 
     C                   IF        DFTYPE = 'F' AND DFLDEL = 'Y'
     C                   EXSR      PERMAD
     C                   ENDIF
     C                   ENDIF
 
      ** Validations For Core Records
 
     C                   WHEN      DFMODE = 'Core'
 
     C                   EVAL      DFLDEL = %XLATE(LoCase:UpCase:DFLDEL)
 
      ** Error if DFDEL is not 'Yes' or 'No'
 
     C                   IF        DFLDEL <> 'Y'
     C                   IF        DFLDEL <> 'N'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0282'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN26 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** Process the input of Complex Condition sequence
      ** If File name and member or Component name and sequence
      ** is existing
 
     C                   IF        DFTYPE <> 'X'
 
     C                   EVAL      WCseq = *BLANKS
     C                   EVAL      WMbr = *BLANKS
 
     C                   IF        DFTYPE = 'C'
     C                   EVAL      WCseq = DFSQMR
     C                   ENDIF
 
     C                   IF        DFTYPE = 'F'
     C                   EVAL      WMbr = DFSQMR
     C                   ENDIF
 
     C                   EXSR      VLCCSQ
     C                   ENDIF
 
      ** if Type is X, Display Section Description
 
     C                   IF        DFTYPE = 'X' AND ErrInd <> 'Y'
     C                   EXSR      DSPSCD
 
     C                   DOW       *INKE = *ON AND *IN51 = *OFF
     C                   EXSR      DSPSCD
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        ErrInd <> 'Y'
 
     C/EXEC SQL
     C+ update SCCOMXTD set FMDEL = :DFLDEL , FMCCSQ = :DFCCSQ
     C+ where FMUNIQ = :DFUNIQ
     C/END-EXEC
     C                   IF        DFTYPE = 'F' AND DFLDEL = 'Y'
     C                   EXSR      PERMAD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INSRCD - Insert Record                                       *
      *                                                               *
      *****************************************************************
     C     INSRCD        BEGSR
 
      ** SETUP Display for Insert Screen
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      DFMODE = 'Bespoke'
 
     C                   WRITE     SC00101F0
     C                   WRITE     SC00101F4
 
      ** Display Error Message if ErrInd = Y
 
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   WRITE     SC00101C1
     C                   ENDIF
 
     C                   EXFMT     SC00101F2
 
      ** Reset Values
 
     C                   EXSR      CLEAR
     C                   EXSR      RSTIND
     C                   EVAL      ErrInd = 'N'
 
      ** Refresh fields
 
     C                   IF        *INKE = '1'
     C                   EVAL      DFTYPE = *BLANKS
     C                   EVAL      DFNAME = *BLANKS
     C                   EVAL      DFSQMR = *BLANKS
     C                   EVAL      DFMDFT = *BLANKS
     C                   EVAL      DFCOND = *BLANKS
     C                   EVAL      DFCPLX = *BLANKS
     C                   EVAL      DFSCTD = *BLANKS
     C                   EVAL      DFLDEL = *BLANKS
     C                   ENDIF
 
      ** Process Validation if F12 is not pressed
 
     C                   IF        *INKL = '0' AND *INKE = '0'
     C                   EXSR      VALFLD
 
      ** if Type is X, Display Section Description
 
     C                   IF        DFTYPE = 'X' AND ErrInd <> 'Y'
     C                   EXSR      DSPSCD
 
     C                   DOW       ErrInd = 'Y' AND *IN51 = *OFF
     C                             OR *INKE = *ON
     C                   EXSR      DSPSCD
     C                   ENDDO
     C                   ENDIF
 
      ** Insert the record if there is no error
 
     C                   IF        ErrInd <> 'Y'
 
     C                   EXSR      MVDFTR
 
      ** Generate TimeStamp
 
     C                   CALL      'ZAGENTS'
     C                   PARM                    FMUNIQ
 
     C/EXEC SQL
     C+ insert into SCCOMMTD (FMUNIQ, FMMODE, FMTYPE, FMNAME,
     C+ FMCSEQ, FMMBR, FMMOD, FMFEAT, FMCOND, FMCPLX, FMSCTD)
     C+ values (:FMUNIQ, :FMMODE, :FMTYPE, :FMNAME, :FMCSEQ,
     C+ :FMMBR, :FMMOD, :FMFEAT, :FMCOND, :FMCPLX, :FMSCTD)
     C/END-EXEC
 
     C/EXEC SQL
     C+ insert into SCCOMXTD (FMUNIQ, FMMODE, FMCCSQ, FMDEL)
     C+ values (:FMUNIQ, :FMMODE, :FMCCSQ, :FMDEL)
     C/END-EXEC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALFLD - Validate Fields                                     *
      *                                                               *
      *****************************************************************
     C     VALFLD        BEGSR
 
     C                   EXSR      UPPERC
     C                   SELECT
 
      ** If Type is File or 'F'
 
     C                   WHEN      DFTYPE = 'F'
     C                   EXSR      VALFIL
 
      ** If Type is Component or 'C'
 
     C                   WHEN      DFTYPE = 'C'
     C                   EXSR      VALCMP
 
      ** If Type is 'X' Exclusion
 
     C                   WHEN      DFTYPE = 'X'
     C                   EXSR      VALEXC
 
      ** Error If Type is not 'F' , 'C' and 'X'
 
     C                   OTHER
 
     C                   IF        DFTYPE = *BLANK
     C                   EVAL      ZAMSID = 'CBM0285'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0286'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN30 = *ON
     C
     C                   ENDSL
 
      ** Check if Module or Switchable Feature is existing
 
     C                   SELECT
     C                   WHEN      DFTYPE <> 'X'
 
     C                   IF        DFMDFT = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0299'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      DFMOD = *BLANKS
     C                   EVAL      DFFEAT = *BLANKS
     C                   EVAL      *IN33 = *ON
 
     C                   ELSE
 
     C                   EVAL      KMod = %TRIM(DFMDFT)
     C                   EVAL      KFeat = %TRIM(DFMDFT)
 
     C     KMod          CHAIN     SDMMIDL0
     C                   IF        NOT %FOUND(SDMMIDL0)
     C     KFeat         CHAIN     SCSARSL0
     C                   IF        NOT %FOUND(SCSARSL0)
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0287'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN33 = *ON
 
      ** Move to DFFEAT if Feature is existing
 
     C                   ELSE
     C                   EVAL      DFFEAT = %TRIM(DFMDFT)
     C                   EVAL      DFMOD = *BLANKS
     C                   ENDIF
 
      ** Move to DFMOD if Module is existing
 
     C                   ELSE
     C                   EVAL      DFMOD = %TRIM(DFMDFT)
     C                   EVAL      DFFEAT = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Default Condition to *OFF if it is blank
 
     C                   IF        DFCOND = *BLANKS
 
     C                   IF        DFTYPE = 'C' or DFTYPE = 'F'
     C                   EVAL      DFCOND = '*OFF'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DFCOND <> '*ON '
     C                   IF        DFCOND <> '*OFF'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0288'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN34 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Error if Complex Condition is not Blank, *AND, or *OR
 
     C                   IF        DFCPLX <> *BLANKS
     C                   IF        DFCPLX <> '*AND'
     C                   IF        DFCPLX <> '*OR '
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0290'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN29 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Process the input of Complex Condition sequence
      ** If File name and member or Component name and sequence
      ** is existing
 
     C                   EVAL      WCseq = *BLANKS
     C                   EVAL      WMbr = *BLANKS
 
     C                   IF        DFTYPE = 'C'
     C                   EVAL      WCseq = DFSQMR
     C                   ENDIF
 
     C                   IF        DFTYPE = 'F'
     C                   EVAL      WMbr = DFSQMR
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      AMDDEL = 'A'
     C                   EXSR      VLCCSQ
 
     C                   WHEN      AMDDEL = ' '
     C                   EXSR      CKCCSQ
     C                   ENDSL
 
     C                   WHEN      DFTYPE = 'X'
 
     C                   IF        AMDDEL = 'A' AND DFTYPE = 'X'
     C                   EVAL      DFCOND = *BLANKS
     C                   EVAL      DFCPLX = *BLANKS
     C                   EVAL      DFCCSQ = *BLANKS
     C                   ENDIF
 
      ** If Type is X, Condition and Complex Condition must be blank.
 
     C                   IF        DFCOND <> *BLANKS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0304'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN34 = *ON
     C                   ENDIF
 
     C                   IF        DFCPLX <> *BLANKS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0305'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN29 = *ON
     C                   ENDIF
 
     C                   ENDSL
 
      ** Default Logically Deleted to 'N' if type is not 'X' and blank
      ** Default to Y if type is X and blank
 
     C                   IF        DFLDEL = *BLANKS
 
     C                   IF        DFTYPE = 'X'
     C                   EVAL      DFLDEL = 'Y'
     C                   ENDIF
 
     C                   IF        DFTYPE = 'C' OR DFTYPE = 'F'
     C                   EVAL      DFLDEL = 'N'
     C                   ENDIF
 
     C                   ELSE
 
      ** Error if Logically Deleted is not 'Y' or 'N'
 
     C                   IF        DFLDEL <> 'Y'
     C                   IF        DFLDEL <> 'N'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0282'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN26 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MVDFTR - Moves display file fields to record                 *
      *                                                               *
      *****************************************************************
     C     MVDFTR        BEGSR
 
     C                   EVAL      FMTYPE = DFTYPE
     C                   EVAL      FMNAME = DFNAME
     C                   EVAL      FMCSEQ = DFCSEQ
     C                   EVAL      FMMBR = DFMBR
     C                   EVAL      FMMOD = DFMOD
     C                   EVAL      FMFEAT = DFFEAT
     C                   EVAL      FMCOND = DFCOND
     C                   EVAL      FMCPLX = DFCPLX
     C                   EVAL      FMCCSQ = DFCCSQ
     C                   EVAL      FMMODE = DFMODE
     C                   EVAL      FMDEL = DFLDEL
     C                   EVAL      FMSCTD = DFSCTD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKBLNK - Checks the record if a combination has 2 or more    *
      *           Blank Complex Condition                             *
      *                                                               *
      *****************************************************************
     C     CKBLNK        BEGSR
 
     C/EXEC SQL
     C+ declare CBCursor insensitive scroll cursor for
     C+ select * from SCCOMJK0
     C+ where FMCPLX = '    ' and FMCCSQ <> '001' and FMTYPE <> 'X'
     C/END-EXEC
 
     C/EXEC SQL
     C+ open CBCursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/END-EXEC
 
     C                   IF        TotRow  > 0
     C                   EVAL      ZAMSID = 'CBM0294'
     C                   EXSR      ZASNMS
     C                   EVAL      ErrInd = 'Y'
     C                   ENDIF
 
     C/EXEC SQL
     C+ close CBCursor
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RSTIND - Reset Error Indicators                               *
      *                                                               *
      *****************************************************************
     C     RSTIND        BEGSR
 
      ** Set off Error Indicators
 
     C                   MOVEA     ErIOff        *IN(26)
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN86 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CLEAR - Clears the Error Messages on the subfile              *
      *                                                               *
      *****************************************************************
     C     CLEAR         BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DFPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLRRFD - Clear Record fields                                 *
      *                                                               *
      *****************************************************************
     C     CLRRFD        BEGSR
 
     C                   EVAL      FMTYPE = *BLANKS
     C                   EVAL      FMNAME = *BLANKS
     C                   EVAL      FMCSEQ = *BLANKS
     C                   EVAL      FMMBR  = *BLANKS
     C                   EVAL      FMMOD  = *BLANKS
     C                   EVAL      FMFEAT = *BLANKS
     C                   EVAL      FMCOND = *BLANKS
     C                   EVAL      FMCPLX = *BLANKS
     C                   EVAL      FMCCSQ = '000'
     C                   EVAL      FMMODE = *BLANKS
     C                   EVAL      FMDEL = *BLANKS
     C                   EVAL      FMSCTD = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLRFLD - Clear Display File Fields                           *
      *                                                               *
      *****************************************************************
     C     CLRFLD        BEGSR
 
     C                   EVAL      DFTYPE = *BLANKS
     C                   EVAL      DFNAME = *BLANKS
     C                   EVAL      DFSQMR = *BLANKS
     C                   EVAL      DFCSEQ = *BLANKS
     C                   EVAL      DFMBR  = *BLANKS
     C                   EVAL      DFMDFT = *BLANKS
     C                   EVAL      DFMOD  = *BLANKS
     C                   EVAL      DFFEAT = *BLANKS
     C                   EVAL      DFCOND = *BLANKS
     C                   EVAL      DFCPLX = *BLANKS
     C                   EVAL      DFCCSQ = *BLANKS
     C                   EVAL      DFMODE = *BLANKS
     C                   EVAL      DFDEL = *BLANKS
     C                   EVAL      DFLDEL = *BLANKS
     C                   EVAL      DFSCTD = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PERMAD - Permanent Add Processing                            *
      *                                                               *
      *****************************************************************
     C     PERMAD        BEGSR
 
     C                   EXSR      CHKCON
     C                   IF        IsMet = 'N'
     C                   EVAL      PMode = '*ADD'
     C                   EVAL      PName = DFNAME
     C                   EVAL      PMbr = DFMBR
     C                   EVAL      PType = 'F'
 
      ** Call Generic program that add/remove members
 
     C**********         CALL      'SC001004'                                               MD024412
     C**********         PARM                    PMode                                      MD024412
     C**********         PARM                    PName                                      MD024412
     C**********         PARM                    PMbr                                       MD024412
     C**********         PARM                    PType                                      MD024412
     C                   CALL      'SCC001007'                                              MD024412
     C                   PARM                    PName                                      MD024412
     C                   PARM                    PMbr                                       MD024412
     C                   PARM                    PMode                                      MD024412
     C                   PARM      *BLANKS       PType                                      MD024412
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKCON - Check condition if met                              *
      *                                                               *
      *****************************************************************
     C     CHKCON        BEGSR
 
     C                   EVAL      WAnd = '0'
     C                   EVAL      IsMet = ' '
 
      ** Main Processing. Read through contents of SCCOMJK0.
      ** Only process FMTYPE = 'F' and FMDEL = 'N'
 
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from SCCOMJK0
     C+ where FMTYPE = 'F' and FMDEL = 'N'
     C+ and FMNAME = :DFNAME and FMCSEQ = :DFCSEQ and
     C+ FMMBR = :DFMBR
     C+ order by FMTYPE, FMNAME, FMCSEQ, FMMBR, FMCCSQ
     C/END-EXEC
 
     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ fetch next from ACursor into :COMDS
     C/END-EXEC
     C                   EVAL      WIgnore = 'N'
 
     C                   DOW       SQLCODE = 0
 
      ** Check if first record is deleted
 
     C                   IF        DFNAME = FMNAME AND DFSQMR = FMMBR
     C                             AND FMCCSQ = '1' AND FMDEL = 'Y'
     C                   EVAL      FstDel = 'Y'
     C                   ENDIF
 
     C                   IF        DFNAME = FMNAME AND DFSQMR = FMMBR
     C                             AND FMDEL = 'N'
 
      ** Set Complex condition to blank if first record was deleted
 
     C                   IF        FstDel = 'Y'
     C                   EVAL      FMCPLX = *BLANKS
     C                   ENDIF
     C                   EVAL      FstDel = 'N'
 
      ** If WIgnore = 'Y', condition was already met.
      ** No need to process further.
 
     C                   IF        WIgnore = 'N'
 
      ** Check the status of Switchable Feature or Module
      ** against FMCOND if it is satisified.
 
     C                   EXSR      CHKSTS
 
     C                   IF        FMCPLX = *BLANKS
     C                   EVAL      WAnd = WStat
     C                   ENDIF
 
     C                   IF        FMCPLX = '*AND'
     C                   IF        WAnd = '1' AND WStat = '1'
     C                   EVAL      WAnd = '1'
     C                   ELSE
     C                   EVAL      WAnd = '0'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        FMCPLX = '*OR'
     C                   IF        WAnd = '1'
     C                   EVAL      WIgnore = 'Y'
     C                   ELSE
 
      ** Start all over
 
     C                   EVAL      WAnd = WStat
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C/EXEC SQL
     C+ fetch next from ACursor into :COMDS
     C/END-EXEC
     C                   ENDDO
     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC
 
      ** Evaluation for the last set of complex conditions.
 
     C                   IF        WAnd = '0'
     C                   EVAL      IsMet = 'N'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKSTS - This subroutine checks if the condition is the      *
      *           same with the module's/feature's current status.    *
      *                                                               *
      *****************************************************************
     C     CHKSTS        BEGSR
 
      ** If Switchable Feature is specified.
 
     C                   IF        FMFEAT <> *BLANKS
     C
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      FMFEAT        PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      WStat = '0'
     C                   IF        PRtcd = *BLANKS AND FMCOND = '*ON'
     C                   EVAL      WStat = '1'
     C                   ENDIF
     C                   IF        PRtcd <> *BLANKS AND FMCOND = '*OFF'
     C                   EVAL      WStat = '1'
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Module Name is specified.
 
     C                   IF        FMMOD <> *BLANKS
 
     C     FMMOD         CHAIN     SDMMIDL0
 
     C                   EVAL      WStat = '0'
     C                   IF        FOMMIN = 'Y' AND FMCOND = '*ON'
     C                   EVAL      WStat = '1'
     C                   ENDIF
     C                   IF        FOMMIN = 'N' AND FMCOND = '*OFF'
     C                   EVAL      WStat = '1'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LDSUBF - Load Subfile                                        *
      *                                                               *
      *****************************************************************
     C     LDSUBF        BEGSR
 
      ** Clear SFL
 
     C                   IF        ErrInd <> 'Y' AND *IN21 = *OFF
     C                             OR *INKE = *ON
     C                   EVAL      *IN37 = *ON
     C                   WRITE     SC00101C0
     C                   EVAL      *IN37 = *OFF
     C                   Z-ADD     0             RdCtr
     C                   ENDIF
 
      ** Seton Control
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
 
      ** Display all records if SRCFNM is blank
 
     C                   IF        SRCFNM = *BLANKS
     C                   EVAL      WSrcfnm = '%'
     C                   ELSE
     C                   EVAL      WSrcfnm = %TRIMR(SRCFNM) + '%'
     C                   ENDIF
 
     C/EXEC SQL
     C+ declare COMCursor insensitive scroll cursor for
     C+ select * from SCCOMJK0
     C+ where FMNAME like trim(:WSrcfnm)
     C+ order by FMTYPE , FMNAME, FMCSEQ, FMMBR, FMCCSQ
     C/END-EXEC
 
     C/EXEC SQL
     C+ open COMCursor
     C/END-EXEC
 
      ** Get the number of rows of the selected records
 
     C/EXEC SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/END-EXEC
 
     C/EXEC SQL
     C+ fetch next from COMCursor into :ComDS
     C/END-EXEC
 
      ** Process if no record on file
 
     C                   IF        SQLCODE = 100 AND SRCFNM = *BLANKS
     C                   EVAL      SRCFNM = *BLANKS
 
     C                   DOW       *INKC ='0' AND *INKF = '0'
     C                   EXSR      CLRFLD
     C                   EVAL      *IN86 = *ON
 
     C                   WRITE     SC00101F0
     C                   WRITE     SC00101F1
     C                   EVAL      ZAMSID = 'CBM0293'
     C                   EXSR      ZASNMS
 
     C                   WRITE     SC00101C1
     C                   EXFMT     SC00101F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      CLEAR
     C                   EXSR      RSTIND
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      SRCFNM = *BLANKS
 
      ** Load records to subfile
 
     C                   IF        ErrInd <> 'Y' AND *IN21 = *OFF
     C                             OR *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                   ADD       1             RdCtr
     C                   EXSR      MVRTDF
     C                   WRITE     SC00101S0
     C                   EXSR      CLRRFD
     C                   EXSR      CLRFLD
     C/EXEC SQL
     C+ fetch next from COMCursor into :ComDS
     C/END-EXEC
     C                   ENDDO
     C                   ENDIF
 
      ** Load Screen
 
     C                   WRITE     SC00101F0
     C                   WRITE     SC00101F1
 
      ** Display Error Message if ErrInd = Y
 
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   WRITE     SC00101C1
     C                   ENDIF
 
     C                   EXFMT     SC00101C0
 
      ** Reset Values
 
     C                   IF        *INKE = *ON OR *INKF = *ON
     C                   READC     SC00101S0                              80
 
     C                   DOW       *IN80 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN49 = *OFF
     C                   EVAL      AMDDEL = ' '
 
     C                   UPDATE    SC00101S0
     C                   READC     SC00101S0                              80
     C                   ENDDO
     C                   ENDIF
 
     C                   EXSR      CLEAR
     C                   EXSR      RSTIND
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/EXEC SQL
     C+ close COMCursor
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CHCKLF - Check if file and member is existing and an LF      *
      *                                                               *
      *****************************************************************
     C     CHCKLF        BEGSR
 
     C                   CALL      'SCC001001'
     C                   PARM                    DFNAME
     C                   PARM      *BLANKS       RtCd
     C                   PARM                    PMbr
 
     C                   IF        RtCd = *BLANKS
     C                   EVAL      DFMBR = %TRIM(DFSQMR)
 
     C                   ELSE
     C                   IF        Rtcd = '*NRF'
     C                   EVAL      ZAMSID = 'CBM0295'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   IF        Rtcd = '*ERROR'
     C                   EVAL      ZAMSID = 'CBM0303'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   IF        DFSQMR <> '*FILE'
     C                   IF        DFSQMR <> '*ALL '
     C                   EVAL      ZAMSID = 'CBM0283'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MVRTDF - Moves data fields to display file                   *
      *                                                               *
      *****************************************************************
     C     MVRTDF        BEGSR
 
     C                   EVAL      AMDDEL = ' '
     C                   EVAL      DFUNIQ = FMUNIQ
     C                   EVAL      DFTYPE = FMTYPE
     C                   EVAL      DFNAME = FMNAME
     C                   EVAL      DFCSEQ = FMCSEQ
     C                   EVAL      DFMBR = FMMBR
     C                   EVAL      DFMOD = FMMOD
     C                   EVAL      DFFEAT = FMFEAT
     C                   EVAL      DFCPLX = FMCPLX
     C                   EVAL      DFCCSQ = FMCCSQ
     C                   EVAL      DFLDEL = FMDEL
     C                   EVAL      DFCOND = FMCOND
     C                   EVAL      DFSCTD = FMSCTD
 
     C                   IF        FMTYPE = 'F'
     C                   EVAL      DFSQMR  = %TRIM(FMMBR)
     C                   EVAL      DFTYPD  = 'File'
     C                   ENDIF
 
     C                   IF        FMTYPE = 'C'
     C                   EVAL      DFSQMR  = %TRIM(FMCSEQ)
     C                   EVAL      DFTYPD  = 'Component'
     C                   ENDIF
 
     C                   IF        FMTYPE = 'X'
     C                   EVAL      DFSQMR  = %TRIM(FMCSEQ)
     C                   EVAL      DFMDFT  = %TRIM(FMMBR)
     C                   EVAL      DFTYPD  = 'Exclusion'
     C                   ENDIF
 
     C                   IF        DFTYPE <> 'X'
     C                   IF        FMFEAT <> *BLANKS
     C                   EVAL      DFMDFT = FMFEAT
     C                   ELSE
     C                   EVAL      DFMDFT = FMMOD
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        FMMODE = 'C'
     C                   EVAL      DFMODE = 'Core'
     C                   ELSE
     C                   EVAL      DFMODE = 'Bespoke'
     C                   ENDIF
 
     C                   IF        FMDEL = 'Y'
     C                   EVAL      DFDEL = 'Yes'
     C                   ELSE
     C                   EVAL      DFDEL = 'No'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALFIL - Validate when type is File                          *
      *                                                               *
      *****************************************************************
     C     VALFIL        BEGSR
 
      ** Default Member to *FILE if blank
 
     C                   IF        DFSQMR = *BLANKS
     C                   EVAL      DFSQMR = '*FILE'
     C                   ENDIF
 
      ** if Member is not *FILE or *ALL check if member is existing
 
     C                   IF        %TRIM(DFSQMR) = '*FILE' OR
     C                             %TRIM(DFSQMR) = '*ALL'
     C                   EVAL      PMbr = '*NONE    '
     C                   ELSE
     C                   EVAL      PMbr = %TRIM(DFSQMR)
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      DFNAME = *BLANK
     C                   EVAL      ZAMSID = 'CBM0297'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   WHEN      DFNAME <> *BLANK
     C                   EXSR      CHCKLF
     C                   ENDSL
 
      ** If Type is F CSEQ must be blank
 
     C                   EVAL      DFCSEQ = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALCMP - Validate when type is Component                     *
      *                                                               *
      *****************************************************************
     C     VALCMP        BEGSR
 
      ** Error if Name is Blank
 
     C                   IF        DFNAME = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0297'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   ELSE
     C                   EVAL      PCott = DFNAME
     C                   EVAL      PCseq = %TRIM(DFSQMR)
 
      ** Check Component and sequence if existing on CBCMPNL0
 
     C     FNMSQK        CHAIN     CBCMPNL0
     C                   IF        %FOUND(CBCMPNL0)
     C                   EVAL      DFCSEQ = %TRIM(DFSQMR)
     C                   ELSE
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0284'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** Error if Sequence or Member field is blank
 
     C                   IF        DFSQMR = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0298'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ELSE
 
      ** Check if Sequence is Numeric
 
     C                   EVAL      Pos = %CHECK(Num:%TRIM(DFSQMR))
     C                   IF        Pos = 0
     C                   EVAL      WwSqmr = %DEC(%TRIM(DFSQMR):10:0)
     C                   ELSE
     C                   EVAL      ZAMSID = 'CBM0300'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** If Sequence number is not from 00001 - 99999
 
     C                   IF        WwSqmr < 1 OR WwSqmr > 99999
     C                   EVAL      ZAMSID = 'CBM0301'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
 
      ** Member should be blank if Type is Component or 'C'
 
     C                   EVAL      DFMBR = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALEXC - Validate when type is Exclusion                     *
      *                                                               *
      *****************************************************************
     C     VALEXC        BEGSR
 
      ** Place Section name to DFMBR for insertion later.
 
     C                   EVAL      DFMBR = DFMDFT
 
      ** Error if Name is Blank
 
     C                   IF        DFNAME = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0297'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   ELSE
 
     C                   EVAL      PCott = DFNAME
     C                   IF        DFSQMR = '*ALL'
 
      ** If Component sequence is *ALL check if the component
      ** has a record
 
     C     DFNAME        SETLL     CBCMPNL0
 
     C                   IF        NOT %EQUAL(CBCMPNL0)
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0284'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN32 = *ON
     C                   ELSE
     C                   EVAL      DFCSEQ = DFSQMR
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PCseq = %TRIM(DFSQMR)
 
      ** Check Component and sequence if existing on CBCMPNL0
 
     C     FNMSQK        CHAIN     CBCMPNL0
     C                   IF        %FOUND(CBCMPNL0)
     C                   EVAL      DFCSEQ = %TRIM(DFSQMR)
     C                   ELSE
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSID = 'CBM0284'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Error if Sequence or Member field is blank
 
     C                   IF        DFSQMR = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0298'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ELSE
     C                   IF        DFSQMR <> '*ALL'
 
      ** Check if Sequence is Numeric
 
     C                   EVAL      Pos = %CHECK(Num:%TRIM(DFSQMR))
     C                   IF        Pos = 0
     C                   EVAL      WwSqmr = %DEC(%TRIM(DFSQMR):10:0)
     C                   ELSE
     C                   EVAL      ZAMSID = 'CBM0313'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
 
      ** If Sequence number is not from 00001 - 99999
 
     C                   IF        WwSqmr < 1 OR WwSqmr > 99999
     C                   EVAL      ZAMSID = 'CBM0301'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** When amend check if record did not change before validation
      ** if it already exists
 
     C                   EVAL      WName = *BLANKS
     C                   EVAL      WCseq = *BLANKS
     C                   EVAL      WMbr = *BLANKS
 
     C                   IF        AMDDEL = 'A'
     C/EXEC SQL
     C+ select FMNAME,FMCSEQ,FMMBR into :WName,:WCseq,:WMbr
     C+ from SCCOMJK0 where
     C+ FMUNIQ = :DFUNIQ
     C/END-EXEC
     C                   ENDIF
 
     C                   IF        WName <> DFNAME AND ErrInd <> 'Y' OR
     C                             WCseq <> DFSQMR AND ErrInd <> 'Y' OR
     C                             WMbr <> DFMDFT AND ErrInd <> 'Y'
 
      ** Validate if a record for Exclusion already exist
 
     C/EXEC SQL
     C+ declare VECursor insensitive scroll cursor for
     C+ select * from SCCOMJK0 where
     C+ FMTYPE = :DFTYPE and FMNAME = :DFNAME and
     C+ FMCSEQ = :DFSQMR and FMMBR = :DFMDFT
     C/END-EXEC
 
     C/EXEC SQL
     C+ open VECursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/END-EXEC
 
     C                   IF        TotRow  > 0
     C                   EVAL      ZAMSID = 'CBM0289'
     C                   EXSR      ZASNMS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
 
     C/EXEC SQL
     C+ close VECursor
     C/END-EXEC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DSPSCD - Display Section Description Screen                  *
      *                                                               *
      *****************************************************************
     C     DSPSCD        BEGSR
 
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
 
     C                   IF        DFMODE = 'Core'
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN48 = *ON
     C                   ENDIF
 
     C                   WRITE     SC00101F0
     C                   WRITE     SC00101F4
 
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   WRITE     SC00101C1
     C                   ENDIF
 
     C                   EXFMT     SC00101F6
 
     C                   EXSR      CLEAR
     C                   EXSR      RSTIND
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      ErrInd = 'N'
 
     C                   SELECT
     C                   WHEN      DFMODE = 'Core'
     C                   EVAL      *IN48 = *OFF
 
     C                   IF        *INKL = *ON
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *INKL = *OFF
     C                   ENDIF
 
     C                   WHEN      *INKE = *ON
 
     C                   EVAL      *IN45 = *OFF
 
     C                   IF        AMDDEL = ' '
     C                   EVAL      DFSCTD = *BLANK
     C                   ENDIF
 
     C                   IF        AMDDEL = 'A'
     C/EXEC SQL
     C+ select FMSCTD into :DFSCTD from SCCOMMTD
     C+ where FMUNIQ = :DFUNIQ
     C/END-EXEC
     C                   ENDIF
 
      ** When F12 is Pressed Set ErrInd = 'Y' for it not to update
      ** and go back to first screen
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *INKL = *OFF
 
     C                   WHEN      DFSCTD = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0309'
     C                   EXSR      ZASNMS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN45 = *ON
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKCCSQ - Validate Complex Condition Sequence                 *
      *                                                               *
      *****************************************************************
     C     CKCCSQ        BEGSR
 
     C/EXEC SQL
     C+ declare VLCursor insensitive scroll cursor for
     C+ select FMCCSQ from SCCOMJK0 where FMTYPE = :DFTYPE and
     C+ FMNAME = :DFNAME and FMCSEQ = :WCseq and FMMBR = :WMbr
     C+ order by FMCCSQ desc
     C/END-EXEC
 
     C/EXEC SQL
     C+ open VLCursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ get diagnostics :TotRow = db2_number_rows
     C/END-EXEC
 
     C/EXEC SQL
     C+ fetch first from VLCursor into :WCcsq
     C/END-EXEC
 
      ** If the Combination is not existing DFCCSQ should be 1
 
     C                   IF        TotRow = 0
     C                   EVAL      DFCCSQ = '001'
 
      ** If Combination is first occurence, Complex Cond must be blank
 
     C                   IF        DFCPLX <> *BLANK
     C                   EVAL      ZAMSID = 'CBM0291'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** If Combination is not first occurence, add 1 to the latest
      ** complex conditon sequence of the combination
 
     C                   ELSE
     C                   EVAL      Ccsq = %DEC(WCcsq:3:0) + 1
     C                   EVAL      DFCCSQ = %CHAR(CCSQ)
     C                   MOVE      CCSQ          DFCCSQ
 
      ** If not first occurence Complex Condition must not be blank
 
     C                   IF        DFCPLX = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0292'
     C                   EXSR      ZASNMS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN60 = *ON
     C                   EVAL      *IN29 = *ON
     C                   ENDIF
     C                   ENDIF
     C/EXEC SQL
     C+ close VLCursor
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VLCCSQ - Validate Complex Condition Sequence                 *
      *                                                               *
      *****************************************************************
     C     VLCCSQ        BEGSR
 
     C                   EVAL      Pos = %CHECK(Num:%TRIM(DFCCSQ))
     C                   IF        Pos = 0
     C                   IF        DFCCSQ <> *BLANKS
     C                   EVAL      Ccsq = %DEC(DFCCSQ:3:0)
     C                   MOVE      Ccsq          DFCCSQ
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ZAMSID = 'CBM0307'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
 
     C/EXEC SQL
     C+ select FMCCSQ into :Wccsq from SCCOMJK0
     C+ where FMUNIQ = :DFUNIQ
     C/END-EXEC
 
     C                   SELECT
     C                   WHEN      DFCCSQ = *BLANKS
     C                   EVAL      ZAMSID = 'CBM0308'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN43 = *ON
 
     C                   WHEN      DFCCSQ = '000' AND Pos = 0
     C                   EVAL      ZAMSID = 'CBM0312'
     C                   EXSR      ZASNMS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN43 = *ON
 
     C                   WHEN      DFCCSQ <> *BLANKS AND Pos = 0
 
     C                   IF        WCcsq <> DFCCSQ
 
     C/EXEC SQL
     C+ declare VACursor insensitive scroll cursor for
     C+ select * from SCCOMJK0 where FMTYPE = :DFTYPE and
     C+ FMNAME = :DFNAME and FMCSEQ = :WCseq and FMMBR = :WMbr
     C+ and FMCCSQ = :DFCCSQ
     C/END-EXEC
 
     C/EXEC SQL
     C+ open VACursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ get diagnostics :TotRow = db2_number_rows
     C/END-EXEC
 
     C                   IF        TotRow <> 0
     C                   EVAL      ZAMSID = 'CBM0306'
     C                   EXSR      ZASNMS
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
 
     C/EXEC SQL
     C+ close VACursor
     C/END-EXEC
     C                   ENDIF
 
     C                   SELECT
 
      ** Validation for Complex Condition
 
     C                   WHEN      DFMODE = 'Bespoke'
     C                   IF        DFCCSQ = '001' AND DFCPLX <> *BLANK
     C                   EVAL      ZAMSID = 'CBM0291'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   IF        DFCCSQ <> '001' AND DFCPLX = *BLANK
     C                   EVAL      *IN29 = *ON
     C                   EVAL      ZAMSID = 'CBM0292'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   WHEN      DFMODE = 'Core'
     C                   IF        DFCCSQ = '001' AND DFCPLX <> *BLANK
     C                   EVAL      *IN43 = *ON
     C                   EVAL      ZAMSID = 'CBM0310'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   IF        DFCCSQ <> '001' AND DFCPLX = *BLANK
     C                   EVAL      *IN43 = *ON
     C                   EVAL      ZAMSID = 'CBM0311'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPPERC - Convert to Upper case                               *
      *                                                               *
      *****************************************************************
     C     UPPERC        BEGSR
 
     C                   EVAL      DFTYPE = %XLATE(LoCase:UpCase:DFTYPE)
     C                   EVAL      DFNAME = %XLATE(LoCase:UpCase:DFNAME)
     C                   EVAL      DFSQMR = %XLATE(LoCase:UpCase:DFSQMR)
     C                   EVAL      DFMDFT = %XLATE(LoCase:UpCase:DFMDFT)
     C                   EVAL      DFCOND = %XLATE(LoCase:UpCase:DFCOND)
     C                   EVAL      DFCPLX = %XLATE(LoCase:UpCase:DFCPLX)
     C                   EVAL      DFLDEL = %XLATE(LoCase:UpCase:DFLDEL)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT - Exit Program                                          *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
 
     C                   CALL      'SC001002'
     C                   EXSR      CKBLNK
     C                   IF        ErrInd <> 'Y'
     C                   EXSR      RECDEL
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      *INKC = '0'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECDEL - Delete Records where Logically Delete is 'Y'        *
      *           And if it is Bespoke                                *
      *                                                               *
      *****************************************************************
     C     RECDEL        BEGSR
 
     C/EXEC SQL
     C+ delete from SCCOMMTD where FMUNIQ in
     C+ (select FMUNIQ from SCCOMXTD
     C+ where
     C+ FMMODE = 'B' and FMDEL = 'Y')
     C/END-EXEC
 
     C/EXEC SQL
     C+ delete from SCCOMXTD where FMMODE = 'B' and FMDEL = 'Y'
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ADDRCD - Insert Processing                                   *
      *                                                               *
      *****************************************************************
     C     ADDRCD        BEGSR
 
     C                   EXSR      INSRCD
     C                   DOW       ErrInd = 'Y' AND *INKL = '0' OR *INKE = '1'
     C                   EXSR      INSRCD
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
 
     C                   IF        ZAPGMQ = *BLANK
     C                   EVAL      ZAPGMQ = DFPGMQ
     C                   END
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C     ZAEXIT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     FNMSQK        KLIST
     C                   KFLD                    PCott
     C                   KFLD                    PCseq
 
      ** Get the current time
 
     C                   CALL      'CBTIME'
     C                   PARM                    DayNoa
     C                   PARM                    STime
     C                   PARM                    DFmt
     C                   MOVE      DayNoa        CurrDt
 
      ** Convert date to DDMMYY format
 
     C                   CALL      'ZDATE2'
     C                   PARM                    CurrDt
     C                   PARM                    DFmt
     C                   PARM                    WQ0003
     C                   PARM      *BLANKS       ZDate
 
     C                   EVAL      DFDATE = ZDate
 
     C                   Z-ADD     0             RdCtr
     C                   EVAL      ErrInd = 'N'
     C                   EVAL      ZAMSGF = 'GBCBUSRMSG'
     C                   EVAL      ErIOff = '00000000000'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
