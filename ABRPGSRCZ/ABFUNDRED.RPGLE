     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal funding deals read')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDRED - Internal Funding Deals Read                      *
      *                                                               *
      *  Function:  This module will read forwards and backwards      *
      *             through the Internal Funding Deals File           *
      *                                                               *
      *  Component of: ABFUNDSIN - Internal Funding Deals Maintenance *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL010             Date 02Aug02               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Error in Deal Number                            *
      *    99         End of File for ABFUNDL0                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkAut  - Check for User Authority if not Multi-Branching  *
      *  SRRdBck   - Read Backwards throug Internal Funding Deals File*
      *  SRRdFwd   - Read Forward through Internal Funding Deals File *
      *  SRValDeal - Validate Deal Number                             *
      *                                                               *
      * *PSSR - Error processing                                      *
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
 
      ** Internal Funding Deals by Deal number
     FABFUNDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Internal Funding Deals by Front Office ID
     FABFUNDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDELDP0:MMDELDP1)
 
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
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  StartOfFile           02     02
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRdFwd          S              1
     D PRdBck          S              1
     D PErrMsg         S              7
     D PRdDeal         S              6
     D PRdFrntID       S             20
     D PDealNum        S              6
     D PModeOfOp       S              6
     D PFrntId         S             20
 
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Parameters for ZVACTBU and ZVACTU
     D ZACTN           S              1
     D PErr            S              1  0
 
      ** Work Variable
     D WkTest          S              1
     D WkFrontId       S             20
     D WkDealNo        S              6  0
 
      ** Single Branch Code from SDBANKPD
     D BJSBRC          S              1
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialize Output
 
     C                   EXSR      SRInit
 
      ** Check User Authority
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SRChkAut
     C                   ENDIF
 
     C                   EXSR      SRValDeal
 
      ** Read Forward
 
     C                   IF        PRdFwd = 'Y'
     C                   EXSR      SRRdFwd
     C                   ELSE
 
      ** Read Backwards
 
     C                   IF        PRdBck = 'Y'
     C                   EXSR      SRRdBck
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialise Fields                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Call : None                                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      PErrMsg = *Blanks
     C                   EVAL      PRdDeal = *Blanks
     C                   EVAL      PRdFrntId = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Check for User Authority if not Multi-Branching    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Call : None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM      *ZERO         PErr
 
      ** Retrun Error Message
 
     C                   IF        PErr = 1
     C                   EVAL      PErrMsg = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDeal - Validate Deal Number                              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Call : None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValDeal     Begsr
 
     C                   EVAL      WkFrontId = PFrntId
     C                   MOVE      PDealNum      WkDealNo
 
      ** Validate Deal Number
 
     C                   IF        PDealNum <> *Blanks
     C                   TESTN                   PDealNum             03
     C                   MOVE      PDealNum      WkTest
     C                   TESTZ                   WkTest                   04
     C                   IF        *IN03 = *On and *IN04 = *On
     C                   MOVE      PDealNum      WkDealNo
 
      ** Return Error Message
 
     C                   ELSE
     C                   EVAL      PErrMsg = 'MMM0162'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdFwd - Read Forwards through Internal Funding Deals File   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRdFwd       BEGSR
 
      ** Position to current record on file
 
     C                   IF        PModeOfOp = '*FRONT'
     C     WkFrontId     SETGT     ABFUNDL1
     C                   ELSE
     C     WkDealNo      SETGT     ABFUNDL0
     C                   ENDIF
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       EndOfFile = True or
     C                             HKDSTS='A' and HKDLTF=*Blanks and
     C                             PErr=*Zero and HKTYPE='IL'
 
      **  Read the file.
 
     C                   IF        PModeOfOp = '*FRONT'
     C                   READ      ABFUNDL1                               01
     C                   ELSE
     C                   READ      ABFUNDL0                               01
     C                   ENDIF
 
      ** If multi-branching, check if authorized to look at deal (based
      ** on branch) but if invalid continue searching for valid branch
 
     C                   IF        EndOfFile = False AND BJSBRC = *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HKBRCA
     C                   PARM      *ZERO         PErr
     C                   ENDIF
 
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        EndOfFile = True
     C                   IF        PDealNum = *Blanks and PFrntId = *Blanks
     C                   EVAL      PErrMsg = 'MMM1006'
     C                   ELSE
     C                   EVAL      PErrMsg = 'MMM1002'
     C                   ENDIF
 
      ** Else, return the deal number read
 
     C                   ELSE
     C                   MOVE      HKDN38        PRdDeal
     C                   EVAL      PRdFrntId = HKFRNT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdBck - Read Backwards Through the Internal Funding Deals   *
      *           File                                                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRdBck       BEGSR
 
      ** Position to current record on file
 
     C                   IF        PModeOfOp = '*FRONT'
     C     WkFrontId     SETLL     ABFUNDL1
     C                   ELSE
     C     WkDealNo      SETLL     ABFUNDL0
     C                   ENDIF
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       StartOfFile = True or
     C                             HKDSTS = 'A' and HKDLTF = *Blanks and
     C                             PErr = *Zero and HKTYPE = 'IL'
 
      ** Read from complete or requires authorization
      ** or from authorized
 
     C                   IF        PModeOfOp = '*FRONT'
     C                   READP     ABFUNDL1                               02
     C                   ELSE
     C                   READP     ABFUNDL0                               02
     C                   ENDIF
 
      ** If multi-branching, check if authorized to look at deal (based
      ** on branch) but if invalid continue searching for valid branch
 
     C                   IF        StartOfFile = False AND BJSBRC = *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HKBRCA
     C                   PARM      *ZERO         PErr
     C                   ENDIF
 
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        StartOfFile = True
     C                   EVAL      PErrMsg = 'MMM1003'
 
      ** Else, return the deal number read
 
     C                   ELSE
     C                   MOVE      HKDN38        PRdDeal
     C                   EVAL      PRdFrntID = HKFRNT
     C                   ENDIF
 
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
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (Front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*SIN  ' (Screen Input Function)
      ** Mode = '*RPR  ' (Repair Function)
 
     C                   PARM                    PModeofOp
 
      ** Deal number Pointer
 
     C                   PARM                    PDealNum
 
      ** Front Office Transaction ID
 
     C                   PARM                    PFrntId
 
      ** Read Forward Indicator
      ** Read Backward Indicator
 
     C                   PARM                    PRdFwd
     C                   PARM                    PRdBck
 
      ** Single Branch Code
 
     C                   PARM                    BJSBRC
 
      ** Output Paramters
      ** Error Message
      ** Deal Number Read
 
     C                   PARM                    PErrMsg
     C                   PARM                    PRdDeal
     C                   PARM                    PRdFrntId
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
