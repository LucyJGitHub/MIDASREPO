     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL COB Report Prompts Screen 2')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000900 - Dealing COB Report Prompts Screen 2               *
      *                                                               *
      *  Function:  This module validates the new COB reporting       *
      *             parameters for Dealing then updates the Dealing   *
      *             ICD file.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247443             Date 08May07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237622             Date 06Jan06               *
      *                 226165             Date 31Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 213367             Date 18Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247443 - SCKOBJLCB failure due to lock in SDYLDCPD.          *
      *         - Annotated as 237622.                                *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  237622 - SCKOBJLCB failure due to lock in SDYLDCPD.          *
      *  226165 - Limit UP/UL Generation in DL COB Prompt             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002, and CAS004          *
      *  213367 - Commitment control error                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *  03 - F3 is pressed                                           *
      *  05 - F5 is pressed                                           *
      *  12 - F12 is pressed                                          *
      *  20 - Error in FX/Interest Forward Revaluation Field          *
      *  21 - Error in FX Base Currency Yield Curve                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT     - Initialise Fields                               *
      *  SRCLEAR    - Clear Program Message File                      *
      *  SREXIT     - Activation of Function Key F3                   *
      *  SRRESET    - Activation of Function Key F5                   *
      *  SRPREV     - Activation of Function Key F12                  *
      *  SRVALID    - Validation Of Entry Data                        *
      *  SRUPDAT    - Update of Database File                         *
      *  SRSNDMSG   - Send Error Message                              *
      *  SREND      - Return to Calling Program                       *
      *  *PSSR      - Program exception error routine                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDL000900DFCF   E             WORKSTN INFSR(*PSSR)
      ** Midas DL COB Report Prompts Screen 2
 
     FSDDEALL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                             213367
      ** Midas SD Dealing Data Update
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Midas DL Module Status Data Area                                                     226165
     D DLSTAT        E DS                  EXTNAME(DLSTAT) DTAARA(DLSTAT)                     226165
     D  ZZ02DL       E                     EXTFLD(ZZ02)                                       226165
                                                                                              226165
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Yield Curves file
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
 
      ** External data structure for Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
                                                                                              CAS005
      ** External data structure for Switchable Features                                      CAS005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS005
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D W_RTCD          S              7A
     D W_DLDA          S             10A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A                                                      CAS005
     D PMSGFILE        S             10A   INZ('GBDRSMM')
     D PMSGID          S             10A
     D WERROR          S              1A
     D CAS005          S              1A                                                      CAS005
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialise fields
 
     C                   EXSR      SRINIT
 
     C                   DOU       WERROR = 'N'
 
      ** Write Message Control
 
     C                   WRITE     DL000900F2
 
      ** Execute format Detail Screen
 
     C                   EXFMT     DL000900F0
 
      ** Clear Program Message File
 
     C                   EXSR      SRCLEAR
 
     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C                   EXSR      SREXIT
     C                   WHEN      *IN05 = *ON
     C                   EXSR      SRRESET
     C                   WHEN      *IN12 = *ON
     C                   EXSR      SRPREV
     C                   OTHER
     C                   EXSR      SRVALID
     C                   ENDSL
 
     C                   ENDDO
 
      ** End of Program
 
     C                   EXSR      SREND
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialise fields                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AODEALR0                                               *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    W_RTCD
 
      **  Set up Local Data Area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = *BLANKS
     C                   EVAL      DBPGM = 'DL000900'
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
                                                                                              CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   EVAL      *IN30 = *OFF                                               CAS005
                                                                                              CAS005
      ** Check if CAS005 is installed                                                         CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   IN        DLSTAT                                                     226165
     C                   IF        FREVAL = 'Y'                                               226165
     C                   IF        FREVLP = 'N'                                               226165
     C                   EVAL      *IN30 = *ON                                                CAS005
     C                   ENDIF                                                                226165
     C                   ENDIF                                                                226165
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE =  'SCSARDPD'                                       CAS005
     C                   EVAL      DBKEY  =  'CAS005'                                         CAS005
     C                   EVAL      DBASE  =  2                                                CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Access Dealing ICD
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST'      POPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      #0NPVM = BNNPVM
     C                   EVAL      #0BCYC = BNBCYC
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      #0NPV2 = BNNPV2                                            CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF
 
     C                   EVAL      #0WID = PSJOBNAME
     C                   EVAL      #1PGMQ = PSPROCMOD
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLEAR - Clear Program Message File                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0250                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRCLEAR       BEGSR
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Activation of Function Key F3                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SREND                                                  *
      *                                                               *
      *****************************************************************
 
     C     SREXIT        BEGSR
 
     C                   EVAL      W_RTCD = 'EXIT'
     C                   EXSR      SREND
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESET - Activation of Function Key F5                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRINIT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRESET       BEGSR
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      *IN31 = *OFF                                               CAS005
     C                   ENDIF                                                                CAS005
     C                   EXSR      SRINIT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPREV - Activation of Function Key F12                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SREND                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRPREV        BEGSR
 
     C                   EVAL      W_RTCD = 'PREV'
     C                   EXSR      SREND
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Validation of Entry Data                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSNDMSG, AOYLDCR0, SRUPDAT                            *
      *                                                               *
      *****************************************************************
 
     C     SRVALID       BEGSR
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      *IN31 = *OFF                                               CAS005
     C                   ENDIF                                                                CAS005
 
      ** Validate FX/Interest Forward Revaluation NPV Method
 
     C                   IF        #0NPVM <> 'N' AND
     C                             #0NPVM <> 'F' AND
     C                             #0NPVM <> 'B' AND
     C                             #0NPVM <> 'D' AND
     C                             #0NPVM <> ' '
 
     C                   EVAL      PMSGID = 'DLM1016'
     C                   EXSR      SRSNDMSG
     C                   EVAL      *IN20 = *ON
 
     C                   ENDIF
                                                                                              CAS005
      ** Validate FX/Interest Forward Revaluation NPV Method for UP/UL                        CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   IF        #0NPV2 <> 'N' AND                                          CAS005
     C                             #0NPV2 <> 'F' AND                                          CAS005
     C                             #0NPV2 <> 'B' AND                                          CAS005
     C                             #0NPV2 <> 'D' AND                                          CAS005
     C                             #0NPV2 <> ' '                                              CAS005
                                                                                              CAS005
     C                   EVAL      PMSGID = 'DLM1016'                                         CAS005
     C                   EXSR      SRSNDMSG                                                   CAS005
     C                   EVAL      *IN31 = *ON                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** If no error on both method fields, validate against each other                       CAS005
      **********                                                                       CAS005 226165
     C**********         IF        *IN20 = *OFF AND *IN31 = *OFF                       CAS005 226165
     C**********         IF        #0NPVM = #0NPV2                                     CAS005 226165
     C**********         EVAL      PMSGID = 'DLM1023'                                  CAS005 226165
     C**********         EXSR      SRSNDMSG                                            CAS005 226165
     C**********         EVAL      *IN31 = *ON                                         CAS005 226165
     C**********         ENDIF                                                         CAS005 226165
     C**********         ENDIF                                                         CAS005 226165
     C                   ENDIF                                                                CAS005
 
      ** Validate FX Base Currency Yield Curve
 
     C                   IF        #0BCYC <> *BLANKS
 
     C                   CALLB     'AOYLDCR0'
     C                   PARM      *BLANKS       PRTCD
     C**********         PARM      '*KEY   '     POPTN                                        237622
     C                   PARM      '*FREE  '     POPTN                                        237622
     C                   PARM                    #0BCYC
     C     SDYLDC        PARM      SDYLDC        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
 
     C                   EVAL      PMSGID = 'DLM1017'
     C                   EXSR      SRSNDMSG
     C                   EVAL      *IN21 = *ON
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        #0NPVM = 'B' OR
     C                             #0NPVM = 'D'
     C                             OR #0NPV2 = 'B'                                            226165
     C                             OR #0NPV2 = 'D'                                            226165
 
     C                   EVAL      PMSGID = 'DLM1018'
     C                   EXSR      SRSNDMSG
     C                   EVAL      *IN21 = *ON
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check if there is any error of the fields
 
     C                   IF        *IN20 = *ON OR
     C                             *IN21 = *ON
     C                             OR CAS005 = 'Y' AND                                        CAS005
     C                             *IN31 = *ON                                                CAS005
     C                   EVAL      WERROR = 'Y'
     C                   ELSE
     C                   EVAL      WERROR = 'N'
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDAT - Update of Database file                             *
      *                                                               *
      * Called by: SRVALID                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDAT       BEGSR
 
     C                   EVAL      W_DLDA = 'DEAL'
     C     W_DLDA        CHAIN     SDDEALL0
 
     C                   EVAL      BNNPVM = #0NPVM
     C                   EVAL      BNBCYC = #0BCYC
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      BNNPV2 = #0NPV2                                            CAS005
     C                   ENDIF                                                                CAS005
 
     C                   UPDATE    @BNREEH
     C**********         COMMIT                                                               213367
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDMSG - Send Error Message                                 *
      *                                                               *
      * Called by: SRVALID                                            *
      *                                                               *
      * Calls: ZA0340                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRSNDMSG      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMSGFILE
     C                   PARM                    PMSGID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Return to Calling Program                             *
      *                                                               *
      * Called by: Main Processing, SREXIT, SRPREV                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SREND         BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2001
