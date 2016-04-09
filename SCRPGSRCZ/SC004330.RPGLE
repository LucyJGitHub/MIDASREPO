     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 re-open option prompt')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004330 - 24x7 Re-open Option Prompt                        *
      *                                                               *
      *  Function:  This module will prompt the user for the action   *
      *             to be taken on the 'support' system once the      *
      *             input-cycle is reopened.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *  Last Amend No. CSD013             Date 23Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD013 - Generic Midas ICD Project:                          *
      *           - CBPROMPT data has moved to SDSVALPD.              *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         Error on called program                         *
      *    10         Error on selection (Valid values are 1 - 5)     *
      *    70         Test system mode                                *
      *    97         Message Subfile Control SFLEND                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     - Initial Processing                              *
      *  SRDisplay  - Display additional SSI for swift                *
      *  SRValidate - Validate screen fields                          *
      *  SRUpdate   - Update dataarea SC24X7                          *
      *  SRReturn   - Return to calling program                       *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
     FSC004330DFCF   E             WORKSTN INFSR(*PSSR)
 
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
     D  SelErr                10     10
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for SC24X7 details
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for SCDRSTAT details
     D SCDRSTAT      E DS                  EXTNAME(SCDRSTAT) DTAARA(SCDRSTAT)
 
      ** Data structure for SCDRSTAT details
     D*CBPROMPT******E DS                  EXTNAME(CBPROMPT) DTAARA(CBPROMPT)                 CSD013
                                                                                              CSD013
      ** Data structure for AOSVALR0 string                                                   CSD013
     D @SVAL1          DS           200                                                       CSD013
     D  SVAL1                  1    200                                                       CSD013
     D  SVAL1_4                1      4                                                       CSD013
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZA0340
     D PMsgFile        S             10A
     D PMsgID          S             10A
 
     D WMode           S              1A
     D WRun            S              1A
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      *  Main Procedure                                               *
      *****************************************************************
 
      ** Initial processing
 
     C                   EXSR      SRInit
 
      ** Do while screen: Main Details
 
     C                   DOW       WMode = 'D'
     C                   EXSR      SRDisplay
     C                   ENDDO
 
      ** Do while update
 
     C                   DOW       WMode = 'U'
     C                   EXSR      SRUpdate
     C                   ENDDO
 
      **  Return
 
     C                   IF        WMode = 'R'
     C                   EXSR      SRReturn
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initial Processing                                  *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Initialise error indicator to off
 
     C                   EVAL      SelErr = False
     C                   EVAL      WMode  = 'D'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display additional SSI for swift                 *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: SRValidate, ZA0250                                    *
      *                                                               *
      *****************************************************************
     C     SRDisplay     BEGSR
 
      ** Write message subfile and details
 
     C                   TIME                    #1TIME
 
     C                   WRITE     SC004330C1
     C                   WRITE     SC004330F1
 
      ** Read details screen
 
     C                   READ      SC004330F1
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   EVAL      SelErr = False
 
      ** Validate input
 
     C                   EXSR      SRValidate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate screen fields                          *
      *                                                               *
      *  Called by: SRDisplay                                         *
      *                                                               *
      *  Calls: ZA0340                                                *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Valid value for input field  are '1' thru '5'
 
      ** Test system mode
 
     C                   IF        #1REOP <> '1' and #1REOP <> '2' and
     C                             #1REOP <> '3' and #1REOP <> '4' and
     C                             #1REOP <> '5' and *IN70 = True
 
     C                   EVAL      SelErr = True
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM      'SCC0001'     PMsgId
 
     C                   ENDIF
 
      ** Live system mode
 
     C                   IF        #1REOP <> '1' and #1REOP <> '2' and
     C                             #1REOP <> '3' and *IN70 = False
 
     C                   EVAL      SelErr = True
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM      'SCC0041'     PMsgId
 
     C                   ENDIF
 
     C                   IF        SelErr = False
     C                   EVAL      WMode = 'U'
     C                   ELSE
     C                   EVAL      WMode = 'D'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update dataarea SC24X7                            *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C     *LOCK         IN        SC24X7
     C                   EVAL      S1REOP = #1REOP
     C                   OUT       SC24X7
 
     C                   EVAL      WMode = 'R'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return to calling program                         *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR
 
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Obtain records from SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '        '    @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RtCd <> *BLANK
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBPGM  =  'SC004340'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WID  = PsJobName
     C                   EVAL      #1DATE = BJMRDT
 
      ** Retrieve dataarea SCDRSTAT
 
     C                   IN        SCDRSTAT
 
      **********                                                                              CSD013
      ***Retrieve*dataarea*CBPROMPT************************************                       CSD013
      **********                                                                              CSD013
     C**********         IN        CBPROMPT                                                   CSD013
                                                                                              CSD013
      * Clear all the AOSVALR0 input parameters                                               CSD013
                                                                                              CSD013
     C                   CLEAR                   SVALK1                                       CSD013
     C                   CLEAR                   SVALK2                                       CSD013
     C                   CLEAR                   SVALK3                                       CSD013
     C                   CLEAR                   SVALK4                                       CSD013
     C                   CLEAR                   SVALK5                                       CSD013
     C                   CLEAR                   SVALK6                                       CSD013
     C                   CLEAR                   SVALK7                                       CSD013
     C                   CLEAR                   SVALK8                                       CSD013
     C                   CLEAR                   SVALK9                                       CSD013
     C                   CLEAR                   SVALK0                                       CSD013
                                                                                              CSD013
      * Initialise the first system value key                                                 CSD013
                                                                                              CSD013
     C                   EVAL      SVALK1 = 'TestSystemIndicator'                             CSD013
                                                                                              CSD013
      * Retrieve the system value                                                             CSD013
                                                                                              CSD013
     C                   CALL      'AOSVALR0'                                                 CSD013
     C                   PARM                    RTNCDE            7                          CSD013
     C                   PARM                    SVALK1           20                          CSD013
     C                   PARM                    SVAL1           200                          CSD013
     C                   PARM                    SVALK2           20                          CSD013
     C                   PARM                    SVAL2           200                          CSD013
     C                   PARM                    SVALK3           20                          CSD013
     C                   PARM                    SVAL3           200                          CSD013
     C                   PARM                    SVALK4           20                          CSD013
     C                   PARM                    SVAL4           200                          CSD013
     C                   PARM                    SVALK5           20                          CSD013
     C                   PARM                    SVAL5           200                          CSD013
     C                   PARM                    SVALK6           20                          CSD013
     C                   PARM                    SVAL6           200                          CSD013
     C                   PARM                    SVALK7           20                          CSD013
     C                   PARM                    SVAL7           200                          CSD013
     C                   PARM                    SVALK8           20                          CSD013
     C                   PARM                    SVAL8           200                          CSD013
     C                   PARM                    SVALK9           20                          CSD013
     C                   PARM                    SVAL9           200                          CSD013
     C                   PARM                    SVALK0           20                          CSD013
     C                   PARM                    SVAL10          200                          CSD013
                                                                                              CSD013
      * If the system value is not found then issue a database error                          CSD013
                                                                                              CSD013
     C     RTNCDE        IFNE      '       '                                                  CSD013
     C     SVAL10        IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK0                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL9         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK9                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL8         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK8                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL7         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK7                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL6         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK6                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL5         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK5                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL4         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK4                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL3         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK3                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL2         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK2                                           CSD013
     C                   ENDIF                                                                CSD013
     C     SVAL1         IFEQ      '*NRF'                                                     CSD013
     C                   EVAL      DBKEY  =  SVALK1                                           CSD013
     C                   ENDIF                                                                CSD013
     C     *LOCK         IN        LDA                                                        CSD013
     C                   EVAL      DBASE  =  003                                              CSD013
     C                   EVAL      DBFILE =  'SDSVALPD'                                       CSD013
     C                   EVAL      DBPGM  =  'SC004340'                                       CSD013
     C                   OUT       LDA                                                        CSD013
     C                   EXSR      *PSSR                                                      CSD013
     C                   ENDIF                                                                CSD013
 
      ** Message subfile control
 
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EVAL      *IN97    =  '1'
     C                   EVAL      #1PGMQ   = PSProcName
 
      ** If this is a test system set on *IN70
 
     C**********         IF        PRTEST = 'Y'                                               CSD013
     C                   IF        SVAL1_4 = 'TEST'                                           CSD013
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Calls    : DBERRCTL                                          *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
